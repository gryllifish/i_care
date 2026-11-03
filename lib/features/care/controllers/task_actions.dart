import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/entities/task_validation.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_actions.g.dart';

/// Changes to care tasks and what caregivers record for them. Each one
/// appends an event; edits carry the version they were made on, so
/// concurrent edits are flagged instead of lost. Callers validate first
/// (`validateTaskDetails`). Kept alive so an undo offered after a sheet
/// closes still has a live notifier.
@Riverpod(keepAlive: true)
class TaskActions extends _$TaskActions {
  @override
  void build() {}

  CareRecorder get _recorder => ref.read(careRecorderProvider);

  /// Adds a task; returns its id.
  Future<Result<String>> create({
    required TaskDetails details,
    required TaskSchedule schedule,
  }) async {
    final id = ref.read(newIdProvider)();
    final result = await _recorder.record(
      CareEvent.taskCreated(
        meta: _recorder.meta(),
        taskId: id,
        details: details,
        schedule: normalizeTaskSchedule(schedule),
      ),
    );
    return switch (result) {
      Ok() => Ok(id),
      Err(:final failure) => Err(failure),
    };
  }

  Future<Result<void>> update(
    CareTask task, {
    required TaskDetails details,
    required TaskSchedule schedule,
  }) => _recorder.record(
    CareEvent.taskUpdated(
      meta: _recorder.meta(),
      taskId: task.id,
      baseVersion: task.version,
      details: details,
      schedule: normalizeTaskSchedule(schedule),
    ),
  );

  /// Removes it from Today and the list; its records stay in Activity.
  Future<Result<void>> archive(CareTask task) => _recorder.record(
    CareEvent.taskArchived(
      meta: _recorder.meta(),
      taskId: task.id,
      baseVersion: task.version,
    ),
  );

  Future<Result<TaskDone>> done(TaskSlot slot) => _recorder.record(
    CareEvent.taskDone(
      meta: _recorder.meta(),
      taskId: slot.task.id,
      slotAt: slot.slotAt,
    ) as TaskDone,
  );

  /// Records [slot] as not done, for the reason [reasonId], with what
  /// the caregiver wrote in [note].
  Future<Result<TaskSkipped>> skip(
    TaskSlot slot, {
    required String reasonId,
    String? note,
  }) => _recorder.record(
    CareEvent.taskSkipped(
      meta: _recorder.meta(),
      taskId: slot.task.id,
      slotAt: slot.slotAt,
      reasonId: reasonId,
      note: note,
    ) as TaskSkipped,
  );

  /// Takes back a [TaskDone] or [TaskSkipped] recorded by mistake.
  Future<Result<DoseUndone>> undo(CareEvent record) => _recorder.record(
    CareEvent.doseUndone(meta: _recorder.meta(), targetEventId: record.meta.id)
        as DoseUndone,
  );

  /// Settles [conflict] by applying [chosen] again on top of the current
  /// version, or by keeping what is there when [chosen] is the change that
  /// won. Either way the conflict is marked as reviewed.
  Future<Result<void>> resolve(
    EditConflict conflict,
    CareTask task, {
    required CareEvent chosen,
  }) {
    final reapply = chosen == conflict.changes.last
        ? null
        : switch (chosen) {
            TaskUpdated(:final details, :final schedule) =>
              CareEvent.taskUpdated(
                meta: _recorder.meta(),
                taskId: task.id,
                baseVersion: task.version,
                details: details,
                schedule: schedule,
              ),
            TaskArchived() => CareEvent.taskArchived(
              meta: _recorder.meta(),
              taskId: task.id,
              baseVersion: task.version,
            ),
            _ => null,
          };
    return _recorder.recordAll([
      ?reapply,
      CareEvent.conflictAcknowledged(
        meta: _recorder.meta(),
        conflictKey: conflict.key,
      ),
    ]);
  }
}
