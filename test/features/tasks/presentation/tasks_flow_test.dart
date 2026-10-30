import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/scrolling.dart';
import '../../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);
  late EventFactory events;
  late FakeCareRepository repository;

  setUp(() {
    events = EventFactory();
    repository = FakeCareRepository([
      events.task(
        't1',
        schedule: const TaskSchedule(
          minutesOfDay: [10 * 60],
          weekdays: {DateTime.monday, DateTime.thursday},
        ),
      ),
    ])..status = SyncStatus(lastSyncedAt: now);
  });

  Future<void> openTab(WidgetTester tester) async {
    await pumpApp(tester, repository: repository, now: now);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Tasks'),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The pushed screen's list; text fields have scrollables of their
  /// own, so the list's is looked up explicitly.
  Finder topList() => find
      .descendant(
        of: find.byType(ListView).last,
        matching: find.byType(Scrollable),
      )
      .first;

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await centerInList(tester, finder, list: topList());
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Taps an option of a segmented control, which takes taps on the
  /// whole control rather than on each label.
  Future<void> tapSegment(WidgetTester tester, String label) async {
    final finder = find.text(label);
    await centerInList(tester, finder, list: topList());
    await tester.tapAt(tester.getCenter(finder));
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.descendant(
    of: find.ancestor(
      of: find.text(label),
      matching: find.byType(LabeledField),
    ),
    matching: find.byType(TextField),
  );

  testWidgets('lists tasks with their schedule', (tester) async {
    await openTab(tester);

    expect(find.text('Bath'), findsOneWidget);
    expect(find.text('10:00 · Mon, Thu'), findsOneWidget);
    expect(find.text('1 task · Sample data'), findsOneWidget);
  });

  testWidgets('adds a task during the day, every day by default', (
    tester,
  ) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));

    await tester.enterText(field('Name'), 'Check the skin');
    await tapAndSettle(tester, find.text('Save'));

    final created = repository.recorded.whereType<TaskCreated>().single;
    expect(created.details.name, 'Check the skin');
    expect(created.schedule, const TaskSchedule());
    expect(find.text('During the day · Every day'), findsOneWidget);
  });

  testWidgets('adds a task at set times on chosen days', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));

    await tester.enterText(field('Name'), 'Walk');
    await tapSegment(tester, 'At set times');
    await tapSegment(tester, 'Choose days');
    await tapAndSettle(tester, find.text('Wed'));
    await tapAndSettle(tester, find.text('Save'));

    final created = repository.recorded.whereType<TaskCreated>().single;
    expect(
      created.schedule,
      const TaskSchedule(
        minutesOfDay: [10 * 60],
        weekdays: {DateTime.wednesday},
      ),
    );
  });

  testWidgets('says what is missing instead of saving', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));

    await tapSegment(tester, 'At set times');
    await tapAndSettle(tester, find.byTooltip('Remove 10:00'));
    await tapAndSettle(tester, find.text('Save'));

    expect(find.text('Enter the name'), findsOneWidget);
    expect(find.text('Add at least one time'), findsOneWidget);
    expect(repository.recorded, isEmpty);
  });

  testWidgets('edits a task on its current version', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Bath'));

    expect(find.text('Edit task'), findsOneWidget);
    await tester.enterText(field('Name'), 'Shower');
    await tapAndSettle(tester, find.text('Save'));

    final updated = repository.recorded.single as TaskUpdated;
    expect(updated.details.name, 'Shower');
    expect(updated.baseVersion, 0);
    expect(find.text('Shower'), findsOneWidget);
  });

  testWidgets('archives a task after confirming', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Bath'));

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archive').last);
    await tester.pumpAndSettle();
    expect(find.text('Archive Bath?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Archive'));
    await tester.pumpAndSettle();

    expect(repository.recorded.single, isA<TaskArchived>());
    expect(find.text('Bath'), findsNothing);
    expect(find.textContaining('No tasks yet'), findsOneWidget);
  });
}
