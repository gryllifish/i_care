// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dose_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoseSchedule {

/// Optional spacing between two given doses, checked before giving.
 Duration? get minInterval;
/// Create a copy of DoseSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseScheduleCopyWith<DoseSchedule> get copyWith => _$DoseScheduleCopyWithImpl<DoseSchedule>(this as DoseSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseSchedule&&(identical(other.minInterval, minInterval) || other.minInterval == minInterval));
}


@override
int get hashCode => Object.hash(runtimeType,minInterval);

@override
String toString() {
  return 'DoseSchedule(minInterval: $minInterval)';
}


}

/// @nodoc
abstract mixin class $DoseScheduleCopyWith<$Res>  {
  factory $DoseScheduleCopyWith(DoseSchedule value, $Res Function(DoseSchedule) _then) = _$DoseScheduleCopyWithImpl;
@useResult
$Res call({
 Duration minInterval
});




}
/// @nodoc
class _$DoseScheduleCopyWithImpl<$Res>
    implements $DoseScheduleCopyWith<$Res> {
  _$DoseScheduleCopyWithImpl(this._self, this._then);

  final DoseSchedule _self;
  final $Res Function(DoseSchedule) _then;

/// Create a copy of DoseSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minInterval = null,}) {
  return _then(_self.copyWith(
minInterval: null == minInterval ? _self.minInterval! : minInterval // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [DoseSchedule].
extension DoseSchedulePatterns on DoseSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FixedSchedule value)?  fixed,TResult Function( AsNeededSchedule value)?  asNeeded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FixedSchedule() when fixed != null:
return fixed(_that);case AsNeededSchedule() when asNeeded != null:
return asNeeded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FixedSchedule value)  fixed,required TResult Function( AsNeededSchedule value)  asNeeded,}){
final _that = this;
switch (_that) {
case FixedSchedule():
return fixed(_that);case AsNeededSchedule():
return asNeeded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FixedSchedule value)?  fixed,TResult? Function( AsNeededSchedule value)?  asNeeded,}){
final _that = this;
switch (_that) {
case FixedSchedule() when fixed != null:
return fixed(_that);case AsNeededSchedule() when asNeeded != null:
return asNeeded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<int> minutesOfDay,  Set<int> weekdays,  Duration? minInterval)?  fixed,TResult Function( Duration minInterval,  int? maxPerDay)?  asNeeded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FixedSchedule() when fixed != null:
return fixed(_that.minutesOfDay,_that.weekdays,_that.minInterval);case AsNeededSchedule() when asNeeded != null:
return asNeeded(_that.minInterval,_that.maxPerDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<int> minutesOfDay,  Set<int> weekdays,  Duration? minInterval)  fixed,required TResult Function( Duration minInterval,  int? maxPerDay)  asNeeded,}) {final _that = this;
switch (_that) {
case FixedSchedule():
return fixed(_that.minutesOfDay,_that.weekdays,_that.minInterval);case AsNeededSchedule():
return asNeeded(_that.minInterval,_that.maxPerDay);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<int> minutesOfDay,  Set<int> weekdays,  Duration? minInterval)?  fixed,TResult? Function( Duration minInterval,  int? maxPerDay)?  asNeeded,}) {final _that = this;
switch (_that) {
case FixedSchedule() when fixed != null:
return fixed(_that.minutesOfDay,_that.weekdays,_that.minInterval);case AsNeededSchedule() when asNeeded != null:
return asNeeded(_that.minInterval,_that.maxPerDay);case _:
  return null;

}
}

}

/// @nodoc


class FixedSchedule extends DoseSchedule {
  const FixedSchedule({required final  List<int> minutesOfDay, final  Set<int> weekdays = const <int>{}, this.minInterval}): _minutesOfDay = minutesOfDay,_weekdays = weekdays,super._();
  

/// Minutes after midnight, ascending and without repeats.
 final  List<int> _minutesOfDay;
/// Minutes after midnight, ascending and without repeats.
 List<int> get minutesOfDay {
  if (_minutesOfDay is EqualUnmodifiableListView) return _minutesOfDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_minutesOfDay);
}

/// `DateTime.monday`..`DateTime.sunday`; empty means every day.
 final  Set<int> _weekdays;
/// `DateTime.monday`..`DateTime.sunday`; empty means every day.
@JsonKey() Set<int> get weekdays {
  if (_weekdays is EqualUnmodifiableSetView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_weekdays);
}

/// Optional spacing between two given doses, checked before giving.
@override final  Duration? minInterval;

/// Create a copy of DoseSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FixedScheduleCopyWith<FixedSchedule> get copyWith => _$FixedScheduleCopyWithImpl<FixedSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FixedSchedule&&const DeepCollectionEquality().equals(other._minutesOfDay, _minutesOfDay)&&const DeepCollectionEquality().equals(other._weekdays, _weekdays)&&(identical(other.minInterval, minInterval) || other.minInterval == minInterval));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_minutesOfDay),const DeepCollectionEquality().hash(_weekdays),minInterval);

@override
String toString() {
  return 'DoseSchedule.fixed(minutesOfDay: $minutesOfDay, weekdays: $weekdays, minInterval: $minInterval)';
}


}

/// @nodoc
abstract mixin class $FixedScheduleCopyWith<$Res> implements $DoseScheduleCopyWith<$Res> {
  factory $FixedScheduleCopyWith(FixedSchedule value, $Res Function(FixedSchedule) _then) = _$FixedScheduleCopyWithImpl;
@override @useResult
$Res call({
 List<int> minutesOfDay, Set<int> weekdays, Duration? minInterval
});




}
/// @nodoc
class _$FixedScheduleCopyWithImpl<$Res>
    implements $FixedScheduleCopyWith<$Res> {
  _$FixedScheduleCopyWithImpl(this._self, this._then);

  final FixedSchedule _self;
  final $Res Function(FixedSchedule) _then;

/// Create a copy of DoseSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minutesOfDay = null,Object? weekdays = null,Object? minInterval = freezed,}) {
  return _then(FixedSchedule(
minutesOfDay: null == minutesOfDay ? _self._minutesOfDay : minutesOfDay // ignore: cast_nullable_to_non_nullable
as List<int>,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as Set<int>,minInterval: freezed == minInterval ? _self.minInterval : minInterval // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class AsNeededSchedule extends DoseSchedule {
  const AsNeededSchedule({required this.minInterval, this.maxPerDay}): super._();
  

@override final  Duration minInterval;
 final  int? maxPerDay;

/// Create a copy of DoseSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsNeededScheduleCopyWith<AsNeededSchedule> get copyWith => _$AsNeededScheduleCopyWithImpl<AsNeededSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsNeededSchedule&&(identical(other.minInterval, minInterval) || other.minInterval == minInterval)&&(identical(other.maxPerDay, maxPerDay) || other.maxPerDay == maxPerDay));
}


@override
int get hashCode => Object.hash(runtimeType,minInterval,maxPerDay);

@override
String toString() {
  return 'DoseSchedule.asNeeded(minInterval: $minInterval, maxPerDay: $maxPerDay)';
}


}

/// @nodoc
abstract mixin class $AsNeededScheduleCopyWith<$Res> implements $DoseScheduleCopyWith<$Res> {
  factory $AsNeededScheduleCopyWith(AsNeededSchedule value, $Res Function(AsNeededSchedule) _then) = _$AsNeededScheduleCopyWithImpl;
@override @useResult
$Res call({
 Duration minInterval, int? maxPerDay
});




}
/// @nodoc
class _$AsNeededScheduleCopyWithImpl<$Res>
    implements $AsNeededScheduleCopyWith<$Res> {
  _$AsNeededScheduleCopyWithImpl(this._self, this._then);

  final AsNeededSchedule _self;
  final $Res Function(AsNeededSchedule) _then;

/// Create a copy of DoseSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minInterval = null,Object? maxPerDay = freezed,}) {
  return _then(AsNeededSchedule(
minInterval: null == minInterval ? _self.minInterval : minInterval // ignore: cast_nullable_to_non_nullable
as Duration,maxPerDay: freezed == maxPerDay ? _self.maxPerDay : maxPerDay // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$ScheduleVersion {

 DoseSchedule get schedule; DateTime get effectiveFrom;
/// Create a copy of ScheduleVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleVersionCopyWith<ScheduleVersion> get copyWith => _$ScheduleVersionCopyWithImpl<ScheduleVersion>(this as ScheduleVersion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleVersion&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom));
}


@override
int get hashCode => Object.hash(runtimeType,schedule,effectiveFrom);

@override
String toString() {
  return 'ScheduleVersion(schedule: $schedule, effectiveFrom: $effectiveFrom)';
}


}

/// @nodoc
abstract mixin class $ScheduleVersionCopyWith<$Res>  {
  factory $ScheduleVersionCopyWith(ScheduleVersion value, $Res Function(ScheduleVersion) _then) = _$ScheduleVersionCopyWithImpl;
@useResult
$Res call({
 DoseSchedule schedule, DateTime effectiveFrom
});


$DoseScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$ScheduleVersionCopyWithImpl<$Res>
    implements $ScheduleVersionCopyWith<$Res> {
  _$ScheduleVersionCopyWithImpl(this._self, this._then);

  final ScheduleVersion _self;
  final $Res Function(ScheduleVersion) _then;

/// Create a copy of ScheduleVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schedule = null,Object? effectiveFrom = null,}) {
  return _then(_self.copyWith(
schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DoseSchedule,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ScheduleVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoseScheduleCopyWith<$Res> get schedule {
  
  return $DoseScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleVersion].
extension ScheduleVersionPatterns on ScheduleVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleVersion value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleVersion value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DoseSchedule schedule,  DateTime effectiveFrom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleVersion() when $default != null:
return $default(_that.schedule,_that.effectiveFrom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DoseSchedule schedule,  DateTime effectiveFrom)  $default,) {final _that = this;
switch (_that) {
case _ScheduleVersion():
return $default(_that.schedule,_that.effectiveFrom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DoseSchedule schedule,  DateTime effectiveFrom)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleVersion() when $default != null:
return $default(_that.schedule,_that.effectiveFrom);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleVersion implements ScheduleVersion {
  const _ScheduleVersion({required this.schedule, required this.effectiveFrom});
  

@override final  DoseSchedule schedule;
@override final  DateTime effectiveFrom;

/// Create a copy of ScheduleVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleVersionCopyWith<_ScheduleVersion> get copyWith => __$ScheduleVersionCopyWithImpl<_ScheduleVersion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleVersion&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom));
}


@override
int get hashCode => Object.hash(runtimeType,schedule,effectiveFrom);

@override
String toString() {
  return 'ScheduleVersion(schedule: $schedule, effectiveFrom: $effectiveFrom)';
}


}

/// @nodoc
abstract mixin class _$ScheduleVersionCopyWith<$Res> implements $ScheduleVersionCopyWith<$Res> {
  factory _$ScheduleVersionCopyWith(_ScheduleVersion value, $Res Function(_ScheduleVersion) _then) = __$ScheduleVersionCopyWithImpl;
@override @useResult
$Res call({
 DoseSchedule schedule, DateTime effectiveFrom
});


@override $DoseScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class __$ScheduleVersionCopyWithImpl<$Res>
    implements _$ScheduleVersionCopyWith<$Res> {
  __$ScheduleVersionCopyWithImpl(this._self, this._then);

  final _ScheduleVersion _self;
  final $Res Function(_ScheduleVersion) _then;

/// Create a copy of ScheduleVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schedule = null,Object? effectiveFrom = null,}) {
  return _then(_ScheduleVersion(
schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DoseSchedule,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ScheduleVersion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoseScheduleCopyWith<$Res> get schedule {
  
  return $DoseScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

// dart format on
