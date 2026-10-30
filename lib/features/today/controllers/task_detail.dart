import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_detail.g.dart';

/// The time [taskId] is due at [slotAt], kept current while its sheet is
/// open; null once the task is archived or no longer due then.
@riverpod
AsyncValue<TaskSlot?> taskDetail(Ref ref, String taskId, DateTime slotAt) {
  final now = ref.watch(nowProvider);
  return ref
      .watch(careLogProvider)
      .whenData(
        (log) => log
            .taskSlotsOn(slotAt, now: now)
            .where((slot) => slot.task.id == taskId && slot.slotAt == slotAt)
            .firstOrNull,
      );
}
