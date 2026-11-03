import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/handoff/controllers/handoff.dart';
import 'package:i_care/features/handoff/controllers/note_actions.dart';
import 'package:i_care/features/handoff/presentation/widgets/care_note_card.dart';
import 'package:i_care/features/handoff/presentation/widgets/handoff_text.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/error_view.dart';

/// Notes left for the circle ("te dejo dicho"), newest first, a field to
/// leave one, and the day's summary to copy into a chat.
class HandoffScreen extends ConsumerWidget {
  const HandoffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.handoffTitle),
        actions: [
          if (ref.watch(handoffProvider).value case final handoff?)
            IconButton(
              tooltip: l10n.copySummary,
              onPressed: () => _copySummary(context, ref, handoff),
              icon: const Icon(Icons.copy_all_outlined),
            ),
        ],
      ),
      body: switch (ref.watch(handoffProvider)) {
        AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _Notes(notes: value.notesThisWeek)),
            if (ref.watch(canDoProvider(CareAction.leaveNote)))
              const _NoteComposer(),
          ],
        ),
        AsyncError(:final error) => ErrorView(
          message: l10n.errorMessage(error),
          onRetry: () => ref.invalidate(careLogProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Future<void> _copySummary(
    BuildContext context,
    WidgetRef ref,
    Handoff handoff,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final text = handoffText(
      handoff,
      l10n,
      recipientName: ref.read(recipientNameProvider) ?? l10n.theRecipient,
      caregivers: ref.read(membersByIdProvider),
      locale: Localizations.localeOf(context).toLanguageTag(),
      customReasons: ref.read(customReasonsProvider),
    );
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showMessage(l10n.handoffCopied);
  }
}

class _Notes extends StatelessWidget {
  const _Notes({required this.notes});

  final List<CareNoteAdded> notes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = AppTextStyles.bodyMuted.copyWith(
      color: context.colors.inkMuted,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
      ),
      children: [
        Text(l10n.handoffSubtitle, style: muted),
        const SizedBox(height: AppSpacing.md),
        if (notes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Text(
              l10n.notesEmpty,
              style: muted,
              textAlign: TextAlign.center,
            ),
          ),
        for (final note in notes)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: CareNoteCard(note: note),
          ),
      ],
    );
  }
}

/// A field to write a note and a button to leave it.
class _NoteComposer extends ConsumerStatefulWidget {
  const _NoteComposer();

  @override
  ConsumerState<_NoteComposer> createState() => _NoteComposerState();
}

class _NoteComposerState extends ConsumerState<_NoteComposer> {
  final _text = TextEditingController();
  var _busy = false;

  static const _maxLines = 5;

  @override
  void initState() {
    super.initState();
    // The button is offered once there is something to leave.
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canLeave = !_busy && _text.text.trim().isNotEmpty;
    return Material(
      color: context.colors.surface,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: TextField(
                controller: _text,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: _maxLines,
                style: AppTextStyles.body,
                // Muted, so the field stands out from the white bar.
                decoration: InputDecoration(
                  hintText: l10n.noteFieldHint,
                  fillColor: context.colors.surfaceMuted,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: l10n.leaveNote,
              onPressed: canLeave ? _leave : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _leave() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(noteActionsProvider.notifier)
        .leave(_text.text);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        _text.clear();
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }
}
