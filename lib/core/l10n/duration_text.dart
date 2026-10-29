import 'package:i_care/core/l10n/l10n.dart';

extension DurationText on AppLocalizations {
  /// "25 min", "2 h" or "2 h 10 min", rounded down to whole minutes.
  String duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    return switch ((hours, minutes)) {
      (0, final minutes) => durationMinutes(minutes),
      (final hours, 0) => durationHours(hours),
      (final hours, final minutes) => durationHoursMinutes(hours, minutes),
    };
  }
}
