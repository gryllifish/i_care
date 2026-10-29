import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/medications/controllers/medication_actions.dart';
import 'package:i_care/features/medications/controllers/medication_detail.dart';
import 'package:i_care/features/medications/controllers/schedule_draft.dart';
import 'package:i_care/features/medications/presentation/widgets/schedule_editor.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/save_button.dart';
import 'package:i_care/shared/widgets/segmented_control.dart';
import 'package:i_care/shared/widgets/wheel_pickers.dart';

/// When a new schedule starts.
enum _Start { now, tomorrow, onDay }

/// Changes a medication's schedule from a chosen moment on. Earlier doses
/// keep the schedule they had (a new schedule version, not an edit).
class ScheduleChangeScreen extends ConsumerWidget {
  const ScheduleChangeScreen({required this.medicationId, super.key});

  final String medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Opened directly (a reload on the web), the log may still be loading.
    return switch (ref.watch(medicationDetailProvider(medicationId))) {
      AsyncData(value: final MedicationDetail detail) => _ScheduleChangeForm(
        medication: detail.medication,
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

class _ScheduleChangeForm extends ConsumerStatefulWidget {
  const _ScheduleChangeForm({required this.medication});

  final Medication medication;

  @override
  ConsumerState<_ScheduleChangeForm> createState() =>
      _ScheduleChangeFormState();
}

class _ScheduleChangeFormState extends ConsumerState<_ScheduleChangeForm> {
  late ScheduleDraft _draft;
  _Start _start = _Start.now;
  DateTime? _day;
  var _triedToSave = false;
  var _busy = false;

  static const _maxDaysAhead = 365;

  @override
  void initState() {
    super.initState();
    _draft = ScheduleDraft.from(widget.medication.schedule);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final medication = widget.medication;
    final day = _day;

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.details.name),
        actions: [
          SaveButton(onPressed: _busy ? null : () => _save(medication)),
        ],
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
            title: l10n.scheduleTitle,
            children: [
              ScheduleEditor(
                draft: _draft,
                showIssues: _triedToSave,
                onChanged: (draft) => setState(() => _draft = draft),
              ),
            ],
          ),
          FormSection(
            title: l10n.sectionFromWhen,
            children: [
              SegmentedControl<_Start>(
                options: {
                  _Start.now: l10n.fromNow,
                  _Start.tomorrow: l10n.fromTomorrow,
                  _Start.onDay: l10n.fromPickDate,
                },
                selected: _start,
                onChanged: (start) => start == _Start.onDay
                    ? _pickDay()
                    : setState(() => _start = start),
              ),
              if (_start == _Start.onDay && day != null)
                Text(
                  l10n.fromDate(Formatters.shortDate(day, locale)),
                  style: AppTextStyles.label,
                ),
              Row(
                spacing: AppSpacing.sm,
                children: [
                  const Icon(Icons.history, color: AppColors.inkMuted),
                  Expanded(
                    child: Text(
                      l10n.earlierDosesUnchanged,
                      style: AppTextStyles.bodyMuted,
                    ),
                  ),
                ],
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
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final picked = await showDateWheel(
      context,
      initial: _day ?? tomorrow,
      first: today,
      last: today.add(const Duration(days: _maxDaysAhead)),
    );
    if (picked == null) return;
    setState(() {
      _start = _Start.onDay;
      _day = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _save(Medication medication) async {
    setState(() => _triedToSave = true);
    if (_draft.issues.isNotEmpty) return;

    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final now = ref.read(clockProvider)();
    final effectiveFrom = switch ((_start, _day)) {
      (_Start.tomorrow, _) => DateTime(now.year, now.month, now.day + 1),
      (_Start.onDay, final DateTime day) when day.isAfter(now) => day,
      _ => now,
    };
    setState(() => _busy = true);
    final result = await ref
        .read(medicationActionsProvider.notifier)
        .changeSchedule(
          medication,
          _draft.toSchedule(),
          effectiveFrom: effectiveFrom,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        final name = medication.details.name;
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.medicationSaved(name))),
        );
        context.pop();
      case Err(:final failure):
        messenger.showSnackBar(SnackBar(content: Text(failure.message(l10n))));
    }
  }
}
