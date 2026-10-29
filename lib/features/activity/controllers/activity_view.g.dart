// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activityView)
final activityViewProvider = ActivityViewProvider._();

final class ActivityViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityDay>>,
          AsyncValue<List<ActivityDay>>,
          AsyncValue<List<ActivityDay>>
        >
    with $Provider<AsyncValue<List<ActivityDay>>> {
  ActivityViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityViewHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<ActivityDay>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<ActivityDay>> create(Ref ref) {
    return activityView(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ActivityDay>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ActivityDay>>>(
        value,
      ),
    );
  }
}

String _$activityViewHash() => r'103d648dd759b116a32e9d762286557a57a2dffe';
