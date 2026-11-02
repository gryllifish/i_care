import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/task_actions.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/today/controllers/task_detail.dart';
import 'package:i_care/features/today/presentation/widgets/dose_texts.dart';
import 'package:i_care/features/today/presentation/widgets/record_row.dart';
import 'package:i_care/features/today/presentation/widgets/skip_reason_picker.dart';
import 'package:i_care/features/today/presentation/widgets/task_status_style.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';

/// Opens the sheet to record the care task [taskId] due at [slotAt].
Future<void> showTaskSheet(
  BuildContext context, {
  required String taskId,
  required DateTime slotAt,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => TaskSheet(taskId: taskId, slotAt: slotAt),
);

class TaskSheet extends ConsumerStatefulWidget {
  const TaskSheet({required this.taskId, required this.slotAt, super.key});

  final String taskId;
  final DateTime slotAt;

  @override
  ConsumerState<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends ConsumerState<TaskSheet> {
  var _choosingReason = false;
  var _busy = false;

  /// Reasons that fit a task; "doctor's advice" is about medications.
  static final List<SkipReason> _reasons = [
    for (final reason in SkipReason.values)
      if (reason != SkipReason.doctorAdvice) reason,
  ];

  static const _secondaryButtonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final TaskSlot slot;
    switch (ref.watch(taskDetailProvider(widget.taskId, widget.slotAt))) {
      case AsyncData(:final TaskSlot value):
        slot = value;
      case AsyncLoading():
        return const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        );
      case _:
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(context.l10n.errorNotFound, style: AppTextStyles.body),
        );
    }

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final details = slot.task.details;
    final isResolved =
        slot.status == TaskStatus.done || slot.status == TaskStatus.skipped;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: [
          Text(details.name, style: AppTextStyles.headline),
          Text(
            [
              if (slot.isAnyTime)
                l10n.duringTheDay
              else
                l10n.scheduledAt(Formatters.time(slot.slotAt, locale)),
              slot.style(l10n, context.colors).label,
            ].join(' · '),
            style: AppTextStyles.body,
          ),
          if (details.note.isNotEmpty)
            Text(
              details.note,
              style: AppTextStyles.bodyMuted.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          _Records(slot: slot, onRemove: _remove),
          if (!isResolved)
            if (_choosingReason)
              SkipReasonPicker(
                title: l10n.taskSkipReasonTitle,
                reasons: _reasons,
                onPicked: _busy ? null : (reason) => _skip(slot, reason),
              )
            else ...[
              FilledButton(
                onPressed: _busy ? null : () => _done(slot),
                child: Text(l10n.markDone),
              ),
              OutlinedButton(
                onPressed: _busy
                    ? null
                    : () => setState(() => _choosingReason = true),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(_secondaryButtonHeight),
                ),
                child: Text(l10n.markNotDone),
              ),
            ],
        ],
      ),
    );
  }

  Future<void> _done(TaskSlot slot) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(taskActionsProvider.notifier);
    setState(() => _busy = true);

    final result = await actions.done(slot);
    if (!mounted) return;
    Navigator.of(context).pop();
    switch (result) {
      case Ok(:final value):
        messenger.showMessage(
          l10n.taskRecordedDone(slot.task.details.name),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () => actions.undo(value),
          ),
        );
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }

  Future<void> _skip(TaskSlot slot, SkipReason reason) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(taskActionsProvider.notifier);
    setState(() => _busy = true);

    final result = await actions.skip(slot, reason);
    if (!mounted) return;
    Navigator.of(context).pop();
    switch (result) {
      case Ok(:final value):
        messenger.showMessage(
          l10n.taskRecordedSkipped(slot.task.details.name),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () => actions.undo(value),
          ),
        );
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }

  /// Takes back a record made by mistake, after confirming. It appends an
  /// undo event, so Activity still shows both.
  Future<void> _remove(CareEvent record) async {
    if (_busy) return;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(taskActionsProvider.notifier);
    final name =
        ref.read(membersByIdProvider)[record.meta.caregiverId]?.name ??
        l10n.unknownCaregiver;

    final confirmed = await showConfirmDialog(
      context,
      title: l10n.removeRecordTitle,
      body: switch (record) {
        TaskDone() => l10n.removeDoneBody(
          name,
          Formatters.time(record.meta.occurredAt, locale),
        ),
        _ => l10n.removeTaskSkippedBody(name),
      },
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.remove,
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    final result = await actions.undo(record);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _choosingReason = false;
    });
    switch (result) {
      case Ok():
        messenger.showMessage(l10n.recordRemoved);
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }
}

/// Who recorded this task, each record with a button to take it back.
class _Records extends ConsumerWidget {
  const _Records({required this.slot, required this.onRemove});

  final TaskSlot slot;
  final ValueChanged<CareEvent> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final caregivers = ref.watch(membersByIdProvider);
    final today = ref.watch(nowProvider);
    if (slot.done.isEmpty && slot.skipped.isEmpty) {
      return const SizedBox.shrink();
    }

    String nameOf(String id) => caregivers[id]?.name ?? l10n.unknownCaregiver;
    final me = ref.watch(currentMemberProvider);
    VoidCallback? removeOf(CareEvent record) =>
        me != null && canRemove(me, record) ? () => onRemove(record) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(l10n.taskRecords, style: AppTextStyles.label),
        for (final record in slot.done)
          RecordRow(
            caregiver: caregivers[record.meta.caregiverId],
            name: nameOf(record.meta.caregiverId),
            text: recordedByText(
              l10n,
              name: nameOf(record.meta.caregiverId),
              at: record.meta.occurredAt,
              slotAt: slot.slotAt,
              today: today,
              locale: locale,
            ),
            onRemove: removeOf(record),
          ),
        for (final record in slot.skipped)
          RecordRow(
            caregiver: caregivers[record.meta.caregiverId],
            name: nameOf(record.meta.caregiverId),
            text: l10n.skippedBy(
              nameOf(record.meta.caregiverId),
              record.reason.label(l10n),
            ),
            onRemove: removeOf(record),
          ),
      ],
    );
  }
}
