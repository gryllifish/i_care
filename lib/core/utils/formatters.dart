import 'package:intl/intl.dart';

/// Locale-aware display formatting. Pure functions, so widgets may use
/// them directly.
abstract final class Formatters {
  /// "08:05".
  static String time(DateTime time, String locale) =>
      DateFormat.Hm(locale).format(time);

  /// "Monday, November 2" / "lunes, 2 de noviembre".
  static String longDay(DateTime day, String locale) =>
      DateFormat.MMMMEEEEd(locale).format(day);
}
