import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// Why a dose was not given or a task not done: one button per reason the
/// circle offers, by id. "Other" asks what happened before it is picked.
/// Disabled while [onPicked] is null.
class SkipReasonPicker extends ConsumerStatefulWidget {
  const SkipReasonPicker({
    required this.title,
    required this.reasonIds,
    required this.onPicked,
    super.key,
  });

  final String title;
  final List<String> reasonIds;

  /// The reason's id, and what the caregiver wrote for "Other".
  final void Function(String reasonId, String? note)? onPicked;

  @override
  ConsumerState<SkipReasonPicker> createState() => _SkipReasonPickerState();
}

class _SkipReasonPickerState extends ConsumerState<SkipReasonPicker> {
  final _note = TextEditingController();
  var _writing = false;

  static const _buttonHeight = 48.0;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onPicked = widget.onPicked;
    final customReasons = ref.watch(customReasonsProvider);

    if (_writing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          LabeledField(
            label: l10n.skipOtherField,
            controller: _note,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            multiline: true,
          ),
          FilledButton(
            onPressed: onPicked == null
                ? null
                : () => onPicked(SkipReason.other.id, _note.text.trim()),
            child: Text(l10n.skipOtherSave),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(widget.title, style: AppTextStyles.label),
        for (final reasonId in widget.reasonIds)
          OutlinedButton(
            onPressed: onPicked == null
                ? null
                : () => reasonId == SkipReason.other.id
                      ? setState(() => _writing = true)
                      : onPicked(reasonId, null),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(_buttonHeight),
            ),
            child: Text(
              reasonLabel(l10n, reasonId, customReasons: customReasons),
            ),
          ),
        if (ref.watch(canDoProvider(CareAction.manageReasons)))
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => context.push(AppRoutes.reasons),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.editReasons),
            ),
          ),
      ],
    );
  }
}
