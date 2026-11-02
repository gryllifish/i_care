import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/rejected_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/repositories/care_repository_impl.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';

import '../../helpers/care_events.dart';
import '../../helpers/hive_boxes.dart';

void main() {
  final openBox = useTemporaryHive();
  final events = EventFactory();
  final eight = DateTime(2026, 11, 2, 8);
  final now = DateTime(2026, 11, 2, 9);
  late SimulatedServer server;

  setUp(() async {
    server = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      await openBox(SimulatedServer.devicesBoxName),
      clock: () => now,
    );
    await server.seed([
      for (final event in SampleCircle.memberEvents(DateTime(2025)))
        CareEventCodec.encodeString(event),
    ]);
  });

  /// [id]'s phone, joined as that member of the sample circle.
  Future<(CareRepositoryImpl, SimulatedConnection)> device(String id) async {
    await server.bind('phone-$id', id);
    final connection = SimulatedConnection(server, deviceId: 'phone-$id');
    final repository = CareRepositoryImpl(
      events: EventStore(await openBox(EventStore.boxName(id))),
      rejected: RejectedStore(await openBox(RejectedStore.boxName(id))),
      syncState: SyncStateStore(await openBox(SyncStateStore.boxName(id))),
      gateway: connection,
      clock: () => now,
    )..start();
    addTearDown(repository.dispose);
    return (repository, connection);
  }

  /// The first log emitted whose records (the circle's members left out)
  /// satisfy [matches]; those records.
  Future<List<CareEvent>> logWhere(
    CareRepositoryImpl repository,
    bool Function(List<CareEvent>) matches,
  ) => repository
      .watchEvents()
      .map(
        (log) => [
          for (final event in log)
            if (event is! MemberInvited && event is! MemberJoined) event,
        ],
      )
      .firstWhere(matches);

  bool allSynced(List<CareEvent> log) =>
      log.isNotEmpty && log.every((event) => event.meta.isSynced);

  test('a recorded event is stored here and then synced', () async {
    final (repository, _) = await device('ana');
    final event = events.given('m1', at: eight);

    expect(await repository.record(event), isA<Ok<void>>());

    final [synced] = await logWhere(repository, allSynced);
    expect(synced.meta.id, event.meta.id);
    expect(synced.meta.receivedAt, now);
  });

  test("devices receive each other's events", () async {
    final (ana, _) = await device('ana');
    final (martin, _) = await device('martin');
    final event = events.given('m1', at: eight);

    await ana.record(event);

    final [received] = await logWhere(martin, (log) => log.isNotEmpty);
    expect(received.meta.id, event.meta.id);
  });

  test('offline records stay pending and sync once back online', () async {
    final (repository, connection) = await device('ana');
    connection.isOnline = false;

    await repository.record(events.given('m1', at: eight));

    await expectLater(
      repository.watchSyncStatus(),
      emitsThrough(
        isA<SyncStatus>()
            .having((s) => s.isConnected, 'isConnected', isFalse)
            .having((s) => s.pendingCount, 'pendingCount', 1),
      ),
    );

    connection.isOnline = true;

    await logWhere(repository, allSynced);
    final members = SampleCircle.memberEvents(DateTime(2025)).length;
    expect(server.eventsAfter(null).events, hasLength(members + 1));
  });

  test('after a stop and a reset, syncing restarts from the new log', () async {
    final (repository, _) = await device('ana');
    await repository.record(events.given('m1', at: eight));
    await logWhere(repository, allSynced);

    await repository.stop();
    await server.clear();
    final eventsBox = await openBox(EventStore.boxName('ana'));
    final syncBox = await openBox(SyncStateStore.boxName('ana'));
    await EventStore(eventsBox).clear();
    await SyncStateStore(syncBox).clear();
    final fresh = events.given('m2', at: eight);
    await server.seed([
      for (final event in SampleCircle.memberEvents(DateTime(2025)))
        CareEventCodec.encodeString(event),
      CareEventCodec.encodeString(fresh),
    ]);
    await server.bind('phone-ana', 'ana');
    repository.start();

    final [received] = await logWhere(repository, (log) => log.isNotEmpty);
    expect(received.meta.id, fresh.meta.id);
  });

  test('two offline devices converge on the same log', () async {
    final (ana, anaConnection) = await device('ana');
    final (martin, martinConnection) = await device('martin');
    anaConnection.isOnline = false;
    martinConnection.isOnline = false;

    await ana.record(events.given('m1', at: eight, slotAt: eight));
    await martin.record(
      events.given('m1', at: eight, slotAt: eight, by: 'martin'),
    );
    anaConnection.isOnline = true;
    martinConnection.isOnline = true;

    bool bothSynced(List<CareEvent> log) => log.length == 2 && allSynced(log);
    final anaLog = await logWhere(ana, bothSynced);
    final martinLog = await logWhere(martin, bothSynced);

    expect(anaLog.toSet(), martinLog.toSet());
  });

  test('a refused event is set apart: never resent, not shown, listed until '
      'dismissed', () async {
    final (rosa, _) = await device('rosa');
    final medication = events.created('m2', at: eight).withAuthor('rosa');
    final dose = events.given('m1', at: eight, by: 'rosa');

    await rosa.record(medication);
    await rosa.record(dose);

    final [kept] = await logWhere(rosa, allSynced);
    expect(kept.meta.id, dose.meta.id);
    final [refused] = await rosa.watchRejected().firstWhere(
      (rejected) => rejected.isNotEmpty,
    );
    expect(refused.event, medication);
    expect(refused.reason, RejectionReason.notAllowed);
    final status = await rosa.watchSyncStatus().firstWhere(
      (status) => status.rejectedCount == 1,
    );
    expect(status.pendingCount, 0);

    await rosa.dismissRejected(medication.meta.id);
    expect(await rosa.watchRejected().first, isEmpty);
  });
}
