// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskDraft {

 bool get atSetTimes;/// Minutes after midnight, ascending and without repeats.
 List<int> get times; bool get everyDay;/// `DateTime.monday`..`DateTime.sunday`; used when not [everyDay].
 Set<int> get days;
/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDraftCopyWith<TaskDraft> get copyWith => _$TaskDraftCopyWithImpl<TaskDraft>(this as TaskDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDraft&&(identical(other.atSetTimes, atSetTimes) || other.atSetTimes == atSetTimes)&&const DeepCollectionEquality().equals(other.times, times)&&(identical(other.everyDay, everyDay) || other.everyDay == everyDay)&&const DeepCollectionEquality().equals(other.days, days));
}


@override
int get hashCode => Object.hash(runtimeType,atSetTimes,const DeepCollectionEquality().hash(times),everyDay,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'TaskDraft(atSetTimes: $atSetTimes, times: $times, everyDay: $everyDay, days: $days)';
}


}

/// @nodoc
abstract mixin class $TaskDraftCopyWith<$Res>  {
  factory $TaskDraftCopyWith(TaskDraft value, $Res Function(TaskDraft) _then) = _$TaskDraftCopyWithImpl;
@useResult
$Res call({
 bool atSetTimes, List<int> times, bool everyDay, Set<int> days
});




}
/// @nodoc
class _$TaskDraftCopyWithImpl<$Res>
    implements $TaskDraftCopyWith<$Res> {
  _$TaskDraftCopyWithImpl(this._self, this._then);

  final TaskDraft _self;
  final $Res Function(TaskDraft) _then;

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? atSetTimes = null,Object? times = null,Object? everyDay = null,Object? days = null,}) {
  return _then(_self.copyWith(
atSetTimes: null == atSetTimes ? _self.atSetTimes : atSetTimes // ignore: cast_nullable_to_non_nullable
as bool,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<int>,everyDay: null == everyDay ? _self.everyDay : everyDay // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDraft].
extension TaskDraftPatterns on TaskDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDraft value)  $default,){
final _that = this;
switch (_that) {
case _TaskDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool atSetTimes,  List<int> times,  bool everyDay,  Set<int> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
return $default(_that.atSetTimes,_that.times,_that.everyDay,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool atSetTimes,  List<int> times,  bool everyDay,  Set<int> days)  $default,) {final _that = this;
switch (_that) {
case _TaskDraft():
return $default(_that.atSetTimes,_that.times,_that.everyDay,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool atSetTimes,  List<int> times,  bool everyDay,  Set<int> days)?  $default,) {final _that = this;
switch (_that) {
case _TaskDraft() when $default != null:
return $default(_that.atSetTimes,_that.times,_that.everyDay,_that.days);case _:
  return null;

}
}

}

/// @nodoc


class _TaskDraft extends TaskDraft {
  const _TaskDraft({this.atSetTimes = false, final  List<int> times = const <int>[10 * 60], this.everyDay = true, final  Set<int> days = const <int>{}}): _times = times,_days = days,super._();
  

@override@JsonKey() final  bool atSetTimes;
/// Minutes after midnight, ascending and without repeats.
 final  List<int> _times;
/// Minutes after midnight, ascending and without repeats.
@override@JsonKey() List<int> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

@override@JsonKey() final  bool everyDay;
/// `DateTime.monday`..`DateTime.sunday`; used when not [everyDay].
 final  Set<int> _days;
/// `DateTime.monday`..`DateTime.sunday`; used when not [everyDay].
@override@JsonKey() Set<int> get days {
  if (_days is EqualUnmodifiableSetView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_days);
}


/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDraftCopyWith<_TaskDraft> get copyWith => __$TaskDraftCopyWithImpl<_TaskDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDraft&&(identical(other.atSetTimes, atSetTimes) || other.atSetTimes == atSetTimes)&&const DeepCollectionEquality().equals(other._times, _times)&&(identical(other.everyDay, everyDay) || other.everyDay == everyDay)&&const DeepCollectionEquality().equals(other._days, _days));
}


@override
int get hashCode => Object.hash(runtimeType,atSetTimes,const DeepCollectionEquality().hash(_times),everyDay,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'TaskDraft(atSetTimes: $atSetTimes, times: $times, everyDay: $everyDay, days: $days)';
}


}

/// @nodoc
abstract mixin class _$TaskDraftCopyWith<$Res> implements $TaskDraftCopyWith<$Res> {
  factory _$TaskDraftCopyWith(_TaskDraft value, $Res Function(_TaskDraft) _then) = __$TaskDraftCopyWithImpl;
@override @useResult
$Res call({
 bool atSetTimes, List<int> times, bool everyDay, Set<int> days
});




}
/// @nodoc
class __$TaskDraftCopyWithImpl<$Res>
    implements _$TaskDraftCopyWith<$Res> {
  __$TaskDraftCopyWithImpl(this._self, this._then);

  final _TaskDraft _self;
  final $Res Function(_TaskDraft) _then;

/// Create a copy of TaskDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? atSetTimes = null,Object? times = null,Object? everyDay = null,Object? days = null,}) {
  return _then(_TaskDraft(
atSetTimes: null == atSetTimes ? _self.atSetTimes : atSetTimes // ignore: cast_nullable_to_non_nullable
as bool,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<int>,everyDay: null == everyDay ? _self.everyDay : everyDay // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

// dart format on
