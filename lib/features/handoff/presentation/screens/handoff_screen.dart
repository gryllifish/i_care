import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/handoff/controllers/handoff.dart';
import 'package:i_care/features/handoff/presentation/widgets/handoff_text.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

/// The handoff exactly as it will be pasted, and a button to copy it.
class HandoffScreen extends ConsumerWidget {
  const HandoffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.handoffTitle)),
      body: switch (ref.watch(handoffProvider)) {
        AsyncData(:final value) => _HandoffContent(
          textWith: (note) => handoffText(
            value,
            l10n,
            recipientName:
                ref.watch(recipientNameProvider) ?? l10n.theRecipient,
            caregivers: ref.watch(membersByIdProvider),
            locale: Localizations.localeOf(context).toLanguageTag(),
            customReasons: ref.watch(customReasonsProvider),
            note: note,
          ),
        ),
        AsyncError(:final error) => ErrorView(
          message: l10n.errorMessage(error),
          onRetry: () => ref.invalidate(careLogProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// A note to add, kept only until the text is copied or the screen is
/// left, and the text as it will be pasted.
class _HandoffContent extends StatefulWidget {
  const _HandoffContent({required this.textWith});

  /// The handoff text with the note written here.
  final String Function(String note) textWith;

  @override
  State<_HandoffContent> createState() => _HandoffContentState();
}

class _HandoffContentState extends State<_HandoffContent> {
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The preview follows the note as it is written.
    _note.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = widget.textWith(_note.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              0,
              AppSpacing.screenHorizontal,
              AppSpacing.lg,
            ),
            children: [
              Text(
                l10n.handoffSubtitle,
                style: AppTextStyles.bodyMuted.copyWith(
                  color: context.colors.inkMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledField(
                label: l10n.handoffNoteField,
                controller: _note,
                hint: l10n.handoffNoteHint,
                textCapitalization: TextCapitalization.sentences,
                multiline: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(child: SelectableText(text, style: AppTextStyles.body)),
            ],
          ),
        ),
        SafeArea(
          minimum: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: FilledButton.icon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await Clipboard.setData(ClipboardData(text: text));
              messenger.showMessage(l10n.handoffCopied);
            },
            icon: const Icon(Icons.copy),
            label: Text(l10n.copy),
          ),
        ),
      ],
    );
  }
}
