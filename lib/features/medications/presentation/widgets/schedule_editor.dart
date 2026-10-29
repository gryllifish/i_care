import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';
import 'package:i_care/features/medications/controllers/schedule_draft.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/number_stepper.dart';
import 'package:i_care/shared/widgets/segmented_control.dart';
import 'package:i_care/shared/widgets/wheel_pickers.dart';

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
          _Times(
            draft: draft,
            onChanged: onChanged,
            issue: issues.contains(MedicationIssue.noTimes)
                ? MedicationIssue.noTimes
                : null,
          ),
          _Days(
            draft: draft,
            onChanged: onChanged,
            issue: issues.contains(MedicationIssue.noWeekdays)
                ? MedicationIssue.noWeekdays
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

class _Times extends StatelessWidget {
  const _Times({
    required this.draft,
    required this.onChanged,
    required this.issue,
  });

  final ScheduleDraft draft;
  final ValueChanged<ScheduleDraft> onChanged;
  final MedicationIssue? issue;

  /// Dose times move in five-minute steps: nobody schedules 08:03.
  static const _minuteStep = 5;

  /// A new time defaults to four hours after the last one.
  static const _defaultGapHours = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final times = draft.times;
    final issue = this.issue;

    String format(int minutes) =>
        Formatters.time(DateTime(2024, 1, 1, 0, minutes), locale);

    Future<void> addTime() async {
      final picked = await showTimeWheel(
        context,
        minuteInterval: _minuteStep,
        initial: TimeOfDay(
          hour: times.isEmpty
              ? 8
              : (times.last ~/ Duration.minutesPerHour + _defaultGapHours) %
                    Duration.hoursPerDay,
          minute: 0,
        ),
      );
      if (picked == null) return;
      onChanged(
        draft.withTime(picked.hour * Duration.minutesPerHour + picked.minute),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final minutes in times)
              _TimePill(
                label: format(minutes),
                removeTooltip: l10n.removeTime(format(minutes)),
                onRemove: () => onChanged(draft.withoutTime(minutes)),
              ),
            TextButton.icon(
              onPressed: addTime,
              icon: const Icon(Icons.add_circle),
              label: Text(l10n.addTime),
            ),
          ],
        ),
        if (issue != null) _IssueText(issue: issue),
      ],
    );
  }
}

/// A scheduled time as a white pill with a remove button.
class _TimePill extends StatelessWidget {
  const _TimePill({
    required this.label,
    required this.removeTooltip,
    required this.onRemove,
  });

  final String label;
  final String removeTooltip;
  final VoidCallback onRemove;

  static const _removeIconSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pillBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.title),
            IconButton(
              onPressed: onRemove,
              tooltip: removeTooltip,
              icon: const Icon(
                Icons.close,
                size: _removeIconSize,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Every day, or chosen days. Choosing days starts from none, so "twice a
/// week" is two taps.
class _Days extends StatelessWidget {
  const _Days({
    required this.draft,
    required this.onChanged,
    required this.issue,
  });

  final ScheduleDraft draft;
  final ValueChanged<ScheduleDraft> onChanged;
  final MedicationIssue? issue;

  static const _dayButtonSize = 44.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final issue = this.issue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        SegmentedControl<bool>(
          options: {true: l10n.everyDay, false: l10n.pickDays},
          selected: draft.everyDay,
          onChanged: (everyDay) => onChanged(
            everyDay ? draft.copyWith(everyDay: true) : draft.chooseDays(),
          ),
        ),
        if (!draft.everyDay)
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var day = DateTime.monday; day <= DateTime.sunday; day++)
                _DayButton(
                  label: Formatters.weekday(day, locale),
                  size: _dayButtonSize,
                  selected: draft.days.contains(day),
                  onTap: () => onChanged(draft.toggleDay(day)),
                ),
            ],
          ),
        if (issue != null) _IssueText(issue: issue),
      ],
    );
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({
    required this.label,
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.teal : AppColors.surface,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: size, minHeight: size),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: selected ? AppColors.onAccent : AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IssueText extends StatelessWidget {
  const _IssueText({required this.issue});

  final MedicationIssue issue;

  @override
  Widget build(BuildContext context) => Text(
    issue.message(context.l10n),
    style: AppTextStyles.bodyMuted.copyWith(color: AppColors.overdue),
  );
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
