// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_level.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockLevel {

 double get units;/// Whole days the stock lasts on the current schedule; null when it
/// depends on need.
 int? get daysLeft; bool get isLow;
/// Create a copy of StockLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockLevelCopyWith<StockLevel> get copyWith => _$StockLevelCopyWithImpl<StockLevel>(this as StockLevel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StockLevel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockLevel&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.daysLeft, _this.daysLeft) || other.daysLeft == _this.daysLeft)&&(identical(other.isLow, _this.isLow) || other.isLow == _this.isLow));
}


@override
int get hashCode {
  final _this = this as StockLevel;
  return Object.hash(runtimeType,_this.units,_this.daysLeft,_this.isLow);
}

@override
String toString() {
  final _this = this as StockLevel;
  return 'StockLevel(units: ${_this.units}, daysLeft: ${_this.daysLeft}, isLow: ${_this.isLow})';
}


}

/// @nodoc
abstract mixin class $StockLevelCopyWith<$Res>  {
  factory $StockLevelCopyWith(StockLevel value, $Res Function(StockLevel) _then) = _$StockLevelCopyWithImpl;
@useResult
$Res call({
 double units, int? daysLeft, bool isLow
});




}
/// @nodoc
class _$StockLevelCopyWithImpl<$Res>
    implements $StockLevelCopyWith<$Res> {
  _$StockLevelCopyWithImpl(this._self, this._then);

  final StockLevel _self;
  final $Res Function(StockLevel) _then;

/// Create a copy of StockLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? daysLeft = freezed,Object? isLow = null,}) {
  return _then(StockLevel(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,isLow: null == isLow ? _self.isLow : isLow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StockLevel].
extension StockLevelPatterns on StockLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockLevel value)  $default,){
final _that = this;
switch (_that) {
case _StockLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockLevel value)?  $default,){
final _that = this;
switch (_that) {
case _StockLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double units,  int? daysLeft,  bool isLow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockLevel() when $default != null:
return $default(_that.units,_that.daysLeft,_that.isLow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double units,  int? daysLeft,  bool isLow)  $default,) {final _that = this;
switch (_that) {
case _StockLevel():
return $default(_that.units,_that.daysLeft,_that.isLow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double units,  int? daysLeft,  bool isLow)?  $default,) {final _that = this;
switch (_that) {
case _StockLevel() when $default != null:
return $default(_that.units,_that.daysLeft,_that.isLow);case _:
  return null;

}
}

}

/// @nodoc


class _StockLevel implements StockLevel {
  const _StockLevel({required this.units, this.daysLeft, this.isLow = false});
  

@override final  double units;
/// Whole days the stock lasts on the current schedule; null when it
/// depends on need.
@override final  int? daysLeft;
@override@JsonKey() final  bool isLow;

/// Create a copy of StockLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockLevelCopyWith<_StockLevel> get copyWith => __$StockLevelCopyWithImpl<_StockLevel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockLevel&&(identical(other.units, units) || other.units == units)&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft)&&(identical(other.isLow, isLow) || other.isLow == isLow));
}


@override
int get hashCode {
    return Object.hash(runtimeType,units,daysLeft,isLow);
}

@override
String toString() {
    return 'StockLevel(units: $units, daysLeft: $daysLeft, isLow: $isLow)';
}


}

/// @nodoc
abstract mixin class _$StockLevelCopyWith<$Res> implements $StockLevelCopyWith<$Res> {
  factory _$StockLevelCopyWith(_StockLevel value, $Res Function(_StockLevel) _then) = __$StockLevelCopyWithImpl;
@override @useResult
$Res call({
 double units, int? daysLeft, bool isLow
});




}
/// @nodoc
class __$StockLevelCopyWithImpl<$Res>
    implements _$StockLevelCopyWith<$Res> {
  __$StockLevelCopyWithImpl(this._self, this._then);

  final _StockLevel _self;
  final $Res Function(_StockLevel) _then;

/// Create a copy of StockLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? daysLeft = freezed,Object? isLow = null,}) {
  return _then(_StockLevel(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,daysLeft: freezed == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int?,isLow: null == isLow ? _self.isLow : isLow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
