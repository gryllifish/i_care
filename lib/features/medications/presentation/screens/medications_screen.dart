import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/medications/controllers/medications_view.dart';
import 'package:i_care/features/medications/presentation/widgets/schedule_text.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/low_stock_pill.dart';
import 'package:i_care/shared/widgets/medication_icon.dart';
import 'package:i_care/shared/widgets/screen_header.dart';

/// Every active medication with its schedule and stock.
class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SafeArea(
      bottom: false,
      child: switch (ref.watch(medicationsViewProvider)) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.lg,
            AppSpacing.screenHorizontal,
            AppSpacing.xxl,
          ),
          children: [
            ScreenHeader(
              title: l10n.navMedications,
              subtitle:
                  '${l10n.medicationsCount(value.length)} · ${l10n.sampleData}',
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final row in value)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _MedicationCard(row: row),
              ),
          ],
        ),
        AsyncError(:final error) => ErrorView(
          message: l10n.errorMessage(error),
          onRetry: () => ref.invalidate(careLogProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _MedicationCard extends StatelessWidget {
  const _MedicationCard({required this.row});

  final MedicationRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final medication = row.medication;
    final details = medication.details;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Row(
            spacing: AppSpacing.md,
            children: [
              MedicationIcon(form: details.form),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Text(details.name, style: AppTextStyles.title),
                    Text(details.strength, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
            ],
          ),
          _InfoRow(
            icon: Icons.schedule,
            text: medication.schedule.describe(l10n, locale),
          ),
          if (details.instructions.isNotEmpty)
            _InfoRow(icon: Icons.notes, text: details.instructions),
          _StockRow(stock: row.stock, locale: locale),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  static const _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Icon(icon, size: _iconSize, color: AppColors.inkMuted),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
  }
}

/// Units left on a soft background, flagged when low.
class _StockRow extends StatelessWidget {
  const _StockRow({required this.stock, required this.locale});

  final StockLevel? stock;
  final String locale;

  static const _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stock = this.stock;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: _iconSize,
            color: AppColors.inkMuted,
          ),
          Expanded(
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  stock == null
                      ? l10n.stockNotCounted
                      : l10n.stockUnitsCount(
                          Formatters.units(stock.units, locale),
                        ),
                  style: AppTextStyles.body,
                ),
                if (stock case final StockLevel level when level.isLow)
                  LowStockPill(level: level)
                else if (stock?.daysLeft case final int days)
                  Text(l10n.stockLasts(days), style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
