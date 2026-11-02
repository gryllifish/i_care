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

/// Events recorded here that the server refused (`docs/roles.md`).

@ProviderFor(rejectedEvents)
final rejectedEventsProvider = RejectedEventsProvider._();

/// Events recorded here that the server refused (`docs/roles.md`).

final class RejectedEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RejectedEvent>>,
          List<RejectedEvent>,
          Stream<List<RejectedEvent>>
        >
    with
        $FutureModifier<List<RejectedEvent>>,
        $StreamProvider<List<RejectedEvent>> {
  /// Events recorded here that the server refused (`docs/roles.md`).
  RejectedEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectedEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectedEventsHash();

  @$internal
  @override
  $StreamProviderElement<List<RejectedEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RejectedEvent>> create(Ref ref) {
    return rejectedEvents(ref);
  }
}

String _$rejectedEventsHash() => r'ede9598270483a17ae11169df1aae3cea7890954';

/// What someone can do about refused events: read and dismiss them.

@ProviderFor(RejectedActions)
final rejectedActionsProvider = RejectedActionsProvider._();

/// What someone can do about refused events: read and dismiss them.
final class RejectedActionsProvider
    extends $NotifierProvider<RejectedActions, void> {
  /// What someone can do about refused events: read and dismiss them.
  RejectedActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectedActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectedActionsHash();

  @$internal
  @override
  RejectedActions create() => RejectedActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$rejectedActionsHash() => r'7037b0c32f612b2184fb1260a5cbf4c81fd6f2a8';

/// What someone can do about refused events: read and dismiss them.

abstract class _$RejectedActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Members of the circle not removed, admins first.

@ProviderFor(members)
final membersProvider = MembersProvider._();

/// Members of the circle not removed, admins first.

final class MembersProvider
    extends $FunctionalProvider<List<Member>, List<Member>, List<Member>>
    with $Provider<List<Member>> {
  /// Members of the circle not removed, admins first.
  MembersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'membersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$membersHash();

  @$internal
  @override
  $ProviderElement<List<Member>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Member> create(Ref ref) {
    return members(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Member> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Member>>(value),
    );
  }
}

String _$membersHash() => r'5b14bdbf0863656adb5c9462c375e0b7e1cbdd43';

/// Every member who ever belonged, to name who recorded what.

@ProviderFor(membersById)
final membersByIdProvider = MembersByIdProvider._();

/// Every member who ever belonged, to name who recorded what.

final class MembersByIdProvider
    extends
        $FunctionalProvider<
          Map<String, Member>,
          Map<String, Member>,
          Map<String, Member>
        >
    with $Provider<Map<String, Member>> {
  /// Every member who ever belonged, to name who recorded what.
  MembersByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'membersByIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$membersByIdHash();

  @$internal
  @override
  $ProviderElement<Map<String, Member>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, Member> create(Ref ref) {
    return membersById(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Member> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Member>>(value),
    );
  }
}

String _$membersByIdHash() => r'183825e4ef4eebb38704a5b74430901c47d016b3';

/// The member this device belongs to. Each simulated phone overrides it;
/// joining with an invitation code sets it (`docs/roles.md`).

@ProviderFor(deviceOwnerId)
final deviceOwnerIdProvider = DeviceOwnerIdProvider._();

/// The member this device belongs to. Each simulated phone overrides it;
/// joining with an invitation code sets it (`docs/roles.md`).

final class DeviceOwnerIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The member this device belongs to. Each simulated phone overrides it;
  /// joining with an invitation code sets it (`docs/roles.md`).
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

/// The member using this device; null until the log has them.

@ProviderFor(currentMember)
final currentMemberProvider = CurrentMemberProvider._();

/// The member using this device; null until the log has them.

final class CurrentMemberProvider
    extends $FunctionalProvider<Member?, Member?, Member?>
    with $Provider<Member?> {
  /// The member using this device; null until the log has them.
  CurrentMemberProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMemberProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMemberHash();

  @$internal
  @override
  $ProviderElement<Member?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Member? create(Ref ref) {
    return currentMember(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Member? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Member?>(value),
    );
  }
}

String _$currentMemberHash() => r'6b64958ec386950c24718d3f32b39c8d705f4483';

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
