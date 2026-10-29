import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
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

/// A scheduled dose: time, medication, status and who recorded it.
class DoseTile extends ConsumerWidget {
  const DoseTile({
    required this.slot,
    required this.onTap,
    this.stock,
    super.key,
  });

  final DoseSlot slot;
  final StockLevel? stock;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final names = ref.watch(caregiversByIdProvider);
    final style = slot.style(l10n);
    final details = slot.medication.details;

    final today = ref.watch(nowProvider);
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

    return _TileFrame(
      onTap: onTap,
      leading: Text(
        Formatters.time(slot.slotAt, locale),
        style: AppTextStyles.title,
      ),
      title: '${details.name} ${details.strength}',
      statusStyle: style,
      lines: [style.label, ...records].join(' · '),
      stock: stock,
      isPending: [
        ...slot.given,
        ...slot.skipped,
      ].any((record) => !record.meta.isSynced),
    );
  }
}

/// An as-needed medication and when it was last given.
class AsNeededTile extends ConsumerWidget {
  const AsNeededTile({required this.item, required this.onTap, super.key});

  final AsNeededItem item;
  final VoidCallback onTap;

  static const IconData _icon = Icons.medication_outlined;
  static const _iconSize = 28.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final names = ref.watch(caregiversByIdProvider);
    final details = item.medication.details;
    final last = item.lastDose;

    return _TileFrame(
      onTap: onTap,
      leading: const Icon(_icon, size: _iconSize, color: AppColors.teal),
      title: '${details.name} ${details.strength}',
      lines: last == null
          ? l10n.noDoseYet
          : l10n.lastDose(
              Formatters.time(last.givenAt, locale),
              names[last.meta.caregiverId]?.name ?? l10n.unknownCaregiver,
            ),
      stock: item.stock,
      isPending: last != null && !last.meta.isSynced,
    );
  }
}

class _TileFrame extends StatelessWidget {
  const _TileFrame({
    required this.onTap,
    required this.leading,
    required this.title,
    required this.lines,
    this.statusStyle,
    this.stock,
    this.isPending = false,
  });

  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String lines;
  final DoseStatusStyle? statusStyle;
  final StockLevel? stock;

  /// A record shown here is still only on this phone.
  final bool isPending;

  static const _leadingWidth = 64.0;
  static const _statusIconSize = 28.0;

  @override
  Widget build(BuildContext context) {
    final style = statusStyle;
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                SizedBox(width: _leadingWidth, child: leading),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(title, style: AppTextStyles.label),
                      Text(lines, style: AppTextStyles.bodyMuted),
                      if (stock case final StockLevel level when level.isLow)
                        _LowStockBadge(level: level),
                      if (isPending) const _PendingBadge(),
                    ],
                  ),
                ),
                if (style != null)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: Icon(
                      style.icon,
                      color: style.color,
                      size: _statusIconSize,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  const _PendingBadge();

  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          color: AppColors.inkMuted,
          size: _iconSize,
        ),
        Flexible(
          child: Text(
            context.l10n.notSyncedYet,
            style: AppTextStyles.bodyMuted,
          ),
        ),
      ],
    );
  }
}

class _LowStockBadge extends StatelessWidget {
  const _LowStockBadge({required this.level});

  final StockLevel level;

  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = switch (level) {
      StockLevel(:final units) when units <= 0 => l10n.stockOut,
      StockLevel(daysLeft: final int days) => l10n.stockDays(days),
      _ => l10n.stockOut,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
        const Icon(
          Icons.inventory_2_outlined,
          color: AppColors.due,
          size: _iconSize,
        ),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.bodyMuted.copyWith(color: AppColors.due),
          ),
        ),
      ],
    );
  }
}
