import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';
import 'package:i_care/features/medications/controllers/schedule_draft.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/number_stepper.dart';
import 'package:i_care/shared/widgets/segmented_control.dart';
import 'package:i_care/shared/widgets/times_and_days.dart';

/// Edits a schedule: fixed times on chosen days, or as needed with
/// limits. Controlled: it shows [draft] and reports every change.
class ScheduleEditor extends StatelessWidget {
  const ScheduleEditor({
    required this.draft,
    required this.onChanged,
    this.showIssues = false,
    super.key,
  });

  final ScheduleDraft draft;
  final ValueChanged<ScheduleDraft> onChanged;

  /// Whether to show what is missing; off until the first save attempt.
  final bool showIssues;

  static const _maxIntervalHours = 48;
  static const _maxPerDayLimit = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final issues = showIssues ? draft.issues : const <MedicationIssue>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        SegmentedControl<bool>(
          options: {true: l10n.scheduleFixed, false: l10n.scheduleAsNeeded},
          selected: draft.isFixed,
          onChanged: (isFixed) => onChanged(draft.copyWith(isFixed: isFixed)),
        ),
        if (draft.isFixed) ...[
          TimesField(
            times: draft.times,
            onAdd: (minutes) => onChanged(draft.withTime(minutes)),
            onRemove: (minutes) => onChanged(draft.withoutTime(minutes)),
            error: issues.contains(MedicationIssue.noTimes)
                ? MedicationIssue.noTimes.message(l10n)
                : null,
          ),
          DaysField(
            everyDay: draft.everyDay,
            days: draft.days,
            onEveryDayChanged: (everyDay) => onChanged(
              everyDay ? draft.copyWith(everyDay: true) : draft.chooseDays(),
            ),
            onToggleDay: (day) => onChanged(draft.toggleDay(day)),
            error: issues.contains(MedicationIssue.noWeekdays)
                ? MedicationIssue.noWeekdays.message(l10n)
                : null,
          ),
          _HoursStepper(
            label: l10n.minIntervalOptional,
            hours: draft.fixedMinInterval?.inHours ?? 0,
            min: 0,
            max: _maxIntervalHours,
            onChanged: (hours) => onChanged(
              draft.copyWith(
                fixedMinInterval: hours == 0 ? null : Duration(hours: hours),
              ),
            ),
          ),
        ] else ...[
          _HoursStepper(
            label: l10n.minIntervalLabel,
            hours: draft.asNeededInterval.inHours,
            min: 1,
            max: _maxIntervalHours,
            onChanged: (hours) => onChanged(
              draft.copyWith(asNeededInterval: Duration(hours: hours)),
            ),
          ),
          NumberStepper(
            label: l10n.maxPerDayLabel,
            valueText: switch (draft.maxPerDay) {
              final int max => '$max',
              null => l10n.noLimit,
            },
            onDecrease: switch (draft.maxPerDay) {
              null => null,
              1 => () => onChanged(draft.copyWith(maxPerDay: null)),
              final int max => () => onChanged(
                draft.copyWith(maxPerDay: max - 1),
              ),
            },
            onIncrease: (draft.maxPerDay ?? 0) >= _maxPerDayLimit
                ? null
                : () => onChanged(
                    draft.copyWith(maxPerDay: (draft.maxPerDay ?? 0) + 1),
                  ),
          ),
        ],
      ],
    );
  }
}

class _HoursStepper extends StatelessWidget {
  const _HoursStepper({
    required this.label,
    required this.hours,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int hours;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NumberStepper(
      label: label,
      valueText: hours == 0 ? l10n.noLimit : l10n.hoursValue(hours),
      onDecrease: hours <= min ? null : () => onChanged(hours - 1),
      onIncrease: hours >= max ? null : () => onChanged(hours + 1),
    );
  }
}
