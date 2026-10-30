import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/medications/controllers/medication_actions.dart';
import 'package:i_care/features/medications/controllers/medication_detail.dart';
import 'package:i_care/features/medications/presentation/widgets/stock_input.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/l10n/schedule_text.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/edit_conflict_card.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/low_stock_pill.dart';
import 'package:i_care/shared/widgets/medication_icon.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// One medication: schedule and its history, stock, recent doses, and
/// concurrent edits to review.
class MedicationDetailScreen extends ConsumerWidget {
  const MedicationDetailScreen({required this.medicationId, super.key});

  final String medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return switch (ref.watch(medicationDetailProvider(medicationId))) {
      AsyncData(value: final MedicationDetail detail) => Scaffold(
        appBar: AppBar(
          actions: [
            if (!detail.medication.isArchived)
              _Menu(medication: detail.medication),
          ],
        ),
        body: _DetailContent(detail: detail),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: l10n.errorMessage(error),
          onRetry: () => ref.invalidate(careLogProvider),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(l10n.errorNotFound, style: AppTextStyles.body),
        ),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

enum _MenuAction { edit, archive }

class _Menu extends ConsumerWidget {
  const _Menu({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return PopupMenuButton<_MenuAction>(
      tooltip: l10n.more,
      onSelected: (action) => switch (action) {
        _MenuAction.edit => context.push(
          AppRoutes.editMedicationPath(medication.id),
        ),
        _MenuAction.archive => _archive(context, ref),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MenuAction.edit,
          child: Text(l10n.editMedication),
        ),
        PopupMenuItem(value: _MenuAction.archive, child: Text(l10n.archive)),
      ],
    );
  }

  Future<void> _archive(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.archiveTitle(medication.details.name),
      body: l10n.archiveBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.archive,
    );
    if (!confirmed || !context.mounted) return;
    final result = await ref
        .read(medicationActionsProvider.notifier)
        .archive(medication);
    if (result case Err(:final failure)) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message(l10n))));
      return;
    }
    if (context.mounted) context.pop();
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.detail});

  final MedicationDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final medication = detail.medication;
    final details = medication.details;
    final isActive = !medication.isArchived;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      children: [
        Row(
          spacing: AppSpacing.lg,
          children: [
            MedicationIcon(form: details.form, size: 64),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(details.name, style: AppTextStyles.headline),
                  Text(
                    [
                      if (details.strength.isNotEmpty) details.strength,
                      details.form.label(l10n),
                    ].join(' · '),
                    style: AppTextStyles.bodyMuted,
                  ),
                  if (medication.isArchived)
                    StatusPill(
                      icon: Icons.archive_outlined,
                      label: l10n.archived,
                      color: AppColors.inkMuted,
                      background: AppColors.surfaceMuted,
                    ),
                ],
              ),
            ),
          ],
        ),
        for (final conflict in detail.conflicts) ...[
          const SizedBox(height: AppSpacing.lg),
          _MedicationConflict(conflict: conflict, medication: medication),
        ],
        _Section(
          title: l10n.scheduleTitle,
          action: isActive
              ? TextButton(
                  onPressed: () => context.push(
                    AppRoutes.changeSchedulePath(medication.id),
                  ),
                  child: Text(l10n.changeSchedule),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.md,
            children: [
              Text(
                medication.schedule.describe(l10n, locale),
                style: AppTextStyles.body,
              ),
              if (medication.schedules.length > 1)
                _PreviousSchedules(medication: medication),
            ],
          ),
        ),
        if (details.instructions.isNotEmpty)
          _Section(
            title: l10n.instructionsTitle,
            child: Text(details.instructions, style: AppTextStyles.body),
          ),
        _Section(
          title: l10n.stockTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              _StockSummary(stock: detail.stock),
              if (isActive)
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    for (final change in StockChange.values)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => showStockSheet(
                            context,
                            medication: medication,
                            change: change,
                          ),
                          child: Text(switch (change) {
                            StockChange.recount => l10n.recount,
                            StockChange.refill => l10n.boughtMore,
                          }),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        if (detail.recentDoses.isNotEmpty)
          _Section(
            title: l10n.recentDoses,
            child: _RecentDoses(doses: detail.recentDoses),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            // Side by side when they fit; the action drops below otherwise.
            OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                Semantics(
                  container: true,
                  header: true,
                  child: Text(
                    title.toUpperCase(),
                    semanticsLabel: title,
                    style: AppTextStyles.overline,
                  ),
                ),
                ?action,
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
}

/// Schedules that applied before the current one, newest first, each
/// with the day it ended.
class _PreviousSchedules extends StatelessWidget {
  const _PreviousSchedules({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final versions = medication.schedules;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(l10n.previousSchedules, style: AppTextStyles.label),
        for (var index = versions.length - 2; index >= 0; index--)
          Text(
            [
              versions[index].schedule.describe(l10n, locale),
              l10n.scheduleUntil(
                Formatters.shortDate(versions[index + 1].effectiveFrom, locale),
              ),
            ].join(' · '),
            style: AppTextStyles.bodyMuted,
          ),
      ],
    );
  }
}

class _StockSummary extends StatelessWidget {
  const _StockSummary({required this.stock});

  final StockLevel? stock;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final stock = this.stock;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          stock == null
              ? l10n.stockNotCounted
              : l10n.stockUnitsCount(Formatters.units(stock.units, locale)),
          style: AppTextStyles.title,
        ),
        if (stock case final StockLevel level when level.isLow)
          LowStockPill(level: level)
        else if (stock?.daysLeft case final int days)
          Text(l10n.stockLasts(days), style: AppTextStyles.bodyMuted),
      ],
    );
  }
}

class _RecentDoses extends ConsumerWidget {
  const _RecentDoses({required this.doses});

  final List<DoseGiven> doses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final caregivers = ref.watch(caregiversByIdProvider);
    return Column(
      spacing: AppSpacing.sm,
      children: [
        for (final dose in doses)
          MergeSemantics(
            child: Row(
              spacing: AppSpacing.md,
              children: [
                if (caregivers[dose.meta.caregiverId] case final caregiver?)
                  CaregiverAvatar(caregiver: caregiver),
                Expanded(
                  child: Text(
                    l10n.recordedBy(
                      caregivers[dose.meta.caregiverId]?.name ??
                          l10n.unknownCaregiver,
                      Formatters.time(dose.givenAt, locale),
                    ),
                    style: AppTextStyles.body,
                  ),
                ),
                Text(
                  Formatters.shortDate(dose.givenAt, locale),
                  style: AppTextStyles.bodyMuted,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A concurrent edit of this medication, to keep or undo.
class _MedicationConflict extends ConsumerWidget {
  const _MedicationConflict({required this.conflict, required this.medication});

  final EditConflict conflict;
  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return EditConflictCard(
      conflict: conflict,
      summarize: (change) => switch (change) {
        MedicationUpdated(:final details) => [
          details.name,
          if (details.strength.isNotEmpty) details.strength,
          if (details.instructions.isNotEmpty) details.instructions,
        ].join(' · '),
        ScheduleChanged(:final schedule) => schedule.describe(l10n, locale),
        MedicationArchived() => l10n.changeArchived,
        _ => '',
      },
      onChoose: (change) => ref
          .read(medicationActionsProvider.notifier)
          .resolve(conflict, medication, chosen: change),
    );
  }
}
