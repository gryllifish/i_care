import 'package:flutter/widgets.dart';

/// Shared animation durations so motion feels consistent across the app.
abstract final class AppDurations {
  /// Color and state changes on small controls.
  static const fast = Duration(milliseconds: 200);

  /// Element fade and scale transitions.
  static const medium = Duration(milliseconds: 300);

  /// Page transitions.
  static const page = Duration(milliseconds: 400);

  /// How long "Undo" stays offered after recording a dose.
  static const undoWindow = Duration(seconds: 8);

  /// How long the notice of a conflict that just arrived stays up; the
  /// conflict itself stays on Today until reviewed.
  static const conflictNotice = Duration(seconds: 12);
}

/// Shared easing curves.
abstract final class AppCurves {
  /// Fast start, long soft landing. Used for entrances and page transitions.
  static const emphasized = Cubic(0.2, 0.8, 0.2, 1);
}

/// Honors the OS "Reduce motion" setting.
extension ReducedMotion on BuildContext {
  /// Whether the user asked the OS to minimize animations.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// [duration], or zero when the user asked to reduce motion.
  Duration motion(Duration duration) => reduceMotion ? Duration.zero : duration;
}
