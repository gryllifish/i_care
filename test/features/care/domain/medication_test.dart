import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

void main() {
  const twiceADay = DoseSchedule.fixed(minutesOfDay: [8 * 60, 20 * 60]);
  const atNine = DoseSchedule.fixed(minutesOfDay: [9 * 60]);
  final changedAt = DateTime(2026, 11, 2, 12);

  final medication = Medication(
    id: 'm1',
    details: const MedicationDetails(
      name: 'Enalapril',
      strength: '10 mg',
      form: MedicationForm.tablet,
    ),
    schedules: [
      ScheduleVersion(schedule: twiceADay, effectiveFrom: DateTime(2026)),
      ScheduleVersion(schedule: atNine, effectiveFrom: changedAt),
    ],
  );

  test('the current schedule is the latest version', () {
    expect(medication.schedule, atNine);
  });

  test('scheduleAt picks the version in effect at that moment', () {
    expect(medication.scheduleAt(DateTime(2025, 12, 31)), isNull);
    expect(medication.scheduleAt(DateTime(2026, 11, 2, 11)), twiceADay);
    expect(medication.scheduleAt(changedAt), atNine);
  });

  test('slotsOn keeps past versions for past days', () {
    expect(medication.slotsOn(DateTime(2026, 11)), [
      DateTime(2026, 11, 1, 8),
      DateTime(2026, 11, 1, 20),
    ]);
    expect(medication.slotsOn(DateTime(2026, 11, 3)), [
      DateTime(2026, 11, 3, 9),
    ]);
  });

  test('on the day of a change, each time comes from its version', () {
    // 08:00 was before the change at noon; 20:00 no longer exists; the
    // new 09:00 starts tomorrow, since it was already past at noon.
    expect(medication.slotsOn(DateTime(2026, 11, 2)), [
      DateTime(2026, 11, 2, 8),
    ]);
  });
}
