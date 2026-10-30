import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/appointments/controllers/appointment_actions.dart';
import 'package:i_care/features/appointments/controllers/appointments_view.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/shared/l10n/date_texts.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/date_badge.dart';
import 'package:i_care/shared/widgets/edit_conflict_card.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// One appointment: when and where, questions to ask, and what the
/// doctor said, written by whoever went.
class AppointmentDetailScreen extends ConsumerWidget {
  const AppointmentDetailScreen({required this.appointmentId, super.key});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return switch (ref.watch(appointmentDetailProvider(appointmentId))) {
      AsyncData(value: final AppointmentDetail detail) => Scaffold(
        appBar: AppBar(
          actions: [
            if (!detail.appointment.isCancelled)
              _Menu(appointment: detail.appointment),
          ],
        ),
        body: _DetailContent(detail: detail),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: l10n.errorMessage(error),
          onRetry: () => ref.invalidate(careLogProvider),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(l10n.errorNotFound, style: AppTextStyles.body),
        ),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

enum _MenuAction { edit, cancel }

class _Menu extends ConsumerWidget {
  const _Menu({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return PopupMenuButton<_MenuAction>(
      tooltip: l10n.more,
      onSelected: (action) => switch (action) {
        _MenuAction.edit => context.push(
          AppRoutes.editAppointmentPath(appointment.id),
        ),
        _MenuAction.cancel => _cancel(context, ref),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MenuAction.edit,
          child: Text(l10n.editAppointment),
        ),
        PopupMenuItem(
          value: _MenuAction.cancel,
          child: Text(l10n.cancelAppointment),
        ),
      ],
    );
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.cancelAppointmentTitle(appointment.details.title),
      body: l10n.cancelAppointmentBody,
      cancelLabel: l10n.keepAppointment,
      confirmLabel: l10n.cancelAppointment,
    );
    if (!confirmed || !context.mounted) return;
    final result = await ref
        .read(appointmentActionsProvider.notifier)
        .cancel(appointment);
    if (result case Err(:final failure)) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message(l10n))));
      return;
    }
    if (context.mounted) context.pop();
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.detail});

  final AppointmentDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final appointment = detail.appointment;
    final details = appointment.details;
    final now = ref.watch(nowProvider);
    final questions = details.questionList;
    final canAddNotes =
        !appointment.isCancelled &&
        !appointment.startsAt.subtract(_notesOpenEarly).isAfter(now);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      children: [
        Row(
          spacing: AppSpacing.lg,
          children: [
            DateBadge(
              day: appointment.startsAt,
              muted: appointment.startsAt.isBefore(now),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(details.title, style: AppTextStyles.headline),
                  Text(
                    appointmentWhen(
                      l10n,
                      appointment.startsAt,
                      now: now,
                      locale: locale,
                    ),
                    style: AppTextStyles.body,
                  ),
                  if (appointment.isCancelled)
                    StatusPill(
                      icon: Icons.event_busy,
                      label: l10n.cancelled,
                      color: AppColors.inkMuted,
                      background: AppColors.surfaceMuted,
                    ),
                ],
              ),
            ),
          ],
        ),
        for (final conflict in detail.conflicts) ...[
          const SizedBox(height: AppSpacing.lg),
          _AppointmentConflict(conflict: conflict, appointment: appointment),
        ],
        if (details.doctor.isNotEmpty || details.location.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                if (details.doctor.isNotEmpty)
                  _InfoRow(icon: Icons.person_outline, text: details.doctor),
                if (details.location.isNotEmpty)
                  _InfoRow(
                    icon: Icons.place_outlined,
                    text: details.location,
                  ),
              ],
            ),
          ),
        ],
        if (questions.isNotEmpty)
          FormSection(
            title: l10n.sectionQuestions,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    for (final question in questions)
                      _InfoRow(icon: Icons.help_outline, text: question),
                  ],
                ),
              ),
            ],
          ),
        // Notes are what the doctor said, so they open once the visit can
        // have started.
        if (appointment.notes.isNotEmpty || canAddNotes)
          FormSection(
            title: l10n.visitNotes,
            children: [
              for (final note in appointment.notes) _NoteCard(note: note),
              if (canAddNotes) _AddNote(appointment: appointment),
            ],
          ),
      ],
    );
  }
}

/// How long before an appointment its notes can be written: people often
/// arrive early and start talking with the doctor.
const _notesOpenEarly = Duration(hours: 1);

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  static const _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Icon(icon, size: _iconSize, color: AppColors.inkMuted),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
  }
}

class _NoteCard extends ConsumerWidget {
  const _NoteCard({required this.note});

  final VisitNoteAdded note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final caregiver = ref.watch(caregiversByIdProvider)[note.meta.caregiverId];
    final at = note.meta.occurredAt;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          if (caregiver != null) CaregiverAvatar(caregiver: caregiver),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(note.text, style: AppTextStyles.body),
                Text(
                  l10n.changeBy(
                    caregiver?.name ?? l10n.unknownCaregiver,
                    '${Formatters.shortDate(at, locale)} '
                    '${Formatters.time(at, locale)}',
                  ),
                  style: AppTextStyles.bodyMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddNote extends ConsumerStatefulWidget {
  const _AddNote({required this.appointment});

  final Appointment appointment;

  @override
  ConsumerState<_AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends ConsumerState<_AddNote> {
  final _text = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        LabeledField(
          label: l10n.newNote,
          controller: _text,
          hint: l10n.addNoteHint,
          textCapitalization: TextCapitalization.sentences,
          multiline: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: _busy ? null : _save,
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            child: Text(l10n.addNote),
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final text = _text.text.trim();
    if (text.isEmpty) return;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(appointmentActionsProvider.notifier)
        .addNote(widget.appointment, text);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        _text.clear();
        FocusScope.of(context).unfocus();
      case Err(:final failure):
        messenger.showSnackBar(SnackBar(content: Text(failure.message(l10n))));
    }
  }
}

/// A concurrent edit of this appointment, to keep or undo.
class _AppointmentConflict extends ConsumerWidget {
  const _AppointmentConflict({
    required this.conflict,
    required this.appointment,
  });

  final EditConflict conflict;
  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return EditConflictCard(
      conflict: conflict,
      summarize: (change) => switch (change) {
        AppointmentUpdated(:final details) => [
          details.title,
          Formatters.shortDate(details.startsAt, locale),
          Formatters.time(details.startsAt, locale),
          if (details.doctor.isNotEmpty) details.doctor,
        ].join(' · '),
        AppointmentCancelled() => l10n.changeCancelled,
        _ => '',
      },
      onChoose: (change) => ref
          .read(appointmentActionsProvider.notifier)
          .resolve(conflict, appointment, chosen: change),
    );
  }
}
