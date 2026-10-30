import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// A group of fields under a small uppercase title, on the screen's
/// tinted background: fields stand out as white shapes, without cards.
class FormSection extends StatelessWidget {
  const FormSection({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Semantics(
            container: true,
            header: true,
            child: Text(
              title.toUpperCase(),
              semanticsLabel: title,
              style: AppTextStyles.overline.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
