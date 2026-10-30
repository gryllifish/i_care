import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/shared/widgets/segmented_control.dart';
import 'package:i_care/shared/widgets/wheel_pickers.dart';

/// Times of day as removable pills, with a button to add one. Times are
/// minutes after midnight; [error] shows below when set.
class TimesField extends StatelessWidget {
  const TimesField({
    required this.times,
    required this.onAdd,
    required this.onRemove,
    this.error,
    super.key,
  });

  final List<int> times;
  final ValueChanged<int> onAdd;
  final ValueChanged<int> onRemove;
  final String? error;

  /// Times move in five-minute steps: nobody schedules 08:03.
  static const _minuteStep = 5;

  /// A new time defaults to four hours after the last one.
  static const _defaultGapHours = 4;
  static const _firstHour = 8;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final error = this.error;

    String format(int minutes) =>
        Formatters.time(DateTime(2024, 1, 1, 0, minutes), locale);

    Future<void> addTime() async {
      final picked = await showTimeWheel(
        context,
        minuteInterval: _minuteStep,
        initial: TimeOfDay(
          hour: times.isEmpty
              ? _firstHour
              : (times.last ~/ Duration.minutesPerHour + _defaultGapHours) %
                    Duration.hoursPerDay,
          minute: 0,
        ),
      );
      if (picked == null) return;
      onAdd(picked.hour * Duration.minutesPerHour + picked.minute);
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
                onRemove: () => onRemove(minutes),
              ),
            TextButton.icon(
              onPressed: addTime,
              icon: const Icon(Icons.add_circle),
              label: Text(l10n.addTime),
            ),
          ],
        ),
        if (error != null) _ErrorText(error),
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
        color: context.colors.surface,
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
              icon: Icon(
                Icons.close,
                size: _removeIconSize,
                color: context.colors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Every day, or chosen days (`DateTime.monday`..`DateTime.sunday`).
/// [error] shows below when set.
class DaysField extends StatelessWidget {
  const DaysField({
    required this.everyDay,
    required this.days,
    required this.onEveryDayChanged,
    required this.onToggleDay,
    this.error,
    super.key,
  });

  final bool everyDay;
  final Set<int> days;
  final ValueChanged<bool> onEveryDayChanged;
  final ValueChanged<int> onToggleDay;
  final String? error;

  static const double _dayButtonSize = kMinInteractiveDimension;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final error = this.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        SegmentedControl<bool>(
          options: {true: l10n.everyDay, false: l10n.pickDays},
          selected: everyDay,
          onChanged: onEveryDayChanged,
        ),
        if (!everyDay)
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var day = DateTime.monday; day <= DateTime.sunday; day++)
                _DayButton(
                  label: Formatters.weekday(day, locale),
                  size: _dayButtonSize,
                  selected: days.contains(day),
                  onTap: () => onToggleDay(day),
                ),
            ],
          ),
        if (error != null) _ErrorText(error),
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
        color: selected ? context.colors.teal : context.colors.surface,
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
                    color: selected
                        ? context.colors.onAccent
                        : context.colors.ink,
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

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.bodyMuted.copyWith(color: context.colors.overdue),
  );
}
