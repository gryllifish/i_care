import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/medications/presentation/screens/medication_detail_screen.dart';
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
      events.created('m1', at: DateTime(2026, 11)),
      events.counted('m1', 30, at: DateTime(2026, 11)),
    ])..status = SyncStatus(lastSyncedAt: now);
  });

  Future<void> openTab(WidgetTester tester) async {
    await pumpApp(tester, repository: repository, now: now);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Meds'),
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

  Future<void> bringIntoView(WidgetTester tester, Finder finder) =>
      centerInList(tester, finder, list: topList());

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await bringIntoView(tester, finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Taps an option of a segmented control, which takes taps on the
  /// whole control rather than on each label.
  Future<void> tapSegment(WidgetTester tester, String label) async {
    final finder = find.text(label);
    await bringIntoView(tester, finder);
    await tester.tapAt(tester.getCenter(finder));
    await tester.pumpAndSettle();
  }

  /// The text field labeled [label].
  Finder field(String label) => find.descendant(
    of: find.ancestor(
      of: find.text(label),
      matching: find.byType(LabeledField),
    ),
    matching: find.byType(TextField),
  );

  Future<void> openDetail(WidgetTester tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Enalapril'));
  }

  testWidgets('adds a medication with its schedule and stock', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));

    await tester.enterText(field('Name'), 'Metformin');
    final stock = field('Units in stock (optional)');
    await bringIntoView(tester, stock);
    await tester.enterText(stock, '60');
    await tapAndSettle(tester, find.text('Save'));

    final created = repository.recorded.whereType<MedicationCreated>().single;
    expect(created.details.name, 'Metformin');
    expect(
      created.schedule,
      const DoseSchedule.fixed(minutesOfDay: [8 * 60]),
    );
    expect(
      repository.recorded.whereType<StockCounted>().single.units,
      60,
    );
    expect(find.text('2 active medications · Sample data'), findsOneWidget);
    // 08:00 has passed at 09:00, so the first dose is tomorrow's.
    expect(
      find.text('Metformin saved · First dose: Tomorrow, 08:00'),
      findsOneWidget,
    );
  });

  testWidgets('a medication can be scheduled on chosen days only', (
    tester,
  ) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));
    await tester.enterText(field('Name'), 'Vitamin D');

    await tapSegment(tester, 'Choose days');
    await tapAndSettle(tester, find.text('Save'));
    await bringIntoView(tester, find.text('Choose at least one day'));
    expect(repository.recorded, isEmpty);

    await tapAndSettle(tester, find.text('Mon'));
    await tapAndSettle(tester, find.text('Thu'));
    await tapAndSettle(tester, find.text('Save'));

    final created = repository.recorded.whereType<MedicationCreated>().single;
    expect(
      (created.schedule as FixedSchedule).weekdays,
      {DateTime.monday, DateTime.thursday},
    );
  });

  testWidgets('a medication needs a name and a time', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));

    await tapAndSettle(tester, find.byTooltip('Remove 08:00'));
    await tapAndSettle(tester, find.text('Save'));
    await tester.fling(
      find.byType(Scrollable).last,
      const Offset(0, 3000),
      3000,
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter the name'), findsOneWidget);
    await bringIntoView(tester, find.text('Add at least one time'));
    expect(find.text('Add at least one time'), findsOneWidget);
    expect(repository.recorded, isEmpty);
  });

  testWidgets('changing the schedule keeps the earlier one listed', (
    tester,
  ) async {
    await openDetail(tester);
    await tapAndSettle(tester, find.text('Change schedule'));

    await tapSegment(tester, 'As needed');
    await tapSegment(tester, 'Tomorrow');
    await tapAndSettle(tester, find.text('Save'));

    final changed = repository.recorded.single as ScheduleChanged;
    expect(changed.effectiveFrom, DateTime(2026, 11, 3));
    expect(changed.baseVersion, 0);
    expect(find.text('As needed · at least 6 h apart'), findsOneWidget);
    expect(find.text('Earlier schedules'), findsOneWidget);
  });

  testWidgets('stock is recounted and refilled from the detail', (
    tester,
  ) async {
    await openDetail(tester);

    await tapAndSettle(tester, find.text('Recount'));
    await tester.enterText(find.byType(TextField), '12');
    await tapAndSettle(tester, find.text('Save'));
    expect(find.text('12 units'), findsOneWidget);

    await tapAndSettle(tester, find.text('Bought more'));
    await tapAndSettle(tester, find.text('+30'));
    await tapAndSettle(tester, find.text('Save'));

    expect(repository.recorded.whereType<StockRefilled>().single.units, 30);
    expect(find.text('42 units'), findsOneWidget);
  });

  testWidgets('archiving asks first and removes it from the list', (
    tester,
  ) async {
    await openDetail(tester);

    await tapAndSettle(tester, find.byTooltip('More'));
    await tapAndSettle(tester, find.text('Archive'));
    expect(find.text('Archive Enalapril?'), findsOneWidget);
    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Archive'));

    expect(repository.recorded.single, isA<MedicationArchived>());
    expect(find.byType(MedicationDetailScreen), findsNothing);
    expect(find.text('0 active medications · Sample data'), findsOneWidget);
  });

  testWidgets('concurrent edits are flagged and one can be brought back', (
    tester,
  ) async {
    final edited = DateTime(2026, 11, 2, 8);
    final anas = events.updated(
      'm1',
      baseVersion: 0,
      name: 'By Ana',
      at: edited,
    );
    repository
      ..receive(anas)
      ..receive(
        events.updated(
          'm1',
          baseVersion: 0,
          name: 'By Martín',
          by: 'martin',
          at: edited,
        ),
      );
    await openTab(tester);

    expect(find.text('Needs review'), findsOneWidget);
    await tapAndSettle(tester, find.text('By Martín'));
    expect(
      find.text('Changed by more than one person at the same time'),
      findsOneWidget,
    );

    await tapAndSettle(tester, find.text('Use this one'));

    expect(
      repository.recorded.whereType<MedicationUpdated>().single.details.name,
      'By Ana',
    );
    expect(repository.recorded.last, isA<ConflictAcknowledged>());
    expect(
      find.text('Changed by more than one person at the same time'),
      findsNothing,
    );
  });

  testWidgets('the new screens fit at 200 % text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openDetail(tester);
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, -2000),
      2000,
    );
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.text('Change schedule'));
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, -2000),
      2000,
    );
    await tester.pumpAndSettle();

    // Layout overflows fail the test on their own; nothing to assert.
  });
}
