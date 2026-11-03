// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskDetails {

 String get name;/// Free text, e.g. "Use the shower chair".
 String get note;
/// Create a copy of TaskDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailsCopyWith<TaskDetails> get copyWith => _$TaskDetailsCopyWithImpl<TaskDetails>(this as TaskDetails, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetails&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as TaskDetails;
  return Object.hash(runtimeType,_this.name,_this.note);
}

@override
String toString() {
  final _this = this as TaskDetails;
  return 'TaskDetails(name: ${_this.name}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $TaskDetailsCopyWith<$Res>  {
  factory $TaskDetailsCopyWith(TaskDetails value, $Res Function(TaskDetails) _then) = _$TaskDetailsCopyWithImpl;
@useResult
$Res call({
 String name, String note
});




}
/// @nodoc
class _$TaskDetailsCopyWithImpl<$Res>
    implements $TaskDetailsCopyWith<$Res> {
  _$TaskDetailsCopyWithImpl(this._self, this._then);

  final TaskDetails _self;
  final $Res Function(TaskDetails) _then;

/// Create a copy of TaskDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? note = null,}) {
  return _then(TaskDetails(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDetails].
extension TaskDetailsPatterns on TaskDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDetails value)  $default,){
final _that = this;
switch (_that) {
case _TaskDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDetails value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDetails() when $default != null:
return $default(_that.name,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String note)  $default,) {final _that = this;
switch (_that) {
case _TaskDetails():
return $default(_that.name,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String note)?  $default,) {final _that = this;
switch (_that) {
case _TaskDetails() when $default != null:
return $default(_that.name,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _TaskDetails implements TaskDetails {
  const _TaskDetails({required this.name, this.note = ''});
  

@override final  String name;
/// Free text, e.g. "Use the shower chair".
@override@JsonKey() final  String note;

/// Create a copy of TaskDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDetailsCopyWith<_TaskDetails> get copyWith => __$TaskDetailsCopyWithImpl<_TaskDetails>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDetails&&(identical(other.name, name) || other.name == name)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,note);
}

@override
String toString() {
    return 'TaskDetails(name: $name, note: $note)';
}


}

/// @nodoc
abstract mixin class _$TaskDetailsCopyWith<$Res> implements $TaskDetailsCopyWith<$Res> {
  factory _$TaskDetailsCopyWith(_TaskDetails value, $Res Function(_TaskDetails) _then) = __$TaskDetailsCopyWithImpl;
@override @useResult
$Res call({
 String name, String note
});




}
/// @nodoc
class __$TaskDetailsCopyWithImpl<$Res>
    implements _$TaskDetailsCopyWith<$Res> {
  __$TaskDetailsCopyWithImpl(this._self, this._then);

  final _TaskDetails _self;
  final $Res Function(_TaskDetails) _then;

/// Create a copy of TaskDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? note = null,}) {
  return _then(_TaskDetails(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TaskSchedule {

/// Minutes after midnight, ascending and without repeats; empty means
/// once during the day, at no set time.
 List<int> get minutesOfDay;/// `DateTime.monday`..`DateTime.sunday`; empty means every day.
 Set<int> get weekdays;
/// Create a copy of TaskSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskScheduleCopyWith<TaskSchedule> get copyWith => _$TaskScheduleCopyWithImpl<TaskSchedule>(this as TaskSchedule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSchedule&&const DeepCollectionEquality().equals(other.minutesOfDay, _this.minutesOfDay)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays));
}


@override
int get hashCode {
  final _this = this as TaskSchedule;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.minutesOfDay),const DeepCollectionEquality().hash(_this.weekdays));
}

@override
String toString() {
  final _this = this as TaskSchedule;
  return 'TaskSchedule(minutesOfDay: ${_this.minutesOfDay}, weekdays: ${_this.weekdays})';
}


}

/// @nodoc
abstract mixin class $TaskScheduleCopyWith<$Res>  {
  factory $TaskScheduleCopyWith(TaskSchedule value, $Res Function(TaskSchedule) _then) = _$TaskScheduleCopyWithImpl;
@useResult
$Res call({
 List<int> minutesOfDay, Set<int> weekdays
});




}
/// @nodoc
class _$TaskScheduleCopyWithImpl<$Res>
    implements $TaskScheduleCopyWith<$Res> {
  _$TaskScheduleCopyWithImpl(this._self, this._then);

  final TaskSchedule _self;
  final $Res Function(TaskSchedule) _then;

/// Create a copy of TaskSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minutesOfDay = null,Object? weekdays = null,}) {
  return _then(TaskSchedule(
minutesOfDay: null == minutesOfDay ? _self.minutesOfDay : minutesOfDay // ignore: cast_nullable_to_non_nullable
as List<int>,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSchedule].
extension TaskSchedulePatterns on TaskSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSchedule value)  $default,){
final _that = this;
switch (_that) {
case _TaskSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> minutesOfDay,  Set<int> weekdays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSchedule() when $default != null:
return $default(_that.minutesOfDay,_that.weekdays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> minutesOfDay,  Set<int> weekdays)  $default,) {final _that = this;
switch (_that) {
case _TaskSchedule():
return $default(_that.minutesOfDay,_that.weekdays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> minutesOfDay,  Set<int> weekdays)?  $default,) {final _that = this;
switch (_that) {
case _TaskSchedule() when $default != null:
return $default(_that.minutesOfDay,_that.weekdays);case _:
  return null;

}
}

}

/// @nodoc


class _TaskSchedule extends TaskSchedule {
  const _TaskSchedule({ List<int> minutesOfDay = const <int>[],  Set<int> weekdays = const <int>{}}): _minutesOfDay = minutesOfDay,_weekdays = weekdays,super._();
  

/// Minutes after midnight, ascending and without repeats; empty means
/// once during the day, at no set time.
 final  List<int> _minutesOfDay;
/// Minutes after midnight, ascending and without repeats; empty means
/// once during the day, at no set time.
@override@JsonKey() List<int> get minutesOfDay {
  if (_minutesOfDay is EqualUnmodifiableListView) return _minutesOfDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_minutesOfDay);
}

/// `DateTime.monday`..`DateTime.sunday`; empty means every day.
 final  Set<int> _weekdays;
/// `DateTime.monday`..`DateTime.sunday`; empty means every day.
@override@JsonKey() Set<int> get weekdays {
  if (_weekdays is EqualUnmodifiableSetView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_weekdays);
}


/// Create a copy of TaskSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskScheduleCopyWith<_TaskSchedule> get copyWith => __$TaskScheduleCopyWithImpl<_TaskSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSchedule&&const DeepCollectionEquality().equals(other.minutesOfDay, _minutesOfDay)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_minutesOfDay),const DeepCollectionEquality().hash(_weekdays));
}

@override
String toString() {
    return 'TaskSchedule(minutesOfDay: $minutesOfDay, weekdays: $weekdays)';
}


}

/// @nodoc
abstract mixin class _$TaskScheduleCopyWith<$Res> implements $TaskScheduleCopyWith<$Res> {
  factory _$TaskScheduleCopyWith(_TaskSchedule value, $Res Function(_TaskSchedule) _then) = __$TaskScheduleCopyWithImpl;
@override @useResult
$Res call({
 List<int> minutesOfDay, Set<int> weekdays
});




}
/// @nodoc
class __$TaskScheduleCopyWithImpl<$Res>
    implements _$TaskScheduleCopyWith<$Res> {
  __$TaskScheduleCopyWithImpl(this._self, this._then);

  final _TaskSchedule _self;
  final $Res Function(_TaskSchedule) _then;

/// Create a copy of TaskSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minutesOfDay = null,Object? weekdays = null,}) {
  return _then(_TaskSchedule(
minutesOfDay: null == minutesOfDay ? _self._minutesOfDay : minutesOfDay // ignore: cast_nullable_to_non_nullable
as List<int>,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

/// @nodoc
mixin _$CareTask {

 String get id; TaskDetails get details; TaskSchedule get schedule; bool get isArchived;/// Number of changes applied. Edits carry the version they started
/// from, so concurrent edits can be detected.
 int get version;
/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareTaskCopyWith<CareTask> get copyWith => _$CareTaskCopyWithImpl<CareTask>(this as CareTask, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CareTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareTask&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.schedule, _this.schedule) || other.schedule == _this.schedule)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.version, _this.version) || other.version == _this.version));
}


@override
int get hashCode {
  final _this = this as CareTask;
  return Object.hash(runtimeType,_this.id,_this.details,_this.schedule,_this.isArchived,_this.version);
}

@override
String toString() {
  final _this = this as CareTask;
  return 'CareTask(id: ${_this.id}, details: ${_this.details}, schedule: ${_this.schedule}, isArchived: ${_this.isArchived}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $CareTaskCopyWith<$Res>  {
  factory $CareTaskCopyWith(CareTask value, $Res Function(CareTask) _then) = _$CareTaskCopyWithImpl;
@useResult
$Res call({
 String id, TaskDetails details, TaskSchedule schedule, bool isArchived, int version
});


$TaskDetailsCopyWith<$Res> get details;$TaskScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$CareTaskCopyWithImpl<$Res>
    implements $CareTaskCopyWith<$Res> {
  _$CareTaskCopyWithImpl(this._self, this._then);

  final CareTask _self;
  final $Res Function(CareTask) _then;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? details = null,Object? schedule = null,Object? isArchived = null,Object? version = null,}) {
  return _then(CareTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as TaskDetails,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as TaskSchedule,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskDetailsCopyWith<$Res> get details {
  
  return $TaskDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskScheduleCopyWith<$Res> get schedule {
  
  return $TaskScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [CareTask].
extension CareTaskPatterns on CareTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareTask value)  $default,){
final _that = this;
switch (_that) {
case _CareTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareTask value)?  $default,){
final _that = this;
switch (_that) {
case _CareTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TaskDetails details,  TaskSchedule schedule,  bool isArchived,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareTask() when $default != null:
return $default(_that.id,_that.details,_that.schedule,_that.isArchived,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TaskDetails details,  TaskSchedule schedule,  bool isArchived,  int version)  $default,) {final _that = this;
switch (_that) {
case _CareTask():
return $default(_that.id,_that.details,_that.schedule,_that.isArchived,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TaskDetails details,  TaskSchedule schedule,  bool isArchived,  int version)?  $default,) {final _that = this;
switch (_that) {
case _CareTask() when $default != null:
return $default(_that.id,_that.details,_that.schedule,_that.isArchived,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _CareTask implements CareTask {
  const _CareTask({required this.id, required this.details, required this.schedule, this.isArchived = false, this.version = 0});
  

@override final  String id;
@override final  TaskDetails details;
@override final  TaskSchedule schedule;
@override@JsonKey() final  bool isArchived;
/// Number of changes applied. Edits carry the version they started
/// from, so concurrent edits can be detected.
@override@JsonKey() final  int version;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareTaskCopyWith<_CareTask> get copyWith => __$CareTaskCopyWithImpl<_CareTask>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareTask&&(identical(other.id, id) || other.id == id)&&(identical(other.details, details) || other.details == details)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,details,schedule,isArchived,version);
}

@override
String toString() {
    return 'CareTask(id: $id, details: $details, schedule: $schedule, isArchived: $isArchived, version: $version)';
}


}

/// @nodoc
abstract mixin class _$CareTaskCopyWith<$Res> implements $CareTaskCopyWith<$Res> {
  factory _$CareTaskCopyWith(_CareTask value, $Res Function(_CareTask) _then) = __$CareTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, TaskDetails details, TaskSchedule schedule, bool isArchived, int version
});


@override $TaskDetailsCopyWith<$Res> get details;@override $TaskScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class __$CareTaskCopyWithImpl<$Res>
    implements _$CareTaskCopyWith<$Res> {
  __$CareTaskCopyWithImpl(this._self, this._then);

  final _CareTask _self;
  final $Res Function(_CareTask) _then;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? details = null,Object? schedule = null,Object? isArchived = null,Object? version = null,}) {
  return _then(_CareTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as TaskDetails,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as TaskSchedule,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskDetailsCopyWith<$Res> get details {
  
  return $TaskDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskScheduleCopyWith<$Res> get schedule {
  
  return $TaskScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

// dart format on
