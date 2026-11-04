import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:i_care/core/config/demo_layout.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controllers.g.dart';

/// The language chosen for this phone; null follows the system.
@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {
  @override
  Locale? build() =>
      switch (ref.watch(devicePrefsProvider).read(PrefKeys.language)) {
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

/// Light, dark, or following the system (the default) on this phone.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() =>
      switch (ref.watch(devicePrefsProvider).read(PrefKeys.themeMode)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> choose(ThemeMode mode) async {
    state = mode;
    await ref
        .read(devicePrefsProvider)
        .write(PrefKeys.themeMode, mode == ThemeMode.system ? null : mode.name);
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

/// Clears everything on every simulated phone and on the server, leaving
/// no circle: the demo as a first install. `bootstrap` provides it.
@Riverpod(keepAlive: true)
DemoReset demoStartEmpty(Ref ref) =>
    () =>
        throw UnimplementedError('Override demoStartEmptyProvider at startup');

/// Whether this is the demo, with simulated phones and sample data, or a
/// real phone syncing with a backend, where demo actions are not offered.
/// `bootstrap` provides it.
@Riverpod(keepAlive: true)
bool isDemo(Ref ref) => true;

/// How this demo shows its phones. `bootstrap` provides it.
@Riverpod(keepAlive: true)
DemoLayout demoLayout(Ref ref) => DemoLayout.twoPhones;

/// Whether this phone offers resetting the demo: an admin's, or the one
/// phone of the one-phone demo, which has no admin to ask.
@riverpod
bool canResetDemo(Ref ref) =>
    ref.watch(isDemoProvider) &&
    (ref.watch(demoLayoutProvider) == DemoLayout.onePhone ||
        ref.watch(canDoProvider(CareAction.resetDemo)));

/// Whether this phone is told about the circle's news. Off until the
/// person turns it on, which asks the system for permission.
@Riverpod(keepAlive: true)
class PushNotifications extends _$PushNotifications {
  @override
  bool build() =>
      ref.watch(devicePrefsProvider).read(PrefKeys.notifications) == 'true';

  /// Turns notifications on or off; stays as it was when that fails.
  Future<Result<void>> set({required bool enabled}) async {
    final repository = ref.read(pushRepositoryProvider);
    if (repository == null) return const Ok(null);
    final result = enabled
        ? await repository.enable(language: _pushLanguage(ref))
        : await repository.disable();
    if (result case Ok()) {
      state = enabled;
      await ref
          .read(devicePrefsProvider)
          .write(PrefKeys.notifications, enabled ? 'true' : null);
    }
    return result;
  }
}

/// Lives with the app: sends this phone's push token again on start and
/// when the language changes, since either may have changed.
@Riverpod(keepAlive: true)
Future<void> pushSync(Ref ref) async {
  final repository = ref.watch(pushRepositoryProvider);
  if (repository == null || !ref.watch(pushNotificationsProvider)) return;
  ref.watch(appLanguageProvider);
  if (await repository.refresh(language: _pushLanguage(ref)) case Err(
    :final failure,
  )) {
    // Tried again on the next start.
    AppLogger.warning('Push token not refreshed', failure);
  }
}

/// The language push messages use: the app's, `en` or `es`.
String _pushLanguage(Ref ref) => switch ((ref.read(appLanguageProvider) ??
        PlatformDispatcher.instance.locale)
    .languageCode) {
  'es' => 'es',
  _ => 'en',
};
