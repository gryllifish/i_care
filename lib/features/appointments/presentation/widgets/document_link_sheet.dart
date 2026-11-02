import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/appointments/controllers/appointment_actions.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/appointment_validation.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// Asks for a link to keep with [appointment]: what it is and where.
Future<void> showDocumentLinkSheet(
  BuildContext context, {
  required Appointment appointment,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => DocumentLinkSheet(appointment: appointment),
);

class DocumentLinkSheet extends ConsumerStatefulWidget {
  const DocumentLinkSheet({required this.appointment, super.key});

  final Appointment appointment;

  @override
  ConsumerState<DocumentLinkSheet> createState() => _DocumentLinkSheetState();
}

class _DocumentLinkSheetState extends ConsumerState<DocumentLinkSheet> {
  final _title = TextEditingController();
  final _url = TextEditingController();
  Set<DocumentIssue> _issues = const {};
  var _busy = false;

  @override
  void dispose() {
    _title.dispose();
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        // Above the keyboard while typing.
        AppSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: [
          Text(l10n.newLinkTitle, style: AppTextStyles.headline),
          LabeledField(
            label: l10n.fieldDocumentTitle,
            controller: _title,
            hint: l10n.fieldDocumentTitleHint,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            error: _issues.contains(DocumentIssue.titleMissing)
                ? l10n.issueDocumentTitle
                : null,
          ),
          LabeledField(
            label: l10n.fieldDocumentUrl,
            controller: _url,
            hint: l10n.fieldDocumentUrlHint,
            keyboardType: TextInputType.url,
            error: _issues.contains(DocumentIssue.urlInvalid)
                ? l10n.issueDocumentUrl
                : null,
          ),
          Text(
            l10n.linkOnlyNote,
            style: AppTextStyles.bodyMuted.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(l10n.addLink),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final title = _title.text.trim();
    final issues = validateDocument(title: title, url: _url.text);
    setState(() => _issues = issues);
    final url = parseDocumentUrl(_url.text);
    if (issues.isNotEmpty || url == null) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(appointmentActionsProvider.notifier)
        .linkDocument(widget.appointment, title: title, url: url);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        Navigator.of(context).pop();
        messenger.showMessage(l10n.linkAdded);
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }
}
