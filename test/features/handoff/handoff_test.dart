import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/handoff/controllers/handoff.dart';
import 'package:i_care/features/handoff/presentation/widgets/handoff_text.dart';
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
      'Handoff for Elena · Thu, Oct 29, 18:00\n'
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

  test('a note goes right after the header; a blank one is left out', () {
    final handoff = buildHandoff(CareLog([events.created('m1')]), now);
    String textWith(String note) => handoffText(
      handoff,
      l10n,
      recipientName: 'Elena',
      caregivers: const {},
      locale: 'en',
      customReasons: const {},
      note: note,
    );

    final sections = textWith('  Ate little at lunch \n').split('\n\n');
    expect(sections[1], 'Also:\nAte little at lunch');
    expect(textWith('   '), isNot(contains('Also:')));
  });

  testWidgets('opens from Today and copies the text with a note', (
    tester,
  ) async {
    // Tests have no platform clipboard; answer its calls like one.
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map<Object?, Object?>)['text'] as String?;
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
    final repository = FakeCareRepository(circle())
      ..status = SyncStatus(lastSyncedAt: now);
    await pumpApp(tester, repository: repository, now: now);

    final card = find.text('A summary for whoever takes over');
    await centerInList(tester, card, list: find.byType(Scrollable).first);
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.textContaining('Still to give:'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Ate little at lunch');
    await tester.pump();
    expect(find.textContaining('Also:\nAte little at lunch'), findsOneWidget);

    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();
    expect(find.text('Copied. Paste it in your family chat.'), findsOneWidget);
    expect(copied, contains('Also:\nAte little at lunch'));
  });
}
