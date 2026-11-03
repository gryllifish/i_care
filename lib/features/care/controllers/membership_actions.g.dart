// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Who belongs to the circle and which device is whose (`docs/roles.md`).
/// Changes to members are events, carrying the version they were made on;
/// codes, joining and leaving go to the server directly.

@ProviderFor(MembershipActions)
final membershipActionsProvider = MembershipActionsProvider._();

/// Who belongs to the circle and which device is whose (`docs/roles.md`).
/// Changes to members are events, carrying the version they were made on;
/// codes, joining and leaving go to the server directly.
final class MembershipActionsProvider
    extends $NotifierProvider<MembershipActions, void> {
  /// Who belongs to the circle and which device is whose (`docs/roles.md`).
  /// Changes to members are events, carrying the version they were made on;
  /// codes, joining and leaving go to the server directly.
  MembershipActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'membershipActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$membershipActionsHash();

  @$internal
  @override
  MembershipActions create() => MembershipActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$membershipActionsHash() => r'79447cad2ecae86580cc38bc80c75686e38074a9';

/// Who belongs to the circle and which device is whose (`docs/roles.md`).
/// Changes to members are events, carrying the version they were made on;
/// codes, joining and leaving go to the server directly.

abstract class _$MembershipActions extends $Notifier<void> {
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
