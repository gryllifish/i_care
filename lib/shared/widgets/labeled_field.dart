import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// A form field with its label above, always visible, instead of
/// Material's label floating inside the box.
class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    required this.controller,
    this.hint,
    this.error,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.multiline = false,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  /// Shown below the field when set.
  final String? error;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool multiline;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    // Merged so screen readers announce the label with the field.
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Text(label, style: AppTextStyles.label),
          TextField(
            controller: controller,
            autofocus: autofocus,
            keyboardType: multiline ? TextInputType.multiline : keyboardType,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            minLines: 1,
            maxLines: multiline ? null : 1,
            style: AppTextStyles.body,
            decoration: InputDecoration(hintText: hint, errorText: error),
          ),
        ],
      ),
    );
  }
}
