// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This device's event log box.

@ProviderFor(eventBox)
final eventBoxProvider = EventBoxProvider._();

/// This device's event log box.

final class EventBoxProvider
    extends $FunctionalProvider<Box<String>, Box<String>, Box<String>>
    with $Provider<Box<String>> {
  /// This device's event log box.
  EventBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventBoxHash();

  @$internal
  @override
  $ProviderElement<Box<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<String> create(Ref ref) {
    return eventBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<String>>(value),
    );
  }
}

String _$eventBoxHash() => r'82d4df808248738d8817366057a99183f7bbd5d1';

/// This device's box of events the server refused.

@ProviderFor(rejectedBox)
final rejectedBoxProvider = RejectedBoxProvider._();

/// This device's box of events the server refused.

final class RejectedBoxProvider
    extends $FunctionalProvider<Box<String>, Box<String>, Box<String>>
    with $Provider<Box<String>> {
  /// This device's box of events the server refused.
  RejectedBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectedBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectedBoxHash();

  @$internal
  @override
  $ProviderElement<Box<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<String> create(Ref ref) {
    return rejectedBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<String>>(value),
    );
  }
}

String _$rejectedBoxHash() => r'11b3c3fe8d7b57de0dc3a9504147bf55259e0754';

/// How the server knows this device. Each simulated phone overrides it.

@ProviderFor(deviceId)
final deviceIdProvider = DeviceIdProvider._();

/// How the server knows this device. Each simulated phone overrides it.

final class DeviceIdProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// How the server knows this device. Each simulated phone overrides it.
  DeviceIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return deviceId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$deviceIdHash() => r'0b71f5c75533fdd50971e0a6f6530ef26235e922';

/// This device's sync state box.

@ProviderFor(syncStateBox)
final syncStateBoxProvider = SyncStateBoxProvider._();

/// This device's sync state box.

final class SyncStateBoxProvider
    extends $FunctionalProvider<Box<String>, Box<String>, Box<String>>
    with $Provider<Box<String>> {
  /// This device's sync state box.
  SyncStateBoxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncStateBoxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncStateBoxHash();

  @$internal
  @override
  $ProviderElement<Box<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Box<String> create(Ref ref) {
    return syncStateBox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Box<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Box<String>>(value),
    );
  }
}

String _$syncStateBoxHash() => r'e7e4fa744962e37b4109539d522aff58fa01aea5';

/// The server every device shares; the same instance is given to every
/// device container.

@ProviderFor(simulatedServer)
final simulatedServerProvider = SimulatedServerProvider._();

/// The server every device shares; the same instance is given to every
/// device container.

final class SimulatedServerProvider
    extends
        $FunctionalProvider<SimulatedServer, SimulatedServer, SimulatedServer>
    with $Provider<SimulatedServer> {
  /// The server every device shares; the same instance is given to every
  /// device container.
  SimulatedServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'simulatedServerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$simulatedServerHash();

  @$internal
  @override
  $ProviderElement<SimulatedServer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SimulatedServer create(Ref ref) {
    return simulatedServer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SimulatedServer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SimulatedServer>(value),
    );
  }
}

String _$simulatedServerHash() => r'caf5e0f73683cbaf8d91f64fda2e8d9b896bf87d';

/// This device's connection, exposed with its concrete type so the demo
/// controls can switch the network off.

@ProviderFor(simulatedConnection)
final simulatedConnectionProvider = SimulatedConnectionProvider._();

/// This device's connection, exposed with its concrete type so the demo
/// controls can switch the network off.

final class SimulatedConnectionProvider
    extends
        $FunctionalProvider<
          SimulatedConnection,
          SimulatedConnection,
          SimulatedConnection
        >
    with $Provider<SimulatedConnection> {
  /// This device's connection, exposed with its concrete type so the demo
  /// controls can switch the network off.
  SimulatedConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'simulatedConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$simulatedConnectionHash();

  @$internal
  @override
  $ProviderElement<SimulatedConnection> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SimulatedConnection create(Ref ref) {
    return simulatedConnection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SimulatedConnection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SimulatedConnection>(value),
    );
  }
}

String _$simulatedConnectionHash() =>
    r'6633c61231896d594e0111399716dbb6bae16816';

@ProviderFor(syncGateway)
final syncGatewayProvider = SyncGatewayProvider._();

final class SyncGatewayProvider
    extends $FunctionalProvider<SyncGateway, SyncGateway, SyncGateway>
    with $Provider<SyncGateway> {
  SyncGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncGatewayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncGatewayHash();

  @$internal
  @override
  $ProviderElement<SyncGateway> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncGateway create(Ref ref) {
    return syncGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncGateway>(value),
    );
  }
}

String _$syncGatewayHash() => r'74690cd6230652fcbd3ba57dc4032a9f6db3131b';

/// The repository with its sync controls, for the demo's reset.

@ProviderFor(careRepositoryImpl)
final careRepositoryImplProvider = CareRepositoryImplProvider._();

/// The repository with its sync controls, for the demo's reset.

final class CareRepositoryImplProvider
    extends
        $FunctionalProvider<
          CareRepositoryImpl,
          CareRepositoryImpl,
          CareRepositoryImpl
        >
    with $Provider<CareRepositoryImpl> {
  /// The repository with its sync controls, for the demo's reset.
  CareRepositoryImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'careRepositoryImplProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$careRepositoryImplHash();

  @$internal
  @override
  $ProviderElement<CareRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CareRepositoryImpl create(Ref ref) {
    return careRepositoryImpl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CareRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CareRepositoryImpl>(value),
    );
  }
}

String _$careRepositoryImplHash() =>
    r'db4337f352c94ad488958aa854ba4008bd372253';

@ProviderFor(careRepository)
final careRepositoryProvider = CareRepositoryProvider._();

final class CareRepositoryProvider
    extends $FunctionalProvider<CareRepository, CareRepository, CareRepository>
    with $Provider<CareRepository> {
  CareRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'careRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$careRepositoryHash();

  @$internal
  @override
  $ProviderElement<CareRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CareRepository create(Ref ref) {
    return careRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CareRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CareRepository>(value),
    );
  }
}

String _$careRepositoryHash() => r'02c1a84b680ae14d3c507bb0ea0202e4f454e64e';

/// Push notifications on this phone; null where there are none: the
/// demo, and builds without Firebase or on platforms without push.
/// `bootstrap` provides it for the beta.

@ProviderFor(pushRepository)
final pushRepositoryProvider = PushRepositoryProvider._();

/// Push notifications on this phone; null where there are none: the
/// demo, and builds without Firebase or on platforms without push.
/// `bootstrap` provides it for the beta.

final class PushRepositoryProvider
    extends
        $FunctionalProvider<PushRepository?, PushRepository?, PushRepository?>
    with $Provider<PushRepository?> {
  /// Push notifications on this phone; null where there are none: the
  /// demo, and builds without Firebase or on platforms without push.
  /// `bootstrap` provides it for the beta.
  PushRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRepositoryHash();

  @$internal
  @override
  $ProviderElement<PushRepository?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushRepository? create(Ref ref) {
    return pushRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushRepository? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushRepository?>(value),
    );
  }
}

String _$pushRepositoryHash() => r'049c62e5926eb2371bd036038fe7dc5a3dc9d06c';

@ProviderFor(membershipGateway)
final membershipGatewayProvider = MembershipGatewayProvider._();

final class MembershipGatewayProvider
    extends
        $FunctionalProvider<
          MembershipGateway,
          MembershipGateway,
          MembershipGateway
        >
    with $Provider<MembershipGateway> {
  MembershipGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'membershipGatewayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$membershipGatewayHash();

  @$internal
  @override
  $ProviderElement<MembershipGateway> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MembershipGateway create(Ref ref) {
    return membershipGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MembershipGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MembershipGateway>(value),
    );
  }
}

String _$membershipGatewayHash() => r'd56d8722f1217f267dcf00663c4d2ac3cbc3b6b3';

@ProviderFor(membershipRepository)
final membershipRepositoryProvider = MembershipRepositoryProvider._();

final class MembershipRepositoryProvider
    extends
        $FunctionalProvider<
          MembershipRepository,
          MembershipRepository,
          MembershipRepository
        >
    with $Provider<MembershipRepository> {
  MembershipRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'membershipRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$membershipRepositoryHash();

  @$internal
  @override
  $ProviderElement<MembershipRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MembershipRepository create(Ref ref) {
    return membershipRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MembershipRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MembershipRepository>(value),
    );
  }
}

String _$membershipRepositoryHash() =>
    r'8096a04007898be9bba9338a49af19f9a7d601ae';
