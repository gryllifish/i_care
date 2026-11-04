import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/repositories/push_repository_impl.dart';
import 'package:i_care/features/care/data/sync/push_token_gateway.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockMessaging extends Mock implements FirebaseMessaging;

class _MockSettings extends Mock implements NotificationSettings;

/// Keeps what the server was told.
class _FakeGateway implements PushTokenGateway {
  final registered = <({String token, String platform, String language})>[];
  int unregistered = 0;

  @override
  Future<void> registerPushToken({
    required String token,
    required String platform,
    required String language,
  }) async =>
      registered.add((token: token, platform: platform, language: language));

  @override
  Future<void> unregisterPushToken() async => unregistered++;
}

// The repository uses registration tokens on purpose (see its docs).
// ignore_for_file: deprecated_member_use
void main() {
  late _MockMessaging messaging;
  late _FakeGateway gateway;
  late PushRepositoryImpl repository;
  late StreamController<String> refreshes;

  NotificationSettings settings(AuthorizationStatus status) {
    final settings = _MockSettings();
    when(() => settings.authorizationStatus).thenReturn(status);
    return settings;
  }

  void systemSays(AuthorizationStatus status) {
    when(() => messaging.getNotificationSettings())
        .thenAnswer((_) async => settings(status));
  }

  setUp(() {
    messaging = _MockMessaging();
    gateway = _FakeGateway();
    refreshes = StreamController<String>.broadcast();
    addTearDown(refreshes.close);
    when(() => messaging.getToken(vapidKey: any(named: 'vapidKey')))
        .thenAnswer((_) async => 'token-1');
    when(() => messaging.onTokenRefresh).thenAnswer((_) => refreshes.stream);
    repository = PushRepositoryImpl(
      messaging: messaging,
      gateway: gateway,
      platform: 'web',
      vapidKey: 'vapid',
    );
  });

  test('allowing in the system dialog is all it takes: the server keeps '
      'the token, and later ones too', () async {
    when(() => messaging.requestPermission())
        .thenAnswer((_) async => settings(AuthorizationStatus.authorized));

    final result = await repository.request(language: 'es');

    expect((result as Ok<PushPermission>).value, PushPermission.allowed);
    expect(gateway.registered, [
      (token: 'token-1', platform: 'web', language: 'es'),
    ]);
    verify(() => messaging.getToken(vapidKey: 'vapid')).called(1);

    refreshes.add('token-2');
    await pumpEventQueue();
    expect(gateway.registered.last.token, 'token-2');
  });

  test('a no in the dialog is an answer, not an error, and sends '
      'nothing', () async {
    when(() => messaging.requestPermission())
        .thenAnswer((_) async => settings(AuthorizationStatus.denied));

    final result = await repository.request(language: 'es');

    expect((result as Ok<PushPermission>).value, PushPermission.denied);
    expect(gateway.registered, isEmpty);
  });

  test('a browser that blocks notifications reads as denied; other '
      'Firebase failures as no connection', () async {
    when(() => messaging.requestPermission()).thenThrow(
      FirebaseException(plugin: 'messaging', code: 'permission-blocked'),
    );
    final blocked = await repository.request(language: 'en');
    expect((blocked as Ok<PushPermission>).value, PushPermission.denied);

    when(() => messaging.requestPermission()).thenThrow(
      FirebaseException(plugin: 'messaging', code: 'token-subscribe-failed'),
    );
    expect(
      await repository.request(language: 'en'),
      isA<Err<PushPermission>>().having(
        (err) => err.failure,
        'failure',
        isA<NoConnectionFailure>(),
      ),
    );
  });

  test('on start, an allowed phone sends its token by itself', () async {
    systemSays(AuthorizationStatus.authorized);

    await repository.sync(language: 'en');

    expect(gateway.registered.single.language, 'en');
    expect(gateway.unregistered, 0);
  });

  test('on start, a phone never asked sends nothing and is not '
      'forgotten', () async {
    systemSays(AuthorizationStatus.notDetermined);

    final result = await repository.sync(language: 'es');

    expect((result as Ok<PushPermission>).value, PushPermission.notAsked);
    expect(gateway.registered, isEmpty);
    expect(gateway.unregistered, 0);
  });

  test('on start, a phone whose notifications were turned off in the '
      'system is forgotten by the server', () async {
    systemSays(AuthorizationStatus.denied);

    await repository.sync(language: 'es');

    expect(gateway.registered, isEmpty);
    expect(gateway.unregistered, 1);
  });
}
