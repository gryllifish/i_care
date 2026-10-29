// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todayView)
final todayViewProvider = TodayViewProvider._();

final class TodayViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodayView>,
          AsyncValue<TodayView>,
          AsyncValue<TodayView>
        >
    with $Provider<AsyncValue<TodayView>> {
  TodayViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayViewHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<TodayView>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<TodayView> create(Ref ref) {
    return todayView(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TodayView> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TodayView>>(value),
    );
  }
}

String _$todayViewHash() => r'285c6f4587c97e1040eeca3b17cdab90525cc912';
