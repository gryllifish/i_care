import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';

part 'task_slot.freezed.dart';

enum TaskStatus {
  /// More than [DoseTiming.window] ahead.
  upcoming,

  /// Within [DoseTiming.window] of its time, or any time today for a task
  /// with no set time.
  due,

  /// More than [DoseTiming.window] late and not resolved.
  late,
  done,
  skipped,
}

/// One time a care task is due and what caregivers recorded for it.
@freezed
abstract class TaskSlot with _$TaskSlot {
  const factory TaskSlot({
    required CareTask task,

    /// The start of the day for a task with no set time.
    required DateTime slotAt,
    required TaskStatus status,

    /// In log order. More than one is fine: unlike a dose, doing a task
    /// twice harms nobody, so it is shown but never a conflict.
    @Default(<TaskDone>[]) List<TaskDone> done,
    @Default(<TaskSkipped>[]) List<TaskSkipped> skipped,
  }) = _TaskSlot;

  const TaskSlot._();

  bool get isAnyTime => task.schedule.isAnyTime;

  /// Done or skipped.
  bool get isResolved =>
      status == TaskStatus.done || status == TaskStatus.skipped;

  /// Whether [caregiverId] already recorded it as done.
  bool isDoneBy(String caregiverId) =>
      done.any((record) => record.meta.caregiverId == caregiverId);
}
