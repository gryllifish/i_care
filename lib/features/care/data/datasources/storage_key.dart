import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';

/// The key that encrypts this phone's stores when they hold real health
/// data (`docs/privacy.md`). Made once and kept in the platform's secure
/// storage (Keychain, Android Keystore), never next to the data. On the
/// web that storage is the browser's own, which only keeps the key out of
/// plain sight of whoever reads the disk.
class StorageKey {
  const StorageKey(this._secure);

  final FlutterSecureStorage _secure;

  static const _name = 'storage_key_v1';

  /// AES-256, as [HiveAesCipher] requires.
  static const _keyLength = 32;

  /// The cipher for this phone's boxes, made on first use.
  ///
  /// Throws [StorageException] when secure storage is unavailable or holds
  /// something that is not a key.
  Future<HiveCipher> cipher() async {
    try {
      if (await _secure.read(key: _name) case final String stored) {
        final key = base64Decode(stored);
        if (key.length != _keyLength) {
          throw const StorageException('Invalid storage key');
        }
        return HiveAesCipher(key);
      }
      final key = Hive.generateSecureKey();
      await _secure.write(key: _name, value: base64Encode(key));
      return HiveAesCipher(key);
      // Platform channels and the web implementation report failures as
      // different exception types; all of them mean no key.
    } on StorageException {
      rethrow;
    } on Exception catch (error) {
      throw StorageException('No storage key', cause: error);
    }
  }
}
