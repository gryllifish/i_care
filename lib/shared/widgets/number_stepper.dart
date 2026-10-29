import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// A labeled value with − and + buttons: easier than typing numbers,
/// and impossible to get out of range.
class NumberStepper extends StatelessWidget {
  const NumberStepper({
    required this.label,
    required this.valueText,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  final String label;

  /// The value as shown, e.g. "6 hours" or "½".
  final String valueText;

  /// Null when the value is at its minimum or maximum.
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(label, style: AppTextStyles.label),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.pillBorder,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onDecrease,
                icon: const Icon(Icons.remove),
                tooltip: '−',
              ),
              Expanded(
                child: Semantics(
                  label: label,
                  value: valueText,
                  child: ExcludeSemantics(
                    child: Text(
                      valueText,
                      style: AppTextStyles.label,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrease,
                icon: const Icon(Icons.add),
                tooltip: '+',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
