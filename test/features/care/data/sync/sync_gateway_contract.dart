import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';

import '../../helpers/care_events.dart';

/// Three devices on one server holding the sample circle's members:
/// `device` joined as Ana (admin), `other` as Martín (caregiver) and
/// `helper` as Rosa (helper); and a way to take `device` offline.
typedef Gateways = ({
  SyncGateway device,
  SyncGateway other,
  SyncGateway helper,
  void Function({required bool online}) setDeviceOnline,
});

/// Behavior every [SyncGateway] must have. Runs against the simulated
/// remote now and against the Firestore emulator in stage 2
/// (`docs/backend.md`).
void runSyncGatewayContract(Future<Gateways> Function() connect) {
  late Gateways gateways;
  late EventFactory events;
  final eight = DateTime(2026, 11, 2, 8);

  /// Where the log stood before each test: after the circle's members.
  late String start;

  setUp(() async {
    gateways = await connect();
    events = EventFactory();
    start = (await gateways.device.watch().first).cursor;
  });

  Future<List<CareEvent>> firstBatch(SyncGateway gateway, {String? cursor}) =>
      gateway.watch(cursor: cursor).first.then((batch) => batch.events);

  test('push returns the events with the time the server got them', () async {
    final event = events.given('m1', at: eight);

    final result = await gateways.device.push([event]);
    final [stored] = result.stored;

    expect(result.rejected, isEmpty);
    expect(stored.meta.receivedAt, isNotNull);
    expect(stored.copyWith(meta: event.meta), event);
  });

  test('pushing an event twice stores it once, unchanged', () async {
    final event = events.given('m1', at: eight);

    final [first] = (await gateways.device.push([event])).stored;
    final [second] = (await gateways.other.push([event])).stored;

    expect(second, first);
    expect(await firstBatch(gateways.other, cursor: start), [first]);
  });

  test('watch starts with every event, in server order', () async {
    final stored = [
      ...(await gateways.device.push([events.given('m1', at: eight)])).stored,
      ...(await gateways.other.push([
        events.given('m1', at: eight, by: 'martin'),
      ])).stored,
    ];

    expect(await firstBatch(gateways.device, cursor: start), stored);
  });

  test('watch resumes after its cursor', () async {
    await gateways.device.push([events.given('m1', at: eight)]);
    final cursor = (await gateways.device.watch().first).cursor;
    final later = (await gateways.other.push([
      events.given('m1', at: eight, by: 'martin'),
    ])).stored;

    expect(await firstBatch(gateways.device, cursor: cursor), later);
  });

  test("watch delivers other devices' events as they arrive", () async {
    final recorder = _Recorder(gateways.device.watch(cursor: start));
    addTearDown(recorder.cancel);
    await recorder.until(() => recorder.batches.isNotEmpty);

    final stored = (await gateways.other.push([
      events.given('m1', at: eight, by: 'martin'),
    ])).stored;

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
    final recorder = _Recorder(gateways.device.watch(cursor: start));
    addTearDown(recorder.cancel);
    await recorder.until(() => recorder.batches.isNotEmpty);

    gateways.setDeviceOnline(online: false);
    await recorder.until(() => recorder.errors.isNotEmpty);
    expect(recorder.errors.first, isA<NoConnectionException>());

    final missed = (await gateways.other.push([
      events.given('m1', at: eight, by: 'martin'),
    ])).stored;
    gateways.setDeviceOnline(online: true);

    await recorder.until(() => recorder.received.isNotEmpty);
    expect(recorder.received, missed);
  });

  group('authorization (docs/roles.md)', () {
    test(
      'refuses an event written as someone else, and stores the rest',
      () async {
        final asMartin = events.given('m1', at: eight, by: 'martin');
        final asAna = events.given('m1', at: eight);

        final result = await gateways.device.push([asMartin, asAna]);

        expect(result.stored.map((e) => e.meta.id), [asAna.meta.id]);
        expect(result.rejected.single.event, asMartin);
        expect(result.rejected.single.reason, RejectionReason.wrongAuthor);
      },
    );

    test("refuses what the author's role does not allow", () async {
      final result = await gateways.helper.push([
        events.created('m2', at: eight).withAuthor('rosa'),
        events.given('m1', at: eight, by: 'rosa'),
      ]);

      expect(result.rejected.single.reason, RejectionReason.notAllowed);
      expect(result.stored.single, isA<DoseGiven>());
    });

    test("only admins take back someone else's record, except to review a "
        'conflict', () async {
      final [anas] = (await gateways.device.push([
        events.given('m1', at: eight),
      ])).stored;

      final byHelper = await gateways.helper.push([
        events.undone(anas).withAuthor('rosa'),
      ]);
      final inReview = await gateways.other.push([
        events
            .undone(anas)
            .withAuthor('martin')
            .copyWith(conflictKey: 'dose:m1:x'),
      ]);

      expect(byHelper.rejected.single.reason, RejectionReason.notAllowed);
      expect(inReview.stored, hasLength(1));
    });

    test(
      "keeps a removed member's facts, flagged, and refuses the rest",
      () async {
        await gateways.device.push([
          events.memberRemoved('rosa', baseVersion: 0),
        ]);

        final result = await gateways.helper.push([
          events.given('m1', at: eight, by: 'rosa'),
          events.created('m2', at: eight).withAuthor('rosa'),
        ]);

        expect(result.stored.single.meta.fromFormerMember, isTrue);
        expect(result.rejected.single.reason, RejectionReason.notMember);
      },
    );

    test(
      "a helper's watch leaves out the team's appointments and notes",
      () async {
        final [note, dose] = (await gateways.device.push([
          events.note('a1', 'Same dose'),
          events.given('m1', at: eight),
        ])).stored;

        expect(await firstBatch(gateways.helper, cursor: start), [dose]);
        expect(await firstBatch(gateways.other, cursor: start), [note, dose]);
      },
    );

    test('never leaves the circle without an admin', () async {
      final result = await gateways.device.push([
        events.roleChanged('ana', MemberRole.caregiver, baseVersion: 0),
      ]);

      expect(result.rejected.single.reason, RejectionReason.lastAdmin);
    });
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
