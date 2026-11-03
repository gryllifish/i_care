// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Changes to medications. Each one appends events carrying the version
/// it was made on, so concurrent edits are flagged instead of lost.
/// Callers validate first (`validateDetails`, `validateSchedule`).

@ProviderFor(MedicationActions)
final medicationActionsProvider = MedicationActionsProvider._();

/// Changes to medications. Each one appends events carrying the version
/// it was made on, so concurrent edits are flagged instead of lost.
/// Callers validate first (`validateDetails`, `validateSchedule`).
final class MedicationActionsProvider
    extends $NotifierProvider<MedicationActions, void> {
  /// Changes to medications. Each one appends events carrying the version
  /// it was made on, so concurrent edits are flagged instead of lost.
  /// Callers validate first (`validateDetails`, `validateSchedule`).
  MedicationActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicationActionsHash();

  @$internal
  @override
  MedicationActions create() => MedicationActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$medicationActionsHash() => r'46381c2140a9c7053b573701f8eaacce107ca9ea';

/// Changes to medications. Each one appends events carrying the version
/// it was made on, so concurrent edits are flagged instead of lost.
/// Callers validate first (`validateDetails`, `validateSchedule`).

abstract class _$MedicationActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
