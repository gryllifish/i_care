import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';

/// A day as a small calendar leaf: the day number over the month.
class DateBadge extends StatelessWidget {
  const DateBadge({required this.day, this.muted = false, super.key});

  final DateTime day;

  /// Grayed out, for past days.
  final bool muted;

  static const _size = 56.0;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final color = muted ? context.colors.inkMuted : context.colors.tealDark;
    return ExcludeSemantics(
      // A minimum, not a fixed size: it grows with large text.
      child: Container(
        constraints: const BoxConstraints(minWidth: _size, minHeight: _size),
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: muted ? context.colors.surfaceMuted : context.colors.tealSoft,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Formatters.dayOfMonth(day, locale),
              style: AppTextStyles.headline.copyWith(color: color, height: 1),
            ),
            Text(
              Formatters.monthBadge(day, locale),
              style: AppTextStyles.overline.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
