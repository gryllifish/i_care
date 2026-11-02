import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/today/presentation/widgets/dose_tile.dart';
import 'package:i_care/features/today/presentation/widgets/task_tile.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:i_care/shared/widgets/app_card.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/scrolling.dart';
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

  /// Opens the sheet of the dose at [time] on the timeline.
  Future<void> openDose(WidgetTester tester, String time) async {
    final tile = find.ancestor(
      of: find.text(time),
      matching: find.byType(DoseTile),
    );
    await centerInList(tester, tile, list: find.byType(Scrollable).first);
    await tester.tap(
      find.descendant(of: tile.first, matching: find.byType(AppCard)),
    );
    await tester.pumpAndSettle();
  }

  /// [text] inside the open dose sheet, not on the screen behind it.
  Finder inSheet(String text) => find.descendant(
    of: find.byType(BottomSheet),
    matching: find.text(text),
  );

  /// Scrolls the timeline until [finder] is built and visible.
  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find.byType(Scrollable).first,
      );

  testWidgets('shows the next dose and today by part of the day', (
    tester,
  ) async {
    await pumpApp(tester, repository: circle(), now: now);

    expect(find.text('NEXT DOSE · DUE NOW'), findsOneWidget);
    expect(find.text('08:00 · Enalapril'), findsOneWidget);
    expect(find.text('1 of 2 doses recorded today'), findsNothing);
    expect(find.text('0 of 2 doses recorded today'), findsOneWidget);
    await scrollTo(tester, find.text('Night'));
    expect(find.text('Morning'), findsOneWidget);
    expect(find.text('Due now'), findsOneWidget);
  });

  testWidgets('recording a dose names the caregiver and offers undo', (
    tester,
  ) async {
    final repository = circle();
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(inSheet('Mark as given'));
    await tester.pumpAndSettle();

    final given = repository.recorded.single as DoseGiven;
    expect(given.slotAt, eight);
    expect(given.meta.caregiverId, 'ana');
    expect(given.knownDoseIds, isEmpty);
    expect(find.text('Ana at 08:10'), findsOneWidget);
    expect(find.text('Given'), findsOneWidget);
    // The fake never syncs, so the record stays on this phone only.
    expect(find.text('Not synced yet'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(
      repository.recorded.last,
      isA<DoseUndone>().having((e) => e.targetEventId, 'target', 'new-0'),
    );
    expect(find.text('Ana at 08:10'), findsNothing);
  });

  group('the next dose card', () {
    Future<void> giveFromCard(WidgetTester tester) async {
      await tester.tap(find.text('Mark as given').first);
      // The record lands, the log changes, the card starts to switch and
      // the given one learns it was recorded.
      await tester.pump();
      await tester.pump();
      await tester.pump();
    }

    /// How visible the card with [title] is, as its fade sets it.
    double opacityOf(WidgetTester tester, String title) => tester
        .widget<FadeTransition>(
          find
              .ancestor(
                of: find.text(title),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;

    testWidgets('says the dose was given, then fades through to the next', (
      tester,
    ) async {
      await pumpApp(tester, repository: circle(), now: now);
      expect(find.text('08:00 · Enalapril'), findsOneWidget);

      await giveFromCard(tester);
      expect(
        find.ancestor(
          of: find.text('Given'),
          matching: find.byWidgetPredicate((widget) => widget is FilledButton),
        ),
        findsOneWidget,
      );

      // Early on: the given card is still fading; the next one has not
      // appeared, so two cards are never seen at once.
      await tester.pump(const Duration(milliseconds: 120));
      expect(opacityOf(tester, '08:00 · Enalapril'), greaterThan(0));
      expect(opacityOf(tester, '20:00 · Enalapril'), 0);

      // Later: the given card is gone, the next one is coming in.
      await tester.pump(const Duration(milliseconds: 200));
      expect(opacityOf(tester, '08:00 · Enalapril'), 0);
      expect(opacityOf(tester, '20:00 · Enalapril'), greaterThan(0));

      await tester.pumpAndSettle();
      expect(find.text('08:00 · Enalapril'), findsNothing);
      expect(find.text('20:00 · Enalapril'), findsOneWidget);
    });

    testWidgets('changes at once when the system reduces motion', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpApp(tester, repository: circle(), now: now);

      await giveFromCard(tester);
      await tester.pump();

      expect(find.text('08:00 · Enalapril'), findsNothing);
      expect(find.text('20:00 · Enalapril'), findsOneWidget);
    });
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

  testWidgets('a dose given earlier is recorded at that time', (
    tester,
  ) async {
    final repository = circle();
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.text('1 hour ago'));
    await tester.pumpAndSettle();
    await tester.tap(inSheet('Mark as given'));
    await tester.pumpAndSettle();

    final given = repository.recorded.single as DoseGiven;
    expect(given.givenAt, DateTime(2026, 11, 2, 7, 10));
    expect(given.meta.occurredAt, now);
    expect(find.text('Ana at 07:10'), findsOneWidget);
  });

  testWidgets('a dose already given offers removing it, not giving it '
      'again', (tester) async {
    final martins = events.given('m1', at: eight, slotAt: eight, by: 'martin');
    await pumpApp(tester, repository: circle([martins]), now: now);

    await openDose(tester, '08:00');

    expect(inSheet('Mark as given'), findsNothing);
    expect(find.text('Mark as given anyway'), findsNothing);
    expect(find.bySemanticsLabel("Remove Martín's record"), findsOneWidget);
    expect(find.text('I gave it too'), findsOneWidget);
  });

  testWidgets('a dose this caregiver recorded is only offered removing', (
    tester,
  ) async {
    final anas = events.given('m1', at: eight, slotAt: eight);
    await pumpApp(tester, repository: circle([anas]), now: now);

    await openDose(tester, '08:00');

    expect(find.bySemanticsLabel("Remove Ana's record"), findsOneWidget);
    expect(find.text('I gave it too'), findsNothing);
    expect(inSheet('Mark as given'), findsNothing);
  });

  testWidgets('a second dose really given is recorded knowingly', (
    tester,
  ) async {
    final martins = events.given('m1', at: eight, slotAt: eight, by: 'martin');
    final repository = circle([martins]);
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.text('I gave it too'));
    await tester.pumpAndSettle();

    expect(find.text('Check before giving it'), findsOneWidget);
    expect(find.text('Martín already recorded it at 08:00.'), findsOneWidget);

    await tester.tap(find.text('Mark as given anyway'));
    await tester.pumpAndSettle();

    final given = repository.recorded.single as DoseGiven;
    expect(given.knownDoseIds, [martins.meta.id]);
    expect(find.text('Martín at 08:00 · Ana at 08:10'), findsOneWidget);
    expect(find.text('Given twice'), findsOneWidget);
  });

  testWidgets('a third dose given knowingly is not a conflict', (
    tester,
  ) async {
    final martins = events.given('m1', at: eight, slotAt: eight, by: 'martin');
    final rosas = events.given(
      'm1',
      at: eight.add(const Duration(minutes: 1)),
      slotAt: eight,
      by: 'rosa',
      knowing: [martins],
    );
    final repository = circle([martins, rosas]);
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.text('I gave it too'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Mark as given anyway'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark as given anyway'));
    await tester.pumpAndSettle();

    final given = repository.recorded.single as DoseGiven;
    expect(
      given.knownDoseIds,
      unorderedEquals([martins.meta.id, rosas.meta.id]),
    );
    expect(find.text('Enalapril at 08:00 was recorded 3 times'), findsNothing);
    expect(find.text('Review'), findsNothing);
  });

  testWidgets('a dose recorded by mistake is removed after confirming', (
    tester,
  ) async {
    final anas = events.given('m1', at: eight, slotAt: eight);
    final repository = circle([anas]);
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.bySemanticsLabel("Remove Ana's record"));
    await tester.pumpAndSettle();

    expect(find.text('Remove this record?'), findsOneWidget);
    expect(
      find.text(
        'Ana recorded it as given at 08:00. Remove it only if the dose was '
        'not given. The change shows in Activity.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    final undone = repository.recorded.single as DoseUndone;
    expect(undone.targetEventId, anas.meta.id);
    expect(inSheet('Mark as given'), findsOneWidget);
    expect(inSheet('Skip this dose'), findsOneWidget);
  });

  testWidgets("only an admin is offered removing someone else's record", (
    tester,
  ) async {
    final anas = events.given('m1', at: eight, slotAt: eight);
    final martins = events.given(
      'm1',
      at: DateTime(2026, 11, 1, 20),
      slotAt: DateTime(2026, 11, 1, 20),
      by: 'martin',
    );
    await pumpApp(
      tester,
      repository: circle([anas, martins]),
      now: now,
      prefs: MemoryDevicePrefs({
        PrefKeys.welcomeSeen: 'true',
        PrefKeys.memberId: 'martin',
      }),
    );

    await openDose(tester, '08:00');

    expect(find.bySemanticsLabel("Remove Ana's record"), findsNothing);
  });

  testWidgets('cancelling the confirmation keeps the record', (tester) async {
    final repository = circle([events.given('m1', at: eight, slotAt: eight)]);
    await pumpApp(tester, repository: repository, now: now);

    await openDose(tester, '08:00');
    await tester.tap(find.bySemanticsLabel("Remove Ana's record"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repository.recorded, isEmpty);
    expect(find.bySemanticsLabel("Remove Ana's record"), findsOneWidget);
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
      expect(inSheet('Mark as given'), findsNothing);

      await tester.tap(find.text('No, only one'));
      await tester.pumpAndSettle();

      expect(
        repository.recorded.single,
        isA<DoseUndone>()
            .having((e) => e.targetEventId, 'target', martins.meta.id)
            // So the server takes it from a caregiver as part of a review.
            .having((e) => e.conflictKey, 'conflictKey', startsWith('dose:')),
      );
      expect(find.text('Repeated record cancelled'), findsOneWidget);
      await scrollTo(tester, find.text('Ana at 08:00'));
      expect(find.text('Given'), findsOneWidget);
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

    expect(find.text('FROM YESTERDAY · LATE'), findsOneWidget);

    // Nothing to check first, so the card records it right away.
    await tester.tap(find.text('Mark as given'));
    await tester.pumpAndSettle();

    expect(repository.recorded.single, isA<DoseGiven>());
    await scrollTo(tester, find.text('Ana, today at 08:10'));
    expect(find.text('From yesterday'), findsOneWidget);
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
    expect(find.text('Ana at 08:10'), findsOneWidget);
    expect(find.text('Skipped'), findsOneWidget);
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
    await tester.tap(inSheet('Mark as given'));
    await tester.pumpAndSettle();

    expect(find.text("We couldn't read the saved data."), findsOneWidget);
    expect(find.byType(SnackBarAction), findsNothing);
  });

  group('care tasks', () {
    final day = DateTime(2026, 11, 2);

    /// Opens the sheet of the task named [name].
    Future<void> openTask(WidgetTester tester, String name) async {
      final card = find.ancestor(
        of: find.text(name),
        matching: find.byType(TaskCard),
      );
      await centerInList(tester, card, list: find.byType(Scrollable).first);
      await tester.tap(card);
      await tester.pumpAndSettle();
    }

    testWidgets('show on the timeline by time, untimed ones during the day', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle([
          events.task('t1', name: 'Walk'),
          events.task(
            't2',
            name: 'Check her skin',
            schedule: const TaskSchedule(),
          ),
        ]),
        now: now,
      );

      await scrollTo(tester, find.text('Walk'));
      expect(
        find.ancestor(of: find.text('10:00'), matching: find.byType(TaskTile)),
        findsOneWidget,
      );
      await scrollTo(tester, find.text('During the day'));
      expect(find.text('Check her skin'), findsOneWidget);
      expect(find.text('To do today'), findsOneWidget);
    });

    testWidgets('are marked done, with undo', (tester) async {
      final repository = circle([
        events.task(
          't1',
          name: 'Check her skin',
          schedule: const TaskSchedule(),
        ),
      ]);
      await pumpApp(tester, repository: repository, now: now);

      await openTask(tester, 'Check her skin');
      await tester.tap(find.text('Mark as done'));
      await tester.pumpAndSettle();

      final done = repository.recorded.single as TaskDone;
      expect(done.slotAt, day);
      expect(find.text('Check her skin: done'), findsOneWidget);
      expect(find.text('Ana at 08:10'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(repository.recorded.last, isA<DoseUndone>());
    });

    testWidgets('are marked not done with a reason that fits a task', (
      tester,
    ) async {
      final repository = circle([events.task('t1', name: 'Walk')]);
      await pumpApp(tester, repository: repository, now: now);

      await openTask(tester, 'Walk');
      await tester.tap(find.text('Not done'));
      await tester.pumpAndSettle();

      expect(find.text("Why wasn't it done?"), findsOneWidget);
      expect(find.text("Doctor's advice"), findsNothing);
      await tester.tap(find.text('Refused it'));
      await tester.pumpAndSettle();

      final skipped = repository.recorded.single as TaskSkipped;
      expect(skipped.reason, SkipReason.refused);
      expect(skipped.slotAt, DateTime(2026, 11, 2, 10));
    });

    testWidgets('a record made by mistake is removed after confirming', (
      tester,
    ) async {
      final done = events.taskDone('t1', slotAt: day, by: 'martin');
      final repository = circle([
        events.task(
          't1',
          name: 'Check her skin',
          schedule: const TaskSchedule(),
        ),
        done,
      ]);
      await pumpApp(tester, repository: repository, now: now);

      await openTask(tester, 'Check her skin');
      expect(find.text('Mark as done'), findsNothing);
      await tester.tap(find.bySemanticsLabel("Remove Martín's record"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();

      final undone = repository.recorded.single as DoseUndone;
      expect(undone.targetEventId, done.meta.id);
      expect(find.text('Mark as done'), findsOneWidget);
    });
  });
}
