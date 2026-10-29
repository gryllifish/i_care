import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';

part 'schedule_draft.freezed.dart';

/// A schedule being edited. Unlike [DoseSchedule] it keeps what a person
/// is halfway through: "choose days" with none chosen yet, and the values
/// of both kinds, so switching kinds and back loses nothing.
@freezed
abstract class ScheduleDraft with _$ScheduleDraft {
  const factory ScheduleDraft({
    @Default(true) bool isFixed,

    /// Minutes after midnight, ascending and without repeats.
    @Default(<int>[8 * 60]) List<int> times,
    @Default(true) bool everyDay,

    /// `DateTime.monday`..`DateTime.sunday`; used when not [everyDay].
    @Default(<int>{}) Set<int> days,

    /// Optional spacing for fixed times.
    Duration? fixedMinInterval,
    @Default(Duration(hours: 6)) Duration asNeededInterval,
    int? maxPerDay,
  }) = _ScheduleDraft;

  const ScheduleDraft._();

  factory ScheduleDraft.from(DoseSchedule schedule) => switch (schedule) {
    FixedSchedule(:final minutesOfDay, :final weekdays, :final minInterval) =>
      ScheduleDraft(
        times: minutesOfDay,
        everyDay: weekdays.isEmpty,
        days: weekdays,
        fixedMinInterval: minInterval,
      ),
    AsNeededSchedule(:final minInterval, :final maxPerDay) => ScheduleDraft(
      isFixed: false,
      asNeededInterval: minInterval,
      maxPerDay: maxPerDay,
    ),
  };

  /// The schedule to store. Only meaningful when [issues] is empty.
  DoseSchedule toSchedule() => isFixed
      ? normalizeSchedule(
          DoseSchedule.fixed(
            minutesOfDay: times,
            weekdays: everyDay ? const {} : days,
            minInterval: fixedMinInterval,
          ),
        )
      : DoseSchedule.asNeeded(
          minInterval: asNeededInterval,
          maxPerDay: maxPerDay,
        );

  Set<MedicationIssue> get issues => {
    ...validateSchedule(toSchedule()),
    if (isFixed && !everyDay && days.isEmpty) MedicationIssue.noWeekdays,
  };

  /// Adds a time, keeping times ascending and without repeats.
  ScheduleDraft withTime(int minutes) =>
      copyWith(times: {...times, minutes}.toList()..sort());

  ScheduleDraft withoutTime(int minutes) => copyWith(
    times: [
      for (final time in times)
        if (time != minutes) time,
    ],
  );

  ScheduleDraft toggleDay(int day) => copyWith(
    days: days.contains(day) ? ({...days}..remove(day)) : {...days, day},
  );

  /// Switches to choosing days, starting from none: picking two days is
  /// two taps, not five.
  ScheduleDraft chooseDays() => copyWith(everyDay: false, days: const {});
}
