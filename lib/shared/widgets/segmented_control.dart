import 'package:flutter/cupertino.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// A sliding segmented control: a gray track with the chosen option on a
/// white thumb. Cupertino's, so it looks the same on Android and iOS.
class SegmentedControl<T extends Object> extends StatelessWidget {
  const SegmentedControl({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Values and their labels, in display order.
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl<T>(
        groupValue: selected,
        backgroundColor: AppColors.divider,
        thumbColor: AppColors.surface,
        padding: const EdgeInsets.all(AppSpacing.xs),
        onValueChanged: (value) {
          if (value != null) onChanged(value);
        },
        children: {
          for (final MapEntry(key: value, value: label) in options.entries)
            value: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm + AppSpacing.xxs,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(
                  color: value == selected ? AppColors.ink : AppColors.inkMuted,
                ),
              ),
            ),
        },
      ),
    );
  }
}
