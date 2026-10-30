// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Active care tasks by name.

@ProviderFor(tasksView)
final tasksViewProvider = TasksViewProvider._();

/// Active care tasks by name.

final class TasksViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TaskRow>>,
          AsyncValue<List<TaskRow>>,
          AsyncValue<List<TaskRow>>
        >
    with $Provider<AsyncValue<List<TaskRow>>> {
  /// Active care tasks by name.
  TasksViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksViewHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<TaskRow>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<TaskRow>> create(Ref ref) {
    return tasksView(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<TaskRow>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<TaskRow>>>(value),
    );
  }
}

String _$tasksViewHash() => r'977878fe3b95d43cf8100137d817e557581cfe43';

/// One task, archived or not, with its unreviewed concurrent edits; null
/// when there is no such task.

@ProviderFor(taskRow)
final taskRowProvider = TaskRowFamily._();

/// One task, archived or not, with its unreviewed concurrent edits; null
/// when there is no such task.

final class TaskRowProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskRow?>,
          AsyncValue<TaskRow?>,
          AsyncValue<TaskRow?>
        >
    with $Provider<AsyncValue<TaskRow?>> {
  /// One task, archived or not, with its unreviewed concurrent edits; null
  /// when there is no such task.
  TaskRowProvider._({
    required TaskRowFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskRowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskRowHash();

  @override
  String toString() {
    return r'taskRowProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<TaskRow?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<TaskRow?> create(Ref ref) {
    final argument = this.argument as String;
    return taskRow(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TaskRow?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TaskRow?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskRowProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskRowHash() => r'73b010a44b6700323b1b6fc04fa09c6aa2644455';

/// One task, archived or not, with its unreviewed concurrent edits; null
/// when there is no such task.

final class TaskRowFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<TaskRow?>, String> {
  TaskRowFamily._()
    : super(
        retry: null,
        name: r'taskRowProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One task, archived or not, with its unreviewed concurrent edits; null
  /// when there is no such task.

  TaskRowProvider call(String taskId) =>
      TaskRowProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskRowProvider';
}
