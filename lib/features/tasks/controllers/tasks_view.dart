import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_view.g.dart';

/// An active care task and its concurrent edits nobody has reviewed.
typedef TaskRow = ({CareTask task, List<EditConflict> conflicts});

/// Active care tasks by name.
@riverpod
AsyncValue<List<TaskRow>> tasksView(Ref ref) =>
    ref.watch(careLogProvider).whenData((log) {
      final conflicts = log.conflicts.whereType<EditConflict>();
      return [
        for (final task in log.tasks)
          (
            task: task,
            conflicts: [
              for (final conflict in conflicts)
                if (conflict.entityId == task.id) conflict,
            ],
          ),
      ];
    });

/// One task, archived or not, with its unreviewed concurrent edits; null
/// when there is no such task.
@riverpod
AsyncValue<TaskRow?> taskRow(Ref ref, String taskId) =>
    ref.watch(careLogProvider).whenData((log) {
      final task = log.task(taskId);
      if (task == null) return null;
      return (
        task: task,
        conflicts: [
          for (final conflict in log.conflicts.whereType<EditConflict>())
            if (conflict.entityId == taskId) conflict,
        ],
      );
    });
