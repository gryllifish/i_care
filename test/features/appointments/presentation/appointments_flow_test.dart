import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

import '../../../helpers/pump_app.dart';
import '../../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 12);
  late EventFactory events;
  late FakeCareRepository repository;

  setUp(() {
    events = EventFactory();
    repository = FakeCareRepository([
      events.appointment(
        'cardio',
        startsAt: DateTime(2026, 11, 3, 10, 30),
        at: DateTime(2026, 11),
      ),
      events.appointment(
        'checkup',
        title: 'General practice',
        startsAt: DateTime(2026, 11, 1, 11),
        at: DateTime(2026, 11),
      ),
    ])..status = SyncStatus(lastSyncedAt: now);
  });

  Finder tab(String label) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  Finder field(String label) => find.descendant(
    of: find.ancestor(
      of: find.text(label),
      matching: find.byType(LabeledField),
    ),
    matching: find.byType(TextField),
  );

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester) async {
    await pumpApp(tester, repository: repository, now: now);
    await tapAndSettle(tester, tab('Appointments'));
  }

  testWidgets('lists upcoming and past, asking for missing notes', (
    tester,
  ) async {
    await openTab(tester);

    expect(find.text('UPCOMING'), findsOneWidget);
    expect(find.text('Tomorrow, 10:30'), findsOneWidget);
    expect(find.text('PAST'), findsOneWidget);
    expect(find.text('No notes yet: add what the doctor said'), findsOneWidget);
  });

  testWidgets('Today shows the next appointment and opens it', (tester) async {
    await pumpApp(tester, repository: repository, now: now);

    await tester.scrollUntilVisible(
      find.text('NEXT APPOINTMENT'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tapAndSettle(tester, find.text('Cardiology'));

    expect(find.text('Cardiology'), findsWidgets);
    // Upcoming: no notes to write yet.
    expect(find.text('VISIT NOTES'), findsNothing);
  });

  testWidgets('adds an appointment, requiring a title', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));

    await tapAndSettle(tester, find.text('Save'));
    expect(find.text('Enter the specialty or reason'), findsOneWidget);

    await tester.enterText(field('Specialty or reason'), 'Dentist');
    await tester.enterText(field('Doctor (optional)'), 'Dr. Ruiz');
    await tapAndSettle(tester, find.text('Save'));

    final created = repository.recorded.whereType<AppointmentCreated>().single;
    expect(created.details.title, 'Dentist');
    expect(created.details.doctor, 'Dr. Ruiz');
    expect(created.details.startsAt, DateTime(2026, 11, 3, 10));
    expect(find.text('Dentist'), findsOneWidget);
  });

  testWidgets('notes are added after a visit', (tester) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('General practice'));

    await tester.enterText(field('New note'), 'Same treatment for now');
    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Add note'));

    expect(
      repository.recorded.whereType<VisitNoteAdded>().single.text,
      'Same treatment for now',
    );
    expect(find.text('Same treatment for now'), findsOneWidget);
  });

  testWidgets('cancelling asks first and removes it from the list', (
    tester,
  ) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Cardiology'));

    await tapAndSettle(tester, find.byTooltip('More'));
    await tapAndSettle(tester, find.text('Cancel appointment'));
    await tapAndSettle(
      tester,
      find.widgetWithText(FilledButton, 'Cancel appointment'),
    );

    expect(repository.recorded.single, isA<AppointmentCancelled>());
    expect(find.text('Cardiology'), findsNothing);
  });

  testWidgets('the appointment screens fit at 200 % text size', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openTab(tester);
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, -2000),
      2000,
    );
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.text('General practice'));
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, -2000),
      2000,
    );
    await tester.pumpAndSettle();

    // Layout overflows fail the test on their own; nothing to assert.
  });
}
