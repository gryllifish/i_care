import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/today/presentation/widgets/dose_texts.dart';
import 'package:i_care/features/today/presentation/widgets/dose_tile.dart';
import 'package:i_care/features/today/presentation/widgets/task_status_style.dart';
import 'package:i_care/features/today/presentation/widgets/timeline_rail.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/status_pill.dart';
import 'package:i_care/shared/widgets/task_icon.dart';

/// A care task due at a set time, on the day's timeline beside the doses.
class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.slot,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
    super.key,
  });

  final TaskSlot slot;
  final VoidCallback onTap;

  /// Whether the rail starts or ends at this task.
  final bool isFirst;
  final bool isLast;

  static const _timeWidth = 52.0;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final style = slot.style(context.l10n, context.colors);

    // One node for the screen reader: the time, then the card.
    return MergeSemantics(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _timeWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  Formatters.time(slot.slotAt, locale),
                  style: AppTextStyles.label,
                ),
              ),
            ),
            TimelineRail(color: style.color, isFirst: isFirst, isLast: isLast),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TaskCard(slot: slot, onTap: onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A care task as a card: its name, status and who recorded what.
class TaskCard extends ConsumerWidget {
  const TaskCard({required this.slot, required this.onTap, super.key});

  final TaskSlot slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final names = ref.watch(membersByIdProvider);
    final today = ref.watch(nowProvider);
    final style = slot.style(l10n, context.colors);

    final records = [
      for (final record in [...slot.done, ...slot.skipped])
        recordedByText(
          l10n,
          name: names[record.meta.caregiverId]?.name ?? l10n.unknownCaregiver,
          at: record.meta.occurredAt,
          slotAt: slot.slotAt,
          today: today,
          locale: locale,
        ),
    ];
    final isPending = [
      ...slot.done,
      ...slot.skipped,
    ].any((record) => !record.meta.isSynced);

    return AppCard(
      onTap: onTap,
      child: Row(
        spacing: AppSpacing.md,
        children: [
          const TaskIcon(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Text(slot.task.details.name, style: AppTextStyles.label),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    StatusPill(
                      icon: style.icon,
                      label: style.label,
                      color: style.color,
                      background: style.background,
                    ),
                    if (isPending) const PendingPill(),
                  ],
                ),
                if (records.isNotEmpty)
                  Text(
                    records.join(' · '),
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
