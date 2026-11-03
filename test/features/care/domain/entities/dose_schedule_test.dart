import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';

void main() {
  // Monday.
  final monday = DateTime(2026, 11, 2, 9, 45);

  test('the first slot is the next time today when one is left', () {
    const schedule = DoseSchedule.fixed(minutesOfDay: [8 * 60, 20 * 60]);

    expect(schedule.firstSlotFrom(monday), DateTime(2026, 11, 2, 20));
  });

  test('a time already past today moves to tomorrow', () {
    const schedule = DoseSchedule.fixed(minutesOfDay: [8 * 60]);

    expect(schedule.firstSlotFrom(monday), DateTime(2026, 11, 3, 8));
  });

  test('a time exactly now counts', () {
    const schedule = DoseSchedule.fixed(minutesOfDay: [9 * 60 + 45]);

    expect(schedule.firstSlotFrom(monday), monday);
  });

  test('a weekly schedule waits for its weekday, even a week ahead', () {
    const schedule = DoseSchedule.fixed(
      minutesOfDay: [8 * 60],
      weekdays: {DateTime.monday},
    );

    expect(schedule.firstSlotFrom(monday), DateTime(2026, 11, 9, 8));
  });

  test('an as-needed schedule has no first slot', () {
    const schedule = DoseSchedule.asNeeded(minInterval: Duration(hours: 6));

    expect(schedule.firstSlotFrom(monday), isNull);
  });
}
