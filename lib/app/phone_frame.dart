import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';

/// On wide screens (the web demo on a desktop), shows the app inside a
/// phone-sized frame instead of stretching a mobile layout. On phones it
/// returns [child] untouched.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({required this.child, super.key});

  final Widget child;

  static const _maxSize = Size(430, 920);
  static const _minHeight = 650.0;
  static const _wideBreakpoint = 600.0;
  static const _margin = 24.0;
  static const _shadow = BoxShadow(
    color: AppColors.frameShadow,
    blurRadius: 90,
    offset: Offset(0, 30),
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (media.size.width < _wideBreakpoint) return child;

    final size = Size(
      _maxSize.width,
      math.max(
        _minHeight,
        math.min(_maxSize.height, media.size.height - _margin * 2),
      ),
    );

    return ColoredBox(
      color: AppColors.backdrop,
      child: Center(
        child: Container(
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
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
