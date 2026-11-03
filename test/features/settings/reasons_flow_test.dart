import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/today/presentation/widgets/task_tile.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/scrolling.dart';
import '../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);
  final day = DateTime(2026, 11, 2);
  late EventFactory events;

  setUp(() => events = EventFactory());

  /// A task with no set time, and one of the circle's own reasons.
  FakeCareRepository circle([List<CareEvent> extra = const []]) =>
      FakeCareRepository([
        events.task(
          't1',
          name: 'Check the skin',
          schedule: const TaskSchedule(),
          at: DateTime(2026, 11),
        ),
        CareEvent.skipReasonAdded(
          meta: events.meta(at: DateTime(2026, 11)),
          reasonId: 'custom-1',
          label: 'At the day center',
        ),
        ...extra,
      ])..status = SyncStatus(lastSyncedAt: now);

  Future<void> openTask(WidgetTester tester) async {
    final card = find.ancestor(
      of: find.text('Check the skin'),
      matching: find.byType(TaskCard),
    );
    await centerInList(tester, card, list: find.byType(Scrollable).first);
    await tester.tap(card);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not done'));
    await tester.pumpAndSettle();
  }

  test('a skip reads as its reason, or as what was written for Other', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    const custom = {'custom-1': 'At the day center'};

    expect(
      skipText(l10n, reasonId: 'asleep', note: null, customReasons: custom),
      'Was asleep',
    );
    expect(
      skipText(l10n, reasonId: 'custom-1', note: null, customReasons: custom),
      'At the day center',
    );
    expect(
      skipText(l10n, reasonId: 'other', note: 'Fever', customReasons: custom),
      'Fever',
    );
    expect(
      skipText(l10n, reasonId: 'refused', note: 'Tired', customReasons: custom),
      'Refused it (Tired)',
    );
  });

  testWidgets("the circle's reason is offered and named in Activity", (
    tester,
  ) async {
    final repository = circle();
    await pumpApp(tester, repository: repository, now: now);

    await openTask(tester);
    await tester.tap(find.text('At the day center'));
    await tester.pumpAndSettle();

    final skipped = repository.recorded.single as TaskSkipped;
    expect(skipped.reasonId, 'custom-1');
    expect(skipped.slotAt, day);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Activity'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Ana skipped Check the skin: At the day center'),
      findsOneWidget,
    );
  });

  testWidgets('"Other" asks what happened and keeps it', (tester) async {
    final repository = circle();
    await pumpApp(tester, repository: repository, now: now);

    await openTask(tester);
    await tester.tap(find.text('Other reason'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'She had a fever');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final skipped = repository.recorded.single as TaskSkipped;
    expect(skipped.reasonId, 'other');
    expect(skipped.note, 'She had a fever');
  });

  group('in Settings', () {
    Future<void> openReasons(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Edit reasons'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ListView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('Edit reasons'));
      await tester.pumpAndSettle();
    }

    testWidgets('an admin adds a reason, refusing one already there', (
      tester,
    ) async {
      final repository = circle();
      await pumpApp(tester, repository: repository, now: now);
      await openReasons(tester);

      final field = find.ancestor(
        of: find.text('e.g. At the hospital'),
        matching: find.byType(TextField),
      );
      await tester.enterText(field, ' at the day center ');
      await tester.tap(find.text('Add reason'));
      await tester.pumpAndSettle();
      expect(
        find.text('Enter a reason that is not on the list.'),
        findsOneWidget,
      );
      expect(repository.recorded, isEmpty);

      await tester.enterText(field, 'Visiting family');
      await tester.tap(find.text('Add reason'));
      await tester.pumpAndSettle();

      final added = repository.recorded.single as SkipReasonAdded;
      expect(added.label, 'Visiting family');
      expect(added.reasonId, startsWith('custom-'));
    });

    testWidgets('an admin stops offering a standard reason', (tester) async {
      final repository = circle();
      await pumpApp(tester, repository: repository, now: now);
      await openReasons(tester);

      final asleep = find.ancestor(
        of: find.text('Was asleep'),
        matching: find.byType(SwitchListTile),
      );
      await tester.ensureVisible(asleep);
      await tester.pumpAndSettle();
      await tester.tap(asleep);
      await tester.pumpAndSettle();

      final hidden = repository.recorded.single as SkipReasonHidden;
      expect(hidden.reasonId, 'asleep');
    });

    testWidgets('a helper does not manage reasons', (tester) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: MemoryDevicePrefs({
          PrefKeys.welcomeSeen: 'true',
          PrefKeys.memberId: 'rosa',
        }),
      );
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('REASONS FOR NOT GIVING OR DOING'), findsNothing);
      expect(find.text('Edit reasons'), findsNothing);
    });
  });

  group('from the reason picker', () {
    testWidgets('an admin edits the reasons and comes back to pick one', (
      tester,
    ) async {
      await pumpApp(tester, repository: circle(), now: now);
      await openTask(tester);

      await tester.ensureVisible(find.text('Edit reasons'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit reasons'));
      await tester.pumpAndSettle();
      expect(find.text('Add reason'), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('At the day center'), findsOneWidget);
    });

    testWidgets('a helper only picks', (tester) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: MemoryDevicePrefs({
          PrefKeys.welcomeSeen: 'true',
          PrefKeys.memberId: 'rosa',
        }),
      );
      await openTask(tester);

      expect(find.text('At the day center'), findsOneWidget);
      expect(find.text('Edit reasons'), findsNothing);
    });
  });
}
