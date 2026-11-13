// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether this build offers protecting access with a Google account
/// (`docs/roles.md`, recoverable access): the beta on Android.

@ProviderFor(accessOffered)
final accessOfferedProvider = AccessOfferedProvider._();

/// Whether this build offers protecting access with a Google account
/// (`docs/roles.md`, recoverable access): the beta on Android.

final class AccessOfferedProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this build offers protecting access with a Google account
  /// (`docs/roles.md`, recoverable access): the beta on Android.
  AccessOfferedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessOfferedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessOfferedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return accessOffered(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$accessOfferedHash() => r'8f4c74dd5eae8682eb1808a3c840c0a028eb5973';

/// The email of the Google account protecting this phone's access; null
/// when none does, or where it is not offered.

@ProviderFor(ProtectedAccess)
final protectedAccessProvider = ProtectedAccessProvider._();

/// The email of the Google account protecting this phone's access; null
/// when none does, or where it is not offered.
final class ProtectedAccessProvider
    extends $AsyncNotifierProvider<ProtectedAccess, String?> {
  /// The email of the Google account protecting this phone's access; null
  /// when none does, or where it is not offered.
  ProtectedAccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'protectedAccessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$protectedAccessHash();

  @$internal
  @override
  ProtectedAccess create() => ProtectedAccess();
}

String _$protectedAccessHash() => r'c8cdc349ac329943bde4ec31fd62049c126eadf8';

/// The email of the Google account protecting this phone's access; null
/// when none does, or where it is not offered.

abstract class _$ProtectedAccess extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the circle depends on one admin: if they lose their phone,
/// nobody else can issue codes (`docs/roles.md`). Admins only invited do
/// not count, since they have no phone yet.

@ProviderFor(hasSingleAdmin)
final hasSingleAdminProvider = HasSingleAdminProvider._();

/// Whether the circle depends on one admin: if they lose their phone,
/// nobody else can issue codes (`docs/roles.md`). Admins only invited do
/// not count, since they have no phone yet.

final class HasSingleAdminProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the circle depends on one admin: if they lose their phone,
  /// nobody else can issue codes (`docs/roles.md`). Admins only invited do
  /// not count, since they have no phone yet.
  HasSingleAdminProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasSingleAdminProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasSingleAdminHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasSingleAdmin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasSingleAdminHash() => r'df55d7a519786537134ed76574e443cf8fe32bfb';
