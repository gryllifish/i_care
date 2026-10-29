import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';

/// Type scale. Sizes start one step above Material's defaults: the app is
/// read in a hurry, often by older caregivers.
abstract final class AppTextStyles {
  static const headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.15,
    color: AppColors.ink,
  );

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontSize: 17,
    height: 1.45,
    color: AppColors.ink,
  );

  static const bodyMuted = TextStyle(
    fontSize: 15,
    height: 1.4,
    color: AppColors.inkMuted,
  );

  static const label = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
}
