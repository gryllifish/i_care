import 'dart:ui';

import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controllers.g.dart';

/// The language chosen for this phone; null follows the system.
@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {
  @override
  Locale? build() => switch (ref
      .watch(devicePrefsProvider)
      .read(
        PrefKeys.language,
      )) {
    final String code => Locale(code),
    null => null,
  };

  Future<void> choose(Locale? locale) async {
    state = locale;
    await ref
        .read(devicePrefsProvider)
        .write(PrefKeys.language, locale?.languageCode);
  }
}

/// Whether this phone already showed the welcome.
@Riverpod(keepAlive: true)
class WelcomeSeen extends _$WelcomeSeen {
  @override
  bool build() =>
      ref.watch(devicePrefsProvider).read(PrefKeys.welcomeSeen) == 'true';

  Future<void> markSeen() async {
    state = true;
    await ref.read(devicePrefsProvider).write(PrefKeys.welcomeSeen, 'true');
  }
}

/// Clears everything recorded on every simulated phone and on the server,
/// then loads the sample data again. `bootstrap` provides it, since only
/// it knows every phone.
typedef DemoReset = Future<void> Function();

@Riverpod(keepAlive: true)
DemoReset demoReset(Ref ref) =>
    () => throw UnimplementedError('Override demoResetProvider at startup');
