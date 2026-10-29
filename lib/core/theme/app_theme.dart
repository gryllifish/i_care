import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  /// Minimum height of primary buttons: above the 48 dp target, since
  /// they are pressed in a hurry and sometimes with unsteady hands.
  static const _buttonHeight = 56.0;
  static const _navigationBarHeight = 76.0;

  static ThemeData light() {
    final base = ThemeData(
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.teal,
        surface: AppColors.surface,
        error: AppColors.overdue,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
    const stadium = StadiumBorder();

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      dividerColor: AppColors.divider,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.onAccent,
          minimumSize: const Size.fromHeight(_buttonHeight),
          textStyle: AppTextStyles.label,
          shape: stadium,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.teal,
          minimumSize: const Size.fromHeight(_buttonHeight),
          textStyle: AppTextStyles.label,
          shape: stadium,
          side: const BorderSide(color: AppColors.divider, width: 1.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.teal,
          textStyle: AppTextStyles.label,
          shape: stadium,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: stadium,
        side: const BorderSide(color: AppColors.divider),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.tealSoft,
        labelStyle: AppTextStyles.label,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: _navigationBarHeight,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.tealSoft,
        indicatorShape: stadium,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTextStyles.pill.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.ink
                : AppColors.inkMuted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.tealDark
                : AppColors.inkMuted,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        actionTextColor: AppColors.tealSoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        contentTextStyle: AppTextStyles.body.copyWith(
          color: AppColors.onAccent,
        ),
      ),
    );
  }
}
