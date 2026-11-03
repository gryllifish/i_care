import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Keeps this phone's Supabase session in the platform's secure storage
/// instead of plain preferences: its refresh token opens the circle's
/// health data (`docs/privacy.md`).
///
/// A failure is logged and reads as no session: the phone then signs in
/// again, as a new device, rather than failing to start.
class SecureSessionStorage extends LocalStorage {
  const SecureSessionStorage(this._secure);

  final FlutterSecureStorage _secure;

  static const _key = 'supabase_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => await accessToken() != null;

  @override
  Future<String?> accessToken() async {
    try {
      return await _secure.read(key: _key);
    } on Exception catch (error, stackTrace) {
      AppLogger.error('Could not read the session', error, stackTrace);
      return null;
    }
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    try {
      await _secure.write(key: _key, value: persistSessionString);
    } on Exception catch (error, stackTrace) {
      AppLogger.error('Could not keep the session', error, stackTrace);
    }
  }

  @override
  Future<void> removePersistedSession() async {
    try {
      await _secure.delete(key: _key);
    } on Exception catch (error, stackTrace) {
      AppLogger.error('Could not remove the session', error, stackTrace);
    }
  }
}
