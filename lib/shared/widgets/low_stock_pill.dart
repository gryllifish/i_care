import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// Stock runs out soon or has run out.
class LowStockPill extends StatelessWidget {
  const LowStockPill({required this.level, super.key});

  final StockLevel level;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StatusPill(
      icon: Icons.inventory_2_outlined,
      label: switch (level) {
        StockLevel(:final units) when units <= 0 => l10n.stockOut,
        StockLevel(daysLeft: final int days) => l10n.stockDays(days),
        _ => l10n.stockOut,
      },
      color: context.colors.due,
      background: context.colors.dueSoft,
    );
  }
}
