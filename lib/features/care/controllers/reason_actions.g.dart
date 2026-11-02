// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reason_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The circle's own reasons for not giving a dose or doing a task, and
/// which reasons are offered. Callers check a new label with
/// `isNewReasonLabel` first.

@ProviderFor(ReasonActions)
final reasonActionsProvider = ReasonActionsProvider._();

/// The circle's own reasons for not giving a dose or doing a task, and
/// which reasons are offered. Callers check a new label with
/// `isNewReasonLabel` first.
final class ReasonActionsProvider
    extends $NotifierProvider<ReasonActions, void> {
  /// The circle's own reasons for not giving a dose or doing a task, and
  /// which reasons are offered. Callers check a new label with
  /// `isNewReasonLabel` first.
  ReasonActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reasonActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reasonActionsHash();

  @$internal
  @override
  ReasonActions create() => ReasonActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$reasonActionsHash() => r'cc762e07a0987075b556b09b59199ddc40f475ec';

/// The circle's own reasons for not giving a dose or doing a task, and
/// which reasons are offered. Callers check a new label with
/// `isNewReasonLabel` first.

abstract class _$ReasonActions extends $Notifier<void> {
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
