import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/appointments/presentation/widgets/question_list_field.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';
import 'package:i_care/shared/providers/link_opener.dart';
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
    await tapAndSettle(tester, tab('Visits'));
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

    // Back returns to where it was opened from.
    await tapAndSettle(tester, find.byType(BackButton));
    expect(find.byType(TodayScreen), findsOneWidget);
    expect(find.text('NEXT APPOINTMENT'), findsOneWidget);
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

  testWidgets('questions are written one per field and can be removed', (
    tester,
  ) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));
    await tester.enterText(field('Specialty or reason'), 'Dentist');

    Finder question(int index) => find
        .descendant(
          of: find.byType(QuestionListField),
          matching: find.byType(TextField),
        )
        .at(index);

    await tester.ensureVisible(question(0));
    await tester.enterText(question(0), 'Is the dose right?');
    // The keyboard's next key adds a field below.
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();
    await tester.enterText(question(1), 'Blood test?');
    await tapAndSettle(tester, find.text('Add question'));
    await tester.enterText(question(2), 'When is the next visit?');
    await tapAndSettle(tester, find.byTooltip('Remove question').at(1));
    await tapAndSettle(tester, find.text('Save'));

    final created = repository.recorded.whereType<AppointmentCreated>().single;
    expect(
      created.details.questions,
      'Is the dose right?\nWhen is the next visit?',
    );
  });

  testWidgets('day and time are picked apart, each keeping the other', (
    tester,
  ) async {
    await openTab(tester);
    await tapAndSettle(tester, find.text('Add'));
    await tester.enterText(field('Specialty or reason'), 'Dentist');

    /// Turns the open wheel to [value] and confirms it.
    Future<void> pick(DateTime value) async {
      tester
          .widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker))
          .onDateTimeChanged(value);
      await tapAndSettle(tester, find.text('Done'));
    }

    await tapAndSettle(tester, find.text('10:00'));
    await pick(DateTime(2024, 1, 1, 15, 30));
    await tapAndSettle(tester, find.text('Tue, Nov 3'));
    await pick(DateTime(2026, 11, 10));
    expect(find.text('Tue, Nov 10'), findsOneWidget);
    expect(find.text('15:30'), findsOneWidget);

    await tapAndSettle(tester, find.text('Save'));
    final created = repository.recorded.whereType<AppointmentCreated>().single;
    expect(created.details.startsAt, DateTime(2026, 11, 10, 15, 30));
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

  group('documents', () {
    testWidgets('a link is added, checked first and shown on the list', (
      tester,
    ) async {
      await openTab(tester);
      await tapAndSettle(tester, find.text('Cardiology'));
      await tapAndSettle(tester, find.text('Add link'));

      await tester.enterText(field('Link'), 'lab results');
      await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Add link'));
      expect(find.text('Enter what it is'), findsOneWidget);
      expect(
        find.text('Enter a web address, like lab.example.com/results'),
        findsOneWidget,
      );
      expect(repository.recorded, isEmpty);

      await tester.enterText(field('What it is'), 'Blood test results');
      await tester.enterText(field('Link'), 'lab.example.com/results');
      await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Add link'));

      final linked = repository.recorded.single as DocumentLinked;
      expect(linked.title, 'Blood test results');
      expect(linked.url, 'https://lab.example.com/results');
      expect(find.text('Blood test results'), findsOneWidget);
      expect(find.text('lab.example.com · Ana'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('1 document'), findsOneWidget);
    });

    testWidgets('a link opens outside the app', (tester) async {
      final opened = <String>[];
      repository.events.add(
        events.document('cardio', 'ECG', at: DateTime(2026, 11, 2)),
      );
      await pumpApp(
        tester,
        repository: repository,
        now: now,
        overrides: [
          linkOpenerProvider.overrideWithValue((url) async {
            opened.add(url);
            return true;
          }),
        ],
      );
      await tapAndSettle(tester, tab('Visits'));
      await tapAndSettle(tester, find.text('Cardiology'));
      await tapAndSettle(tester, find.text('ECG'));

      expect(opened, ['https://lab.example.com/results']);
    });

    testWidgets('a link is removed after confirming', (tester) async {
      final ecg = events.document('cardio', 'ECG', at: DateTime(2026, 11, 2));
      repository.events.add(ecg);
      await openTab(tester);
      await tapAndSettle(tester, find.text('Cardiology'));

      await tapAndSettle(tester, find.byTooltip('Remove ECG'));
      expect(find.text('Remove ECG?'), findsOneWidget);
      await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Remove'));

      final removed = repository.recorded.single as DocumentRemoved;
      expect(removed.documentId, ecg.meta.id);
      expect(find.text('ECG'), findsNothing);
    });
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

  testWidgets('the appointment screens fit at 200 % text size', (tester) async {
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
