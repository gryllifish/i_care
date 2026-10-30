import 'package:i_care/features/care/domain/entities/care_task.dart';

/// Something to fix before a care task can be saved.
enum TaskIssue {
  nameMissing,

  /// Set times were chosen, but none was added. Only editors can produce
  /// it: a stored schedule with no times means "during the day".
  noTimes,

  /// Days were to be chosen, but none was. Only editors can produce it.
  noWeekdays,
}

/// Issues in [details]; empty when they can be saved.
Set<TaskIssue> validateTaskDetails(TaskDetails details) => {
  if (details.name.trim().isEmpty) TaskIssue.nameMissing,
};

/// [schedule] in its stored form: times ascending and without repeats,
/// so equal schedules compare equal.
TaskSchedule normalizeTaskSchedule(TaskSchedule schedule) => schedule.copyWith(
  minutesOfDay: schedule.minutesOfDay.toSet().toList()..sort(),
);
