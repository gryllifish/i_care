import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';

void main() {
  // 2026-11-02 is a Monday.
  final monday = DateTime(2026, 11, 2);
  final tuesday = DateTime(2026, 11, 3);

  group('FixedSchedule.slotsOn', () {
    test('returns every time on every day when no weekdays are set', () {
      const schedule = DoseSchedule.fixed(minutesOfDay: [8 * 60, 20 * 60 + 30]);

      expect(schedule.slotsOn(monday), [
        DateTime(2026, 11, 2, 8),
        DateTime(2026, 11, 2, 20, 30),
      ]);
    });

    test('ignores the time part of the day it is given', () {
      const schedule = DoseSchedule.fixed(minutesOfDay: [9 * 60]);

      expect(schedule.slotsOn(DateTime(2026, 11, 2, 23, 59)), [
        DateTime(2026, 11, 2, 9),
      ]);
    });

    test('returns nothing on weekdays outside the schedule', () {
      const schedule = DoseSchedule.fixed(
        minutesOfDay: [9 * 60],
        weekdays: {DateTime.monday},
      );

      expect(schedule.slotsOn(monday), hasLength(1));
      expect(schedule.slotsOn(tuesday), isEmpty);
    });
  });

  test('as-needed schedules have no slots', () {
    const schedule = DoseSchedule.asNeeded(minInterval: Duration(hours: 6));

    expect(schedule.slotsOn(monday), isEmpty);
  });

  group('dosesPerDay', () {
    test('averages fixed doses over the week', () {
      const daily = DoseSchedule.fixed(minutesOfDay: [8 * 60, 20 * 60]);
      const weekly = DoseSchedule.fixed(
        minutesOfDay: [8 * 60],
        weekdays: {DateTime.monday},
      );

      expect(daily.dosesPerDay, 2);
      expect(weekly.dosesPerDay, closeTo(1 / 7, 1e-9));
    });

    test('is unknown for as-needed schedules', () {
      const schedule = DoseSchedule.asNeeded(minInterval: Duration(hours: 6));

      expect(schedule.dosesPerDay, isNull);
    });
  });
}
