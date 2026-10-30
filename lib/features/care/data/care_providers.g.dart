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
    r'd7ef6b71ca53648407e2eb20e0889ccd92f1e28b';

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
    r'e87e337a9c3b1063fe19ca58ab996000b6ce00a0';

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
