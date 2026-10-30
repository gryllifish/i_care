import 'package:flutter/widgets.dart';
import 'package:i_care/core/theme/app_colors.dart';

/// Elevation as soft, low shadows rather than Material's tinted surfaces.
abstract final class AppShadows {
  static List<BoxShadow> card(AppColors colors) => [
    BoxShadow(color: colors.shadow, blurRadius: 18, offset: const Offset(0, 6)),
  ];

  /// The next-dose card, which floats above the rest.
  static List<BoxShadow> hero(AppColors colors) => [
    BoxShadow(
      color: colors.shadow,
      blurRadius: 28,
      offset: const Offset(0, 12),
    ),
  ];
}
