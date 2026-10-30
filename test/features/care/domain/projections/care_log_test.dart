import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';

import '../../helpers/care_events.dart';

void main() {
  late EventFactory events;
  final day = DateTime(2026, 11, 2);
  final eight = DateTime(2026, 11, 2, 8);
  final eightPm = DateTime(2026, 11, 2, 20);

  setUp(() => events = EventFactory());

  group('medications', () {
    test('are created, updated and archived through events', () {
      final created = events.created('m1');
      final log = CareLog([
        created,
        events.created('m2', name: 'Aspirin'),
        events.updated('m1', baseVersion: 0, name: 'Enalapril 20'),
        events.archived('m2', baseVersion: 0),
      ]);

      expect(log.medications.map((m) => m.details.name), ['Enalapril 20']);
      expect(log.medication('m1')?.version, 1);
      expect(log.medication('m2')?.isArchived, isTrue);
    });

    test('a schedule change keeps the previous version', () {
      final log = CareLog([
        events.created('m1'),
        events.scheduleChanged(
          'm1',
          baseVersion: 0,
          schedule: const DoseSchedule.fixed(minutesOfDay: [9 * 60]),
          effectiveFrom: DateTime(2026, 11, 3),
        ),
      ]);

      expect(log.slotsOn(day, now: eight).map((s) => s.slotAt), [
        eight,
        eightPm,
      ]);
      expect(
        log.slotsOn(DateTime(2026, 11, 3), now: eight).map((s) => s.slotAt),
        [DateTime(2026, 11, 3, 9)],
      );
    });

    test('changes made on the same version are flagged, not lost', () {
      final created = events.created('m1');
      final first = events.updated('m1', baseVersion: 0, name: 'By Ana');
      final second = events.updated(
        'm1',
        baseVersion: 0,
        name: 'By Martín',
        by: 'martin',
      );
      final log = CareLog([created, first, second]);

      expect(log.medication('m1')?.details.name, 'By Martín');
      expect(log.conflicts, [
        isA<EditConflict>().having((c) => c.changes, 'changes', [
          first,
          second,
        ]),
      ]);
    });

    test('concurrent changes to different parts are not conflicts', () {
      final log = CareLog([
        events.created('m1'),
        events.updated('m1', baseVersion: 0),
        events.scheduleChanged(
          'm1',
          baseVersion: 0,
          schedule: const DoseSchedule.fixed(minutesOfDay: [9 * 60]),
          effectiveFrom: DateTime(2026, 11, 3),
        ),
      ]);

      expect(log.conflicts, isEmpty);
      expect(log.medication('m1')?.version, 2);
    });

    test('archiving conflicts with any concurrent change', () {
      final log = CareLog([
        events.created('m1'),
        events.archived('m1', baseVersion: 0),
        events.updated('m1', baseVersion: 0, by: 'martin'),
      ]);

      expect(log.conflicts.single, isA<EditConflict>());
      expect(log.medication('m1')?.isArchived, isTrue);
    });

    test('a change lists every overlapping change it raced against', () {
      final created = events.created('m1');
      final first = events.updated('m1', baseVersion: 0);
      final second = events.updated('m1', baseVersion: 1);
      final stale = events.updated('m1', baseVersion: 0, by: 'martin');
      final log = CareLog([created, first, second, stale]);

      expect(log.conflicts, [
        isA<EditConflict>().having((c) => c.changes, 'changes', [
          first,
          second,
          stale,
        ]),
      ]);
    });

    test('sequential changes are not conflicts', () {
      final log = CareLog([
        events.created('m1'),
        events.updated('m1', baseVersion: 0),
        events.updated('m1', baseVersion: 1),
      ]);

      expect(log.conflicts, isEmpty);
    });
  });

  group('dose status', () {
    DoseStatus statusAt(DateTime now, [List<Object> extra = const []]) {
      final log = CareLog([events.created('m1'), ...extra.cast()]);
      return log.slotsOn(day, now: now).first.status;
    }

    test('follows the time when nothing is recorded', () {
      expect(statusAt(DateTime(2026, 11, 2, 7, 29)), DoseStatus.upcoming);
      expect(statusAt(DateTime(2026, 11, 2, 7, 30)), DoseStatus.due);
      expect(statusAt(DateTime(2026, 11, 2, 8, 30)), DoseStatus.due);
      expect(statusAt(DateTime(2026, 11, 2, 8, 31)), DoseStatus.overdue);
    });

    test('is given or skipped once recorded', () {
      final later = DateTime(2026, 11, 2, 12);

      expect(
        statusAt(later, [events.given('m1', at: eight, slotAt: eight)]),
        DoseStatus.given,
      );
      expect(
        statusAt(later, [events.skipped('m1', at: eight, slotAt: eight)]),
        DoseStatus.skipped,
      );
    });

    test('an undone dose is pending again', () {
      final given = events.given('m1', at: eight, slotAt: eight);

      expect(
        statusAt(DateTime(2026, 11, 2, 12), [given, events.undone(given)]),
        DoseStatus.overdue,
      );
    });

    test('slots are ordered by time, then by name', () {
      final log = CareLog([
        events.created('m1', name: 'Zinc'),
        events.created('m2', name: 'Aspirin'),
      ]);

      expect(
        log
            .slotsOn(day, now: eight)
            .map((s) => (s.slotAt.hour, s.medication.details.name)),
        [(8, 'Aspirin'), (8, 'Zinc'), (20, 'Aspirin'), (20, 'Zinc')],
      );
    });

    test('unresolved doses from the day before are kept', () {
      final yesterdayEight = DateTime(2026, 11, 1, 8);
      final log = CareLog([
        events.created('m1'),
        events.given('m1', at: yesterdayEight, slotAt: yesterdayEight),
      ]);

      expect(
        log.fromYesterday(day, now: eight).map((s) => s.slotAt),
        [DateTime(2026, 11, 1, 20)],
      );
    });

    test('doses from the day before resolved today stay visible today', () {
      final yesterdayEight = DateTime(2026, 11, 1, 8);
      final yesterdayNight = DateTime(2026, 11, 1, 20);
      final log = CareLog([
        events.created('m1'),
        events.given('m1', at: yesterdayEight, slotAt: yesterdayEight),
        events.given('m1', at: eight, slotAt: yesterdayNight),
      ]);
      final [slot] = log.fromYesterday(day, now: eight);

      expect(slot.slotAt, yesterdayNight);
      expect(slot.status, DoseStatus.given);
      expect(log.fromYesterday(DateTime(2026, 11, 3), now: eight), isEmpty);
    });
  });

  group('dose conflicts', () {
    test('two doses for one time are a conflict', () {
      final ana = events.given('m1', at: eight, slotAt: eight);
      final martin = events.given(
        'm1',
        at: eight.add(const Duration(minutes: 3)),
        slotAt: eight,
        by: 'martin',
      );
      final log = CareLog([events.created('m1'), ana, martin]);
      final slot = log.slotsOn(day, now: eightPm).first;

      expect(slot.status, DoseStatus.given);
      expect(slot.given, [ana, martin]);
      expect(slot.hasConflict, isTrue);
      expect(log.conflicts.single, isA<DoseConflict>());
    });

    test('a dose given knowing about the other is double, not a '
        'conflict', () {
      final ana = events.given('m1', at: eight, slotAt: eight);
      final log = CareLog([
        events.created('m1'),
        ana,
        events.given('m1', at: eight, slotAt: eight, knowing: [ana]),
      ]);
      final slot = log.slotsOn(day, now: eightPm).first;

      expect(log.conflicts, isEmpty);
      expect(slot.isDouble, isTrue);
      expect(slot.hasConflict, isFalse);
    });

    test('knowing about one dose does not excuse another nobody saw', () {
      // Luis and Martín both confirmed despite seeing Ana's dose, but
      // Martín's phone never showed him Luis's.
      final ana = events.given('m1', at: eight, slotAt: eight);
      final luis = events.given(
        'm1',
        at: eight,
        slotAt: eight,
        by: 'luis',
        knowing: [ana],
      );
      final martin = events.given(
        'm1',
        at: eight,
        slotAt: eight,
        by: 'martin',
        knowing: [ana],
      );
      final log = CareLog([events.created('m1'), ana, luis, martin]);

      expect(log.conflicts.single, isA<DoseConflict>());
      expect(log.conflicts.single.key, CareLog.doseConflictKey('m1', eight));
    });

    test('an acknowledged conflict is no longer pending', () {
      final log = CareLog([
        events.created('m1'),
        events.given('m1', at: eight, slotAt: eight),
        events.given('m1', at: eight, slotAt: eight, by: 'martin'),
        events.acknowledged(CareLog.doseConflictKey('m1', eight)),
      ]);

      expect(log.conflicts, isEmpty);
      expect(log.slotsOn(day, now: eightPm).first.hasConflict, isFalse);
    });

    test('as-needed doses closer than the minimum interval conflict', () {
      final first = events.given('m1', at: eight);
      final tooSoon = events.given(
        'm1',
        at: eight.add(const Duration(hours: 2)),
        by: 'martin',
      );
      final fine = events.given('m1', at: eight.add(const Duration(hours: 9)));
      final log = CareLog([
        events.created(
          'm1',
          schedule: const DoseSchedule.asNeeded(
            minInterval: Duration(hours: 6),
          ),
        ),
        first,
        tooSoon,
        fine,
      ]);

      expect(log.conflicts, [
        isA<DoseConflict>().having((c) => c.doses, 'doses', [first, tooSoon]),
      ]);
    });

    test('the interval uses when the caregiver says the dose was given', () {
      final asNeeded = events.created(
        'm1',
        schedule: const DoseSchedule.asNeeded(minInterval: Duration(hours: 6)),
      );
      // Recorded at 13:00 but given at 08:00; the next dose at 15:00 is
      // seven hours later, not two.
      final late = events.given(
        'm1',
        at: DateTime(2026, 11, 2, 13),
        givenAt: eight,
      );
      final next = events.given('m1', at: DateTime(2026, 11, 2, 15));
      final log = CareLog([asNeeded, late, next]);

      expect(log.conflicts, isEmpty);
      expect(log.lastDose('m1'), next);
    });

    test('a dose given knowing about the previous one is not an interval '
        'conflict', () {
      final first = events.given('m1', at: eight);
      final log = CareLog([
        events.created(
          'm1',
          schedule: const DoseSchedule.asNeeded(
            minInterval: Duration(hours: 6),
          ),
        ),
        first,
        events.given(
          'm1',
          at: eight.add(const Duration(hours: 1)),
          knowing: [first],
        ),
      ]);

      expect(log.conflicts, isEmpty);
    });
  });

  group('stock', () {
    test('is unknown until someone counts or refills it', () {
      final log = CareLog([events.created('m1')]);

      expect(log.stockOf('m1'), isNull);
    });

    test('is the count, minus doses given after it, plus refills', () {
      final log = CareLog([
        events.created('m1'),
        events.given('m1', at: eight, slotAt: eight),
        events.counted('m1', 30, at: eight),
        events.given('m1', at: eightPm, slotAt: eightPm, units: 0.5),
        events.refilled('m1', 10, at: eightPm),
      ]);

      expect(log.stockOf('m1')?.units, 39.5);
    });

    test('a refill without a count starts tracking from zero', () {
      final log = CareLog([events.created('m1'), events.refilled('m1', 20)]);

      expect(log.stockOf('m1')?.units, 20);
    });

    test('undone doses give their units back', () {
      final given = events.given('m1', at: eight, slotAt: eight);
      final log = CareLog([
        events.created('m1'),
        events.counted('m1', 10),
        given,
        events.undone(given),
      ]);

      expect(log.stockOf('m1')?.units, 10);
    });

    test('days left follow the schedule and flag low stock', () {
      final log = CareLog([
        events.created('m1', lowStockDays: 5),
        events.counted('m1', 11),
      ]);

      // Two doses a day: 11 units last 5 whole days.
      expect(log.stockOf('m1')?.daysLeft, 5);
      expect(log.stockOf('m1')?.isLow, isTrue);
    });

    test('as-needed stock has no days left and is low only when empty', () {
      const asNeeded = DoseSchedule.asNeeded(minInterval: Duration(hours: 6));
      final log = CareLog([
        events.created('m1', schedule: asNeeded),
        events.counted('m1', 1),
        events.created('m2', schedule: asNeeded),
        events.counted('m2', 0),
      ]);

      expect(log.stockOf('m1')?.daysLeft, isNull);
      expect(log.stockOf('m1')?.isLow, isFalse);
      expect(log.stockOf('m2')?.isLow, isTrue);
    });
  });

  group('appointments', () {
    final later = DateTime(2026, 11, 10, 10);
    final sooner = DateTime(2026, 11, 4, 9);

    test('are listed soonest first, without cancelled ones', () {
      final log = CareLog([
        events.appointment('a1', startsAt: later),
        events.appointment('a2', startsAt: sooner, title: 'Dentist'),
        events.appointment('a3', startsAt: sooner),
        events.appointmentCancelled('a3', baseVersion: 0),
      ]);

      expect(log.appointments.map((a) => a.id), ['a2', 'a1']);
      expect(log.appointment('a3')?.isCancelled, isTrue);
    });

    test('gather visit notes from several caregivers', () {
      final anas = events.note('a1', 'Keep the dose');
      final martins = events.note('a1', 'Check again in May', by: 'martin');
      final log = CareLog([
        events.appointment('a1', startsAt: sooner),
        anas,
        martins,
      ]);

      expect(log.appointment('a1')?.notes, [anas, martins]);
    });

    test('concurrent edits conflict like medication edits', () {
      final log = CareLog([
        events.appointment('a1', startsAt: sooner),
        events.appointmentUpdated('a1', baseVersion: 0, startsAt: later),
        events.appointmentUpdated(
          'a1',
          baseVersion: 0,
          startsAt: sooner,
          by: 'martin',
        ),
      ]);

      expect(
        log.conflicts.single,
        isA<EditConflict>().having((c) => c.entityId, 'entityId', 'a1'),
      );
    });

    test('a note never conflicts with an edit', () {
      final log = CareLog([
        events.appointment('a1', startsAt: sooner),
        events.appointmentUpdated('a1', baseVersion: 0, startsAt: later),
        events.note('a1', 'Fine'),
      ]);

      expect(log.conflicts, isEmpty);
      expect(log.appointment('a1')?.version, 1);
    });
  });

  test('lastDose and givenOn use when doses happened', () {
    final morning = events.given('m1', at: eight, slotAt: eight);
    final evening = events.given('m1', at: eightPm, slotAt: eightPm);
    final log = CareLog([events.created('m1'), evening, morning]);

    expect(log.lastDose('m1'), evening);
    expect(log.givenOn('m1', day), [morning, evening]);
    expect(log.givenOn('m1', DateTime(2026, 11, 3)), isEmpty);
  });

  test('every order of the same events projects the same state', () {
    final synced = DateTime(2026, 11, 2, 9);
    final all = [
      events.created('m1', at: DateTime(2026)),
      events.counted('m1', 20, at: eight),
      events.given('m1', at: eight, slotAt: eight, receivedAt: synced),
      events.given('m1', at: eight, slotAt: eight, by: 'martin'),
    ];
    final forward = CareLog(all);
    final backward = CareLog(all.reversed);

    expect(backward.events, forward.events);
    expect(backward.stockOf('m1'), forward.stockOf('m1'));
    expect(backward.conflicts, forward.conflicts);
  });

  group('care tasks', () {
    final ten = DateTime(2026, 11, 2, 10);

    test('are created, updated and archived through events', () {
      final created = events.task('t1');
      final log = CareLog([
        created,
        events.taskUpdated(
          't1',
          baseVersion: 0,
          name: 'Shower',
          schedule: const TaskSchedule(),
        ),
      ]);

      final task = log.task('t1');
      expect(task?.details.name, 'Shower');
      expect(task?.schedule.isAnyTime, isTrue);
      expect(task?.version, 1);
      expect(log.tasks, [task]);

      final archived = CareLog([
        created,
        events.taskArchived('t1', baseVersion: 0),
      ]);
      expect(archived.tasks, isEmpty);
      expect(archived.task('t1')?.isArchived, isTrue);
    });

    test('are due on their weekdays, untimed ones first', () {
      final log = CareLog([
        events.task(
          't1',
          schedule: const TaskSchedule(
            minutesOfDay: [10 * 60],
            weekdays: {DateTime.monday, DateTime.thursday},
          ),
        ),
        events.task(
          't2',
          name: 'Check her skin',
          schedule: const TaskSchedule(),
        ),
        events.task(
          't3',
          name: 'Walk',
          schedule: const TaskSchedule(weekdays: {DateTime.tuesday}),
        ),
      ]);

      // 2026-11-02 is a Monday.
      final slots = log.taskSlotsOn(day, now: day);
      expect(
        [for (final slot in slots) (slot.task.id, slot.slotAt)],
        [('t2', day), ('t1', ten)],
      );
      expect(slots.first.isAnyTime, isTrue);
      expect(
        [
          for (final slot in log.taskSlotsOn(DateTime(2026, 11, 3), now: day))
            slot.task.id,
        ],
        ['t2', 't3'],
      );
    });

    test('are upcoming, due or late by their time; untimed ones are due '
        'all day', () {
      final log = CareLog([
        events.task('t1'),
        events.task(
          't2',
          name: 'Check her skin',
          schedule: const TaskSchedule(),
        ),
      ]);
      TaskStatus statusAt(DateTime now, String id) => log
          .taskSlotsOn(day, now: now)
          .firstWhere((slot) => slot.task.id == id)
          .status;

      expect(statusAt(eight, 't1'), TaskStatus.upcoming);
      expect(statusAt(ten, 't1'), TaskStatus.due);
      expect(statusAt(DateTime(2026, 11, 2, 11), 't1'), TaskStatus.late);
      expect(statusAt(DateTime(2026, 11, 2, 23), 't2'), TaskStatus.due);
    });

    test('are done or skipped by whoever recorded it, and undone records '
        'are left out', () {
      final done = events.taskDone('t1', slotAt: ten, by: 'martin');
      final log = CareLog([
        events.task('t1'),
        events.task(
          't2',
          name: 'Check her skin',
          schedule: const TaskSchedule(),
        ),
        done,
        events.taskSkipped('t2', slotAt: day),
      ]);
      final slots = log.taskSlotsOn(day, now: ten);

      expect(slots.last.status, TaskStatus.done);
      expect(slots.last.isDoneBy('martin'), isTrue);
      expect(slots.last.isDoneBy('ana'), isFalse);
      expect(slots.first.status, TaskStatus.skipped);

      final undone = CareLog([events.task('t1'), done, events.undone(done)]);
      expect(undone.taskSlotsOn(day, now: ten).single.status, TaskStatus.due);
    });

    test('done twice shows both records and is never a conflict', () {
      final log = CareLog([
        events.task('t1'),
        events.taskDone('t1', slotAt: ten),
        events.taskDone('t1', slotAt: ten, by: 'martin'),
      ]);

      expect(log.taskSlotsOn(day, now: ten).single.done, hasLength(2));
      expect(log.conflicts, isEmpty);
    });

    test('concurrent edits are flagged for review', () {
      final log = CareLog([
        events.task('t1'),
        events.taskUpdated('t1', baseVersion: 0, name: 'Shower'),
        events.taskUpdated(
          't1',
          baseVersion: 0,
          name: 'Bed bath',
          by: 'martin',
        ),
      ]);

      expect(log.task('t1')?.details.name, 'Bed bath');
      expect(
        log.conflicts.single,
        isA<EditConflict>().having((c) => c.entityId, 'entityId', 't1'),
      );
    });
  });
}
