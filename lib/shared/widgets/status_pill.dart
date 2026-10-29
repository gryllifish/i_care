import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// A small rounded label: an icon and text on a soft tint of [color].
class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.pillBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + AppSpacing.xxs,
          vertical: AppSpacing.xs + AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(icon, size: _iconSize, color: color),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.pill.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
