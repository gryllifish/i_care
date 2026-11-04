import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/google_account_source.dart';
import 'package:i_care/features/care/data/datasources/rejected_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/repositories/access_repository_impl.dart';
import 'package:i_care/features/care/data/repositories/care_repository_impl.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/access_gateway.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

import '../../helpers/hive_boxes.dart';

/// Google's picker, answering with [account] (null: closed) or throwing
/// [error].
class _FakeGoogle implements GoogleAccountSource {
  String? account = 'ana@example.com';
  AppException? error;

  @override
  Future<GoogleCredential?> pick() async {
    if (error case final error?) throw error;
    return switch (account) {
      final String email => (
        idToken: 'id-$email',
        accessToken: null,
        email: email,
      ),
      null => null,
    };
  }
}

void main() {
  final openBox = useTemporaryHive();
  final now = DateTime(2026, 11, 2, 9);
  late SimulatedServer server;

  setUp(() async {
    server = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      await openBox(SimulatedServer.devicesBoxName),
      await openBox(SimulatedServer.codesBoxName),
      await openBox(SimulatedServer.settingsBoxName),
      clock: () => now,
    );
    await server.seed([
      for (final event in SampleCircle.circleEvents(DateTime(2025)))
        CareEventCodec.encodeString(event),
    ]);
    await server.bind('phone-ana', 'ana');
    await server.bind('phone-martin', 'martin');
  });

  /// The phone [deviceId], with its own copy of the log and [google] as
  /// its account picker.
  Future<(AccessRepositoryImpl, CareRepositoryImpl, SimulatedConnection)> phone(
    String deviceId,
    _FakeGoogle google,
  ) async {
    final connection = SimulatedConnection(server, deviceId: deviceId);
    final care = CareRepositoryImpl(
      events: EventStore(await openBox(EventStore.boxName(deviceId))),
      rejected: RejectedStore(await openBox(RejectedStore.boxName(deviceId))),
      syncState: SyncStateStore(
        await openBox(SyncStateStore.boxName(deviceId)),
      ),
      gateway: connection,
      clock: () => now,
    )..start();
    addTearDown(care.dispose);
    final access = AccessRepositoryImpl(
      google: google,
      gateway: connection,
      care: care,
    );
    return (access, care, connection);
  }

  group('protecting', () {
    test('links the account picked and says which it is', () async {
      final (ana, _, _) = await phone('phone-ana', _FakeGoogle());

      expect(
        await ana.protectedWith(),
        isA<Ok<String?>>().having((ok) => ok.value, 'before', isNull),
      );
      expect(
        await ana.protect(),
        isA<Ok<String?>>().having((ok) => ok.value, 'email', 'ana@example.com'),
      );
      expect(
        await ana.protectedWith(),
        isA<Ok<String?>>().having((ok) => ok.value, 'after', 'ana@example.com'),
      );
    });

    test('closing the picker changes nothing and is no error', () async {
      final (ana, _, _) = await phone(
        'phone-ana',
        _FakeGoogle()..account = null,
      );

      expect(
        await ana.protect(),
        isA<Ok<String?>>().having((ok) => ok.value, 'email', isNull),
      );
      expect(server.protectedWith('phone-ana'), isNull);
    });

    test("an account protecting someone else's access is refused", () async {
      final (ana, _, _) = await phone('phone-ana', _FakeGoogle());
      final (martin, _, _) = await phone('phone-martin', _FakeGoogle());
      await ana.protect();

      expect(
        await martin.protect(),
        isA<Err<String?>>().having(
          (err) => err.failure,
          'failure',
          isA<AccountInUseFailure>(),
        ),
      );
    });

    test('offline, it fails as a transient failure', () async {
      final (ana, _, connection) = await phone('phone-ana', _FakeGoogle());
      connection.isOnline = false;

      expect(
        await ana.protect(),
        isA<Err<String?>>().having(
          (err) => err.failure.isTransient,
          'transient',
          isTrue,
        ),
      );
    });
  });

  group('recovering on a new phone', () {
    test(
      'makes it the member, tells the circle and ends the old phone',
      () async {
        final (oldPhone, _, _) = await phone('phone-ana', _FakeGoogle());
        await oldPhone.protect();
        final (newPhone, care, _) = await phone('phone-new', _FakeGoogle());

        expect(
          await newPhone.recover(),
          isA<Ok<String?>>().having((ok) => ok.value, 'member', 'ana'),
        );
        expect(server.activeMemberOf('phone-new'), 'ana');
        expect(server.isActive('phone-ana'), isFalse);
        final log = await care.watchEvents().firstWhere(
          (events) => events.any((event) => event is AccessRecovered),
        );
        final recovered = log.whereType<AccessRecovered>().single;
        expect(recovered.memberId, 'ana');
        expect(recovered.meta.caregiverId, systemAuthor);
      },
    );

    test('with an account protecting nobody, says so', () async {
      final (newPhone, _, _) = await phone('phone-new', _FakeGoogle());

      expect(
        await newPhone.recover(),
        isA<Err<String?>>().having(
          (err) => err.failure,
          'failure',
          isA<NoAccessFailure>(),
        ),
      );
      expect(server.isActive('phone-new'), isFalse);
    });

    test('closing the picker changes nothing', () async {
      final (oldPhone, _, _) = await phone('phone-ana', _FakeGoogle());
      await oldPhone.protect();
      final (newPhone, _, _) = await phone(
        'phone-new',
        _FakeGoogle()..account = null,
      );

      expect(
        await newPhone.recover(),
        isA<Ok<String?>>().having((ok) => ok.value, 'member', isNull),
      );
      expect(server.isActive('phone-ana'), isTrue);
    });
  });
}
