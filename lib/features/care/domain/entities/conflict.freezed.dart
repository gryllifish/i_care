// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conflict.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Conflict {

 String get key; String get medicationId;
/// Create a copy of Conflict
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictCopyWith<Conflict> get copyWith => _$ConflictCopyWithImpl<Conflict>(this as Conflict, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conflict&&(identical(other.key, key) || other.key == key)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId));
}


@override
int get hashCode => Object.hash(runtimeType,key,medicationId);

@override
String toString() {
  return 'Conflict(key: $key, medicationId: $medicationId)';
}


}

/// @nodoc
abstract mixin class $ConflictCopyWith<$Res>  {
  factory $ConflictCopyWith(Conflict value, $Res Function(Conflict) _then) = _$ConflictCopyWithImpl;
@useResult
$Res call({
 String key, String medicationId
});




}
/// @nodoc
class _$ConflictCopyWithImpl<$Res>
    implements $ConflictCopyWith<$Res> {
  _$ConflictCopyWithImpl(this._self, this._then);

  final Conflict _self;
  final $Res Function(Conflict) _then;

/// Create a copy of Conflict
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? medicationId = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Conflict].
extension ConflictPatterns on Conflict {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DoseConflict value)?  dose,TResult Function( EditConflict value)?  edit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DoseConflict() when dose != null:
return dose(_that);case EditConflict() when edit != null:
return edit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DoseConflict value)  dose,required TResult Function( EditConflict value)  edit,}){
final _that = this;
switch (_that) {
case DoseConflict():
return dose(_that);case EditConflict():
return edit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DoseConflict value)?  dose,TResult? Function( EditConflict value)?  edit,}){
final _that = this;
switch (_that) {
case DoseConflict() when dose != null:
return dose(_that);case EditConflict() when edit != null:
return edit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String key,  String medicationId,  List<DoseGiven> doses)?  dose,TResult Function( String key,  String medicationId,  List<CareEvent> changes)?  edit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DoseConflict() when dose != null:
return dose(_that.key,_that.medicationId,_that.doses);case EditConflict() when edit != null:
return edit(_that.key,_that.medicationId,_that.changes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String key,  String medicationId,  List<DoseGiven> doses)  dose,required TResult Function( String key,  String medicationId,  List<CareEvent> changes)  edit,}) {final _that = this;
switch (_that) {
case DoseConflict():
return dose(_that.key,_that.medicationId,_that.doses);case EditConflict():
return edit(_that.key,_that.medicationId,_that.changes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String key,  String medicationId,  List<DoseGiven> doses)?  dose,TResult? Function( String key,  String medicationId,  List<CareEvent> changes)?  edit,}) {final _that = this;
switch (_that) {
case DoseConflict() when dose != null:
return dose(_that.key,_that.medicationId,_that.doses);case EditConflict() when edit != null:
return edit(_that.key,_that.medicationId,_that.changes);case _:
  return null;

}
}

}

/// @nodoc


class DoseConflict implements Conflict {
  const DoseConflict({required this.key, required this.medicationId, required final  List<DoseGiven> doses}): _doses = doses;
  

@override final  String key;
@override final  String medicationId;
 final  List<DoseGiven> _doses;
 List<DoseGiven> get doses {
  if (_doses is EqualUnmodifiableListView) return _doses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_doses);
}


/// Create a copy of Conflict
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseConflictCopyWith<DoseConflict> get copyWith => _$DoseConflictCopyWithImpl<DoseConflict>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseConflict&&(identical(other.key, key) || other.key == key)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&const DeepCollectionEquality().equals(other._doses, _doses));
}


@override
int get hashCode => Object.hash(runtimeType,key,medicationId,const DeepCollectionEquality().hash(_doses));

@override
String toString() {
  return 'Conflict.dose(key: $key, medicationId: $medicationId, doses: $doses)';
}


}

/// @nodoc
abstract mixin class $DoseConflictCopyWith<$Res> implements $ConflictCopyWith<$Res> {
  factory $DoseConflictCopyWith(DoseConflict value, $Res Function(DoseConflict) _then) = _$DoseConflictCopyWithImpl;
@override @useResult
$Res call({
 String key, String medicationId, List<DoseGiven> doses
});




}
/// @nodoc
class _$DoseConflictCopyWithImpl<$Res>
    implements $DoseConflictCopyWith<$Res> {
  _$DoseConflictCopyWithImpl(this._self, this._then);

  final DoseConflict _self;
  final $Res Function(DoseConflict) _then;

/// Create a copy of Conflict
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? medicationId = null,Object? doses = null,}) {
  return _then(DoseConflict(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,doses: null == doses ? _self._doses : doses // ignore: cast_nullable_to_non_nullable
as List<DoseGiven>,
  ));
}


}

/// @nodoc


class EditConflict implements Conflict {
  const EditConflict({required this.key, required this.medicationId, required final  List<CareEvent> changes}): _changes = changes;
  

@override final  String key;
@override final  String medicationId;
 final  List<CareEvent> _changes;
 List<CareEvent> get changes {
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changes);
}


/// Create a copy of Conflict
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditConflictCopyWith<EditConflict> get copyWith => _$EditConflictCopyWithImpl<EditConflict>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditConflict&&(identical(other.key, key) || other.key == key)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&const DeepCollectionEquality().equals(other._changes, _changes));
}


@override
int get hashCode => Object.hash(runtimeType,key,medicationId,const DeepCollectionEquality().hash(_changes));

@override
String toString() {
  return 'Conflict.edit(key: $key, medicationId: $medicationId, changes: $changes)';
}


}

/// @nodoc
abstract mixin class $EditConflictCopyWith<$Res> implements $ConflictCopyWith<$Res> {
  factory $EditConflictCopyWith(EditConflict value, $Res Function(EditConflict) _then) = _$EditConflictCopyWithImpl;
@override @useResult
$Res call({
 String key, String medicationId, List<CareEvent> changes
});




}
/// @nodoc
class _$EditConflictCopyWithImpl<$Res>
    implements $EditConflictCopyWith<$Res> {
  _$EditConflictCopyWithImpl(this._self, this._then);

  final EditConflict _self;
  final $Res Function(EditConflict) _then;

/// Create a copy of Conflict
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? medicationId = null,Object? changes = null,}) {
  return _then(EditConflict(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<CareEvent>,
  ));
}


}

// dart format on
