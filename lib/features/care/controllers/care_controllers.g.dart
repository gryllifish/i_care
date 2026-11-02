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

/// The member this device joined the circle as; null until it joins
/// with a code, and again after it leaves (`docs/roles.md`). Remembered
/// on the device.

@ProviderFor(DeviceMembership)
final deviceMembershipProvider = DeviceMembershipProvider._();

/// The member this device joined the circle as; null until it joins
/// with a code, and again after it leaves (`docs/roles.md`). Remembered
/// on the device.
final class DeviceMembershipProvider
    extends $NotifierProvider<DeviceMembership, String?> {
  /// The member this device joined the circle as; null until it joins
  /// with a code, and again after it leaves (`docs/roles.md`). Remembered
  /// on the device.
  DeviceMembershipProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceMembershipProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceMembershipHash();

  @$internal
  @override
  DeviceMembership create() => DeviceMembership();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$deviceMembershipHash() => r'f0d53d4424c03a67888196a9825be14d285d64cc';

/// The member this device joined the circle as; null until it joins
/// with a code, and again after it leaves (`docs/roles.md`). Remembered
/// on the device.

abstract class _$DeviceMembership extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The member using this device; null before it joins, or until the log
/// has them.

@ProviderFor(currentMember)
final currentMemberProvider = CurrentMemberProvider._();

/// The member using this device; null before it joins, or until the log
/// has them.

final class CurrentMemberProvider
    extends $FunctionalProvider<Member?, Member?, Member?>
    with $Provider<Member?> {
  /// The member using this device; null before it joins, or until the log
  /// has them.
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

String _$currentMemberHash() => r'0ea33ce7343d2e1040cc29f9b92fbbeed3f7f821';

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

/// Whether this phone's member may do [action] (`docs/roles.md`); false
/// before the log has them. The UI offers only what this allows; the
/// server checks every event anyway.

@ProviderFor(canDo)
final canDoProvider = CanDoFamily._();

/// Whether this phone's member may do [action] (`docs/roles.md`); false
/// before the log has them. The UI offers only what this allows; the
/// server checks every event anyway.

final class CanDoProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this phone's member may do [action] (`docs/roles.md`); false
  /// before the log has them. The UI offers only what this allows; the
  /// server checks every event anyway.
  CanDoProvider._({
    required CanDoFamily super.from,
    required CareAction super.argument,
  }) : super(
         retry: null,
         name: r'canDoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$canDoHash();

  @override
  String toString() {
    return r'canDoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as CareAction;
    return canDo(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CanDoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$canDoHash() => r'cbe0c3a029e85d1affe643548775eaa39d6a3481';

/// Whether this phone's member may do [action] (`docs/roles.md`); false
/// before the log has them. The UI offers only what this allows; the
/// server checks every event anyway.

final class CanDoFamily extends $Family
    with $FunctionalFamilyOverride<bool, CareAction> {
  CanDoFamily._()
    : super(
        retry: null,
        name: r'canDoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether this phone's member may do [action] (`docs/roles.md`); false
  /// before the log has them. The UI offers only what this allows; the
  /// server checks every event anyway.

  CanDoProvider call(CareAction action) =>
      CanDoProvider._(argument: action, from: this);

  @override
  String toString() => r'canDoProvider';
}

/// Starts this phone's copy of the log over when a role change changes
/// what it may read (`docs/roles.md`, "Data by role"): becoming a helper
/// drops the team's events, leaving it brings them. The app keeps it
/// alive.

@ProviderFor(audienceSync)
final audienceSyncProvider = AudienceSyncProvider._();

/// Starts this phone's copy of the log over when a role change changes
/// what it may read (`docs/roles.md`, "Data by role"): becoming a helper
/// drops the team's events, leaving it brings them. The app keeps it
/// alive.

final class AudienceSyncProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Starts this phone's copy of the log over when a role change changes
  /// what it may read (`docs/roles.md`, "Data by role"): becoming a helper
  /// drops the team's events, leaving it brings them. The app keeps it
  /// alive.
  AudienceSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audienceSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audienceSyncHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return audienceSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$audienceSyncHash() => r'7f124182da284708ead07af51ec976ab383a73bb';
