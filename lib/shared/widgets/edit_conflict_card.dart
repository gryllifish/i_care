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
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// Changes made at the same time by different people, side by side, to
/// keep the one in use or bring back another.
class EditConflictCard extends ConsumerStatefulWidget {
  const EditConflictCard({
    required this.conflict,
    required this.summarize,
    required this.onChoose,
    super.key,
  });

  final EditConflict conflict;

  /// What a change set, in one line.
  final String Function(CareEvent change) summarize;

  /// Keeps or brings back the given change; resolves when recorded.
  final Future<Result<void>> Function(CareEvent change) onChoose;

  @override
  ConsumerState<EditConflictCard> createState() => _EditConflictCardState();
}

class _EditConflictCardState extends ConsumerState<EditConflictCard> {
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final caregivers = ref.watch(membersByIdProvider);
    final changes = widget.conflict.changes;
    final reviews = ref.watch(canDoProvider(CareAction.reviewConflict));

    return AppCard(
      color: context.colors.overdueSoft,
      raised: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(Icons.error, color: context.colors.overdue),
              Expanded(
                child: Text(
                  l10n.editConflictTitle,
                  style: AppTextStyles.label.copyWith(
                    color: context.colors.overdue,
                  ),
                ),
              ),
            ],
          ),
          Text(l10n.editConflictBody, style: AppTextStyles.body),
          for (final change in changes)
            AppCard(
              raised: false,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Text(
                    l10n.changeBy(
                      caregivers[change.meta.caregiverId]?.name ??
                          l10n.unknownCaregiver,
                      Formatters.time(change.meta.occurredAt, locale),
                    ),
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                  Text(widget.summarize(change), style: AppTextStyles.body),
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    overflowAlignment: OverflowBarAlignment.end,
                    overflowSpacing: AppSpacing.xs,
                    children: [
                      if (change == changes.last)
                        StatusPill(
                          icon: Icons.check,
                          label: l10n.inUse,
                          color: context.colors.given,
                          background: context.colors.givenSoft,
                        )
                      else
                        const SizedBox.shrink(),
                      if (reviews)
                        TextButton(
                          onPressed: _busy ? null : () => _choose(change),
                          child: Text(
                            change == changes.last
                                ? l10n.keepThis
                                : l10n.useThis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _choose(CareEvent change) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await widget.onChoose(change);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
    }
    if (mounted) setState(() => _busy = false);
  }
}
