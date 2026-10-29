import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/constants/app_durations.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/projections/dose_warnings.dart';
import 'package:i_care/features/today/controllers/dose_controller.dart';
import 'package:i_care/features/today/presentation/widgets/dose_status_style.dart';
import 'package:i_care/features/today/presentation/widgets/dose_texts.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';

/// Opens the sheet to record the dose of [medicationId] scheduled at
/// [slotAt], or an as-needed dose when [slotAt] is null.
Future<void> showDoseSheet(
  BuildContext context, {
  required String medicationId,
  required DateTime? slotAt,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => DoseSheet(medicationId: medicationId, slotAt: slotAt),
);

class DoseSheet extends ConsumerStatefulWidget {
  const DoseSheet({
    required this.medicationId,
    required this.slotAt,
    super.key,
  });

  final String medicationId;
  final DateTime? slotAt;

  @override
  ConsumerState<DoseSheet> createState() => _DoseSheetState();
}

class _DoseSheetState extends ConsumerState<DoseSheet> {
  var _choosingReason = false;
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final DoseDetail detail;
    switch (ref.watch(doseDetailProvider(widget.medicationId, widget.slotAt))) {
      case AsyncData(:final DoseDetail value):
        detail = value;
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
    final details = detail.medication.details;
    final slot = detail.slot;
    final isResolved =
        slot != null &&
        (slot.status == DoseStatus.given || slot.status == DoseStatus.skipped);

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
          Text(
            '${details.name} ${details.strength}',
            style: AppTextStyles.headline,
          ),
          Text(
            [
              if (slot != null)
                l10n.scheduledAt(Formatters.time(slot.slotAt, locale))
              else
                l10n.asNeeded,
              if (slot != null) slot.style(l10n).label,
            ].join(' · '),
            style: AppTextStyles.body,
          ),
          if (details.instructions.isNotEmpty)
            Text(details.instructions, style: AppTextStyles.bodyMuted),
          if (detail.conflicts.isNotEmpty)
            _Notice(
              icon: Icons.error,
              color: AppColors.overdue,
              background: AppColors.overdueSoft,
              title: l10n.statusGivenTwice,
              lines: [l10n.conflictDoseBody],
              action: TextButton(
                onPressed: _busy ? null : () => _acknowledge(detail),
                child: Text(l10n.markReviewed),
              ),
            )
          else if (slot?.isDouble ?? false)
            _Notice(
              icon: Icons.info_outline,
              color: AppColors.inkMuted,
              background: AppColors.skippedSoft,
              title: l10n.statusGivenTwice,
              lines: [l10n.doubleDoseBody],
            ),
          _History(detail: detail),
          if (detail.warnings.isNotEmpty)
            _Notice(
              icon: Icons.warning_amber,
              color: AppColors.due,
              background: AppColors.dueSoft,
              title: l10n.checkBeforeGiving,
              lines: [
                for (final warning in detail.warnings)
                  warning.text(
                    l10n,
                    locale: locale,
                    caregivers: ref.watch(caregiversByIdProvider),
                  ),
              ],
            ),
          if (_choosingReason && slot != null)
            _ReasonPicker(
              onPicked: _busy ? null : (reason) => _skip(detail, slot, reason),
            )
          else ...[
            FilledButton(
              onPressed: _busy ? null : () => _give(detail),
              child: Text(
                detail.warnings.isEmpty ? l10n.markGiven : l10n.markGivenAnyway,
              ),
            ),
            if (slot != null && !isResolved)
              OutlinedButton(
                onPressed: _busy
                    ? null
                    : () => setState(() => _choosingReason = true),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(_secondaryButtonHeight),
                ),
                child: Text(l10n.skipDose),
              ),
          ],
        ],
      ),
    );
  }

  static const _secondaryButtonHeight = 48.0;

  Future<void> _give(DoseDetail detail) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(doseActionsProvider.notifier);
    setState(() => _busy = true);

    final result = await actions.give(
      detail.medication,
      slotAt: widget.slotAt,
      knownDoseIds: knownDoseIdsOf(detail.warnings),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(switch (result) {
      Ok(:final value) => SnackBar(
        content: Text(l10n.doseRecordedGiven(detail.medication.details.name)),
        duration: AppDurations.undoWindow,
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => actions.undo(value),
        ),
      ),
      Err(:final failure) => SnackBar(content: Text(failure.message(l10n))),
    });
  }

  Future<void> _skip(
    DoseDetail detail,
    DoseSlot slot,
    SkipReason reason,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(doseActionsProvider.notifier);
    setState(() => _busy = true);

    final result = await actions.skip(
      detail.medication,
      slotAt: slot.slotAt,
      reason: reason,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(switch (result) {
      Ok(:final value) => SnackBar(
        content: Text(l10n.doseRecordedSkipped(detail.medication.details.name)),
        duration: AppDurations.undoWindow,
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => actions.undo(value),
        ),
      ),
      Err(:final failure) => SnackBar(content: Text(failure.message(l10n))),
    });
  }

  Future<void> _acknowledge(DoseDetail detail) async {
    final actions = ref.read(doseActionsProvider.notifier);
    setState(() => _busy = true);
    for (final conflict in detail.conflicts) {
      await actions.acknowledge(conflict.key);
    }
    if (mounted) setState(() => _busy = false);
  }
}

/// Who recorded what for this dose.
class _History extends ConsumerWidget {
  const _History({required this.detail});

  final DoseDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final caregivers = ref.watch(caregiversByIdProvider);
    final skipped = detail.slot?.skipped ?? const <DoseSkipped>[];
    if (detail.history.isEmpty && skipped.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget row(String caregiverId, String text) => Row(
      spacing: AppSpacing.md,
      children: [
        if (caregivers[caregiverId] case final caregiver?)
          CaregiverAvatar(caregiver: caregiver),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
    String nameOf(String id) => caregivers[id]?.name ?? l10n.unknownCaregiver;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          detail.slot == null ? l10n.recordedToday : l10n.recordedForThisDose,
          style: AppTextStyles.label,
        ),
        for (final dose in detail.history)
          row(
            dose.meta.caregiverId,
            l10n.recordedBy(
              nameOf(dose.meta.caregiverId),
              Formatters.time(dose.givenAt, locale),
            ),
          ),
        for (final skip in skipped)
          row(
            skip.meta.caregiverId,
            l10n.skippedBy(
              nameOf(skip.meta.caregiverId),
              skip.reason.label(l10n),
            ),
          ),
      ],
    );
  }
}

class _ReasonPicker extends StatelessWidget {
  const _ReasonPicker({required this.onPicked});

  final ValueChanged<SkipReason>? onPicked;

  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onPicked = this.onPicked;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(l10n.skipReasonTitle, style: AppTextStyles.label),
        for (final reason in SkipReason.values)
          OutlinedButton(
            onPressed: onPicked == null ? null : () => onPicked(reason),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(_buttonHeight),
            ),
            child: Text(reason.label(l10n)),
          ),
      ],
    );
  }
}

/// A highlighted box: a conflict, a warning or a note.
class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.lines,
    this.action,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final List<String> lines;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(icon, color: color),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.label.copyWith(color: color),
                ),
              ),
            ],
          ),
          for (final line in lines) Text(line, style: AppTextStyles.body),
          ?action,
        ],
      ),
    );
  }
}
