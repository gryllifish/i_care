// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The time [taskId] is due at [slotAt], kept current while its sheet is
/// open; null once the task is archived or no longer due then.

@ProviderFor(taskDetail)
final taskDetailProvider = TaskDetailFamily._();

/// The time [taskId] is due at [slotAt], kept current while its sheet is
/// open; null once the task is archived or no longer due then.

final class TaskDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskSlot?>,
          AsyncValue<TaskSlot?>,
          AsyncValue<TaskSlot?>
        >
    with $Provider<AsyncValue<TaskSlot?>> {
  /// The time [taskId] is due at [slotAt], kept current while its sheet is
  /// open; null once the task is archived or no longer due then.
  TaskDetailProvider._({
    required TaskDetailFamily super.from,
    required (String, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'taskDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskDetailHash();

  @override
  String toString() {
    return r'taskDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<TaskSlot?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<TaskSlot?> create(Ref ref) {
    final argument = this.argument as (String, DateTime);
    return taskDetail(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TaskSlot?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TaskSlot?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskDetailHash() => r'60cb06d9fafb3f6268de5dd93df4ded628be6679';

/// The time [taskId] is due at [slotAt], kept current while its sheet is
/// open; null once the task is archived or no longer due then.

final class TaskDetailFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<TaskSlot?>, (String, DateTime)> {
  TaskDetailFamily._()
    : super(
        retry: null,
        name: r'taskDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The time [taskId] is due at [slotAt], kept current while its sheet is
  /// open; null once the task is archived or no longer due then.

  TaskDetailProvider call(String taskId, DateTime slotAt) =>
      TaskDetailProvider._(argument: (taskId, slotAt), from: this);

  @override
  String toString() => r'taskDetailProvider';
}
