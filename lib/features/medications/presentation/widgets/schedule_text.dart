import 'package:i_care/core/l10n/duration_text.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';

extension DoseScheduleText on DoseSchedule {
  /// "08:00 · 20:00 · Every day", "09:00 · Mon, Thu", or "As needed · at
  /// least 6 h apart · up to 4 a day".
  String describe(AppLocalizations l10n, String locale) => switch (this) {
    FixedSchedule(:final minutesOfDay, :final weekdays, :final minInterval) => [
      for (final minutes in minutesOfDay)
        Formatters.time(DateTime(2024, 1, 1, 0, minutes), locale),
      if (weekdays.isEmpty)
        l10n.everyDay
      else
        [
          for (final weekday in weekdays.toList()..sort())
            Formatters.weekday(weekday, locale),
        ].join(', '),
      if (minInterval != null) l10n.minIntervalText(l10n.duration(minInterval)),
    ].join(' · '),
    AsNeededSchedule(:final minInterval, :final maxPerDay) => [
      l10n.asNeeded,
      l10n.minIntervalText(l10n.duration(minInterval)),
      if (maxPerDay != null) l10n.maxPerDayText(maxPerDay),
    ].join(' · '),
  };
}
