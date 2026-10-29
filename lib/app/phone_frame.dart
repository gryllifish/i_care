import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';

/// A phone-sized frame for showing the app on wide screens (the web demo
/// on a desktop) instead of stretching a mobile layout.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({required this.child, required this.maxHeight, super.key});

  final Widget child;

  /// Height available for the frame; it shrinks down to a minimum.
  final double maxHeight;

  static const width = 390.0;
  static const _maxFrameHeight = 844.0;
  static const _minFrameHeight = 600.0;
  static const _shadow = BoxShadow(
    color: AppColors.frameShadow,
    blurRadius: 60,
    offset: Offset(0, 20),
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = Size(
      width,
      math.max(_minFrameHeight, math.min(_maxFrameHeight, maxHeight)),
    );

    return Container(
      width: size.width,
      height: size.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.device),
        boxShadow: const [_shadow],
      ),
      // Screens read their size from MediaQuery, so give them the frame's.
      child: MediaQuery(
        data: media.copyWith(
          size: size,
          padding: EdgeInsets.zero,
          viewPadding: EdgeInsets.zero,
          viewInsets: EdgeInsets.zero,
        ),
        child: child,
      ),
    );
  }
}
