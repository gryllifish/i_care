import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// The top of a tab: title and subtitle, with optional widgets around.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    this.overline,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    super.key,
  });

  final String title;

  /// Small text above the title, e.g. "CARING FOR".
  final String? overline;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  /// Shown below, e.g. status pills.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final overline = this.overline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Row(
          spacing: AppSpacing.md,
          children: [
            ?leading,
            Expanded(
              // Read as one heading: "Caring for Elena, Monday, November 2".
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    if (overline != null)
                      Text(
                        overline.toUpperCase(),
                        semanticsLabel: overline,
                        style: AppTextStyles.overline.copyWith(
                          color: context.colors.inkMuted,
                        ),
                      ),
                    Semantics(
                      header: true,
                      child: Text(title, style: AppTextStyles.headline),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyMuted.copyWith(
                          color: context.colors.inkMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        ?footer,
      ],
    );
  }
}
