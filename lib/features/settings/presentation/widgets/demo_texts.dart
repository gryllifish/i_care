import 'package:i_care/core/config/demo_layout.dart';
import 'package:i_care/core/l10n/l10n.dart';

/// What starting the demo empty clears, for the phones [layout] has.
String startEmptyBody(AppLocalizations l10n, DemoLayout layout) =>
    switch (layout) {
      DemoLayout.twoPhones => l10n.startEmptyBody,
      DemoLayout.onePhone => l10n.startEmptyBodyOnePhone,
    };
