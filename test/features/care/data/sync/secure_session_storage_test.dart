import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/data/sync/secure_session_storage.dart';

void main() {
  const storage = SecureSessionStorage(FlutterSecureStorage());

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('keeps the session until it is removed', () async {
    expect(await storage.hasAccessToken(), isFalse);

    await storage.persistSession('{"access_token": "t"}');
    expect(await storage.accessToken(), '{"access_token": "t"}');
    expect(await storage.hasAccessToken(), isTrue);

    await storage.removePersistedSession();
    expect(await storage.hasAccessToken(), isFalse);
  });
}
