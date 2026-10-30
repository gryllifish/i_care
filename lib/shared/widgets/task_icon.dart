import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';

/// A care task's icon in a soft circle, beside medications' icons.
class TaskIcon extends StatelessWidget {
  const TaskIcon({this.size = 44, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.colors.surfaceMuted,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.volunteer_activism_outlined,
          color: context.colors.recipient,
          size: size / 2,
        ),
      ),
    );
  }
}
