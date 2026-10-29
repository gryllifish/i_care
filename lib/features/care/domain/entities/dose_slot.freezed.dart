// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dose_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoseSlot {

 Medication get medication; DateTime get slotAt; DoseStatus get status;/// Doses recorded as given, in log order. More than one is a conflict
/// unless each later one was given knowing about the others.
 List<DoseGiven> get given; List<DoseSkipped> get skipped;/// An unreviewed conflict involves this dose.
 bool get hasConflict;
/// Create a copy of DoseSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseSlotCopyWith<DoseSlot> get copyWith => _$DoseSlotCopyWithImpl<DoseSlot>(this as DoseSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseSlot&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.given, given)&&const DeepCollectionEquality().equals(other.skipped, skipped)&&(identical(other.hasConflict, hasConflict) || other.hasConflict == hasConflict));
}


@override
int get hashCode => Object.hash(runtimeType,medication,slotAt,status,const DeepCollectionEquality().hash(given),const DeepCollectionEquality().hash(skipped),hasConflict);

@override
String toString() {
  return 'DoseSlot(medication: $medication, slotAt: $slotAt, status: $status, given: $given, skipped: $skipped, hasConflict: $hasConflict)';
}


}

/// @nodoc
abstract mixin class $DoseSlotCopyWith<$Res>  {
  factory $DoseSlotCopyWith(DoseSlot value, $Res Function(DoseSlot) _then) = _$DoseSlotCopyWithImpl;
@useResult
$Res call({
 Medication medication, DateTime slotAt, DoseStatus status, List<DoseGiven> given, List<DoseSkipped> skipped, bool hasConflict
});


$MedicationCopyWith<$Res> get medication;

}
/// @nodoc
class _$DoseSlotCopyWithImpl<$Res>
    implements $DoseSlotCopyWith<$Res> {
  _$DoseSlotCopyWithImpl(this._self, this._then);

  final DoseSlot _self;
  final $Res Function(DoseSlot) _then;

/// Create a copy of DoseSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medication = null,Object? slotAt = null,Object? status = null,Object? given = null,Object? skipped = null,Object? hasConflict = null,}) {
  return _then(_self.copyWith(
medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,given: null == given ? _self.given : given // ignore: cast_nullable_to_non_nullable
as List<DoseGiven>,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<DoseSkipped>,hasConflict: null == hasConflict ? _self.hasConflict : hasConflict // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DoseSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}
}


/// Adds pattern-matching-related methods to [DoseSlot].
extension DoseSlotPatterns on DoseSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoseSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoseSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoseSlot value)  $default,){
final _that = this;
switch (_that) {
case _DoseSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoseSlot value)?  $default,){
final _that = this;
switch (_that) {
case _DoseSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Medication medication,  DateTime slotAt,  DoseStatus status,  List<DoseGiven> given,  List<DoseSkipped> skipped,  bool hasConflict)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoseSlot() when $default != null:
return $default(_that.medication,_that.slotAt,_that.status,_that.given,_that.skipped,_that.hasConflict);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Medication medication,  DateTime slotAt,  DoseStatus status,  List<DoseGiven> given,  List<DoseSkipped> skipped,  bool hasConflict)  $default,) {final _that = this;
switch (_that) {
case _DoseSlot():
return $default(_that.medication,_that.slotAt,_that.status,_that.given,_that.skipped,_that.hasConflict);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Medication medication,  DateTime slotAt,  DoseStatus status,  List<DoseGiven> given,  List<DoseSkipped> skipped,  bool hasConflict)?  $default,) {final _that = this;
switch (_that) {
case _DoseSlot() when $default != null:
return $default(_that.medication,_that.slotAt,_that.status,_that.given,_that.skipped,_that.hasConflict);case _:
  return null;

}
}

}

/// @nodoc


class _DoseSlot extends DoseSlot {
  const _DoseSlot({required this.medication, required this.slotAt, required this.status, final  List<DoseGiven> given = const <DoseGiven>[], final  List<DoseSkipped> skipped = const <DoseSkipped>[], this.hasConflict = false}): _given = given,_skipped = skipped,super._();
  

@override final  Medication medication;
@override final  DateTime slotAt;
@override final  DoseStatus status;
/// Doses recorded as given, in log order. More than one is a conflict
/// unless each later one was given knowing about the others.
 final  List<DoseGiven> _given;
/// Doses recorded as given, in log order. More than one is a conflict
/// unless each later one was given knowing about the others.
@override@JsonKey() List<DoseGiven> get given {
  if (_given is EqualUnmodifiableListView) return _given;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_given);
}

 final  List<DoseSkipped> _skipped;
@override@JsonKey() List<DoseSkipped> get skipped {
  if (_skipped is EqualUnmodifiableListView) return _skipped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skipped);
}

/// An unreviewed conflict involves this dose.
@override@JsonKey() final  bool hasConflict;

/// Create a copy of DoseSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoseSlotCopyWith<_DoseSlot> get copyWith => __$DoseSlotCopyWithImpl<_DoseSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoseSlot&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._given, _given)&&const DeepCollectionEquality().equals(other._skipped, _skipped)&&(identical(other.hasConflict, hasConflict) || other.hasConflict == hasConflict));
}


@override
int get hashCode => Object.hash(runtimeType,medication,slotAt,status,const DeepCollectionEquality().hash(_given),const DeepCollectionEquality().hash(_skipped),hasConflict);

@override
String toString() {
  return 'DoseSlot(medication: $medication, slotAt: $slotAt, status: $status, given: $given, skipped: $skipped, hasConflict: $hasConflict)';
}


}

/// @nodoc
abstract mixin class _$DoseSlotCopyWith<$Res> implements $DoseSlotCopyWith<$Res> {
  factory _$DoseSlotCopyWith(_DoseSlot value, $Res Function(_DoseSlot) _then) = __$DoseSlotCopyWithImpl;
@override @useResult
$Res call({
 Medication medication, DateTime slotAt, DoseStatus status, List<DoseGiven> given, List<DoseSkipped> skipped, bool hasConflict
});


@override $MedicationCopyWith<$Res> get medication;

}
/// @nodoc
class __$DoseSlotCopyWithImpl<$Res>
    implements _$DoseSlotCopyWith<$Res> {
  __$DoseSlotCopyWithImpl(this._self, this._then);

  final _DoseSlot _self;
  final $Res Function(_DoseSlot) _then;

/// Create a copy of DoseSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medication = null,Object? slotAt = null,Object? status = null,Object? given = null,Object? skipped = null,Object? hasConflict = null,}) {
  return _then(_DoseSlot(
medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,given: null == given ? _self._given : given // ignore: cast_nullable_to_non_nullable
as List<DoseGiven>,skipped: null == skipped ? _self._skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<DoseSkipped>,hasConflict: null == hasConflict ? _self.hasConflict : hasConflict // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DoseSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}
}

// dart format on
