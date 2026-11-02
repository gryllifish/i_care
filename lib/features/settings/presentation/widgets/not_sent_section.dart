import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/l10n/event_text.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/form_section.dart';

/// Records the server refused, each with why, until dismissed. Absent
/// when there are none.
class NotSentSection extends ConsumerWidget {
  const NotSentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rejected = ref.watch(rejectedEventsProvider).value ?? const [];
    if (rejected.isEmpty) return const SizedBox.shrink();
    return FormSection(
      title: l10n.sectionNotSent,
      children: [
        Text(
          l10n.notSentNote,
          style: AppTextStyles.bodyMuted.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        for (final item in rejected) _RejectedCard(rejected: item),
      ],
    );
  }
}

class _RejectedCard extends ConsumerWidget {
  const _RejectedCard({required this.rejected});

  final RejectedEvent rejected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final event = rejected.event;
    final at = event.meta.occurredAt;
    final author = ref.watch(membersByIdProvider)[event.meta.caregiverId];
    final subject = ref.watch(careLogProvider).value?.subjectOf(event);

    return AppCard(
      raised: false,
      color: context.colors.overdueSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Text(
            eventSentence(
              l10n,
              event: event,
              author: author?.name ?? l10n.unknownCaregiver,
              subject: subject,
              locale: locale,
            ),
            style: AppTextStyles.body,
          ),
          Text(
            [
              Formatters.shortDate(at, locale),
              Formatters.time(at, locale),
              rejected.reason.text(l10n),
            ].join(' · '),
            style: AppTextStyles.bodyMuted.copyWith(
              color: context.colors.overdueDark,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _dismiss(context, ref),
              child: Text(l10n.dismiss),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _dismiss(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(rejectedActionsProvider.notifier)
        .dismiss(rejected);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
    }
  }
}
