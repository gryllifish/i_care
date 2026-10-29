import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';

/// "Save" as a compact pill at the end of an app bar.
class SaveButton extends StatelessWidget {
  const SaveButton({required this.onPressed, super.key});

  /// Null while saving.
  final VoidCallback? onPressed;

  static const _height = 40.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, _height),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
        child: Text(context.l10n.save),
      ),
    );
  }
}
