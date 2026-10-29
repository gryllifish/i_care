// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicationDetails {

 String get name;/// Free text as written on the box, e.g. "500 mg".
 String get strength; MedicationForm get form;/// Free text from the prescription, e.g. "With food".
 String get instructions;/// Units taken per dose; fractional for half tablets.
 double get unitsPerDose;/// Stock counts as low when it lasts this many days or fewer.
 int get lowStockDays;
/// Create a copy of MedicationDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationDetailsCopyWith<MedicationDetails> get copyWith => _$MedicationDetailsCopyWithImpl<MedicationDetails>(this as MedicationDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationDetails&&(identical(other.name, name) || other.name == name)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.unitsPerDose, unitsPerDose) || other.unitsPerDose == unitsPerDose)&&(identical(other.lowStockDays, lowStockDays) || other.lowStockDays == lowStockDays));
}


@override
int get hashCode => Object.hash(runtimeType,name,strength,form,instructions,unitsPerDose,lowStockDays);

@override
String toString() {
  return 'MedicationDetails(name: $name, strength: $strength, form: $form, instructions: $instructions, unitsPerDose: $unitsPerDose, lowStockDays: $lowStockDays)';
}


}

/// @nodoc
abstract mixin class $MedicationDetailsCopyWith<$Res>  {
  factory $MedicationDetailsCopyWith(MedicationDetails value, $Res Function(MedicationDetails) _then) = _$MedicationDetailsCopyWithImpl;
@useResult
$Res call({
 String name, String strength, MedicationForm form, String instructions, double unitsPerDose, int lowStockDays
});




}
/// @nodoc
class _$MedicationDetailsCopyWithImpl<$Res>
    implements $MedicationDetailsCopyWith<$Res> {
  _$MedicationDetailsCopyWithImpl(this._self, this._then);

  final MedicationDetails _self;
  final $Res Function(MedicationDetails) _then;

/// Create a copy of MedicationDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? strength = null,Object? form = null,Object? instructions = null,Object? unitsPerDose = null,Object? lowStockDays = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,unitsPerDose: null == unitsPerDose ? _self.unitsPerDose : unitsPerDose // ignore: cast_nullable_to_non_nullable
as double,lowStockDays: null == lowStockDays ? _self.lowStockDays : lowStockDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationDetails].
extension MedicationDetailsPatterns on MedicationDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationDetails value)  $default,){
final _that = this;
switch (_that) {
case _MedicationDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationDetails value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String strength,  MedicationForm form,  String instructions,  double unitsPerDose,  int lowStockDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationDetails() when $default != null:
return $default(_that.name,_that.strength,_that.form,_that.instructions,_that.unitsPerDose,_that.lowStockDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String strength,  MedicationForm form,  String instructions,  double unitsPerDose,  int lowStockDays)  $default,) {final _that = this;
switch (_that) {
case _MedicationDetails():
return $default(_that.name,_that.strength,_that.form,_that.instructions,_that.unitsPerDose,_that.lowStockDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String strength,  MedicationForm form,  String instructions,  double unitsPerDose,  int lowStockDays)?  $default,) {final _that = this;
switch (_that) {
case _MedicationDetails() when $default != null:
return $default(_that.name,_that.strength,_that.form,_that.instructions,_that.unitsPerDose,_that.lowStockDays);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationDetails implements MedicationDetails {
  const _MedicationDetails({required this.name, required this.strength, required this.form, this.instructions = '', this.unitsPerDose = 1, this.lowStockDays = 7});
  

@override final  String name;
/// Free text as written on the box, e.g. "500 mg".
@override final  String strength;
@override final  MedicationForm form;
/// Free text from the prescription, e.g. "With food".
@override@JsonKey() final  String instructions;
/// Units taken per dose; fractional for half tablets.
@override@JsonKey() final  double unitsPerDose;
/// Stock counts as low when it lasts this many days or fewer.
@override@JsonKey() final  int lowStockDays;

/// Create a copy of MedicationDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationDetailsCopyWith<_MedicationDetails> get copyWith => __$MedicationDetailsCopyWithImpl<_MedicationDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationDetails&&(identical(other.name, name) || other.name == name)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.unitsPerDose, unitsPerDose) || other.unitsPerDose == unitsPerDose)&&(identical(other.lowStockDays, lowStockDays) || other.lowStockDays == lowStockDays));
}


@override
int get hashCode => Object.hash(runtimeType,name,strength,form,instructions,unitsPerDose,lowStockDays);

@override
String toString() {
  return 'MedicationDetails(name: $name, strength: $strength, form: $form, instructions: $instructions, unitsPerDose: $unitsPerDose, lowStockDays: $lowStockDays)';
}


}

/// @nodoc
abstract mixin class _$MedicationDetailsCopyWith<$Res> implements $MedicationDetailsCopyWith<$Res> {
  factory _$MedicationDetailsCopyWith(_MedicationDetails value, $Res Function(_MedicationDetails) _then) = __$MedicationDetailsCopyWithImpl;
@override @useResult
$Res call({
 String name, String strength, MedicationForm form, String instructions, double unitsPerDose, int lowStockDays
});




}
/// @nodoc
class __$MedicationDetailsCopyWithImpl<$Res>
    implements _$MedicationDetailsCopyWith<$Res> {
  __$MedicationDetailsCopyWithImpl(this._self, this._then);

  final _MedicationDetails _self;
  final $Res Function(_MedicationDetails) _then;

/// Create a copy of MedicationDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? strength = null,Object? form = null,Object? instructions = null,Object? unitsPerDose = null,Object? lowStockDays = null,}) {
  return _then(_MedicationDetails(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,unitsPerDose: null == unitsPerDose ? _self.unitsPerDose : unitsPerDose // ignore: cast_nullable_to_non_nullable
as double,lowStockDays: null == lowStockDays ? _self.lowStockDays : lowStockDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Medication {

 String get id; MedicationDetails get details;/// Ascending by `effectiveFrom`; never empty.
 List<ScheduleVersion> get schedules; bool get isArchived;/// Number of changes applied. Edits carry the version they started
/// from, so concurrent edits can be detected.
 int get version;
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCopyWith<Medication> get copyWith => _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other.schedules, schedules)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,details,const DeepCollectionEquality().hash(schedules),isArchived,version);

@override
String toString() {
  return 'Medication(id: $id, details: $details, schedules: $schedules, isArchived: $isArchived, version: $version)';
}


}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res>  {
  factory $MedicationCopyWith(Medication value, $Res Function(Medication) _then) = _$MedicationCopyWithImpl;
@useResult
$Res call({
 String id, MedicationDetails details, List<ScheduleVersion> schedules, bool isArchived, int version
});


$MedicationDetailsCopyWith<$Res> get details;

}
/// @nodoc
class _$MedicationCopyWithImpl<$Res>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? details = null,Object? schedules = null,Object? isArchived = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as MedicationDetails,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ScheduleVersion>,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDetailsCopyWith<$Res> get details {
  
  return $MedicationDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}


/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medication value)  $default,){
final _that = this;
switch (_that) {
case _Medication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medication value)?  $default,){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MedicationDetails details,  List<ScheduleVersion> schedules,  bool isArchived,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.details,_that.schedules,_that.isArchived,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MedicationDetails details,  List<ScheduleVersion> schedules,  bool isArchived,  int version)  $default,) {final _that = this;
switch (_that) {
case _Medication():
return $default(_that.id,_that.details,_that.schedules,_that.isArchived,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MedicationDetails details,  List<ScheduleVersion> schedules,  bool isArchived,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.details,_that.schedules,_that.isArchived,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _Medication extends Medication {
  const _Medication({required this.id, required this.details, required final  List<ScheduleVersion> schedules, this.isArchived = false, this.version = 0}): _schedules = schedules,super._();
  

@override final  String id;
@override final  MedicationDetails details;
/// Ascending by `effectiveFrom`; never empty.
 final  List<ScheduleVersion> _schedules;
/// Ascending by `effectiveFrom`; never empty.
@override List<ScheduleVersion> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

@override@JsonKey() final  bool isArchived;
/// Number of changes applied. Edits carry the version they started
/// from, so concurrent edits can be detected.
@override@JsonKey() final  int version;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCopyWith<_Medication> get copyWith => __$MedicationCopyWithImpl<_Medication>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,details,const DeepCollectionEquality().hash(_schedules),isArchived,version);

@override
String toString() {
  return 'Medication(id: $id, details: $details, schedules: $schedules, isArchived: $isArchived, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res> implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(_Medication value, $Res Function(_Medication) _then) = __$MedicationCopyWithImpl;
@override @useResult
$Res call({
 String id, MedicationDetails details, List<ScheduleVersion> schedules, bool isArchived, int version
});


@override $MedicationDetailsCopyWith<$Res> get details;

}
/// @nodoc
class __$MedicationCopyWithImpl<$Res>
    implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? details = null,Object? schedules = null,Object? isArchived = null,Object? version = null,}) {
  return _then(_Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as MedicationDetails,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<ScheduleVersion>,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDetailsCopyWith<$Res> get details {
  
  return $MedicationDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

// dart format on
