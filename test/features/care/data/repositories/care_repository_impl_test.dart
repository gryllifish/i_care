import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/datasources/sync_state_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/repositories/care_repository_impl.dart';
import 'package:i_care/features/care/data/sync/simulated_connection.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
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
      clock: () => now,
    );
  });

  Future<(CareRepositoryImpl, SimulatedConnection)> device(String id) async {
    final connection = SimulatedConnection(server);
    final repository = CareRepositoryImpl(
      events: EventStore(await openBox(EventStore.boxName(id))),
      syncState: SyncStateStore(await openBox(SyncStateStore.boxName(id))),
      gateway: connection,
      clock: () => now,
    )..start();
    addTearDown(repository.dispose);
    return (repository, connection);
  }

  /// The first log emitted that satisfies [matches].
  Future<List<CareEvent>> logWhere(
    CareRepositoryImpl repository,
    bool Function(List<CareEvent>) matches,
  ) => repository.watchEvents().firstWhere(matches);

  bool allSynced(List<CareEvent> log) =>
      log.isNotEmpty && log.every((event) => event.meta.isSynced);

  test('a recorded event is stored here and then synced', () async {
    final (repository, _) = await device('a');
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
    final (repository, connection) = await device('a');
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
    expect(server.eventsAfter(null).events, hasLength(1));
  });

  test('after a stop and a reset, syncing restarts from the new log', () async {
    final (repository, _) = await device('a');
    await repository.record(events.given('m1', at: eight));
    await logWhere(repository, allSynced);

    await repository.stop();
    await server.clear();
    final eventsBox = await openBox(EventStore.boxName('a'));
    final syncBox = await openBox(SyncStateStore.boxName('a'));
    await EventStore(eventsBox).clear();
    await SyncStateStore(syncBox).clear();
    final fresh = events.given('m2', at: eight);
    await server.receive([CareEventCodec.encodeString(fresh)]);
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
}
