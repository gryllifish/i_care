import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/handoff/controllers/handoff.dart';
import 'package:i_care/features/handoff/presentation/widgets/handoff_text.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/error_view.dart';

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
          text: handoffText(
            value,
            l10n,
            recipientName: SampleCircle.recipientName,
            caregivers: ref.watch(caregiversByIdProvider),
            locale: Localizations.localeOf(context).toLanguageTag(),
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

class _HandoffContent extends StatelessWidget {
  const _HandoffContent({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              Text(l10n.handoffSubtitle, style: AppTextStyles.bodyMuted),
              const SizedBox(height: AppSpacing.md),
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
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.handoffCopied)),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(l10n.copy),
          ),
        ),
      ],
    );
  }
}
