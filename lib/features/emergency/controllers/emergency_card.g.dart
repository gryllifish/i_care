// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_card.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emergencyCard)
final emergencyCardProvider = EmergencyCardProvider._();

final class EmergencyCardProvider
    extends
        $FunctionalProvider<
          AsyncValue<EmergencyCard>,
          AsyncValue<EmergencyCard>,
          AsyncValue<EmergencyCard>
        >
    with $Provider<AsyncValue<EmergencyCard>> {
  EmergencyCardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyCardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyCardHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<EmergencyCard>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<EmergencyCard> create(Ref ref) {
    return emergencyCard(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<EmergencyCard> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<EmergencyCard>>(value),
    );
  }
}

String _$emergencyCardHash() => r'c1aa43a108841081c59054b0eafce3515cc5295a';

/// Changes to the profile, carrying the version they were made on.

@ProviderFor(ProfileActions)
final profileActionsProvider = ProfileActionsProvider._();

/// Changes to the profile, carrying the version they were made on.
final class ProfileActionsProvider
    extends $NotifierProvider<ProfileActions, void> {
  /// Changes to the profile, carrying the version they were made on.
  ProfileActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileActionsHash();

  @$internal
  @override
  ProfileActions create() => ProfileActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$profileActionsHash() => r'95c4f1062903415c73d158165d58ca4cb795b4da';

/// Changes to the profile, carrying the version they were made on.

abstract class _$ProfileActions extends $Notifier<void> {
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
