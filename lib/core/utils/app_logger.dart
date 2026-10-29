import 'dart:developer' as developer;

/// App-wide logger. Use it instead of `print`.
///
/// Thin wrapper over `dart:developer` so logs show up in DevTools with
/// levels, without adding a dependency.
abstract final class AppLogger {
  static const _name = 'app';

  // Levels follow package:logging so DevTools colors them correctly.
  static const _debugLevel = 500;
  static const _infoLevel = 800;
  static const _warningLevel = 900;
  static const _errorLevel = 1000;

  /// Logs development details.
  static void debug(String message) =>
      developer.log(message, name: _name, level: _debugLevel);

  /// Logs notable app events.
  static void info(String message) =>
      developer.log(message, name: _name, level: _infoLevel);

  /// Logs expected problems the app recovered from.
  static void warning(String message, [Object? error, StackTrace? stack]) =>
      developer.log(
        message,
        name: _name,
        level: _warningLevel,
        error: error,
        stackTrace: stack,
      );

  /// Logs unexpected errors.
  static void error(String message, [Object? error, StackTrace? stack]) =>
      developer.log(
        message,
        name: _name,
        level: _errorLevel,
        error: error,
        stackTrace: stack,
      );
}
