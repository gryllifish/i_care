// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmergencyCard {

/// Null until someone fills it in.
 RecipientProfile? get profile; int get profileVersion;/// Active medications, from the log, so the card never goes stale.
 List<Medication> get medications; List<EditConflict> get conflicts;
/// Create a copy of EmergencyCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyCardCopyWith<EmergencyCard> get copyWith => _$EmergencyCardCopyWithImpl<EmergencyCard>(this as EmergencyCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyCard&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.profileVersion, profileVersion) || other.profileVersion == profileVersion)&&const DeepCollectionEquality().equals(other.medications, medications)&&const DeepCollectionEquality().equals(other.conflicts, conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,profile,profileVersion,const DeepCollectionEquality().hash(medications),const DeepCollectionEquality().hash(conflicts));

@override
String toString() {
  return 'EmergencyCard(profile: $profile, profileVersion: $profileVersion, medications: $medications, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class $EmergencyCardCopyWith<$Res>  {
  factory $EmergencyCardCopyWith(EmergencyCard value, $Res Function(EmergencyCard) _then) = _$EmergencyCardCopyWithImpl;
@useResult
$Res call({
 RecipientProfile? profile, int profileVersion, List<Medication> medications, List<EditConflict> conflicts
});


$RecipientProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$EmergencyCardCopyWithImpl<$Res>
    implements $EmergencyCardCopyWith<$Res> {
  _$EmergencyCardCopyWithImpl(this._self, this._then);

  final EmergencyCard _self;
  final $Res Function(EmergencyCard) _then;

/// Create a copy of EmergencyCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? profileVersion = null,Object? medications = null,Object? conflicts = null,}) {
  return _then(_self.copyWith(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as RecipientProfile?,profileVersion: null == profileVersion ? _self.profileVersion : profileVersion // ignore: cast_nullable_to_non_nullable
as int,medications: null == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<Medication>,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<EditConflict>,
  ));
}
/// Create a copy of EmergencyCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipientProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $RecipientProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmergencyCard].
extension EmergencyCardPatterns on EmergencyCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyCard value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyCard value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecipientProfile? profile,  int profileVersion,  List<Medication> medications,  List<EditConflict> conflicts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyCard() when $default != null:
return $default(_that.profile,_that.profileVersion,_that.medications,_that.conflicts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecipientProfile? profile,  int profileVersion,  List<Medication> medications,  List<EditConflict> conflicts)  $default,) {final _that = this;
switch (_that) {
case _EmergencyCard():
return $default(_that.profile,_that.profileVersion,_that.medications,_that.conflicts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecipientProfile? profile,  int profileVersion,  List<Medication> medications,  List<EditConflict> conflicts)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyCard() when $default != null:
return $default(_that.profile,_that.profileVersion,_that.medications,_that.conflicts);case _:
  return null;

}
}

}

/// @nodoc


class _EmergencyCard implements EmergencyCard {
  const _EmergencyCard({this.profile, this.profileVersion = 0, final  List<Medication> medications = const <Medication>[], final  List<EditConflict> conflicts = const <EditConflict>[]}): _medications = medications,_conflicts = conflicts;
  

/// Null until someone fills it in.
@override final  RecipientProfile? profile;
@override@JsonKey() final  int profileVersion;
/// Active medications, from the log, so the card never goes stale.
 final  List<Medication> _medications;
/// Active medications, from the log, so the card never goes stale.
@override@JsonKey() List<Medication> get medications {
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medications);
}

 final  List<EditConflict> _conflicts;
@override@JsonKey() List<EditConflict> get conflicts {
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conflicts);
}


/// Create a copy of EmergencyCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyCardCopyWith<_EmergencyCard> get copyWith => __$EmergencyCardCopyWithImpl<_EmergencyCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyCard&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.profileVersion, profileVersion) || other.profileVersion == profileVersion)&&const DeepCollectionEquality().equals(other._medications, _medications)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,profile,profileVersion,const DeepCollectionEquality().hash(_medications),const DeepCollectionEquality().hash(_conflicts));

@override
String toString() {
  return 'EmergencyCard(profile: $profile, profileVersion: $profileVersion, medications: $medications, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class _$EmergencyCardCopyWith<$Res> implements $EmergencyCardCopyWith<$Res> {
  factory _$EmergencyCardCopyWith(_EmergencyCard value, $Res Function(_EmergencyCard) _then) = __$EmergencyCardCopyWithImpl;
@override @useResult
$Res call({
 RecipientProfile? profile, int profileVersion, List<Medication> medications, List<EditConflict> conflicts
});


@override $RecipientProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$EmergencyCardCopyWithImpl<$Res>
    implements _$EmergencyCardCopyWith<$Res> {
  __$EmergencyCardCopyWithImpl(this._self, this._then);

  final _EmergencyCard _self;
  final $Res Function(_EmergencyCard) _then;

/// Create a copy of EmergencyCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? profileVersion = null,Object? medications = null,Object? conflicts = null,}) {
  return _then(_EmergencyCard(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as RecipientProfile?,profileVersion: null == profileVersion ? _self.profileVersion : profileVersion // ignore: cast_nullable_to_non_nullable
as int,medications: null == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<Medication>,conflicts: null == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<EditConflict>,
  ));
}

/// Create a copy of EmergencyCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipientProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $RecipientProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
