// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicationDetail {

 Medication get medication; StockLevel? get stock;/// Latest doses given, newest first.
 List<DoseGiven> get recentDoses;/// Concurrent edits to this medication nobody has reviewed.
 List<EditConflict> get conflicts;
/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationDetailCopyWith<MedicationDetail> get copyWith => _$MedicationDetailCopyWithImpl<MedicationDetail>(this as MedicationDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationDetail&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other.recentDoses, recentDoses)&&const DeepCollectionEquality().equals(other.conflicts, conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,medication,stock,const DeepCollectionEquality().hash(recentDoses),const DeepCollectionEquality().hash(conflicts));

@override
String toString() {
  return 'MedicationDetail(medication: $medication, stock: $stock, recentDoses: $recentDoses, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class $MedicationDetailCopyWith<$Res>  {
  factory $MedicationDetailCopyWith(MedicationDetail value, $Res Function(MedicationDetail) _then) = _$MedicationDetailCopyWithImpl;
@useResult
$Res call({
 Medication medication, StockLevel? stock, List<DoseGiven> recentDoses, List<EditConflict> conflicts
});


$MedicationCopyWith<$Res> get medication;$StockLevelCopyWith<$Res>? get stock;

}
/// @nodoc
class _$MedicationDetailCopyWithImpl<$Res>
    implements $MedicationDetailCopyWith<$Res> {
  _$MedicationDetailCopyWithImpl(this._self, this._then);

  final MedicationDetail _self;
  final $Res Function(MedicationDetail) _then;

/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medication = null,Object? stock = freezed,Object? recentDoses = null,Object? conflicts = null,}) {
  return _then(_self.copyWith(
medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockLevel?,recentDoses: null == recentDoses ? _self.recentDoses : recentDoses // ignore: cast_nullable_to_non_nullable
as List<DoseGiven>,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<EditConflict>,
  ));
}
/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockLevelCopyWith<$Res>? get stock {
    if (_self.stock == null) {
    return null;
  }

  return $StockLevelCopyWith<$Res>(_self.stock!, (value) {
    return _then(_self.copyWith(stock: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicationDetail].
extension MedicationDetailPatterns on MedicationDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationDetail value)  $default,){
final _that = this;
switch (_that) {
case _MedicationDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Medication medication,  StockLevel? stock,  List<DoseGiven> recentDoses,  List<EditConflict> conflicts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationDetail() when $default != null:
return $default(_that.medication,_that.stock,_that.recentDoses,_that.conflicts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Medication medication,  StockLevel? stock,  List<DoseGiven> recentDoses,  List<EditConflict> conflicts)  $default,) {final _that = this;
switch (_that) {
case _MedicationDetail():
return $default(_that.medication,_that.stock,_that.recentDoses,_that.conflicts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Medication medication,  StockLevel? stock,  List<DoseGiven> recentDoses,  List<EditConflict> conflicts)?  $default,) {final _that = this;
switch (_that) {
case _MedicationDetail() when $default != null:
return $default(_that.medication,_that.stock,_that.recentDoses,_that.conflicts);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationDetail implements MedicationDetail {
  const _MedicationDetail({required this.medication, this.stock, final  List<DoseGiven> recentDoses = const <DoseGiven>[], final  List<EditConflict> conflicts = const <EditConflict>[]}): _recentDoses = recentDoses,_conflicts = conflicts;
  

@override final  Medication medication;
@override final  StockLevel? stock;
/// Latest doses given, newest first.
 final  List<DoseGiven> _recentDoses;
/// Latest doses given, newest first.
@override@JsonKey() List<DoseGiven> get recentDoses {
  if (_recentDoses is EqualUnmodifiableListView) return _recentDoses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentDoses);
}

/// Concurrent edits to this medication nobody has reviewed.
 final  List<EditConflict> _conflicts;
/// Concurrent edits to this medication nobody has reviewed.
@override@JsonKey() List<EditConflict> get conflicts {
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conflicts);
}


/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationDetailCopyWith<_MedicationDetail> get copyWith => __$MedicationDetailCopyWithImpl<_MedicationDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationDetail&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other._recentDoses, _recentDoses)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,medication,stock,const DeepCollectionEquality().hash(_recentDoses),const DeepCollectionEquality().hash(_conflicts));

@override
String toString() {
  return 'MedicationDetail(medication: $medication, stock: $stock, recentDoses: $recentDoses, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class _$MedicationDetailCopyWith<$Res> implements $MedicationDetailCopyWith<$Res> {
  factory _$MedicationDetailCopyWith(_MedicationDetail value, $Res Function(_MedicationDetail) _then) = __$MedicationDetailCopyWithImpl;
@override @useResult
$Res call({
 Medication medication, StockLevel? stock, List<DoseGiven> recentDoses, List<EditConflict> conflicts
});


@override $MedicationCopyWith<$Res> get medication;@override $StockLevelCopyWith<$Res>? get stock;

}
/// @nodoc
class __$MedicationDetailCopyWithImpl<$Res>
    implements _$MedicationDetailCopyWith<$Res> {
  __$MedicationDetailCopyWithImpl(this._self, this._then);

  final _MedicationDetail _self;
  final $Res Function(_MedicationDetail) _then;

/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medication = null,Object? stock = freezed,Object? recentDoses = null,Object? conflicts = null,}) {
  return _then(_MedicationDetail(
medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockLevel?,recentDoses: null == recentDoses ? _self._recentDoses : recentDoses // ignore: cast_nullable_to_non_nullable
as List<DoseGiven>,conflicts: null == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<EditConflict>,
  ));
}

/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}/// Create a copy of MedicationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockLevelCopyWith<$Res>? get stock {
    if (_self.stock == null) {
    return null;
  }

  return $StockLevelCopyWith<$Res>(_self.stock!, (value) {
    return _then(_self.copyWith(stock: value));
  });
}
}

// dart format on
