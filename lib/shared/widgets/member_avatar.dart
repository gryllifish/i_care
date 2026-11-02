import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/domain/entities/member.dart';

/// A member's initial on their color.
class MemberAvatar extends StatelessWidget {
  const MemberAvatar({required this.member, this.size = 32, super.key});

  final Member member;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context
        .colors
        .avatars[member.colorIndex % context.colors.avatars.length];
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: color,
        child: Text(
          member.name.characters.first,
          style: AppTextStyles.label.copyWith(
            color: context.colors.onAccent,
            fontSize: size * 0.45,
          ),
        ),
      ),
    );
  }
}
