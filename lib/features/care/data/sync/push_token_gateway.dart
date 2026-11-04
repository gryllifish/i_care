import 'package:i_care/core/error/app_exception.dart';

/// Where this phone's push token is kept, so the server can tell it about
/// the circle's news (`docs/backend.md`, "Push notifications").
abstract interface class PushTokenGateway {
  /// Keeps [token] for this device, replacing the one before.
  ///
  /// Throws [NoConnectionException] or [ServerException].
  Future<void> registerPushToken({
    required String token,
    required String platform,
    required String language,
  });

  /// Forgets this device's token.
  ///
  /// Throws [NoConnectionException] or [ServerException].
  Future<void> unregisterPushToken();
}
