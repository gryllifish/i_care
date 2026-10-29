// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipient_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CareContact {

 String get name;/// Specialty for doctors, relationship for relatives.
 String get role; String get phone;
/// Create a copy of CareContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareContactCopyWith<CareContact> get copyWith => _$CareContactCopyWithImpl<CareContact>(this as CareContact, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareContact&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,name,role,phone);

@override
String toString() {
  return 'CareContact(name: $name, role: $role, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $CareContactCopyWith<$Res>  {
  factory $CareContactCopyWith(CareContact value, $Res Function(CareContact) _then) = _$CareContactCopyWithImpl;
@useResult
$Res call({
 String name, String role, String phone
});




}
/// @nodoc
class _$CareContactCopyWithImpl<$Res>
    implements $CareContactCopyWith<$Res> {
  _$CareContactCopyWithImpl(this._self, this._then);

  final CareContact _self;
  final $Res Function(CareContact) _then;

/// Create a copy of CareContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? role = null,Object? phone = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CareContact].
extension CareContactPatterns on CareContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareContact value)  $default,){
final _that = this;
switch (_that) {
case _CareContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareContact value)?  $default,){
final _that = this;
switch (_that) {
case _CareContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String role,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareContact() when $default != null:
return $default(_that.name,_that.role,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String role,  String phone)  $default,) {final _that = this;
switch (_that) {
case _CareContact():
return $default(_that.name,_that.role,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String role,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _CareContact() when $default != null:
return $default(_that.name,_that.role,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _CareContact implements CareContact {
  const _CareContact({required this.name, this.role = '', this.phone = ''});
  

@override final  String name;
/// Specialty for doctors, relationship for relatives.
@override@JsonKey() final  String role;
@override@JsonKey() final  String phone;

/// Create a copy of CareContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareContactCopyWith<_CareContact> get copyWith => __$CareContactCopyWithImpl<_CareContact>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareContact&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,name,role,phone);

@override
String toString() {
  return 'CareContact(name: $name, role: $role, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$CareContactCopyWith<$Res> implements $CareContactCopyWith<$Res> {
  factory _$CareContactCopyWith(_CareContact value, $Res Function(_CareContact) _then) = __$CareContactCopyWithImpl;
@override @useResult
$Res call({
 String name, String role, String phone
});




}
/// @nodoc
class __$CareContactCopyWithImpl<$Res>
    implements _$CareContactCopyWith<$Res> {
  __$CareContactCopyWithImpl(this._self, this._then);

  final _CareContact _self;
  final $Res Function(_CareContact) _then;

/// Create a copy of CareContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? role = null,Object? phone = null,}) {
  return _then(_CareContact(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RecipientProfile {

 String get name; DateTime? get birthDate;/// Free text, one per line, shown first and in red.
 String get allergies; String get conditions; List<CareContact> get doctors; List<CareContact> get contacts; String get notes;
/// Create a copy of RecipientProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipientProfileCopyWith<RecipientProfile> get copyWith => _$RecipientProfileCopyWithImpl<RecipientProfile>(this as RecipientProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipientProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&const DeepCollectionEquality().equals(other.doctors, doctors)&&const DeepCollectionEquality().equals(other.contacts, contacts)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,name,birthDate,allergies,conditions,const DeepCollectionEquality().hash(doctors),const DeepCollectionEquality().hash(contacts),notes);

@override
String toString() {
  return 'RecipientProfile(name: $name, birthDate: $birthDate, allergies: $allergies, conditions: $conditions, doctors: $doctors, contacts: $contacts, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RecipientProfileCopyWith<$Res>  {
  factory $RecipientProfileCopyWith(RecipientProfile value, $Res Function(RecipientProfile) _then) = _$RecipientProfileCopyWithImpl;
@useResult
$Res call({
 String name, DateTime? birthDate, String allergies, String conditions, List<CareContact> doctors, List<CareContact> contacts, String notes
});




}
/// @nodoc
class _$RecipientProfileCopyWithImpl<$Res>
    implements $RecipientProfileCopyWith<$Res> {
  _$RecipientProfileCopyWithImpl(this._self, this._then);

  final RecipientProfile _self;
  final $Res Function(RecipientProfile) _then;

/// Create a copy of RecipientProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? birthDate = freezed,Object? allergies = null,Object? conditions = null,Object? doctors = null,Object? contacts = null,Object? notes = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String,doctors: null == doctors ? _self.doctors : doctors // ignore: cast_nullable_to_non_nullable
as List<CareContact>,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<CareContact>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipientProfile].
extension RecipientProfilePatterns on RecipientProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipientProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipientProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipientProfile value)  $default,){
final _that = this;
switch (_that) {
case _RecipientProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipientProfile value)?  $default,){
final _that = this;
switch (_that) {
case _RecipientProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DateTime? birthDate,  String allergies,  String conditions,  List<CareContact> doctors,  List<CareContact> contacts,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipientProfile() when $default != null:
return $default(_that.name,_that.birthDate,_that.allergies,_that.conditions,_that.doctors,_that.contacts,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DateTime? birthDate,  String allergies,  String conditions,  List<CareContact> doctors,  List<CareContact> contacts,  String notes)  $default,) {final _that = this;
switch (_that) {
case _RecipientProfile():
return $default(_that.name,_that.birthDate,_that.allergies,_that.conditions,_that.doctors,_that.contacts,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DateTime? birthDate,  String allergies,  String conditions,  List<CareContact> doctors,  List<CareContact> contacts,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _RecipientProfile() when $default != null:
return $default(_that.name,_that.birthDate,_that.allergies,_that.conditions,_that.doctors,_that.contacts,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _RecipientProfile extends RecipientProfile {
  const _RecipientProfile({required this.name, this.birthDate, this.allergies = '', this.conditions = '', final  List<CareContact> doctors = const <CareContact>[], final  List<CareContact> contacts = const <CareContact>[], this.notes = ''}): _doctors = doctors,_contacts = contacts,super._();
  

@override final  String name;
@override final  DateTime? birthDate;
/// Free text, one per line, shown first and in red.
@override@JsonKey() final  String allergies;
@override@JsonKey() final  String conditions;
 final  List<CareContact> _doctors;
@override@JsonKey() List<CareContact> get doctors {
  if (_doctors is EqualUnmodifiableListView) return _doctors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_doctors);
}

 final  List<CareContact> _contacts;
@override@JsonKey() List<CareContact> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

@override@JsonKey() final  String notes;

/// Create a copy of RecipientProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipientProfileCopyWith<_RecipientProfile> get copyWith => __$RecipientProfileCopyWithImpl<_RecipientProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipientProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&const DeepCollectionEquality().equals(other._doctors, _doctors)&&const DeepCollectionEquality().equals(other._contacts, _contacts)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,name,birthDate,allergies,conditions,const DeepCollectionEquality().hash(_doctors),const DeepCollectionEquality().hash(_contacts),notes);

@override
String toString() {
  return 'RecipientProfile(name: $name, birthDate: $birthDate, allergies: $allergies, conditions: $conditions, doctors: $doctors, contacts: $contacts, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RecipientProfileCopyWith<$Res> implements $RecipientProfileCopyWith<$Res> {
  factory _$RecipientProfileCopyWith(_RecipientProfile value, $Res Function(_RecipientProfile) _then) = __$RecipientProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, DateTime? birthDate, String allergies, String conditions, List<CareContact> doctors, List<CareContact> contacts, String notes
});




}
/// @nodoc
class __$RecipientProfileCopyWithImpl<$Res>
    implements _$RecipientProfileCopyWith<$Res> {
  __$RecipientProfileCopyWithImpl(this._self, this._then);

  final _RecipientProfile _self;
  final $Res Function(_RecipientProfile) _then;

/// Create a copy of RecipientProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? birthDate = freezed,Object? allergies = null,Object? conditions = null,Object? doctors = null,Object? contacts = null,Object? notes = null,}) {
  return _then(_RecipientProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String,doctors: null == doctors ? _self._doctors : doctors // ignore: cast_nullable_to_non_nullable
as List<CareContact>,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<CareContact>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
