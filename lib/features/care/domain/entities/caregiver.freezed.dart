// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'caregiver.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Caregiver {

 String get id; String get name;/// Index into the avatar palette, stable across devices.
 int get colorIndex;
/// Create a copy of Caregiver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaregiverCopyWith<Caregiver> get copyWith => _$CaregiverCopyWithImpl<Caregiver>(this as Caregiver, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Caregiver&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorIndex);

@override
String toString() {
  return 'Caregiver(id: $id, name: $name, colorIndex: $colorIndex)';
}


}

/// @nodoc
abstract mixin class $CaregiverCopyWith<$Res>  {
  factory $CaregiverCopyWith(Caregiver value, $Res Function(Caregiver) _then) = _$CaregiverCopyWithImpl;
@useResult
$Res call({
 String id, String name, int colorIndex
});




}
/// @nodoc
class _$CaregiverCopyWithImpl<$Res>
    implements $CaregiverCopyWith<$Res> {
  _$CaregiverCopyWithImpl(this._self, this._then);

  final Caregiver _self;
  final $Res Function(Caregiver) _then;

/// Create a copy of Caregiver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? colorIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Caregiver].
extension CaregiverPatterns on Caregiver {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Caregiver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Caregiver() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Caregiver value)  $default,){
final _that = this;
switch (_that) {
case _Caregiver():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Caregiver value)?  $default,){
final _that = this;
switch (_that) {
case _Caregiver() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int colorIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Caregiver() when $default != null:
return $default(_that.id,_that.name,_that.colorIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int colorIndex)  $default,) {final _that = this;
switch (_that) {
case _Caregiver():
return $default(_that.id,_that.name,_that.colorIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int colorIndex)?  $default,) {final _that = this;
switch (_that) {
case _Caregiver() when $default != null:
return $default(_that.id,_that.name,_that.colorIndex);case _:
  return null;

}
}

}

/// @nodoc


class _Caregiver implements Caregiver {
  const _Caregiver({required this.id, required this.name, required this.colorIndex});
  

@override final  String id;
@override final  String name;
/// Index into the avatar palette, stable across devices.
@override final  int colorIndex;

/// Create a copy of Caregiver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaregiverCopyWith<_Caregiver> get copyWith => __$CaregiverCopyWithImpl<_Caregiver>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Caregiver&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorIndex);

@override
String toString() {
  return 'Caregiver(id: $id, name: $name, colorIndex: $colorIndex)';
}


}

/// @nodoc
abstract mixin class _$CaregiverCopyWith<$Res> implements $CaregiverCopyWith<$Res> {
  factory _$CaregiverCopyWith(_Caregiver value, $Res Function(_Caregiver) _then) = __$CaregiverCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int colorIndex
});




}
/// @nodoc
class __$CaregiverCopyWithImpl<$Res>
    implements _$CaregiverCopyWith<$Res> {
  __$CaregiverCopyWithImpl(this._self, this._then);

  final _Caregiver _self;
  final $Res Function(_Caregiver) _then;

/// Create a copy of Caregiver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? colorIndex = null,}) {
  return _then(_Caregiver(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
