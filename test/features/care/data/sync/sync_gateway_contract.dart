import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

import '../../helpers/care_events.dart';

/// Two devices connected to the same server, and a way to take the first
/// one offline.
typedef GatewayPair = ({
  SyncGateway device,
  SyncGateway other,
  void Function({required bool online}) setDeviceOnline,
});

/// Behavior every [SyncGateway] must have. Runs against the simulated
/// remote now and against the Firestore emulator in stage 2
/// (`docs/backend.md`).
void runSyncGatewayContract(Future<GatewayPair> Function() connect) {
  late GatewayPair gateways;
  late EventFactory events;
  final eight = DateTime(2026, 11, 2, 8);

  setUp(() async {
    gateways = await connect();
    events = EventFactory();
  });

  Future<List<CareEvent>> firstBatch(SyncGateway gateway, {String? cursor}) =>
      gateway.watch(cursor: cursor).first.then((batch) => batch.events);

  test('push returns the events with the time the server got them', () async {
    final event = events.given('m1', at: eight);

    final [stored] = await gateways.device.push([event]);

    expect(stored.meta.receivedAt, isNotNull);
    expect(stored.copyWith(meta: event.meta), event);
  });

  test('pushing an event twice stores it once, unchanged', () async {
    final event = events.given('m1', at: eight);

    final [first] = await gateways.device.push([event]);
    final [second] = await gateways.other.push([event]);

    expect(second, first);
    expect(await firstBatch(gateways.other), [first]);
  });

  test('watch starts with every event, in server order', () async {
    final stored = [
      ...await gateways.device.push([events.given('m1', at: eight)]),
      ...await gateways.other.push([events.given('m1', at: eight)]),
    ];

    expect(await firstBatch(gateways.device), stored);
  });

  test('watch resumes after its cursor', () async {
    await gateways.device.push([events.given('m1', at: eight)]);
    final cursor = (await gateways.device.watch().first).cursor;
    final later = await gateways.other.push([events.given('m1', at: eight)]);

    expect(await firstBatch(gateways.device, cursor: cursor), later);
  });

  test("watch delivers other devices' events as they arrive", () async {
    final recorder = _Recorder(gateways.device.watch());
    addTearDown(recorder.cancel);
    await recorder.until(() => recorder.batches.isNotEmpty);

    final stored = await gateways.other.push([events.given('m1', at: eight)]);

    await recorder.until(() => recorder.received.isNotEmpty);
    expect(recorder.received, stored);
  });

  test('pushing while offline fails with NoConnectionException', () async {
    gateways.setDeviceOnline(online: false);

    await expectLater(
      gateways.device.push([events.given('m1', at: eight)]),
      throwsA(isA<NoConnectionException>()),
    );
  });

  test('watch reports going offline and catches up when back', () async {
    final recorder = _Recorder(gateways.device.watch());
    addTearDown(recorder.cancel);
    await recorder.until(() => recorder.batches.isNotEmpty);

    gateways.setDeviceOnline(online: false);
    await recorder.until(() => recorder.errors.isNotEmpty);
    expect(recorder.errors.first, isA<NoConnectionException>());

    final missed = await gateways.other.push([events.given('m1', at: eight)]);
    gateways.setDeviceOnline(online: true);

    await recorder.until(() => recorder.received.isNotEmpty);
    expect(recorder.received, missed);
  });
}

/// Records a watch stream without stopping at errors, as the repository
/// listens to it.
class _Recorder {
  _Recorder(Stream<SyncBatch> stream) {
    _subscription = stream.listen(
      (batch) {
        batches.add(batch);
        _changes.add(null);
      },
      onError: (Object error) {
        errors.add(error);
        _changes.add(null);
      },
    );
  }

  late final StreamSubscription<SyncBatch> _subscription;
  final _changes = StreamController<void>.broadcast();
  final batches = <SyncBatch>[];
  final errors = <Object>[];

  /// Every event received so far, across batches.
  List<CareEvent> get received => [
    for (final batch in batches) ...batch.events,
  ];

  Future<void> until(bool Function() condition) async {
    if (condition()) return;
    await _changes.stream
        .firstWhere((_) => condition())
        .timeout(const Duration(seconds: 5));
  }

  Future<void> cancel() async {
    await _subscription.cancel();
    await _changes.close();
  }
}
