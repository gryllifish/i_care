import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

/// Something to fix before a medication or schedule can be saved.
enum MedicationIssue {
  nameMissing,
  unitsPerDoseNotPositive,
  lowStockDaysNegative,
  noTimes,

  /// Days were to be chosen, but none was. Only editors can produce it:
  /// a stored schedule with no weekdays means every day.
  noWeekdays,
  minIntervalNotPositive,
  maxPerDayNotPositive,
}

/// Issues in [details]; empty when they can be saved.
Set<MedicationIssue> validateDetails(MedicationDetails details) => {
  if (details.name.trim().isEmpty) MedicationIssue.nameMissing,
  if (details.unitsPerDose <= 0) MedicationIssue.unitsPerDoseNotPositive,
  if (details.lowStockDays < 0) MedicationIssue.lowStockDaysNegative,
};

/// Issues in [schedule]; empty when it can be saved. An empty weekday set
/// means every day.
Set<MedicationIssue> validateSchedule(DoseSchedule schedule) =>
    switch (schedule) {
      FixedSchedule(:final minutesOfDay, :final minInterval) => {
        if (minutesOfDay.isEmpty) MedicationIssue.noTimes,
        if (minInterval != null && minInterval <= Duration.zero)
          MedicationIssue.minIntervalNotPositive,
      },
      AsNeededSchedule(:final minInterval, :final maxPerDay) => {
        if (minInterval <= Duration.zero)
          MedicationIssue.minIntervalNotPositive,
        if (maxPerDay != null && maxPerDay <= 0)
          MedicationIssue.maxPerDayNotPositive,
      },
    };

/// [schedule] in its stored form: fixed times ascending and without
/// repeats, so equal schedules compare equal.
DoseSchedule normalizeSchedule(DoseSchedule schedule) => switch (schedule) {
  FixedSchedule(:final minutesOfDay) => schedule.copyWith(
    minutesOfDay: minutesOfDay.toSet().toList()..sort(),
  ),
  AsNeededSchedule() => schedule,
};
