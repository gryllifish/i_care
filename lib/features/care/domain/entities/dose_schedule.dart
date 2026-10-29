import 'package:freezed_annotation/freezed_annotation.dart';

part 'dose_schedule.freezed.dart';

/// When a medication is meant to be given, as entered by a caregiver.
///
/// Times are wall-clock times in the care recipient's time zone. On days
/// when clocks change, a time that does not exist moves forward with the
/// clock (02:30 becomes 03:30), as `DateTime` does.
@freezed
sealed class DoseSchedule with _$DoseSchedule {
  /// At fixed times on chosen weekdays.
  const factory DoseSchedule.fixed({
    /// Minutes after midnight, ascending and without repeats.
    required List<int> minutesOfDay,

    /// `DateTime.monday`..`DateTime.sunday`; empty means every day.
    @Default(<int>{}) Set<int> weekdays,

    /// Optional spacing between two given doses, checked before giving.
    Duration? minInterval,
  }) = FixedSchedule;

  /// Only when needed, within limits the caregiver entered.
  const factory DoseSchedule.asNeeded({
    required Duration minInterval,
    int? maxPerDay,
  }) = AsNeededSchedule;

  const DoseSchedule._();

  /// The scheduled times on [day] (its date part); none when as needed.
  List<DateTime> slotsOn(DateTime day) => switch (this) {
    FixedSchedule(:final minutesOfDay, :final weekdays)
        when weekdays.isEmpty || weekdays.contains(day.weekday) =>
      [
        for (final minutes in minutesOfDay)
          DateTime(day.year, day.month, day.day, 0, minutes),
      ],
    _ => const [],
  };

  /// Average doses per day, or null when it depends on need.
  double? get dosesPerDay => switch (this) {
    FixedSchedule(:final minutesOfDay, :final weekdays) =>
      minutesOfDay.length *
          (weekdays.isEmpty ? DateTime.daysPerWeek : weekdays.length) /
          DateTime.daysPerWeek,
    AsNeededSchedule() => null,
  };
}

/// A schedule and the moment it took effect. Older versions keep
/// describing past days, so changing a schedule never rewrites history.
@freezed
abstract class ScheduleVersion with _$ScheduleVersion {
  const factory ScheduleVersion({
    required DoseSchedule schedule,
    required DateTime effectiveFrom,
  }) = _ScheduleVersion;
}
