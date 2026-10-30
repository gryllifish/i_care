// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The care circle's state on this device, re-projected on every change.

@ProviderFor(careLog)
final careLogProvider = CareLogProvider._();

/// The care circle's state on this device, re-projected on every change.

final class CareLogProvider
    extends $FunctionalProvider<AsyncValue<CareLog>, CareLog, Stream<CareLog>>
    with $FutureModifier<CareLog>, $StreamProvider<CareLog> {
  /// The care circle's state on this device, re-projected on every change.
  CareLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'careLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$careLogHash();

  @$internal
  @override
  $StreamProviderElement<CareLog> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<CareLog> create(Ref ref) {
    return careLog(ref);
  }
}

String _$careLogHash() => r'9f5b368af1386b802a454979e5b1073c417c0fd0';

@ProviderFor(syncStatus)
final syncStatusProvider = SyncStatusProvider._();

final class SyncStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<SyncStatus>,
          SyncStatus,
          Stream<SyncStatus>
        >
    with $FutureModifier<SyncStatus>, $StreamProvider<SyncStatus> {
  SyncStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStatusHash();

  @$internal
  @override
  $StreamProviderElement<SyncStatus> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<SyncStatus> create(Ref ref) {
    return syncStatus(ref);
  }
}

String _$syncStatusHash() => r'da164c6383bc14969471008f4d39968f5f4e1231';

/// Members of the circle. Fixed sample members until stage 2 adds
/// accounts and invitations.

@ProviderFor(caregivers)
final caregiversProvider = CaregiversProvider._();

/// Members of the circle. Fixed sample members until stage 2 adds
/// accounts and invitations.

final class CaregiversProvider
    extends
        $FunctionalProvider<List<Caregiver>, List<Caregiver>, List<Caregiver>>
    with $Provider<List<Caregiver>> {
  /// Members of the circle. Fixed sample members until stage 2 adds
  /// accounts and invitations.
  CaregiversProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caregiversProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caregiversHash();

  @$internal
  @override
  $ProviderElement<List<Caregiver>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Caregiver> create(Ref ref) {
    return caregivers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Caregiver> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Caregiver>>(value),
    );
  }
}

String _$caregiversHash() => r'954c8b3e511ee5bddf07fb9fb610aabd95caa2ef';

/// Members by id, to name who recorded what.

@ProviderFor(caregiversById)
final caregiversByIdProvider = CaregiversByIdProvider._();

/// Members by id, to name who recorded what.

final class CaregiversByIdProvider
    extends
        $FunctionalProvider<
          Map<String, Caregiver>,
          Map<String, Caregiver>,
          Map<String, Caregiver>
        >
    with $Provider<Map<String, Caregiver>> {
  /// Members by id, to name who recorded what.
  CaregiversByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caregiversByIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caregiversByIdHash();

  @$internal
  @override
  $ProviderElement<Map<String, Caregiver>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, Caregiver> create(Ref ref) {
    return caregiversById(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Caregiver> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Caregiver>>(value),
    );
  }
}

String _$caregiversByIdHash() => r'af23b52c2de0fdffc2ac099de24164657178d328';

/// Who uses this device at first. Each simulated phone overrides it.

@ProviderFor(deviceOwnerId)
final deviceOwnerIdProvider = DeviceOwnerIdProvider._();

/// Who uses this device at first. Each simulated phone overrides it.

final class DeviceOwnerIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Who uses this device at first. Each simulated phone overrides it.
  DeviceOwnerIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceOwnerIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceOwnerIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return deviceOwnerId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$deviceOwnerIdHash() => r'e5798ca577b965c557ae931d7f862e9cc9cd52c9';

/// Who is recording on this device; "Who are you?" switches it, and the
/// choice is remembered on this device.

@ProviderFor(CurrentCaregiver)
final currentCaregiverProvider = CurrentCaregiverProvider._();

/// Who is recording on this device; "Who are you?" switches it, and the
/// choice is remembered on this device.
final class CurrentCaregiverProvider
    extends $NotifierProvider<CurrentCaregiver, Caregiver> {
  /// Who is recording on this device; "Who are you?" switches it, and the
  /// choice is remembered on this device.
  CurrentCaregiverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCaregiverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCaregiverHash();

  @$internal
  @override
  CurrentCaregiver create() => CurrentCaregiver();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Caregiver value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Caregiver>(value),
    );
  }
}

String _$currentCaregiverHash() => r'36e1a2de43989acb85cf71ada2426503bc77f777';

/// Who is recording on this device; "Who are you?" switches it, and the
/// choice is remembered on this device.

abstract class _$CurrentCaregiver extends $Notifier<Caregiver> {
  Caregiver build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Caregiver, Caregiver>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Caregiver, Caregiver>,
              Caregiver,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Whether this simulated phone has network. Demo control only.

@ProviderFor(NetworkEnabled)
final networkEnabledProvider = NetworkEnabledProvider._();

/// Whether this simulated phone has network. Demo control only.
final class NetworkEnabledProvider
    extends $NotifierProvider<NetworkEnabled, bool> {
  /// Whether this simulated phone has network. Demo control only.
  NetworkEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkEnabledHash();

  @$internal
  @override
  NetworkEnabled create() => NetworkEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$networkEnabledHash() => r'09d4d2b268023025eb17b2debddd81434cfca39e';

/// Whether this simulated phone has network. Demo control only.

abstract class _$NetworkEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
