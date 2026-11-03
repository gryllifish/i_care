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

  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final base = ThemeData(
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.teal,
        brightness: brightness,
        primary: colors.teal,
        onPrimary: colors.onAccent,
        surface: colors.surface,
        onSurface: colors.ink,
        onSurfaceVariant: colors.inkMuted,
        error: colors.overdue,
        onError: colors.onAccent,
      ),
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],
    );
    const stadium = StadiumBorder();

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: colors.ink,
        displayColor: colors.ink,
      ),
      dividerColor: colors.divider,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.teal,
          foregroundColor: colors.onAccent,
          minimumSize: const Size.fromHeight(_buttonHeight),
          textStyle: AppTextStyles.label,
          shape: stadium,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.teal,
          minimumSize: const Size.fromHeight(_buttonHeight),
          textStyle: AppTextStyles.label,
          shape: stadium,
          side: BorderSide(color: colors.divider, width: 1.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.teal,
          textStyle: AppTextStyles.label,
          shape: stadium,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.ink,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.title.copyWith(color: colors.ink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Fields sit on the tinted background, never inside cards.
        fillColor: colors.surface,
        hintStyle: AppTextStyles.body.copyWith(color: colors.inkMuted),
        errorStyle: AppTextStyles.bodyMuted.copyWith(color: colors.overdue),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: _fieldBorder(Colors.transparent),
        enabledBorder: _fieldBorder(Colors.transparent),
        focusedBorder: _fieldBorder(colors.teal),
        errorBorder: _fieldBorder(colors.overdue),
        focusedErrorBorder: _fieldBorder(colors.overdue),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: colors.tealSoft,
          selectedForegroundColor: colors.tealDark,
          textStyle: AppTextStyles.label,
          minimumSize: const Size.fromHeight(_segmentHeight),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.teal,
        foregroundColor: colors.onAccent,
        shape: const StadiumBorder(),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: stadium,
        side: BorderSide.none,
        backgroundColor: colors.surface,
        selectedColor: colors.tealSoft,
        labelStyle: AppTextStyles.label.copyWith(color: colors.ink),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: _navigationBarHeight,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colors.tealSoft,
        indicatorShape: stadium,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTextStyles.pill.copyWith(
            color: states.contains(WidgetState.selected)
                ? colors.ink
                : colors.inkMuted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colors.tealDark
                : colors.inkMuted,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.ink,
        actionTextColor: colors.tealSoft,
        closeIconColor: colors.onAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        contentTextStyle: AppTextStyles.body.copyWith(color: colors.onAccent),
      ),
    );
  }
}
