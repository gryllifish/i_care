import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/datasources/storage_key.dart';

void main() {
  const secure = FlutterSecureStorage();

  test('makes a key once and keeps it in secure storage', () async {
    FlutterSecureStorage.setMockInitialValues({});

    final first = await const StorageKey(secure).cipher();
    final stored = await secure.readAll();
    final again = await const StorageKey(secure).cipher();

    expect(stored.values.single, hasLength(44)); // 32 bytes in base64
    expect(again.calculateKeyCrc(), first.calculateKeyCrc());
  });

  test('refuses a stored value that is not a key', () async {
    FlutterSecureStorage.setMockInitialValues({'storage_key_v1': 'c2hvcnQ='});

    await expectLater(
      const StorageKey(secure).cipher(),
      throwsA(isA<StorageException>()),
    );
  });
}
