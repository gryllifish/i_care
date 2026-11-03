import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/appointments/controllers/appointment_actions.dart';
import 'package:i_care/features/appointments/controllers/appointments_view.dart';
import 'package:i_care/features/appointments/presentation/widgets/question_list_field.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/appointment_validation.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';
import 'package:i_care/shared/widgets/save_button.dart';
import 'package:i_care/shared/widgets/wheel_pickers.dart';

/// Adds an appointment, or edits [appointmentId].
class AppointmentFormScreen extends ConsumerWidget {
  const AppointmentFormScreen({this.appointmentId, super.key});

  final String? appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = appointmentId;
    if (id == null) return const _AppointmentForm(editing: null);
    // Opened directly (a reload on the web), the log may still be loading.
    return switch (ref.watch(appointmentDetailProvider(id))) {
      AsyncData(value: final AppointmentDetail detail) => _AppointmentForm(
        editing: detail.appointment,
      ),
      AsyncLoading() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(context.l10n.errorNotFound, style: AppTextStyles.body),
        ),
      ),
    };
  }
}

class _AppointmentForm extends ConsumerStatefulWidget {
  const _AppointmentForm({required this.editing});

  /// Null when adding a new appointment.
  final Appointment? editing;

  @override
  ConsumerState<_AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends ConsumerState<_AppointmentForm> {
  late final TextEditingController _title;
  late final TextEditingController _doctor;
  late final TextEditingController _location;
  late List<String> _questions;
  late DateTime _startsAt;
  Set<AppointmentIssue> _issues = const {};
  var _busy = false;

  /// New appointments default to tomorrow at this hour.
  static const _defaultHour = 10;
  static const int _maxDaysAhead = 2 * 365;
  static const _minuteStep = 5;

  @override
  void initState() {
    super.initState();
    final details = widget.editing?.details;
    final now = ref.read(clockProvider)();
    _title = TextEditingController(text: details?.title);
    _doctor = TextEditingController(text: details?.doctor);
    _location = TextEditingController(text: details?.location);
    _questions = details?.questionList ?? const [];
    _startsAt =
        details?.startsAt ??
        DateTime(now.year, now.month, now.day + 1, _defaultHour);
  }

  @override
  void dispose() {
    _title.dispose();
    _doctor.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editing == null ? l10n.newAppointment : l10n.editAppointment,
        ),
        actions: [SaveButton(onPressed: _busy ? null : _save)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          0,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          FormSection(
            title: l10n.sectionAppointment,
            children: [
              LabeledField(
                label: l10n.fieldTitle,
                controller: _title,
                hint: l10n.fieldTitleHint,
                textCapitalization: TextCapitalization.sentences,
                error: _issues.contains(AppointmentIssue.titleMissing)
                    ? l10n.issueTitleMissing
                    : null,
              ),
              // Day and time apart: a single date-and-time wheel does not
              // fit a phone with a 12-hour clock.
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    flex: 3,
                    child: _PickerField(
                      label: l10n.fieldDay,
                      icon: Icons.event,
                      text: Formatters.weekdayAndDate(_startsAt, locale),
                      onTap: _pickDay,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _PickerField(
                      label: l10n.fieldTime,
                      icon: Icons.schedule,
                      text: Formatters.time(_startsAt, locale),
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              LabeledField(
                label: l10n.fieldDoctor,
                controller: _doctor,
                textCapitalization: TextCapitalization.words,
              ),
              LabeledField(
                label: l10n.fieldLocation,
                controller: _location,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
          FormSection(
            title: l10n.sectionQuestions,
            children: [
              QuestionListField(
                initial: _questions,
                onChanged: (questions) => _questions = questions,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDay() async {
    final now = ref.read(clockProvider)();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(_startsAt.year, _startsAt.month, _startsAt.day);
    final picked = await showDateWheel(
      context,
      initial: day,
      // An appointment being edited may already be in the past.
      first: day.isBefore(today) ? day : today,
      last: today.add(const Duration(days: _maxDaysAhead)),
    );
    if (picked == null) return;
    setState(
      () => _startsAt = _startsAt.copyWith(
        year: picked.year,
        month: picked.month,
        day: picked.day,
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimeWheel(
      context,
      initial: TimeOfDay.fromDateTime(_startsAt),
      minuteInterval: _minuteStep,
    );
    if (picked == null) return;
    setState(
      () => _startsAt = _startsAt.copyWith(
        hour: picked.hour,
        minute: picked.minute,
      ),
    );
  }

  Future<void> _save() async {
    final details = AppointmentDetails(
      title: _title.text.trim(),
      startsAt: _startsAt,
      doctor: _doctor.text.trim(),
      location: _location.text.trim(),
      questions: AppointmentDetails.joinQuestions(_questions),
    );
    final issues = validateAppointment(details);
    setState(() => _issues = issues);
    if (issues.isNotEmpty) return;

    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(appointmentActionsProvider.notifier);
    final editing = widget.editing;
    setState(() => _busy = true);
    final result = editing == null
        ? await actions.create(details)
        : await actions.update(editing, details);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        messenger.showMessage(l10n.medicationSaved(details.title));
        context.pop();
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }
}

/// A field-shaped button showing a picked value, with its label above.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(label, style: AppTextStyles.label),
        Semantics(
          button: true,
          label: label,
          value: text,
          excludeSemantics: true,
          child: Material(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                // As tall as the text fields around it.
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Icon(icon, color: context.colors.teal),
                    Expanded(child: Text(text, style: AppTextStyles.body)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
