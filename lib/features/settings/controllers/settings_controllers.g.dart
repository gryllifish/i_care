// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The language chosen for this phone; null follows the system.

@ProviderFor(AppLanguage)
final appLanguageProvider = AppLanguageProvider._();

/// The language chosen for this phone; null follows the system.
final class AppLanguageProvider
    extends $NotifierProvider<AppLanguage, Locale?> {
  /// The language chosen for this phone; null follows the system.
  AppLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLanguageHash();

  @$internal
  @override
  AppLanguage create() => AppLanguage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLanguageHash() => r'1b3819e9cbfd98748898fcfd1190f7d9c8c0465c';

/// The language chosen for this phone; null follows the system.

abstract class _$AppLanguage extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Light, dark, or following the system (the default) on this phone.

@ProviderFor(AppThemeMode)
final appThemeModeProvider = AppThemeModeProvider._();

/// Light, dark, or following the system (the default) on this phone.
final class AppThemeModeProvider
    extends $NotifierProvider<AppThemeMode, ThemeMode> {
  /// Light, dark, or following the system (the default) on this phone.
  AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$appThemeModeHash() => r'2bd6e510efd0e458953fe5cd05021430f61060ff';

/// Light, dark, or following the system (the default) on this phone.

abstract class _$AppThemeMode extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether this phone already showed the welcome.

@ProviderFor(WelcomeSeen)
final welcomeSeenProvider = WelcomeSeenProvider._();

/// Whether this phone already showed the welcome.
final class WelcomeSeenProvider extends $NotifierProvider<WelcomeSeen, bool> {
  /// Whether this phone already showed the welcome.
  WelcomeSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeSeenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeSeenHash();

  @$internal
  @override
  WelcomeSeen create() => WelcomeSeen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$welcomeSeenHash() => r'8a846037af443249eb786ac3bdc60c240ea6496d';

/// Whether this phone already showed the welcome.

abstract class _$WelcomeSeen extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(demoReset)
final demoResetProvider = DemoResetProvider._();

final class DemoResetProvider
    extends $FunctionalProvider<DemoReset, DemoReset, DemoReset>
    with $Provider<DemoReset> {
  DemoResetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoResetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoResetHash();

  @$internal
  @override
  $ProviderElement<DemoReset> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DemoReset create(Ref ref) {
    return demoReset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DemoReset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoReset>(value),
    );
  }
}

String _$demoResetHash() => r'cea7277252f8d34940a8469fec82785e2082acab';

/// Clears everything on every simulated phone and on the server, leaving
/// no circle: the demo as a first install. `bootstrap` provides it.

@ProviderFor(demoStartEmpty)
final demoStartEmptyProvider = DemoStartEmptyProvider._();

/// Clears everything on every simulated phone and on the server, leaving
/// no circle: the demo as a first install. `bootstrap` provides it.

final class DemoStartEmptyProvider
    extends $FunctionalProvider<DemoReset, DemoReset, DemoReset>
    with $Provider<DemoReset> {
  /// Clears everything on every simulated phone and on the server, leaving
  /// no circle: the demo as a first install. `bootstrap` provides it.
  DemoStartEmptyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoStartEmptyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoStartEmptyHash();

  @$internal
  @override
  $ProviderElement<DemoReset> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DemoReset create(Ref ref) {
    return demoStartEmpty(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DemoReset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoReset>(value),
    );
  }
}

String _$demoStartEmptyHash() => r'edaadf9ac06440b16fa5b67345dd885858696159';

/// Whether this is the demo, with simulated phones and sample data, or a
/// real phone syncing with a backend, where demo actions are not offered.
/// `bootstrap` provides it.

@ProviderFor(isDemo)
final isDemoProvider = IsDemoProvider._();

/// Whether this is the demo, with simulated phones and sample data, or a
/// real phone syncing with a backend, where demo actions are not offered.
/// `bootstrap` provides it.

final class IsDemoProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this is the demo, with simulated phones and sample data, or a
  /// real phone syncing with a backend, where demo actions are not offered.
  /// `bootstrap` provides it.
  IsDemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isDemoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isDemoHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isDemo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isDemoHash() => r'06bd36445964042156baca663e3cef91ec4765ea';

/// How this demo shows its phones. `bootstrap` provides it.

@ProviderFor(demoLayout)
final demoLayoutProvider = DemoLayoutProvider._();

/// How this demo shows its phones. `bootstrap` provides it.

final class DemoLayoutProvider
    extends $FunctionalProvider<DemoLayout, DemoLayout, DemoLayout>
    with $Provider<DemoLayout> {
  /// How this demo shows its phones. `bootstrap` provides it.
  DemoLayoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoLayoutProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoLayoutHash();

  @$internal
  @override
  $ProviderElement<DemoLayout> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DemoLayout create(Ref ref) {
    return demoLayout(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DemoLayout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoLayout>(value),
    );
  }
}

String _$demoLayoutHash() => r'e7c2c07f473891c19d07f3de2e7f7bf3ccec218f';

/// Whether this phone offers resetting the demo: an admin's, or the one
/// phone of the one-phone demo, which has no admin to ask.

@ProviderFor(canResetDemo)
final canResetDemoProvider = CanResetDemoProvider._();

/// Whether this phone offers resetting the demo: an admin's, or the one
/// phone of the one-phone demo, which has no admin to ask.

final class CanResetDemoProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this phone offers resetting the demo: an admin's, or the one
  /// phone of the one-phone demo, which has no admin to ask.
  CanResetDemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canResetDemoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canResetDemoHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canResetDemo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canResetDemoHash() => r'8abb5e182f93117f13ea0322c01392bfcc849c0d';

/// This phone's notification permission, or null where there are no
/// push notifications (`docs/backend.md`). Lives with the app: on start
/// and when the language changes it keeps the phone's token on the
/// server, or has the server forget it once the permission is gone.

@ProviderFor(PushNotifications)
final pushNotificationsProvider = PushNotificationsProvider._();

/// This phone's notification permission, or null where there are no
/// push notifications (`docs/backend.md`). Lives with the app: on start
/// and when the language changes it keeps the phone's token on the
/// server, or has the server forget it once the permission is gone.
final class PushNotificationsProvider
    extends $AsyncNotifierProvider<PushNotifications, PushPermission?> {
  /// This phone's notification permission, or null where there are no
  /// push notifications (`docs/backend.md`). Lives with the app: on start
  /// and when the language changes it keeps the phone's token on the
  /// server, or has the server forget it once the permission is gone.
  PushNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationsHash();

  @$internal
  @override
  PushNotifications create() => PushNotifications();
}

String _$pushNotificationsHash() => r'f7d86b748db3f3829df426b7c61fbb61ccfcf283';

/// This phone's notification permission, or null where there are no
/// push notifications (`docs/backend.md`). Lives with the app: on start
/// and when the language changes it keeps the phone's token on the
/// server, or has the server forget it once the permission is gone.

abstract class _$PushNotifications extends $AsyncNotifier<PushPermission?> {
  FutureOr<PushPermission?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PushPermission?>, PushPermission?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PushPermission?>, PushPermission?>,
              AsyncValue<PushPermission?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
