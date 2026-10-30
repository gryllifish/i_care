import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/task_validation.dart';

part 'task_draft.freezed.dart';

/// A task's schedule being edited. Unlike [TaskSchedule] it keeps what a
/// person is halfway through: set times chosen with none added yet, "pick
/// days" with none picked, and the times while "during the day" is on.
@freezed
abstract class TaskDraft with _$TaskDraft {
  const factory TaskDraft({
    @Default(false) bool atSetTimes,

    /// Minutes after midnight, ascending and without repeats.
    @Default(<int>[10 * 60]) List<int> times,
    @Default(true) bool everyDay,

    /// `DateTime.monday`..`DateTime.sunday`; used when not [everyDay].
    @Default(<int>{}) Set<int> days,
  }) = _TaskDraft;

  const TaskDraft._();

  factory TaskDraft.from(TaskSchedule schedule) => TaskDraft(
    atSetTimes: !schedule.isAnyTime,
    times: schedule.isAnyTime ? const [10 * 60] : schedule.minutesOfDay,
    everyDay: schedule.weekdays.isEmpty,
    days: schedule.weekdays,
  );

  /// The schedule to store. Only meaningful when [issues] is empty.
  TaskSchedule toSchedule() => normalizeTaskSchedule(
    TaskSchedule(
      minutesOfDay: atSetTimes ? times : const [],
      weekdays: everyDay ? const {} : days,
    ),
  );

  Set<TaskIssue> get issues => {
    if (atSetTimes && times.isEmpty) TaskIssue.noTimes,
    if (!everyDay && days.isEmpty) TaskIssue.noWeekdays,
  };

  /// Adds a time, keeping times ascending and without repeats.
  TaskDraft withTime(int minutes) =>
      copyWith(times: {...times, minutes}.toList()..sort());

  TaskDraft withoutTime(int minutes) => copyWith(
    times: [
      for (final time in times)
        if (time != minutes) time,
    ],
  );

  TaskDraft toggleDay(int day) => copyWith(
    days: days.contains(day) ? ({...days}..remove(day)) : {...days, day},
  );

  /// Switches to choosing days, starting from none: picking two days is
  /// two taps, not five.
  TaskDraft chooseDays() => copyWith(everyDay: false, days: const {});
}
