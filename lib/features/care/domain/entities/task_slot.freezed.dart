// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskSlot {

 CareTask get task;/// The start of the day for a task with no set time.
 DateTime get slotAt; TaskStatus get status;/// In log order. More than one is fine: unlike a dose, doing a task
/// twice harms nobody, so it is shown but never a conflict.
 List<TaskDone> get done; List<TaskSkipped> get skipped;
/// Create a copy of TaskSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSlotCopyWith<TaskSlot> get copyWith => _$TaskSlotCopyWithImpl<TaskSlot>(this as TaskSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSlot&&(identical(other.task, task) || other.task == task)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.done, done)&&const DeepCollectionEquality().equals(other.skipped, skipped));
}


@override
int get hashCode => Object.hash(runtimeType,task,slotAt,status,const DeepCollectionEquality().hash(done),const DeepCollectionEquality().hash(skipped));

@override
String toString() {
  return 'TaskSlot(task: $task, slotAt: $slotAt, status: $status, done: $done, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class $TaskSlotCopyWith<$Res>  {
  factory $TaskSlotCopyWith(TaskSlot value, $Res Function(TaskSlot) _then) = _$TaskSlotCopyWithImpl;
@useResult
$Res call({
 CareTask task, DateTime slotAt, TaskStatus status, List<TaskDone> done, List<TaskSkipped> skipped
});


$CareTaskCopyWith<$Res> get task;

}
/// @nodoc
class _$TaskSlotCopyWithImpl<$Res>
    implements $TaskSlotCopyWith<$Res> {
  _$TaskSlotCopyWithImpl(this._self, this._then);

  final TaskSlot _self;
  final $Res Function(TaskSlot) _then;

/// Create a copy of TaskSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? slotAt = null,Object? status = null,Object? done = null,Object? skipped = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as CareTask,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as List<TaskDone>,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<TaskSkipped>,
  ));
}
/// Create a copy of TaskSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareTaskCopyWith<$Res> get task {
  
  return $CareTaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskSlot].
extension TaskSlotPatterns on TaskSlot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSlot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSlot value)  $default,){
final _that = this;
switch (_that) {
case _TaskSlot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSlot value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSlot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CareTask task,  DateTime slotAt,  TaskStatus status,  List<TaskDone> done,  List<TaskSkipped> skipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSlot() when $default != null:
return $default(_that.task,_that.slotAt,_that.status,_that.done,_that.skipped);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CareTask task,  DateTime slotAt,  TaskStatus status,  List<TaskDone> done,  List<TaskSkipped> skipped)  $default,) {final _that = this;
switch (_that) {
case _TaskSlot():
return $default(_that.task,_that.slotAt,_that.status,_that.done,_that.skipped);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CareTask task,  DateTime slotAt,  TaskStatus status,  List<TaskDone> done,  List<TaskSkipped> skipped)?  $default,) {final _that = this;
switch (_that) {
case _TaskSlot() when $default != null:
return $default(_that.task,_that.slotAt,_that.status,_that.done,_that.skipped);case _:
  return null;

}
}

}

/// @nodoc


class _TaskSlot extends TaskSlot {
  const _TaskSlot({required this.task, required this.slotAt, required this.status, final  List<TaskDone> done = const <TaskDone>[], final  List<TaskSkipped> skipped = const <TaskSkipped>[]}): _done = done,_skipped = skipped,super._();
  

@override final  CareTask task;
/// The start of the day for a task with no set time.
@override final  DateTime slotAt;
@override final  TaskStatus status;
/// In log order. More than one is fine: unlike a dose, doing a task
/// twice harms nobody, so it is shown but never a conflict.
 final  List<TaskDone> _done;
/// In log order. More than one is fine: unlike a dose, doing a task
/// twice harms nobody, so it is shown but never a conflict.
@override@JsonKey() List<TaskDone> get done {
  if (_done is EqualUnmodifiableListView) return _done;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_done);
}

 final  List<TaskSkipped> _skipped;
@override@JsonKey() List<TaskSkipped> get skipped {
  if (_skipped is EqualUnmodifiableListView) return _skipped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skipped);
}


/// Create a copy of TaskSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSlotCopyWith<_TaskSlot> get copyWith => __$TaskSlotCopyWithImpl<_TaskSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSlot&&(identical(other.task, task) || other.task == task)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._done, _done)&&const DeepCollectionEquality().equals(other._skipped, _skipped));
}


@override
int get hashCode => Object.hash(runtimeType,task,slotAt,status,const DeepCollectionEquality().hash(_done),const DeepCollectionEquality().hash(_skipped));

@override
String toString() {
  return 'TaskSlot(task: $task, slotAt: $slotAt, status: $status, done: $done, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class _$TaskSlotCopyWith<$Res> implements $TaskSlotCopyWith<$Res> {
  factory _$TaskSlotCopyWith(_TaskSlot value, $Res Function(_TaskSlot) _then) = __$TaskSlotCopyWithImpl;
@override @useResult
$Res call({
 CareTask task, DateTime slotAt, TaskStatus status, List<TaskDone> done, List<TaskSkipped> skipped
});


@override $CareTaskCopyWith<$Res> get task;

}
/// @nodoc
class __$TaskSlotCopyWithImpl<$Res>
    implements _$TaskSlotCopyWith<$Res> {
  __$TaskSlotCopyWithImpl(this._self, this._then);

  final _TaskSlot _self;
  final $Res Function(_TaskSlot) _then;

/// Create a copy of TaskSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? slotAt = null,Object? status = null,Object? done = null,Object? skipped = null,}) {
  return _then(_TaskSlot(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as CareTask,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,done: null == done ? _self._done : done // ignore: cast_nullable_to_non_nullable
as List<TaskDone>,skipped: null == skipped ? _self._skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<TaskSkipped>,
  ));
}

/// Create a copy of TaskSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareTaskCopyWith<$Res> get task {
  
  return $CareTaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
