import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/repositories/push_repository_impl.dart';
import 'package:i_care/features/care/data/sync/push_token_gateway.dart';
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

  setUp(() {
    messaging = _MockMessaging();
    gateway = _FakeGateway();
    refreshes = StreamController<String>.broadcast();
    addTearDown(refreshes.close);
    when(() => messaging.getToken(vapidKey: any(named: 'vapidKey')))
        .thenAnswer((_) async => 'token-1');
    when(() => messaging.onTokenRefresh).thenAnswer((_) => refreshes.stream);
    when(() => messaging.deleteToken()).thenAnswer((_) async {});
    repository = PushRepositoryImpl(
      messaging: messaging,
      gateway: gateway,
      platform: 'web',
      vapidKey: 'vapid',
    );
  });

  test('turning on asks for permission, then the server keeps the token, '
      'and later tokens too', () async {
    when(() => messaging.requestPermission())
        .thenAnswer((_) async => settings(AuthorizationStatus.authorized));

    expect(await repository.enable(language: 'es'), isA<Ok<void>>());
    expect(gateway.registered, [
      (token: 'token-1', platform: 'web', language: 'es'),
    ]);
    verify(() => messaging.getToken(vapidKey: 'vapid')).called(1);

    refreshes.add('token-2');
    await pumpEventQueue();
    expect(gateway.registered.last.token, 'token-2');
  });

  test(
    'a person who says no is told how to allow it, and nothing is sent',
    () async {
      when(() => messaging.requestPermission())
          .thenAnswer((_) async => settings(AuthorizationStatus.denied));

      final result = await repository.enable(language: 'es');

      expect(
        result,
        isA<Err<void>>().having(
          (err) => err.failure,
          'failure',
          isA<NotificationsBlockedFailure>(),
        ),
      );
      expect(gateway.registered, isEmpty);
    },
  );

  test('a browser that blocks notifications says so; other Firebase '
      'failures read as no connection', () async {
    when(() => messaging.requestPermission()).thenThrow(
      FirebaseException(plugin: 'messaging', code: 'permission-blocked'),
    );
    expect(
      await repository.enable(language: 'en'),
      isA<Err<void>>().having(
        (err) => err.failure,
        'failure',
        isA<NotificationsBlockedFailure>(),
      ),
    );

    when(() => messaging.requestPermission()).thenThrow(
      FirebaseException(plugin: 'messaging', code: 'token-subscribe-failed'),
    );
    expect(
      await repository.enable(language: 'en'),
      isA<Err<void>>().having(
        (err) => err.failure,
        'failure',
        isA<NoConnectionFailure>(),
      ),
    );
  });

  test(
    'refreshing sends the token only when notifications are allowed',
    () async {
      when(() => messaging.getNotificationSettings())
          .thenAnswer((_) async => settings(AuthorizationStatus.notDetermined));
      await repository.refresh(language: 'es');
      expect(gateway.registered, isEmpty);

      when(() => messaging.getNotificationSettings())
          .thenAnswer((_) async => settings(AuthorizationStatus.authorized));
      await repository.refresh(language: 'en');
      expect(gateway.registered.single.language, 'en');
    },
  );

  test('turning off forgets the token on the server and here', () async {
    expect(await repository.disable(), isA<Ok<void>>());

    expect(gateway.unregistered, 1);
    verify(() => messaging.deleteToken()).called(1);
  });
}
