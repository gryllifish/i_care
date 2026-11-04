import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/guard.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/data/sync/push_token_gateway.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';

/// [PushRepository] over Firebase Cloud Messaging, which gives this phone
/// its token, and the [PushTokenGateway], which keeps it on the server.
/// Firebase types never leave this class.
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
  Future<Result<void>> enable({required String language}) => guard(() async {
    final settings = await _firebase(_messaging.requestPermission);
    if (!_allowed(settings)) {
      throw const NotificationsBlockedException('Notifications not allowed');
    }
    await _register(language);
  });

  @override
  Future<Result<void>> refresh({required String language}) => guard(() async {
    final settings = await _firebase(_messaging.getNotificationSettings);
    if (_allowed(settings)) await _register(language);
  });

  @override
  Future<Result<void>> disable() => guard(() async {
    await _refreshes?.cancel();
    _refreshes = null;
    await _gateway.unregisterPushToken();
    await _firebase(_messaging.deleteToken);
  });

  static bool _allowed(NotificationSettings settings) =>
      switch (settings.authorizationStatus) {
        AuthorizationStatus.authorized ||
        AuthorizationStatus.provisional => true,
        AuthorizationStatus.denied ||
        AuthorizationStatus.deniedPermanently ||
        AuthorizationStatus.notDetermined => false,
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

  /// Runs a Firebase call, reporting its failures as [AppException]s.
  ///
  /// Throws [NotificationsBlockedException] when the browser blocks
  /// notifications, else [NoConnectionException].
  static Future<T> _firebase<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on FirebaseException catch (error) {
      if (error.code.contains('permission-blocked')) {
        throw NotificationsBlockedException(error.code, cause: error);
      }
      throw NoConnectionException('Firebase: ${error.code}', cause: error);
    }
  }
}
