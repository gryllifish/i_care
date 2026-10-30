import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/tasks/controllers/tasks_view.dart';
import 'package:i_care/shared/l10n/schedule_text.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/screen_header.dart';
import 'package:i_care/shared/widgets/status_pill.dart';
import 'package:i_care/shared/widgets/task_icon.dart';

/// Every active care task with its schedule.
class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // Tabs stay alive side by side: each button needs its own tag.
        heroTag: AppRoutes.tasks,
        onPressed: () => context.push(AppRoutes.newTaskPath()),
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
      ),
      body: SafeArea(
        bottom: false,
        child: switch (ref.watch(tasksViewProvider)) {
          AsyncData(:final value) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.lg,
              AppSpacing.screenHorizontal,
              AppSpacing.xxl,
            ),
            children: [
              ScreenHeader(
                title: l10n.navTasks,
                subtitle: [
                  l10n.tasksCount(value.length),
                  l10n.sampleData,
                ].join(' · '),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (value.isEmpty)
                Text(
                  l10n.tasksEmpty,
                  style: AppTextStyles.body.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
              for (final row in value)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _TaskCard(row: row),
                ),
              // Room for the floating button over the last card.
              const SizedBox(height: AppSpacing.xxxl * 2),
            ],
          ),
          AsyncError(:final error) => ErrorView(
            message: l10n.errorMessage(error),
            onRetry: () => ref.invalidate(careLogProvider),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.row});

  final TaskRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final task = row.task;
    final details = task.details;

    return AppCard(
      onTap: () => context.push(AppRoutes.editTaskPath(task.id)),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          const TaskIcon(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(details.name, style: AppTextStyles.title),
                Text(
                  task.schedule.describe(l10n, locale),
                  style: AppTextStyles.body,
                ),
                if (details.note.isNotEmpty)
                  Text(
                    details.note,
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                if (row.conflicts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: StatusPill(
                      icon: Icons.error,
                      label: l10n.medicationConflictBadge,
                      color: context.colors.overdue,
                      background: context.colors.overdueSoft,
                    ),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.inkMuted),
        ],
      ),
    );
  }
}
