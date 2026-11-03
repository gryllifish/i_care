import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/shared/l10n/date_texts.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/member_avatar.dart';

/// A note left for the circle: who wrote it, when, and what it says.
class CareNoteCard extends ConsumerWidget {
  const CareNoteCard({required this.note, this.raised = true, super.key});

  final CareNoteAdded note;

  /// False inside another card.
  final bool raised;

  static const _avatarSize = 28.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final author = ref.watch(membersByIdProvider)[note.meta.caregiverId];
    final when = recentWhen(
      l10n,
      note.meta.occurredAt,
      now: ref.watch(nowProvider),
      locale: Localizations.localeOf(context).toLanguageTag(),
    );
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        if (author != null) MemberAvatar(member: author, size: _avatarSize),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxs,
            children: [
              Text(
                [author?.name ?? l10n.unknownCaregiver, when].join(' · '),
                style: AppTextStyles.bodyMuted.copyWith(
                  color: context.colors.inkMuted,
                ),
              ),
              Text(note.text, style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
    return raised ? AppCard(child: content) : content;
  }
}
