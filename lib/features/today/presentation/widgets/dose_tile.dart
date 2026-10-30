import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/today/controllers/today_view.dart';
import 'package:i_care/features/today/presentation/widgets/dose_status_style.dart';
import 'package:i_care/features/today/presentation/widgets/dose_texts.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/low_stock_pill.dart';
import 'package:i_care/shared/widgets/medication_icon.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// A scheduled dose on the day's timeline: its time on the left, a dot on
/// the rail colored by status, and a card with what was recorded.
class DoseTile extends ConsumerWidget {
  const DoseTile({
    required this.slot,
    required this.onTap,
    this.stock,
    this.isFirst = false,
    this.isLast = false,
    super.key,
  });

  final DoseSlot slot;
  final StockLevel? stock;
  final VoidCallback onTap;

  /// Whether the rail starts or ends at this dose.
  final bool isFirst;
  final bool isLast;

  static const _timeWidth = 52.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final names = ref.watch(caregiversByIdProvider);
    final today = ref.watch(nowProvider);
    final style = slot.style(l10n, context.colors);
    final details = slot.medication.details;

    String record(CareEvent event, DateTime at) => recordedByText(
      l10n,
      name: names[event.meta.caregiverId]?.name ?? l10n.unknownCaregiver,
      at: at,
      slotAt: slot.slotAt,
      today: today,
      locale: locale,
    );
    final records = [
      for (final dose in slot.given) record(dose, dose.givenAt),
      for (final skip in slot.skipped) record(skip, skip.meta.occurredAt),
    ];
    final isPending = [
      ...slot.given,
      ...slot.skipped,
    ].any((record) => !record.meta.isSynced);

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
            _Rail(color: style.color, isFirst: isFirst, isLast: isLast),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  onTap: onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.sm,
                    children: [
                      Text(
                        '${details.name} ${details.strength}',
                        style: AppTextStyles.label,
                      ),
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
                          if (stock case final StockLevel level
                              when level.isLow)
                            LowStockPill(level: level),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The vertical line joining the day's doses, with a dot for each.
class _Rail extends StatelessWidget {
  const _Rail({
    required this.color,
    required this.isFirst,
    required this.isLast,
  });

  final Color color;
  final bool isFirst;
  final bool isLast;

  static const _width = 28.0;
  static const _lineWidth = 2.0;
  static const _dotSize = 14.0;
  static const double _dotTop = AppSpacing.lg + 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (!(isFirst && isLast))
            Positioned(
              top: isFirst ? _dotTop : 0,
              bottom: isLast ? null : 0,
              height: isLast ? _dotTop : null,
              child: SizedBox(
                width: _lineWidth,
                child: ColoredBox(color: context.colors.divider),
              ),
            ),
          Positioned(
            top: _dotTop,
            child: Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.background, width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An as-needed medication and when it was last given.
class AsNeededTile extends ConsumerWidget {
  const AsNeededTile({required this.item, required this.onTap, super.key});

  final AsNeededItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final names = ref.watch(caregiversByIdProvider);
    final details = item.medication.details;
    final last = item.lastDose;

    return AppCard(
      onTap: onTap,
      child: Row(
        spacing: AppSpacing.md,
        children: [
          MedicationIcon(form: details.form),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  '${details.name} ${details.strength}',
                  style: AppTextStyles.label,
                ),
                Text(
                  last == null
                      ? l10n.noDoseYet
                      : l10n.lastDose(
                          Formatters.time(last.givenAt, locale),
                          names[last.meta.caregiverId]?.name ??
                              l10n.unknownCaregiver,
                        ),
                  style: AppTextStyles.bodyMuted.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                if (item.stock case final StockLevel level when level.isLow)
                  LowStockPill(level: level),
                if (last != null && !last.meta.isSynced) const PendingPill(),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.inkMuted),
        ],
      ),
    );
  }
}

/// A record shown here is still only on this phone.
class PendingPill extends StatelessWidget {
  const PendingPill({super.key});

  @override
  Widget build(BuildContext context) => StatusPill(
    icon: Icons.cloud_upload_outlined,
    label: context.l10n.notSyncedYet,
    color: context.colors.inkMuted,
    background: context.colors.surfaceMuted,
  );
}
