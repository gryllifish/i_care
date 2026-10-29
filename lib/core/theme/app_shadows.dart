import 'package:flutter/widgets.dart';
import 'package:i_care/core/theme/app_colors.dart';

/// Elevation as soft, low shadows rather than Material's tinted surfaces.
abstract final class AppShadows {
  static const card = [
    BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 6)),
  ];

  /// The next-dose card, which floats above the rest.
  static const hero = [
    BoxShadow(color: AppColors.shadow, blurRadius: 28, offset: Offset(0, 12)),
  ];
}
