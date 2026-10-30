import 'package:flutter/material.dart';
import 'package:i_care/core/constants/app_durations.dart';

/// Messages at the bottom of the screen. Every one can be closed;
/// confirmations also go away on their own, errors stay until closed.
extension AppSnackBars on ScaffoldMessengerState {
  /// A confirmation, with an optional action such as "Undo".
  void showMessage(String message, {SnackBarAction? action}) => showSnackBar(
    SnackBar(
      content: Text(message),
      duration: AppDurations.message,
      // Flutter keeps a snack bar with an action up until it is dismissed.
      persist: false,
      showCloseIcon: true,
      action: action,
    ),
  );

  /// A failure the user should not miss: it stays until closed.
  void showError(String message) => showSnackBar(
    SnackBar(content: Text(message), persist: true, showCloseIcon: true),
  );
}
