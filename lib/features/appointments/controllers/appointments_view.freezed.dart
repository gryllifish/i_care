// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointments_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppointmentsView {

/// Soonest first.
 List<Appointment> get upcoming;/// Most recent first.
 List<Appointment> get past;/// Ids of recent past appointments nobody wrote notes for.
 Set<String> get missingNotes;/// Ids of appointments with concurrent edits to review.
 Set<String> get needReview;
/// Create a copy of AppointmentsView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentsViewCopyWith<AppointmentsView> get copyWith => _$AppointmentsViewCopyWithImpl<AppointmentsView>(this as AppointmentsView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentsView&&const DeepCollectionEquality().equals(other.upcoming, upcoming)&&const DeepCollectionEquality().equals(other.past, past)&&const DeepCollectionEquality().equals(other.missingNotes, missingNotes)&&const DeepCollectionEquality().equals(other.needReview, needReview));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(upcoming),const DeepCollectionEquality().hash(past),const DeepCollectionEquality().hash(missingNotes),const DeepCollectionEquality().hash(needReview));

@override
String toString() {
  return 'AppointmentsView(upcoming: $upcoming, past: $past, missingNotes: $missingNotes, needReview: $needReview)';
}


}

/// @nodoc
abstract mixin class $AppointmentsViewCopyWith<$Res>  {
  factory $AppointmentsViewCopyWith(AppointmentsView value, $Res Function(AppointmentsView) _then) = _$AppointmentsViewCopyWithImpl;
@useResult
$Res call({
 List<Appointment> upcoming, List<Appointment> past, Set<String> missingNotes, Set<String> needReview
});




}
/// @nodoc
class _$AppointmentsViewCopyWithImpl<$Res>
    implements $AppointmentsViewCopyWith<$Res> {
  _$AppointmentsViewCopyWithImpl(this._self, this._then);

  final AppointmentsView _self;
  final $Res Function(AppointmentsView) _then;

/// Create a copy of AppointmentsView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? upcoming = null,Object? past = null,Object? missingNotes = null,Object? needReview = null,}) {
  return _then(_self.copyWith(
upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<Appointment>,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<Appointment>,missingNotes: null == missingNotes ? _self.missingNotes : missingNotes // ignore: cast_nullable_to_non_nullable
as Set<String>,needReview: null == needReview ? _self.needReview : needReview // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentsView].
extension AppointmentsViewPatterns on AppointmentsView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentsView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentsView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentsView value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentsView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentsView value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentsView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Appointment> upcoming,  List<Appointment> past,  Set<String> missingNotes,  Set<String> needReview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentsView() when $default != null:
return $default(_that.upcoming,_that.past,_that.missingNotes,_that.needReview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Appointment> upcoming,  List<Appointment> past,  Set<String> missingNotes,  Set<String> needReview)  $default,) {final _that = this;
switch (_that) {
case _AppointmentsView():
return $default(_that.upcoming,_that.past,_that.missingNotes,_that.needReview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Appointment> upcoming,  List<Appointment> past,  Set<String> missingNotes,  Set<String> needReview)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentsView() when $default != null:
return $default(_that.upcoming,_that.past,_that.missingNotes,_that.needReview);case _:
  return null;

}
}

}

/// @nodoc


class _AppointmentsView implements AppointmentsView {
  const _AppointmentsView({final  List<Appointment> upcoming = const <Appointment>[], final  List<Appointment> past = const <Appointment>[], final  Set<String> missingNotes = const <String>{}, final  Set<String> needReview = const <String>{}}): _upcoming = upcoming,_past = past,_missingNotes = missingNotes,_needReview = needReview;
  

/// Soonest first.
 final  List<Appointment> _upcoming;
/// Soonest first.
@override@JsonKey() List<Appointment> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

/// Most recent first.
 final  List<Appointment> _past;
/// Most recent first.
@override@JsonKey() List<Appointment> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

/// Ids of recent past appointments nobody wrote notes for.
 final  Set<String> _missingNotes;
/// Ids of recent past appointments nobody wrote notes for.
@override@JsonKey() Set<String> get missingNotes {
  if (_missingNotes is EqualUnmodifiableSetView) return _missingNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_missingNotes);
}

/// Ids of appointments with concurrent edits to review.
 final  Set<String> _needReview;
/// Ids of appointments with concurrent edits to review.
@override@JsonKey() Set<String> get needReview {
  if (_needReview is EqualUnmodifiableSetView) return _needReview;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_needReview);
}


/// Create a copy of AppointmentsView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentsViewCopyWith<_AppointmentsView> get copyWith => __$AppointmentsViewCopyWithImpl<_AppointmentsView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentsView&&const DeepCollectionEquality().equals(other._upcoming, _upcoming)&&const DeepCollectionEquality().equals(other._past, _past)&&const DeepCollectionEquality().equals(other._missingNotes, _missingNotes)&&const DeepCollectionEquality().equals(other._needReview, _needReview));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_past),const DeepCollectionEquality().hash(_missingNotes),const DeepCollectionEquality().hash(_needReview));

@override
String toString() {
  return 'AppointmentsView(upcoming: $upcoming, past: $past, missingNotes: $missingNotes, needReview: $needReview)';
}


}

/// @nodoc
abstract mixin class _$AppointmentsViewCopyWith<$Res> implements $AppointmentsViewCopyWith<$Res> {
  factory _$AppointmentsViewCopyWith(_AppointmentsView value, $Res Function(_AppointmentsView) _then) = __$AppointmentsViewCopyWithImpl;
@override @useResult
$Res call({
 List<Appointment> upcoming, List<Appointment> past, Set<String> missingNotes, Set<String> needReview
});




}
/// @nodoc
class __$AppointmentsViewCopyWithImpl<$Res>
    implements _$AppointmentsViewCopyWith<$Res> {
  __$AppointmentsViewCopyWithImpl(this._self, this._then);

  final _AppointmentsView _self;
  final $Res Function(_AppointmentsView) _then;

/// Create a copy of AppointmentsView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? upcoming = null,Object? past = null,Object? missingNotes = null,Object? needReview = null,}) {
  return _then(_AppointmentsView(
upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<Appointment>,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<Appointment>,missingNotes: null == missingNotes ? _self._missingNotes : missingNotes // ignore: cast_nullable_to_non_nullable
as Set<String>,needReview: null == needReview ? _self._needReview : needReview // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
