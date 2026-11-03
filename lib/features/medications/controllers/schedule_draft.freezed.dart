// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleDraft {

 bool get isFixed;/// Minutes after midnight, ascending and without repeats.
 List<int> get times; bool get everyDay;/// `DateTime.monday`..`DateTime.sunday`; used when not [everyDay].
 Set<int> get days;/// Optional spacing for fixed times.
 Duration? get fixedMinInterval; Duration get asNeededInterval; int? get maxPerDay;
/// Create a copy of ScheduleDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDraftCopyWith<ScheduleDraft> get copyWith => _$ScheduleDraftCopyWithImpl<ScheduleDraft>(this as ScheduleDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScheduleDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDraft&&(identical(other.isFixed, _this.isFixed) || other.isFixed == _this.isFixed)&&const DeepCollectionEquality().equals(other.times, _this.times)&&(identical(other.everyDay, _this.everyDay) || other.everyDay == _this.everyDay)&&const DeepCollectionEquality().equals(other.days, _this.days)&&(identical(other.fixedMinInterval, _this.fixedMinInterval) || other.fixedMinInterval == _this.fixedMinInterval)&&(identical(other.asNeededInterval, _this.asNeededInterval) || other.asNeededInterval == _this.asNeededInterval)&&(identical(other.maxPerDay, _this.maxPerDay) || other.maxPerDay == _this.maxPerDay));
}


@override
int get hashCode {
  final _this = this as ScheduleDraft;
  return Object.hash(runtimeType,_this.isFixed,const DeepCollectionEquality().hash(_this.times),_this.everyDay,const DeepCollectionEquality().hash(_this.days),_this.fixedMinInterval,_this.asNeededInterval,_this.maxPerDay);
}

@override
String toString() {
  final _this = this as ScheduleDraft;
  return 'ScheduleDraft(isFixed: ${_this.isFixed}, times: ${_this.times}, everyDay: ${_this.everyDay}, days: ${_this.days}, fixedMinInterval: ${_this.fixedMinInterval}, asNeededInterval: ${_this.asNeededInterval}, maxPerDay: ${_this.maxPerDay})';
}


}

/// @nodoc
abstract mixin class $ScheduleDraftCopyWith<$Res>  {
  factory $ScheduleDraftCopyWith(ScheduleDraft value, $Res Function(ScheduleDraft) _then) = _$ScheduleDraftCopyWithImpl;
@useResult
$Res call({
 bool isFixed, List<int> times, bool everyDay, Set<int> days, Duration? fixedMinInterval, Duration asNeededInterval, int? maxPerDay
});




}
/// @nodoc
class _$ScheduleDraftCopyWithImpl<$Res>
    implements $ScheduleDraftCopyWith<$Res> {
  _$ScheduleDraftCopyWithImpl(this._self, this._then);

  final ScheduleDraft _self;
  final $Res Function(ScheduleDraft) _then;

/// Create a copy of ScheduleDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isFixed = null,Object? times = null,Object? everyDay = null,Object? days = null,Object? fixedMinInterval = freezed,Object? asNeededInterval = null,Object? maxPerDay = freezed,}) {
  return _then(ScheduleDraft(
isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<int>,everyDay: null == everyDay ? _self.everyDay : everyDay // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as Set<int>,fixedMinInterval: freezed == fixedMinInterval ? _self.fixedMinInterval : fixedMinInterval // ignore: cast_nullable_to_non_nullable
as Duration?,asNeededInterval: null == asNeededInterval ? _self.asNeededInterval : asNeededInterval // ignore: cast_nullable_to_non_nullable
as Duration,maxPerDay: freezed == maxPerDay ? _self.maxPerDay : maxPerDay // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDraft].
extension ScheduleDraftPatterns on ScheduleDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDraft value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isFixed,  List<int> times,  bool everyDay,  Set<int> days,  Duration? fixedMinInterval,  Duration asNeededInterval,  int? maxPerDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDraft() when $default != null:
return $default(_that.isFixed,_that.times,_that.everyDay,_that.days,_that.fixedMinInterval,_that.asNeededInterval,_that.maxPerDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isFixed,  List<int> times,  bool everyDay,  Set<int> days,  Duration? fixedMinInterval,  Duration asNeededInterval,  int? maxPerDay)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDraft():
return $default(_that.isFixed,_that.times,_that.everyDay,_that.days,_that.fixedMinInterval,_that.asNeededInterval,_that.maxPerDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isFixed,  List<int> times,  bool everyDay,  Set<int> days,  Duration? fixedMinInterval,  Duration asNeededInterval,  int? maxPerDay)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDraft() when $default != null:
return $default(_that.isFixed,_that.times,_that.everyDay,_that.days,_that.fixedMinInterval,_that.asNeededInterval,_that.maxPerDay);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleDraft extends ScheduleDraft {
  const _ScheduleDraft({this.isFixed = true,  List<int> times = const <int>[8 * 60], this.everyDay = true,  Set<int> days = const <int>{}, this.fixedMinInterval, this.asNeededInterval = const Duration(hours: 6), this.maxPerDay}): _times = times,_days = days,super._();
  

@override@JsonKey() final  bool isFixed;
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

/// Optional spacing for fixed times.
@override final  Duration? fixedMinInterval;
@override@JsonKey() final  Duration asNeededInterval;
@override final  int? maxPerDay;

/// Create a copy of ScheduleDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDraftCopyWith<_ScheduleDraft> get copyWith => __$ScheduleDraftCopyWithImpl<_ScheduleDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDraft&&(identical(other.isFixed, isFixed) || other.isFixed == isFixed)&&const DeepCollectionEquality().equals(other.times, _times)&&(identical(other.everyDay, everyDay) || other.everyDay == everyDay)&&const DeepCollectionEquality().equals(other.days, _days)&&(identical(other.fixedMinInterval, fixedMinInterval) || other.fixedMinInterval == fixedMinInterval)&&(identical(other.asNeededInterval, asNeededInterval) || other.asNeededInterval == asNeededInterval)&&(identical(other.maxPerDay, maxPerDay) || other.maxPerDay == maxPerDay));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isFixed,const DeepCollectionEquality().hash(_times),everyDay,const DeepCollectionEquality().hash(_days),fixedMinInterval,asNeededInterval,maxPerDay);
}

@override
String toString() {
    return 'ScheduleDraft(isFixed: $isFixed, times: $times, everyDay: $everyDay, days: $days, fixedMinInterval: $fixedMinInterval, asNeededInterval: $asNeededInterval, maxPerDay: $maxPerDay)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDraftCopyWith<$Res> implements $ScheduleDraftCopyWith<$Res> {
  factory _$ScheduleDraftCopyWith(_ScheduleDraft value, $Res Function(_ScheduleDraft) _then) = __$ScheduleDraftCopyWithImpl;
@override @useResult
$Res call({
 bool isFixed, List<int> times, bool everyDay, Set<int> days, Duration? fixedMinInterval, Duration asNeededInterval, int? maxPerDay
});




}
/// @nodoc
class __$ScheduleDraftCopyWithImpl<$Res>
    implements _$ScheduleDraftCopyWith<$Res> {
  __$ScheduleDraftCopyWithImpl(this._self, this._then);

  final _ScheduleDraft _self;
  final $Res Function(_ScheduleDraft) _then;

/// Create a copy of ScheduleDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isFixed = null,Object? times = null,Object? everyDay = null,Object? days = null,Object? fixedMinInterval = freezed,Object? asNeededInterval = null,Object? maxPerDay = freezed,}) {
  return _then(_ScheduleDraft(
isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<int>,everyDay: null == everyDay ? _self.everyDay : everyDay // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as Set<int>,fixedMinInterval: freezed == fixedMinInterval ? _self.fixedMinInterval : fixedMinInterval // ignore: cast_nullable_to_non_nullable
as Duration?,asNeededInterval: null == asNeededInterval ? _self.asNeededInterval : asNeededInterval // ignore: cast_nullable_to_non_nullable
as Duration,maxPerDay: freezed == maxPerDay ? _self.maxPerDay : maxPerDay // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
