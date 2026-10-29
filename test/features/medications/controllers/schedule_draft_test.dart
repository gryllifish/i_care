import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';
import 'package:i_care/features/medications/controllers/schedule_draft.dart';

void main() {
  test('round-trips both kinds of schedule', () {
    const fixed = DoseSchedule.fixed(
      minutesOfDay: [480, 1200],
      weekdays: {DateTime.monday, DateTime.thursday},
      minInterval: Duration(hours: 8),
    );
    const asNeeded = DoseSchedule.asNeeded(
      minInterval: Duration(hours: 6),
      maxPerDay: 4,
    );

    expect(ScheduleDraft.from(fixed).toSchedule(), fixed);
    expect(ScheduleDraft.from(asNeeded).toSchedule(), asNeeded);
  });

  test('choosing days starts from none and needs at least one', () {
    final draft = const ScheduleDraft().chooseDays();

    expect(draft.days, isEmpty);
    expect(draft.issues, {MedicationIssue.noWeekdays});

    final twice = draft.toggleDay(DateTime.monday).toggleDay(DateTime.thursday);
    expect(twice.issues, isEmpty);
    expect(
      (twice.toSchedule() as FixedSchedule).weekdays,
      {DateTime.monday, DateTime.thursday},
    );
  });

  test('every day is stored as no weekdays', () {
    final draft = const ScheduleDraft()
        .chooseDays()
        .toggleDay(DateTime.monday)
        .copyWith(everyDay: true);

    expect((draft.toSchedule() as FixedSchedule).weekdays, isEmpty);
  });

  test('times stay ascending without repeats', () {
    final draft = const ScheduleDraft(
      times: [],
    ).withTime(1200).withTime(480).withTime(1200);

    expect(draft.times, [480, 1200]);
    expect(draft.withoutTime(480).times, [1200]);
  });

  test('switching kinds keeps the values of each', () {
    final draft = const ScheduleDraft(
      times: [540],
    ).copyWith(isFixed: false, maxPerDay: 3).copyWith(isFixed: true);

    expect(draft.times, [540]);
    expect(draft.maxPerDay, 3);
  });
}
