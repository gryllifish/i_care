import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';

import '../../../helpers/pump_app.dart';
import '../../care/helpers/care_events.dart';

void main() {
  late EventFactory events;
  final eight = DateTime(2026, 11, 2, 8);
  final now = DateTime(2026, 11, 2, 8, 10);

  setUp(() => events = EventFactory());

  /// Enalapril at 08:00 and 20:00, with yesterday's doses given.
  FakeCareRepository circle([List<CareEvent> extra = const []]) {
    final yesterday = DateTime(2026, 11, 1, 8);
    final yesterdayNight = DateTime(2026, 11, 1, 20);
    return FakeCareRepository([
      events.created('m1', effectiveFrom: DateTime(2026, 11)),
      events.given('m1', at: yesterday, slotAt: yesterday, by: 'martin'),
      events.given('m1', at: yesterdayNight, slotAt: yesterdayNight),
      ...extra,
    ])..status = SyncStatus(lastSyncedAt: now);
  }

  Future<void> openDose(WidgetTester tester, String time) async {
    await tester.tap(find.text(time).last);
    await tester.pumpAndSettle();
  }

  testWidgets('shows the next dose and today by part of the day', (
    tester,
  ) async {
    await pumpApp(tester, repository: circle(), now: now);

    expect(find.text('Next dose'), findsOneWidget);
    expect(find.text('08:00 · Enalapril 10 mg'), findsOneWidget);
    expect(find.text('Morning'), findsOneWidget);
    expect(find.text('Night'), findsOneWidget);
    expect(find.text('Due now'), findsWidgets);
  });

  testWidgets('recording a dose names the caregiver and offers undo', (
    tester,
  ) async {
    final repository = circle();
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.text('Mark as given'));
    await tester.pumpAndSettle();

    final given = repository.recorded.single as DoseGiven;
    expect(given.slotAt, eight);
    expect(given.meta.caregiverId, 'ana');
    expect(given.knownDoseIds, isEmpty);
    expect(find.text('Given · Ana at 08:10'), findsOneWidget);
    // The fake never syncs, so the record stays on this phone only.
    expect(find.text('Not synced yet'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(
      repository.recorded.last,
      isA<DoseUndone>().having((e) => e.targetEventId, 'target', 'new-0'),
    );
    expect(find.text('Due now'), findsWidgets);
  });

  testWidgets('warns when this phone has not synced for a while', (
    tester,
  ) async {
    final repository = circle()
      ..status = SyncStatus(lastSyncedAt: DateTime(2026, 11, 2, 7));
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');

    expect(
      find.text(
        'This phone last synced at 07:00: someone may have given it already.',
      ),
      findsOneWidget,
    );
    expect(find.text('Mark as given anyway'), findsOneWidget);
  });

  testWidgets('a dose already given is confirmed knowingly', (tester) async {
    final martins = events.given('m1', at: eight, slotAt: eight, by: 'martin');
    final repository = circle([martins]);
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');

    expect(find.text('Check before giving it'), findsOneWidget);
    expect(find.text('Martín already recorded it at 08:00.'), findsOneWidget);

    await tester.tap(find.text('Mark as given anyway'));
    await tester.pumpAndSettle();

    final given = repository.recorded.single as DoseGiven;
    expect(given.knownDoseIds, [martins.meta.id]);
    expect(find.text('Given twice · Martín at 08:00 · Ana at 08:10'), findsOne);
  });

  group('doses given twice without seeing each other', () {
    late FakeCareRepository repository;
    late DoseGiven anas;
    late DoseGiven martins;

    setUp(() {
      anas = events.given('m1', at: eight, slotAt: eight);
      martins = events.given(
        'm1',
        at: eight.add(const Duration(minutes: 1)),
        slotAt: eight,
        by: 'martin',
      );
      repository = circle([anas, martins]);
    });

    Future<void> openConflict(WidgetTester tester) async {
      await tester.tap(find.text('Enalapril at 08:00 was recorded 2 times'));
      await tester.pumpAndSettle();
    }

    testWidgets('say what happened at the top of Today', (tester) async {
      await pumpApp(tester, repository: repository, now: now);

      expect(
        find.text('Enalapril at 08:00 was recorded 2 times'),
        findsOneWidget,
      );
      expect(find.text('Ana at 08:00 · Martín at 08:01'), findsOneWidget);
    });

    testWidgets('"only one" cancels the repeated record', (tester) async {
      await pumpApp(tester, repository: repository, now: now);

      await openConflict(tester);
      expect(find.text('Did Elena get both doses?'), findsOneWidget);
      expect(find.text('Mark as given'), findsNothing);

      await tester.tap(find.text('No, only one'));
      await tester.pumpAndSettle();

      expect(
        repository.recorded.single,
        isA<DoseUndone>().having(
          (e) => e.targetEventId,
          'target',
          martins.meta.id,
        ),
      );
      expect(find.text('Repeated record cancelled'), findsOneWidget);
      expect(find.text('Given · Ana at 08:00'), findsOneWidget);
    });

    testWidgets('"both were given" keeps the double dose on record', (
      tester,
    ) async {
      await pumpApp(tester, repository: repository, now: now);

      await openConflict(tester);
      await tester.tap(find.text('Yes, both were given'));
      await tester.pumpAndSettle();

      expect(repository.recorded.single, isA<ConflictAcknowledged>());
      expect(
        find.text(
          'Recorded as given more than once. If in doubt, ask the doctor '
          'or pharmacist.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('interrupt when they arrive with a sync', (tester) async {
      final repository = circle([anas]);
      await pumpApp(tester, repository: repository, now: now);

      repository.receive(martins);
      await tester.pumpAndSettle();

      expect(
        find.text('Enalapril was recorded more than once'),
        findsOneWidget,
      );
      await tester.tap(find.text('Review').last);
      await tester.pumpAndSettle();

      expect(find.text('Did Elena get both doses?'), findsOneWidget);
    });
  });

  testWidgets('an offline phone warns before giving and says where the '
      'record is', (tester) async {
    final repository = circle()
      ..status = SyncStatus(lastSyncedAt: now, isConnected: false);
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    expect(
      find.text('This phone is offline: someone may have given it already.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Mark as given anyway'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Enalapril saved on this phone. It will sync when the connection '
        'is back.',
      ),
      findsOneWidget,
    );
  });

  testWidgets("yesterday's dose stays visible after giving it today", (
    tester,
  ) async {
    final repository = FakeCareRepository([
      events.created('m1', effectiveFrom: DateTime(2026, 11)),
    ])..status = SyncStatus(lastSyncedAt: now);
    await pumpApp(tester, repository: repository, now: now);

    await tester.tap(find.text('Yesterday 08:00 · Enalapril 10 mg'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark as given'));
    await tester.pumpAndSettle();

    expect(find.text('From yesterday'), findsOneWidget);
    expect(find.text('Given · Ana, today at 08:10'), findsOneWidget);
  });

  testWidgets('a dose can be skipped with a reason', (tester) async {
    final repository = circle();
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.text('Skip this dose'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Was asleep'));
    await tester.pumpAndSettle();

    expect(
      repository.recorded.single,
      isA<DoseSkipped>().having((e) => e.reason, 'reason', SkipReason.asleep),
    );
    expect(find.text('Skipped · Ana at 08:10'), findsOneWidget);
  });

  testWidgets('as-needed doses show who gave the last one', (tester) async {
    final repository = FakeCareRepository([
      events.created(
        'p1',
        name: 'Paracetamol',
        schedule: const DoseSchedule.asNeeded(minInterval: Duration(hours: 6)),
      ),
      events.given('p1', at: DateTime(2026, 11, 2, 6), by: 'martin'),
    ]);
    await pumpApp(tester, repository: repository, now: now);

    expect(find.text('Last dose: 06:00, by Martín'), findsOneWidget);
  });

  testWidgets('says when this phone is offline with changes to send', (
    tester,
  ) async {
    final repository = circle()
      ..status = const SyncStatus(isConnected: false, pendingCount: 2);
    await pumpApp(tester, repository: repository, now: now);

    expect(find.text('Offline · 2 changes waiting to sync'), findsOneWidget);
  });

  testWidgets('a failed write is reported, not swallowed', (tester) async {
    final repository = circle()..failure = const StorageFailure();
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.text('Mark as given'));
    await tester.pumpAndSettle();

    expect(find.text("We couldn't read the saved data."), findsOneWidget);
    expect(find.byType(SnackBarAction), findsNothing);
  });
}
