import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/appointments/controllers/appointments_view.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/shared/l10n/date_texts.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/date_badge.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/screen_header.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// Upcoming and past medical appointments.
class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.newAppointmentPath()),
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
      ),
      body: SafeArea(
        bottom: false,
        child: switch (ref.watch(appointmentsViewProvider)) {
          AsyncData(:final value) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.lg,
              AppSpacing.screenHorizontal,
              AppSpacing.xxxl * 2,
            ),
            children: [
              ScreenHeader(
                title: l10n.navAppointments,
                subtitle: l10n.sampleData,
              ),
              if (value.upcoming.isEmpty && value.past.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxl),
                  child: Text(
                    l10n.appointmentsEmpty,
                    style: AppTextStyles.body,
                  ),
                ),
              if (value.upcoming.isNotEmpty)
                FormSection(
                  title: l10n.upcomingTitle,
                  children: [
                    for (final appointment in value.upcoming)
                      _AppointmentCard(
                        appointment: appointment,
                        needsReview: value.needReview.contains(appointment.id),
                      ),
                  ],
                ),
              if (value.past.isNotEmpty)
                FormSection(
                  title: l10n.pastTitle,
                  children: [
                    for (final appointment in value.past)
                      _AppointmentCard(
                        appointment: appointment,
                        isPast: true,
                        missingNotes: value.missingNotes.contains(
                          appointment.id,
                        ),
                        needsReview: value.needReview.contains(appointment.id),
                      ),
                  ],
                ),
            ],
          ),
          AsyncError(:final error) => ErrorView(
            message: l10n.errorMessage(error),
            onRetry: () => ref.invalidate(careLogProvider),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  const _AppointmentCard({
    required this.appointment,
    this.isPast = false,
    this.missingNotes = false,
    this.needsReview = false,
  });

  final Appointment appointment;
  final bool isPast;
  final bool missingNotes;
  final bool needsReview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final details = appointment.details;
    final questions = details.questionList.length;

    return AppCard(
      onTap: () => context.push(AppRoutes.appointmentPath(appointment.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          DateBadge(day: appointment.startsAt, muted: isPast),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(details.title, style: AppTextStyles.title),
                Text(
                  [
                    appointmentWhen(
                      l10n,
                      appointment.startsAt,
                      now: ref.watch(nowProvider),
                      locale: locale,
                    ),
                    if (details.doctor.isNotEmpty) details.doctor,
                  ].join(' · '),
                  style: AppTextStyles.body,
                ),
                if (details.location.isNotEmpty)
                  Text(
                    details.location,
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (needsReview)
                      StatusPill(
                        icon: Icons.error,
                        label: l10n.medicationConflictBadge,
                        color: context.colors.overdue,
                        background: context.colors.overdueSoft,
                      ),
                    if (missingNotes)
                      StatusPill(
                        icon: Icons.edit_note,
                        label: l10n.noNotesPrompt,
                        color: context.colors.due,
                        background: context.colors.dueSoft,
                      )
                    else if (appointment.notes.isNotEmpty)
                      StatusPill(
                        icon: Icons.notes,
                        label: l10n.notesCount(appointment.notes.length),
                        color: context.colors.inkMuted,
                        background: context.colors.surfaceMuted,
                      ),
                    if (!isPast && questions > 0)
                      StatusPill(
                        icon: Icons.help_outline,
                        label: l10n.questionsCount(questions),
                        color: context.colors.tealDark,
                        background: context.colors.tealSoft,
                      ),
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
