import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/guard.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/data/sync/push_token_gateway.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';

/// [PushRepository] over Firebase Cloud Messaging, which asks for
/// permission and gives this phone its token, and the [PushTokenGateway],
/// which keeps it on the server. Firebase types never leave this class.
///
/// Uses registration tokens (`getToken`, `onTokenRefresh`), which the
/// `push` function sends to through FCM's `messages:send`. firebase_messaging
/// 17 deprecates them for installation IDs and direct send; moving means
/// changing the function too, so it waits (`docs/backend.md`).
// ignore_for_file: deprecated_member_use
class PushRepositoryImpl implements PushRepository {
  PushRepositoryImpl({
    required this._messaging,
    required this._gateway,
    required this._platform,
    this._vapidKey,
  });

  final FirebaseMessaging _messaging;
  final PushTokenGateway _gateway;

  /// `android` or `web`, as the server stores it.
  final String _platform;

  /// The web push certificate's public key; web only.
  final String? _vapidKey;

  StreamSubscription<String>? _refreshes;

  @override
  Future<Result<PushPermission>> permission() => guard(
    () async => _read(await _settings(_messaging.getNotificationSettings)),
  );

  @override
  Future<Result<PushPermission>> request({required String language}) =>
      guard(() async {
        final permission = _read(await _settings(_messaging.requestPermission));
        if (permission == PushPermission.allowed) await _register(language);
        return permission;
      });

  @override
  Future<Result<PushPermission>> sync({required String language}) =>
      guard(() async {
        final permission = _read(
          await _settings(_messaging.getNotificationSettings),
        );
        switch (permission) {
          case PushPermission.allowed:
            await _register(language);
          case PushPermission.denied:
            // Turned off in the system's settings: stop being sent to.
            await _refreshes?.cancel();
            _refreshes = null;
            await _gateway.unregisterPushToken();
          case PushPermission.notAsked:
            break;
        }
        return permission;
      });

  static PushPermission _read(NotificationSettings? settings) =>
      switch (settings?.authorizationStatus) {
        AuthorizationStatus.authorized ||
        AuthorizationStatus.provisional => PushPermission.allowed,
        AuthorizationStatus.notDetermined => PushPermission.notAsked,
        // Null: the browser blocks notifications for the site.
        AuthorizationStatus.denied ||
        AuthorizationStatus.deniedPermanently ||
        null => PushPermission.denied,
      };

  Future<void> _register(String language) async {
    final token = await _firebase(
      () => _messaging.getToken(vapidKey: _vapidKey),
    );
    if (token == null) {
      throw const NoConnectionException('No push token');
    }
    await _send(token, language);
    // Firebase may replace the token while the app runs.
    await _refreshes?.cancel();
    _refreshes = _messaging.onTokenRefresh.listen(
      (token) => unawaited(_resend(token, language)),
    );
  }

  Future<void> _send(String token, String language) => _gateway
      .registerPushToken(token: token, platform: _platform, language: language);

  Future<void> _resend(String token, String language) async {
    try {
      await _send(token, language);
    } on AppException catch (error, stackTrace) {
      // Sent again on the next start.
      AppLogger.warning('Push token not sent', error, stackTrace);
    }
  }

  /// The system's notification settings; null when the browser blocks
  /// notifications for the site, which Firebase reports as an error.
  ///
  /// Throws [NoConnectionException] for other Firebase failures.
  static Future<NotificationSettings?> _settings(
    Future<NotificationSettings> Function() call,
  ) async {
    try {
      return await _firebase(call);
    } on _Blocked {
      return null;
    }
  }

  /// Runs a Firebase call, reporting its failures as [AppException]s.
  ///
  /// Throws [_Blocked] when the browser blocks notifications, else
  /// [NoConnectionException].
  static Future<T> _firebase<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on FirebaseException catch (error) {
      if (error.code.contains('permission-blocked')) throw const _Blocked();
      throw NoConnectionException('Firebase: ${error.code}', cause: error);
    }
  }
}

/// The browser blocks notifications for the site.
class _Blocked implements Exception {
  const _Blocked();
}
