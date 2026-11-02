// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Changes to care tasks and what caregivers record for them. Each one
/// appends an event; edits carry the version they were made on, so
/// concurrent edits are flagged instead of lost. Callers validate first
/// (`validateTaskDetails`). Kept alive so an undo offered after a sheet
/// closes still has a live notifier.

@ProviderFor(TaskActions)
final taskActionsProvider = TaskActionsProvider._();

/// Changes to care tasks and what caregivers record for them. Each one
/// appends an event; edits carry the version they were made on, so
/// concurrent edits are flagged instead of lost. Callers validate first
/// (`validateTaskDetails`). Kept alive so an undo offered after a sheet
/// closes still has a live notifier.
final class TaskActionsProvider extends $NotifierProvider<TaskActions, void> {
  /// Changes to care tasks and what caregivers record for them. Each one
  /// appends an event; edits carry the version they were made on, so
  /// concurrent edits are flagged instead of lost. Callers validate first
  /// (`validateTaskDetails`). Kept alive so an undo offered after a sheet
  /// closes still has a live notifier.
  TaskActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskActionsHash();

  @$internal
  @override
  TaskActions create() => TaskActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$taskActionsHash() => r'cbb387aa716c47dcd0ce52ea410afa9a372b1d01';

/// Changes to care tasks and what caregivers record for them. Each one
/// appends an event; edits carry the version they were made on, so
/// concurrent edits are flagged instead of lost. Callers validate first
/// (`validateTaskDetails`). Kept alive so an undo offered after a sheet
/// closes still has a live notifier.

abstract class _$TaskActions extends $Notifier<void> {
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
