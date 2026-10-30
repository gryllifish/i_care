import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';

/// The vertical line joining the day's doses and tasks, with a dot for
/// each.
class TimelineRail extends StatelessWidget {
  const TimelineRail({
    required this.color,
    required this.isFirst,
    required this.isLast,
    super.key,
  });

  final Color color;
  final bool isFirst;
  final bool isLast;

  static const _width = 28.0;
  static const _lineWidth = 2.0;
  static const _dotSize = 14.0;
  static const double _dotTop = AppSpacing.lg + 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (!(isFirst && isLast))
            Positioned(
              top: isFirst ? _dotTop : 0,
              bottom: isLast ? null : 0,
              height: isLast ? _dotTop : null,
              child: SizedBox(
                width: _lineWidth,
                child: ColoredBox(color: context.colors.divider),
              ),
            ),
          Positioned(
            top: _dotTop,
            child: Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.background, width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
