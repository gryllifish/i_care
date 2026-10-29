import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';

void main() {
  const details = MedicationDetails(
    name: 'Enalapril',
    strength: '10 mg',
    form: MedicationForm.tablet,
  );

  test('complete details have no issues', () {
    expect(validateDetails(details), isEmpty);
  });

  test('details need a name and positive units', () {
    expect(
      validateDetails(details.copyWith(name: '  ', unitsPerDose: 0)),
      {MedicationIssue.nameMissing, MedicationIssue.unitsPerDoseNotPositive},
    );
  });

  test('fixed schedules need at least one time', () {
    expect(validateSchedule(const DoseSchedule.fixed(minutesOfDay: [])), {
      MedicationIssue.noTimes,
    });
  });

  test('intervals and limits must be positive', () {
    expect(
      validateSchedule(
        const DoseSchedule.asNeeded(minInterval: Duration.zero, maxPerDay: 0),
      ),
      {
        MedicationIssue.minIntervalNotPositive,
        MedicationIssue.maxPerDayNotPositive,
      },
    );
  });

  test('normalizing sorts fixed times and drops repeats', () {
    expect(
      normalizeSchedule(
        const DoseSchedule.fixed(minutesOfDay: [1200, 480, 1200]),
      ),
      const DoseSchedule.fixed(minutesOfDay: [480, 1200]),
    );
  });
}
