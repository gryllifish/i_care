import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/activity/controllers/activity_view.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/shared/l10n/event_text.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/member_avatar.dart';
import 'package:i_care/shared/widgets/screen_header.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// Who did what, newest first, grouped by day.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SafeArea(
      bottom: false,
      child: switch (ref.watch(activityViewProvider)) {
        AsyncData(:final value) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
                AppSpacing.screenHorizontal,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: ScreenHeader(
                  title: l10n.navActivity,
                  subtitle: l10n.sampleData,
                ),
              ),
            ),
            if (value.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(l10n.activityEmpty, style: AppTextStyles.body),
                ),
              ),
            for (final day in value)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.xl,
                  AppSpacing.screenHorizontal,
                  0,
                ),
                sliver: SliverList.list(
                  children: [
                    _DayTitle(day: day.day),
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (final (index, entry) in day.entries.indexed) ...[
                            if (index > 0)
                              const Divider(
                                height: 1,
                                indent: AppSpacing.xxxl + AppSpacing.xl,
                              ),
                            // One node per entry, read entry by entry.
                            MergeSemantics(child: _EntryRow(entry: entry)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
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
}

class _DayTitle extends ConsumerWidget {
  const _DayTitle({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = ref.watch(nowProvider);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return Semantics(
      container: true,
      header: true,
      child: Text(switch (day) {
        _ when day == today => l10n.today,
        _ when day == yesterday => l10n.yesterday,
        _ => Formatters.longDay(day, locale),
      }, style: AppTextStyles.title),
    );
  }
}

class _EntryRow extends ConsumerWidget {
  const _EntryRow({required this.entry});

  final ActivityEntry entry;

  static const _iconSize = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final event = entry.event;
    final caregiver = ref.watch(membersByIdProvider)[event.meta.caregiverId];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          if (caregiver != null)
            MemberAvatar(member: caregiver)
          else
            const SizedBox.square(dimension: AppSpacing.xxl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(
                  eventSentence(
                    l10n,
                    event: event,
                    author: caregiver?.name ?? l10n.unknownCaregiver,
                    subject: entry.subject,
                    locale: locale,
                  ),
                  style: AppTextStyles.body,
                ),
                Wrap(
                  spacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      Formatters.time(event.meta.occurredAt, locale),
                      style: AppTextStyles.bodyMuted.copyWith(
                        color: context.colors.inkMuted,
                      ),
                    ),
                    if (event.meta.fromFormerMember)
                      StatusPill(
                        icon: Icons.person_off_outlined,
                        label: l10n.afterAccessEnded,
                        color: context.colors.due,
                        background: context.colors.dueSoft,
                      ),
                    if (!event.meta.isSynced) ...[
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: _iconSize,
                        color: context.colors.inkMuted,
                      ),
                      Text(
                        l10n.notSyncedYet,
                        style: AppTextStyles.bodyMuted.copyWith(
                          color: context.colors.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
