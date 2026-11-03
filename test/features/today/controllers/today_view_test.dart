import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/today/controllers/today_view.dart';

import '../../care/helpers/care_events.dart';

void main() {
  late EventFactory events;
  final eight = DateTime(2026, 11, 2, 8);

  setUp(() => events = EventFactory());

  TodayView viewAt(DateTime now, [List<Object> extra = const []]) =>
      buildTodayView(
        CareLog([
          events.created('m1'),
          events.created(
            'm2',
            name: 'Paracetamol',
            schedule: const DoseSchedule.asNeeded(
              minInterval: Duration(hours: 6),
            ),
          ),
          ...extra.cast(),
        ]),
        now,
      );

  test('next is the earliest dose due or late, yesterday first', () {
    final view = viewAt(DateTime(2026, 11, 2, 9));

    expect(view.next?.slotAt, DateTime(2026, 11, 1, 8));
    expect(
      [for (final entry in view.pending) entry.slotAt],
      [
        DateTime(2026, 11, 1, 8),
        DateTime(2026, 11, 1, 20),
        eight,
        DateTime(2026, 11, 2, 20),
      ],
    );
  });

  test("the day's count is today's doses and tasks, not yesterday's", () {
    final yesterday = DateTime(2026, 11, 1, 8);
    final view = viewAt(DateTime(2026, 11, 2, 9), [
      events.given('m1', at: eight, slotAt: yesterday),
      events.given('m1', at: eight, slotAt: eight),
      events.task('t1', schedule: const TaskSchedule()),
    ]);

    expect(view.totalToday, 3);
    expect(view.resolvedToday, 1);
  });

  test('notes from the week are listed, newest first', () {
    final view = viewAt(DateTime(2026, 11, 9, 9), [
      events.careNote('Too old', at: DateTime(2026, 11, 2, 8)),
      events.careNote('Slept well', at: DateTime(2026, 11, 7, 21)),
      events.careNote('Knee hurts', at: DateTime(2026, 11, 9, 8)),
    ]);

    expect(
      [for (final note in view.notes) note.text],
      ['Knee hurts', 'Slept well'],
    );
  });

  test('next is the upcoming dose when nothing is pending', () {
    final yesterday = DateTime(2026, 11, 1, 8);
    final yesterdayNight = DateTime(2026, 11, 1, 20);
    final view = viewAt(DateTime(2026, 11, 2, 12), [
      events.given('m1', at: yesterday, slotAt: yesterday),
      events.given('m1', at: yesterdayNight, slotAt: yesterdayNight),
      events.given('m1', at: eight, slotAt: eight),
    ]);

    expect(view.next?.slotAt, DateTime(2026, 11, 2, 20));
    expect(view.next?.status, DoseStatus.upcoming);
  });

  test('a medication added after its time today starts tomorrow', () {
    final added = DateTime(2026, 11, 2, 9, 45);
    final view = buildTodayView(
      CareLog([
        events.created(
          'm1',
          schedule: const DoseSchedule.fixed(minutesOfDay: [8 * 60]),
          effectiveFrom: added,
        ),
      ]),
      added,
    );

    expect(view.totalToday, 0);
    expect(view.next, isNull);
    expect(view.nextLater?.medication.id, 'm1');
    expect(view.nextLater?.at, DateTime(2026, 11, 3, 8));
  });

  test('a day with doses left has no later dose to mention', () {
    final view = viewAt(DateTime(2026, 11, 2, 9));

    expect(view.nextLater, isNull);
  });

  test('the later dose is the earliest one across medications', () {
    final evening = DateTime(2026, 11, 2, 21);
    final view = buildTodayView(
      CareLog([
        events.created(
          'm1',
          schedule: const DoseSchedule.fixed(minutesOfDay: [9 * 60]),
          effectiveFrom: evening,
        ),
        events.created(
          'm2',
          name: 'Aspirin',
          schedule: const DoseSchedule.fixed(
            minutesOfDay: [10 * 60],
            weekdays: {DateTime.thursday},
          ),
          effectiveFrom: evening,
        ),
        events.created(
          'm3',
          name: 'Metformin',
          schedule: const DoseSchedule.fixed(minutesOfDay: [7 * 60]),
          effectiveFrom: evening,
        ),
      ]),
      evening,
    );

    expect(view.nextLater?.medication.id, 'm3');
    expect(view.nextLater?.at, DateTime(2026, 11, 3, 7));
  });

  /// The list's entries as medication or task ids.
  List<String> ids(List<TimelineEntry> entries) => [
    for (final entry in entries)
      switch (entry) {
        DoseEntry(:final slot) => slot.medication.id,
        TaskEntry(:final slot) => slot.task.id,
      },
  ];

  test("yesterday's unresolved doses lead the list, before today's", () {
    final view = viewAt(DateTime(2026, 11, 2, 9));

    expect(
      [for (final entry in view.pending) entry.slotAt],
      [
        DateTime(2026, 11, 1, 8),
        DateTime(2026, 11, 1, 20),
        DateTime(2026, 11, 2, 8),
        DateTime(2026, 11, 2, 20),
      ],
    );
    expect(view.resolved, isEmpty);
  });

  test('what is given, done or skipped leaves the list for the folded '
      'part', () {
    final yesterday = DateTime(2026, 11, 1, 8);
    final view = viewAt(DateTime(2026, 11, 2, 9), [
      events.given('m1', at: DateTime(2026, 11, 2, 7), slotAt: yesterday),
      events.given('m1', at: eight, slotAt: eight),
    ]);

    expect(
      [for (final entry in view.resolved) entry.slotAt],
      [yesterday, eight],
    );
    expect(
      [for (final entry in view.pending) entry.slotAt],
      [DateTime(2026, 11, 1, 20), DateTime(2026, 11, 2, 20)],
    );
  });

  test('as-needed medications come with their last dose', () {
    final dose = events.given('m2', at: eight);
    final view = viewAt(DateTime(2026, 11, 2, 9), [dose]);

    expect(view.asNeeded.single.medication.id, 'm2');
    expect(view.asNeeded.single.lastDose, dose);
  });

  test('timed tasks join the doses by time, doses first; untimed ones '
      'stand apart until done', () {
    final view = viewAt(DateTime(2026, 11, 2, 9), [
      events.task(
        't1',
        name: 'Walk',
        schedule: const TaskSchedule(minutesOfDay: [8 * 60, 17 * 60]),
      ),
      events.task('t2', name: 'Check her skin', schedule: const TaskSchedule()),
      events.task('t3', schedule: const TaskSchedule()),
      events.taskDone('t3', at: eight, slotAt: DateTime(2026, 11, 2)),
    ]);

    expect(ids(view.pending), ['m1', 'm1', 'm1', 't1', 't1', 'm1']);
    expect(view.pendingAnyTime.single.task.id, 't2');
    expect(ids(view.resolved), ['t3']);
    expect(view.totalToday, 6);
    expect(view.resolvedToday, 1);
  });
}
