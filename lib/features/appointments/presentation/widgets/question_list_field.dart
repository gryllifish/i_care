import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// Questions for the doctor, one field each: "Add question" or the
/// keyboard's next key adds one below, and each can be removed.
class QuestionListField extends StatefulWidget {
  const QuestionListField({
    required this.initial,
    required this.onChanged,
    super.key,
  });

  final List<String> initial;

  /// Every field's text, in order, after each change.
  final ValueChanged<List<String>> onChanged;

  @override
  State<QuestionListField> createState() => _QuestionListFieldState();
}

class _QuestionListFieldState extends State<QuestionListField> {
  final _rows = <_QuestionRow>[];

  @override
  void initState() {
    super.initState();
    // One empty field to start writing in.
    for (final question in widget.initial.isEmpty ? [''] : widget.initial) {
      _rows.add(_QuestionRow(question));
    }
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _notify() =>
      widget.onChanged([for (final row in _rows) row.controller.text]);

  void _addAfter(int index) {
    final row = _QuestionRow('');
    setState(() => _rows.insert(index + 1, row));
    row.focus.requestFocus();
  }

  void _remove(int index) {
    final row = _rows[index];
    setState(() => _rows.removeAt(index));
    // Disposed after this frame, once its field is gone.
    WidgetsBinding.instance.addPostFrameCallback((_) => row.dispose());
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        for (final (index, row) in _rows.indexed)
          Row(
            key: ObjectKey(row),
            spacing: AppSpacing.xs,
            children: [
              Expanded(
                child: TextField(
                  controller: row.controller,
                  focusNode: row.focus,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: l10n.fieldQuestionsHint,
                  ),
                  onChanged: (_) => _notify(),
                  // The new field takes the focus, not the next widget.
                  onEditingComplete: () {},
                  onSubmitted: (_) => _addAfter(index),
                ),
              ),
              IconButton(
                tooltip: l10n.removeQuestion,
                onPressed: () => _remove(index),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => _addAfter(_rows.length - 1),
            icon: const Icon(Icons.add_circle),
            label: Text(l10n.addQuestion),
          ),
        ),
      ],
    );
  }
}

/// A question's field and its focus, kept together so removing one row
/// never hands its text or focus to the next.
class _QuestionRow {
  _QuestionRow(String text) : controller = TextEditingController(text: text);

  final TextEditingController controller;
  final focus = FocusNode();

  void dispose() {
    controller.dispose();
    focus.dispose();
  }
}
