// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Leaving notes for the circle ("te dejo dicho").

@ProviderFor(NoteActions)
final noteActionsProvider = NoteActionsProvider._();

/// Leaving notes for the circle ("te dejo dicho").
final class NoteActionsProvider extends $NotifierProvider<NoteActions, void> {
  /// Leaving notes for the circle ("te dejo dicho").
  NoteActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteActionsHash();

  @$internal
  @override
  NoteActions create() => NoteActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$noteActionsHash() => r'c3928ae3174539c9cb9512c8823f83362d8c4899';

/// Leaving notes for the circle ("te dejo dicho").

abstract class _$NoteActions extends $Notifier<void> {
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
