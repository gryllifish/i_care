import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/features/care/data/sync/supabase_connection.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'sync_gateway_contract.dart';

/// The local stack `supabase start` runs. The key is the CLI's fixed
/// local one, not a secret.
const _apiPort = 54321;
const _publishableKey = 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH';

/// Runs the gateway contract against the backend in `supabase/`, when
/// the local stack is running; skipped otherwise (`docs/backend.md`).
Future<void> main() async {
  final running = await _stackIsRunning();

  group(
    'SupabaseConnection',
    skip: running ? false : 'needs a local stack: `supabase start`',
    () {
      final proxy = _Proxy();
      final devices = <String, _Device>{};
      setUpAll(proxy.start);
      tearDownAll(() async {
        for (final device in devices.values) {
          await device.client.dispose();
        }
        await proxy.stop();
      });

      runSyncGatewayContract(() async {
        proxy.online = true;
        // Only Ana's phone goes through the proxy: her network can drop.
        final ana = devices['ana'] ??= _Device(proxy.port);
        final martin = devices['martin'] ??= _Device(_apiPort);
        final rosa = devices['rosa'] ??= _Device(_apiPort);
        for (final device in [ana, martin, rosa]) {
          await device.signIn();
        }

        // A fresh circle for every test, with the sample's three members.
        try {
          await ana.client.rpc<void>('delete_circle');
        } on PostgrestException catch (error) {
          if (error.message != 'not_member') rethrow;
        }
        await ana.client.rpc<Object?>(
          'create_circle',
          params: {
            'p_creator_name': 'Ana',
            'p_recipient_name': 'Elena',
            'p_member_id': 'ana',
          },
        );
        final at = DateTime(2026, 11, 2, 7);
        await ana.connection.push([
          for (final (index, (id, name, role)) in [
            ('martin', 'Martín', MemberRole.caregiver),
            ('rosa', 'Rosa', MemberRole.helper),
          ].indexed)
            CareEvent.memberInvited(
              meta: EventMeta(
                id: 'invite-$id',
                caregiverId: 'ana',
                occurredAt: at,
              ),
              memberId: id,
              name: name,
              role: role,
              colorIndex: index + 1,
            ),
        ]);
        await martin.connection.join(
          (await ana.connection.issueCode('martin')).code,
        );
        await rosa.connection.join(
          (await ana.connection.issueCode('rosa')).code,
        );

        return (
          device: ana.connection,
          other: martin.connection,
          helper: rosa.connection,
          setDeviceOnline: ({required bool online}) => proxy.online = online,
        );
      });

      group('membership', () {
        _Device newDevice() =>
            devices['new-${devices.length}'] = _Device(_apiPort);

        test('a phone signed out elsewhere starts over as a new device, '
            'which belongs to no one', () async {
          final phone = newDevice();
          await phone.connection.createCircle(
            creatorName: 'Ana',
            recipientName: 'Elena',
          );
          final before = phone.client.auth.currentSession;
          // What recovering on another phone does to this one: its
          // sessions end on the server, while it still holds a token.
          final http = HttpClient();
          addTearDown(http.close);
          final request = await http.postUrl(
            Uri.parse('http://127.0.0.1:$_apiPort/auth/v1/logout?scope=global'),
          );
          request.headers
            ..set('apikey', _publishableKey)
            ..set('Authorization', 'Bearer ${before?.accessToken}');
          expect((await request.close()).statusCode, 204);

          await expectLater(
            phone.connection.watch().first,
            throwsA(isA<NotMemberException>()),
          );
          expect(phone.client.auth.currentUser?.id, isNot(before?.user.id));
        });

        test(
          "a protected account's session is confirmed without asking",
          () async {
            final phone = newDevice();
            final email =
                'protected-${DateTime.now().microsecondsSinceEpoch}'
                '@example.com';
            await phone.connection.createCircle(
              creatorName: 'Ana',
              recipientName: 'Elena',
            );
            // Deleting the circle deletes its protected accounts.
            addTearDown(() => phone.client.rpc<void>('delete_circle'));
            // The phone's own user stops being anonymous, as when Google
            // is linked to it: the local stack confirms no emails.
            await phone.setEmail(email);

            // The first read meets an unconfirmed session and confirms it.
            final batch = await phone.connection.watch().first;
            expect(batch.events, isNotEmpty);
            // Its own phone, so the circle is not told of a new one.
            expect(batch.events.whereType<AccessRecovered>(), isEmpty);
            expect(await phone.connection.protectedWith(), email);
          },
        );

        test('a device in no circle is told so when it reads', () async {
          final stranger = newDevice();

          await expectLater(
            stranger.connection.watch().first,
            throwsA(isA<NotMemberException>()),
          );
        });

        test('a new circle makes its creator the admin, who issues codes '
            'that work once', () async {
          final admin = newDevice();
          final joiner = newDevice();
          final latecomer = newDevice();

          final adminId = await admin.connection.createCircle(
            creatorName: 'Ana',
            recipientName: 'Elena',
          );
          await admin.connection.push([
            CareEvent.memberInvited(
              meta: EventMeta(
                id: 'invite-luis',
                caregiverId: adminId,
                occurredAt: DateTime(2026, 11, 3, 9),
              ),
              memberId: 'luis',
              name: 'Luis',
              role: MemberRole.caregiver,
              colorIndex: 1,
            ),
          ]);
          final code = await admin.connection.issueCode('luis');

          expect(code.code, matches(RegExp(r'^[A-Z0-9]{3}-[A-Z0-9]{3}$')));
          expect(code.expiresAt.isAfter(DateTime.now()), isTrue);
          expect(await joiner.connection.join(code.code), 'luis');
          await expectLater(
            latecomer.connection.join(code.code),
            throwsA(
              isA<InvalidCodeException>().having(
                (error) => error.problem,
                'problem',
                CodeProblem.used,
              ),
            ),
          );
        });

        test('only an admin deletes the circle, and every phone learns it '
            'is in none', () async {
          final admin = newDevice();
          final member = newDevice();
          final adminId = await admin.connection.createCircle(
            creatorName: 'Ana',
            recipientName: 'Elena',
          );
          await admin.connection.push([
            CareEvent.memberInvited(
              meta: EventMeta(
                id: 'invite-luis',
                caregiverId: adminId,
                occurredAt: DateTime(2026, 11, 3, 9),
              ),
              memberId: 'luis',
              name: 'Luis',
              role: MemberRole.caregiver,
              colorIndex: 1,
            ),
          ]);
          await member.connection.join(
            (await admin.connection.issueCode('luis')).code,
          );

          await expectLater(
            member.connection.deleteCircle(),
            throwsA(isA<ForbiddenException>()),
          );
          await admin.connection.deleteCircle();

          for (final phone in [admin, member]) {
            await expectLater(
              phone.connection.watch().first,
              throwsA(isA<NotMemberException>()),
            );
          }
        });

        test('a device keeps and forgets its push token', () async {
          final phone = newDevice();

          await phone.connection.registerPushToken(
            token: 'fcm-token',
            platform: 'android',
            language: 'es',
          );
          await phone.connection.unregisterPushToken();
          await expectLater(
            phone.connection.registerPushToken(
              token: 'fcm-token',
              platform: 'fax',
              language: 'es',
            ),
            throwsA(isA<ServerException>()),
          );
        });

        test('too many wrong codes lock the device out for a while', () async {
          final guesser = newDevice();
          Future<CodeProblem?> attempt() async {
            try {
              await guesser.connection.join('AAAAAA');
              return null;
            } on InvalidCodeException catch (error) {
              return error.problem;
            }
          }

          final problems = [for (var i = 0; i < 6; i++) await attempt()];

          expect(problems, [
            for (var i = 0; i < 5; i++) CodeProblem.unknown,
            CodeProblem.locked,
          ]);
        });
      });
    },
  );
}

Future<bool> _stackIsRunning() async {
  try {
    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      _apiPort,
      timeout: const Duration(seconds: 1),
    );
    socket.destroy();
    return true;
  } on SocketException {
    return false;
  }
}

/// One phone: its own anonymous user and connection.
class _Device {
  _Device(int port)
    : client = SupabaseClient(
        'http://127.0.0.1:$port',
        _publishableKey,
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      ) {
    connection = SupabaseConnection(
      client,
      pollInterval: const Duration(milliseconds: 300),
      timeout: const Duration(seconds: 3),
    );
  }

  final SupabaseClient client;
  late final SupabaseConnection connection;

  Future<void> signIn() async {
    if (client.auth.currentSession == null) {
      await client.auth.signInAnonymously();
    }
  }

  /// Gives this device's user [email], through the public API: it is no
  /// longer anonymous, with the same id and session.
  Future<void> setEmail(String email) async {
    final http = HttpClient();
    try {
      final request = await http.openUrl(
        'PUT',
        Uri.parse('http://127.0.0.1:$_apiPort/auth/v1/user'),
      );
      request.headers
        ..set('apikey', _publishableKey)
        ..set(
          'Authorization',
          'Bearer ${client.auth.currentSession?.accessToken}',
        )
        ..contentType = ContentType.json;
      request.write(jsonEncode({'email': email, 'password': 'password-1'}));
      final response = await request.close();
      if (response.statusCode != 200) {
        throw StateError('Could not set the email: ${response.statusCode}');
      }
      await response.drain<void>();
    } finally {
      http.close();
    }
    // The client learns what its user now is.
    await client.auth.refreshSession();
  }
}

/// A TCP proxy in front of the local stack, so a test can cut one
/// phone's network: requests and the Realtime socket fail as in a real
/// outage, not through a fake client.
class _Proxy {
  ServerSocket? _server;
  final _pipes = <(Socket, Socket)>{};
  var _online = true;

  int get port => _server!.port;

  bool get online => _online;

  set online(bool value) {
    _online = value;
    if (value) return;
    // Closing a pipe removes it from the set: iterate over a copy.
    for (final (client, upstream) in _pipes.toList()) {
      client.destroy();
      upstream.destroy();
    }
    _pipes.clear();
  }

  Future<void> start() async {
    _server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen((client) async {
      if (!_online) {
        client.destroy();
        return;
      }
      final Socket upstream;
      try {
        upstream = await Socket.connect(InternetAddress.loopbackIPv4, _apiPort);
      } on SocketException {
        client.destroy();
        return;
      }
      final pipe = (client, upstream);
      _pipes.add(pipe);
      var closed = false;
      void close() {
        if (closed) return;
        closed = true;
        _pipes.remove(pipe);
        client.destroy();
        upstream.destroy();
      }

      void forward(Socket from, Socket to) => from.listen(
        (data) {
          if (!closed) to.add(data);
        },
        onDone: close,
        onError: (Object _) => close(),
        cancelOnError: true,
      );
      forward(client, upstream);
      forward(upstream, client);
    });
  }

  Future<void> stop() async {
    online = false;
    await _server?.close();
  }
}
