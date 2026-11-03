import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/handoff/controllers/handoff.dart';
import 'package:i_care/features/handoff/presentation/widgets/handoff_text.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/scrolling.dart';
import '../care/helpers/care_events.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  // Thursday, 18:00: the morning dose given, the evening one pending.
  final now = DateTime(2026, 10, 29, 18);
  late EventFactory events;

  setUpAll(() => initializeDateFormatting('en'));
  setUp(() => events = EventFactory());

  List<CareEvent> circle() {
    final yesterday = DateTime(2026, 10, 28, 8);
    final yesterdayNight = DateTime(2026, 10, 28, 20);
    final morning = DateTime(2026, 10, 29, 8);
    return [
      events.created('m1', at: DateTime(2026, 10)),
      events.created(
        'm2',
        name: 'Levothyroxine',
        schedule: const DoseSchedule.fixed(minutesOfDay: [7 * 60]),
        at: DateTime(2026, 10),
      ),
      events.counted('m2', 5, at: DateTime(2026, 10)),
      events.given('m1', at: yesterday, slotAt: yesterday),
      events.given(
        'm2',
        at: DateTime(2026, 10, 28, 7),
        slotAt: DateTime(2026, 10, 28, 7),
      ),
      events.given('m1', at: yesterdayNight, slotAt: yesterdayNight),
      events.given(
        'm1',
        at: morning.add(const Duration(minutes: 4)),
        slotAt: morning,
        by: 'martin',
      ),
      events.skipped(
        'm2',
        at: DateTime(2026, 10, 29, 7, 5),
        slotAt: DateTime(2026, 10, 29, 7),
      ),
      events.appointment(
        'a1',
        startsAt: DateTime(2026, 10, 31, 10, 30),
        at: DateTime(2026, 10),
      ),
      events.note('a1', 'Bring the blood test', at: DateTime(2026, 10, 27)),
    ];
  }

  test('says what was done, what is left and what is coming', () {
    final text = handoffText(
      buildHandoff(CareLog(circle()), now),
      l10n,
      recipientName: 'Elena',
      caregivers: {
        for (final caregiver in SampleCircle.members) caregiver.id: caregiver,
      },
      locale: 'en',
      customReasons: const {},
    );

    expect(
      text,
      "Elena's day · Thu, Oct 29, 18:00\n"
      '\n'
      'Given today:\n'
      '- Enalapril 10 mg, 08:04 (Martín)\n'
      '\n'
      'Skipped today:\n'
      '- Levothyroxine 10 mg, 07:00: Was asleep\n'
      '\n'
      'Still to give:\n'
      '- Enalapril 10 mg, 20:00\n'
      '\n'
      'Running low:\n'
      '- Levothyroxine · 4 days left\n'
      '\n'
      'Next appointment:\n'
      'Cardiology, Saturday, 10:30\n'
      '\n'
      'Last visit note (Cardiology, Ana):\n'
      'Bring the blood test',
    );
  });

  test('lists care tasks done, not done and still to do', () {
    final text = handoffText(
      buildHandoff(
        CareLog([
          ...circle(),
          events.task('t1', at: DateTime(2026, 10)),
          events.task(
            't2',
            name: 'Short walk',
            schedule: const TaskSchedule(minutesOfDay: [17 * 60]),
            at: DateTime(2026, 10),
          ),
          events.task(
            't3',
            name: 'Check the skin',
            schedule: const TaskSchedule(),
            at: DateTime(2026, 10),
          ),
          events.taskDone(
            't1',
            slotAt: DateTime(2026, 10, 29, 10),
            at: DateTime(2026, 10, 29, 10, 10),
            by: 'rosa',
          ),
          events.taskSkipped(
            't2',
            slotAt: DateTime(2026, 10, 29, 17),
            reason: SkipReason.unwell,
          ),
        ]),
        now,
      ),
      l10n,
      recipientName: 'Elena',
      caregivers: {
        for (final caregiver in SampleCircle.members) caregiver.id: caregiver,
      },
      locale: 'en',
      customReasons: const {},
    );

    expect(
      text,
      contains(
        'Tasks done today:\n'
        '- Bath, 10:10 (Rosa)\n'
        '\n'
        'Tasks not done today:\n'
        '- Short walk: Felt unwell\n'
        '\n'
        'Tasks still to do:\n'
        '- Check the skin, during the day\n',
      ),
    );
  });

  test('lists the documents for the next appointment', () {
    final text = handoffText(
      buildHandoff(
        CareLog([
          ...circle(),
          events.document(
            'a1',
            'Blood test results',
            at: DateTime(2026, 10, 28),
          ),
        ]),
        now,
      ),
      l10n,
      recipientName: 'Elena',
      caregivers: {
        for (final caregiver in SampleCircle.members) caregiver.id: caregiver,
      },
      locale: 'en',
      customReasons: const {},
    );

    expect(
      text,
      contains(
        'Next appointment:\n'
        'Cardiology, Saturday, 10:30\n'
        'Documents for it:\n'
        '- Blood test results: https://lab.example.com/results\n',
      ),
    );
  });

  test('says when nothing is left to give', () {
    final handoff = buildHandoff(CareLog([events.created('m1')]), now);
    final text = handoffText(
      handoff.copyWith(pending: const []),
      l10n,
      recipientName: 'Elena',
      caregivers: const {},
      locale: 'en',
      customReasons: const {},
    );

    expect(text, contains('Nothing left to give today.'));
  });

  test('the summary quotes the last day of notes, newest first', () {
    final handoff = buildHandoff(
      CareLog([
        events.created('m1'),
        events.careNote('Old news', at: DateTime(2026, 10, 28, 17)),
        events.careNote(
          'Slept well',
          at: DateTime(2026, 10, 28, 21),
          by: 'rosa',
        ),
        events.careNote('Knee hurts', at: DateTime(2026, 10, 29, 8, 15)),
      ]),
      now,
    );
    final text = handoffText(
      handoff,
      l10n,
      recipientName: 'Elena',
      caregivers: {
        for (final member in SampleCircle.members) member.id: member,
      },
      locale: 'en',
      customReasons: const {},
    );

    expect(
      text.split('\n\n')[1],
      'Notes:\n- Knee hurts (Ana, 08:15)\n- Slept well (Rosa, 21:00)',
    );
    expect(handoff.notesThisWeek.map((note) => note.text), [
      'Knee hurts',
      'Slept well',
      'Old news',
    ]);
  });

  group('notes screen', () {
    Future<FakeCareRepository> open(
      WidgetTester tester, {
      List<CareEvent> extra = const [],
      String memberId = 'ana',
    }) async {
      final repository = FakeCareRepository([...circle(), ...extra])
        ..status = SyncStatus(lastSyncedAt: now);
      await pumpApp(
        tester,
        repository: repository,
        now: now,
        prefs: MemoryDevicePrefs({
          PrefKeys.welcomeSeen: 'true',
          PrefKeys.memberId: memberId,
        }),
      );
      // The notes' line on Today.
      final row = find.textContaining('Notes for the circle');
      await centerInList(tester, row, list: find.byType(Scrollable).first);
      await tester.tap(row);
      await tester.pumpAndSettle();
      return repository;
    }

    testWidgets('a note is left for the circle and listed', (tester) async {
      final repository = await open(tester);
      expect(
        find.text(
          'No notes yet. What you write here, everyone in the circle sees.',
        ),
        findsOneWidget,
      );
      final send = find.byTooltip('Leave note');
      IconButton button() => tester.widget<IconButton>(
        find.ancestor(of: send, matching: find.byType(IconButton)),
      );
      expect(button().onPressed, isNull);

      await tester.enterText(find.byType(TextField), '  Ate little at lunch ');
      await tester.pump();
      await tester.tap(send);
      await tester.pumpAndSettle();

      final note = repository.recorded.single as CareNoteAdded;
      expect(note.text, 'Ate little at lunch');
      expect(find.text('Ate little at lunch'), findsOneWidget);
      expect(find.text('Ana · Today, 18:00'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
    });

    testWidgets('a viewer reads the notes but leaves none', (tester) async {
      await open(
        tester,
        memberId: 'lucia',
        extra: [
          events.memberInvited('lucia', role: MemberRole.viewer),
          events.careNote('Slept well', at: DateTime(2026, 10, 29, 7)),
        ],
      );

      expect(find.text('Slept well'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets("copies the day's summary with the notes", (tester) async {
      // Tests have no platform clipboard; answer its calls like one.
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            final arguments = call.arguments as Map<Object?, Object?>;
            copied = arguments['text'] as String?;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await open(
        tester,
        extra: [events.careNote('Slept well', at: DateTime(2026, 10, 29, 7))],
      );

      await tester.tap(find.byTooltip("Copy the day's summary"));
      await tester.pumpAndSettle();

      expect(
        find.text('Copied. Paste it in your family chat.'),
        findsOneWidget,
      );
      expect(copied, contains('Still to give:'));
      expect(copied, contains('Notes:\n- Slept well (Ana, 07:00)'));
    });
  });
}
