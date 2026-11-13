import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/datasources/google_sign_in_account_source.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoogle extends Mock implements GoogleSignIn;

class _MockAccount extends Mock implements GoogleSignInAccount;

void main() {
  late _MockGoogle google;
  late GoogleSignInAccountSource source;

  _MockAccount account({String? idToken = 'token-1'}) {
    final account = _MockAccount();
    when(() => account.email).thenReturn('ana@example.com');
    when(() => account.authentication)
        .thenReturn(GoogleSignInAuthentication(idToken: idToken));
    return account;
  }

  setUp(() {
    google = _MockGoogle();
    when(() => google.initialize(serverClientId: any(named: 'serverClientId')))
        .thenAnswer((_) async {});
    when(() => google.signOut()).thenAnswer((_) async {});
    source = GoogleSignInAccountSource(google, serverClientId: 'web-client');
  });

  test('hands over the picked account, asking for a token meant for the '
      'backend, and keeps no Google session', () async {
    when(() => google.authenticate()).thenAnswer((_) async => account());

    final credential = await source.pick();

    expect(credential?.idToken, 'token-1');
    expect(credential?.email, 'ana@example.com');
    verify(() => google.initialize(serverClientId: 'web-client')).called(1);
    verify(() => google.signOut()).called(1);
  });

  test('sets Google up once, however often it is asked', () async {
    when(() => google.authenticate()).thenAnswer((_) async => account());

    await source.pick();
    await source.pick();

    verify(() => google.initialize(serverClientId: 'web-client')).called(1);
  });

  test('closing the sheet picks nothing', () async {
    when(() => google.authenticate()).thenThrow(
      const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
    );

    expect(await source.pick(), isNull);
  });

  test('any other trouble with Google is a server error', () async {
    when(() => google.authenticate()).thenThrow(
      const GoogleSignInException(
        code: GoogleSignInExceptionCode.clientConfigurationError,
      ),
    );

    await expectLater(source.pick(), throwsA(isA<ServerException>()));
  });

  test('an account without a token is a server error', () async {
    when(() => google.authenticate())
        .thenAnswer((_) async => account(idToken: null));

    await expectLater(source.pick(), throwsA(isA<ServerException>()));
  });
}
