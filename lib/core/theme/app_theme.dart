import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  /// Fields are soft filled shapes; only focus and errors draw a ring.
  static OutlineInputBorder _fieldBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.sm),
    borderSide: BorderSide(
      color: color,
      width: color == Colors.transparent ? 0 : 2,
    ),
  );

  /// Minimum height of primary buttons: above the 48 dp target, since
  /// they are pressed in a hurry and sometimes with unsteady hands.
  static const _buttonHeight = 56.0;
  static const _navigationBarHeight = 76.0;
  static const _segmentHeight = 48.0;

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
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.title,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Fields sit on the tinted background, never inside cards.
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.inkMuted),
        errorStyle: AppTextStyles.bodyMuted.copyWith(color: AppColors.overdue),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: _fieldBorder(Colors.transparent),
        enabledBorder: _fieldBorder(Colors.transparent),
        focusedBorder: _fieldBorder(AppColors.teal),
        errorBorder: _fieldBorder(AppColors.overdue),
        focusedErrorBorder: _fieldBorder(AppColors.overdue),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.tealSoft,
          selectedForegroundColor: AppColors.tealDark,
          textStyle: AppTextStyles.label,
          minimumSize: const Size.fromHeight(_segmentHeight),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.onAccent,
        shape: StadiumBorder(),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: stadium,
        side: BorderSide.none,
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
