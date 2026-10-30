import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_task.freezed.dart';

/// What caregivers enter about a care task, such as "Bath".
@freezed
abstract class TaskDetails with _$TaskDetails {
  const factory TaskDetails({
    required String name,

    /// Free text, e.g. "Use the shower chair".
    @Default('') String note,
  }) = _TaskDetails;
}

/// When a care task is meant to be done, as entered by a caregiver.
@freezed
abstract class TaskSchedule with _$TaskSchedule {
  const factory TaskSchedule({
    /// Minutes after midnight, ascending and without repeats; empty means
    /// once during the day, at no set time.
    @Default(<int>[]) List<int> minutesOfDay,

    /// `DateTime.monday`..`DateTime.sunday`; empty means every day.
    @Default(<int>{}) Set<int> weekdays,
  }) = _TaskSchedule;

  const TaskSchedule._();

  /// Done once during the day, whenever suits.
  bool get isAnyTime => minutesOfDay.isEmpty;

  bool occursOn(DateTime day) =>
      weekdays.isEmpty || weekdays.contains(day.weekday);

  /// The times it is due on [day] (its date part). A task with no set
  /// time has one slot at the start of the day.
  List<DateTime> slotsOn(DateTime day) => [
    if (occursOn(day))
      if (isAnyTime)
        DateTime(day.year, day.month, day.day)
      else
        for (final minutes in minutesOfDay)
          DateTime(day.year, day.month, day.day, 0, minutes),
  ];
}

/// A care task as projected from the event log.
@freezed
abstract class CareTask with _$CareTask {
  const factory CareTask({
    required String id,
    required TaskDetails details,
    required TaskSchedule schedule,
    @Default(false) bool isArchived,

    /// Number of changes applied. Edits carry the version they started
    /// from, so concurrent edits can be detected.
    @Default(0) int version,
  }) = _CareTask;
}
