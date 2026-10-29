import 'package:flutter/widgets.dart';
import 'package:i_care/core/l10n/generated/app_localizations.dart';

export 'package:i_care/core/l10n/generated/app_localizations.dart';

extension BuildContextL10n on BuildContext {
  /// Shorthand for `AppLocalizations.of(context)`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
