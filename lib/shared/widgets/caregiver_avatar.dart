import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';

/// A caregiver's initial on their color.
class CaregiverAvatar extends StatelessWidget {
  const CaregiverAvatar({required this.caregiver, this.size = 32, super.key});

  final Caregiver caregiver;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context
        .colors
        .avatars[caregiver.colorIndex % context.colors.avatars.length];
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: color,
        child: Text(
          caregiver.name.characters.first,
          style: AppTextStyles.label.copyWith(
            color: context.colors.onAccent,
            fontSize: size * 0.45,
          ),
        ),
      ),
    );
  }
}
