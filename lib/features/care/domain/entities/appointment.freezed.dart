// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppointmentDetails {

/// Specialty or reason, e.g. "Cardiology".
 String get title;/// Wall-clock time in the care recipient's time zone.
 DateTime get startsAt; String get doctor; String get location;/// Questions to ask, one per line.
 String get questions;
/// Create a copy of AppointmentDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentDetailsCopyWith<AppointmentDetails> get copyWith => _$AppointmentDetailsCopyWithImpl<AppointmentDetails>(this as AppointmentDetails, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppointmentDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentDetails&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.doctor, _this.doctor) || other.doctor == _this.doctor)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.questions, _this.questions) || other.questions == _this.questions));
}


@override
int get hashCode {
  final _this = this as AppointmentDetails;
  return Object.hash(runtimeType,_this.title,_this.startsAt,_this.doctor,_this.location,_this.questions);
}

@override
String toString() {
  final _this = this as AppointmentDetails;
  return 'AppointmentDetails(title: ${_this.title}, startsAt: ${_this.startsAt}, doctor: ${_this.doctor}, location: ${_this.location}, questions: ${_this.questions})';
}


}

/// @nodoc
abstract mixin class $AppointmentDetailsCopyWith<$Res>  {
  factory $AppointmentDetailsCopyWith(AppointmentDetails value, $Res Function(AppointmentDetails) _then) = _$AppointmentDetailsCopyWithImpl;
@useResult
$Res call({
 String title, DateTime startsAt, String doctor, String location, String questions
});




}
/// @nodoc
class _$AppointmentDetailsCopyWithImpl<$Res>
    implements $AppointmentDetailsCopyWith<$Res> {
  _$AppointmentDetailsCopyWithImpl(this._self, this._then);

  final AppointmentDetails _self;
  final $Res Function(AppointmentDetails) _then;

/// Create a copy of AppointmentDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? startsAt = null,Object? doctor = null,Object? location = null,Object? questions = null,}) {
  return _then(AppointmentDetails(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,doctor: null == doctor ? _self.doctor : doctor // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentDetails].
extension AppointmentDetailsPatterns on AppointmentDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentDetails value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentDetails value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  DateTime startsAt,  String doctor,  String location,  String questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentDetails() when $default != null:
return $default(_that.title,_that.startsAt,_that.doctor,_that.location,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  DateTime startsAt,  String doctor,  String location,  String questions)  $default,) {final _that = this;
switch (_that) {
case _AppointmentDetails():
return $default(_that.title,_that.startsAt,_that.doctor,_that.location,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  DateTime startsAt,  String doctor,  String location,  String questions)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentDetails() when $default != null:
return $default(_that.title,_that.startsAt,_that.doctor,_that.location,_that.questions);case _:
  return null;

}
}

}

/// @nodoc


class _AppointmentDetails extends AppointmentDetails {
  const _AppointmentDetails({required this.title, required this.startsAt, this.doctor = '', this.location = '', this.questions = ''}): super._();
  

/// Specialty or reason, e.g. "Cardiology".
@override final  String title;
/// Wall-clock time in the care recipient's time zone.
@override final  DateTime startsAt;
@override@JsonKey() final  String doctor;
@override@JsonKey() final  String location;
/// Questions to ask, one per line.
@override@JsonKey() final  String questions;

/// Create a copy of AppointmentDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentDetailsCopyWith<_AppointmentDetails> get copyWith => __$AppointmentDetailsCopyWithImpl<_AppointmentDetails>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentDetails&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.doctor, doctor) || other.doctor == doctor)&&(identical(other.location, location) || other.location == location)&&(identical(other.questions, questions) || other.questions == questions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,startsAt,doctor,location,questions);
}

@override
String toString() {
    return 'AppointmentDetails(title: $title, startsAt: $startsAt, doctor: $doctor, location: $location, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$AppointmentDetailsCopyWith<$Res> implements $AppointmentDetailsCopyWith<$Res> {
  factory _$AppointmentDetailsCopyWith(_AppointmentDetails value, $Res Function(_AppointmentDetails) _then) = __$AppointmentDetailsCopyWithImpl;
@override @useResult
$Res call({
 String title, DateTime startsAt, String doctor, String location, String questions
});




}
/// @nodoc
class __$AppointmentDetailsCopyWithImpl<$Res>
    implements _$AppointmentDetailsCopyWith<$Res> {
  __$AppointmentDetailsCopyWithImpl(this._self, this._then);

  final _AppointmentDetails _self;
  final $Res Function(_AppointmentDetails) _then;

/// Create a copy of AppointmentDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? startsAt = null,Object? doctor = null,Object? location = null,Object? questions = null,}) {
  return _then(_AppointmentDetails(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,doctor: null == doctor ? _self.doctor : doctor // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Appointment {

 String get id; AppointmentDetails get details;/// Notes from the visit, oldest first, by whoever wrote them.
 List<VisitNoteAdded> get notes;/// Links to studies, results or reports, oldest first; removed ones
/// left out. Each one's id is its event's.
 List<DocumentLinked> get documents; bool get isCancelled;/// Number of changes applied, as for medications.
 int get version;
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCopyWith<Appointment> get copyWith => _$AppointmentCopyWithImpl<Appointment>(this as Appointment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Appointment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.details, _this.details) || other.details == _this.details)&&const DeepCollectionEquality().equals(other.notes, _this.notes)&&const DeepCollectionEquality().equals(other.documents, _this.documents)&&(identical(other.isCancelled, _this.isCancelled) || other.isCancelled == _this.isCancelled)&&(identical(other.version, _this.version) || other.version == _this.version));
}


@override
int get hashCode {
  final _this = this as Appointment;
  return Object.hash(runtimeType,_this.id,_this.details,const DeepCollectionEquality().hash(_this.notes),const DeepCollectionEquality().hash(_this.documents),_this.isCancelled,_this.version);
}

@override
String toString() {
  final _this = this as Appointment;
  return 'Appointment(id: ${_this.id}, details: ${_this.details}, notes: ${_this.notes}, documents: ${_this.documents}, isCancelled: ${_this.isCancelled}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $AppointmentCopyWith<$Res>  {
  factory $AppointmentCopyWith(Appointment value, $Res Function(Appointment) _then) = _$AppointmentCopyWithImpl;
@useResult
$Res call({
 String id, AppointmentDetails details, List<VisitNoteAdded> notes, List<DocumentLinked> documents, bool isCancelled, int version
});


$AppointmentDetailsCopyWith<$Res> get details;

}
/// @nodoc
class _$AppointmentCopyWithImpl<$Res>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._self, this._then);

  final Appointment _self;
  final $Res Function(Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? details = null,Object? notes = null,Object? documents = null,Object? isCancelled = null,Object? version = null,}) {
  return _then(Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as AppointmentDetails,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<VisitNoteAdded>,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as List<DocumentLinked>,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDetailsCopyWith<$Res> get details {
  
  return $AppointmentDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}


/// Adds pattern-matching-related methods to [Appointment].
extension AppointmentPatterns on Appointment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointment value)  $default,){
final _that = this;
switch (_that) {
case _Appointment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointment value)?  $default,){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AppointmentDetails details,  List<VisitNoteAdded> notes,  List<DocumentLinked> documents,  bool isCancelled,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.details,_that.notes,_that.documents,_that.isCancelled,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AppointmentDetails details,  List<VisitNoteAdded> notes,  List<DocumentLinked> documents,  bool isCancelled,  int version)  $default,) {final _that = this;
switch (_that) {
case _Appointment():
return $default(_that.id,_that.details,_that.notes,_that.documents,_that.isCancelled,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AppointmentDetails details,  List<VisitNoteAdded> notes,  List<DocumentLinked> documents,  bool isCancelled,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.details,_that.notes,_that.documents,_that.isCancelled,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _Appointment extends Appointment {
  const _Appointment({required this.id, required this.details,  List<VisitNoteAdded> notes = const <VisitNoteAdded>[],  List<DocumentLinked> documents = const <DocumentLinked>[], this.isCancelled = false, this.version = 0}): _notes = notes,_documents = documents,super._();
  

@override final  String id;
@override final  AppointmentDetails details;
/// Notes from the visit, oldest first, by whoever wrote them.
 final  List<VisitNoteAdded> _notes;
/// Notes from the visit, oldest first, by whoever wrote them.
@override@JsonKey() List<VisitNoteAdded> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

/// Links to studies, results or reports, oldest first; removed ones
/// left out. Each one's id is its event's.
 final  List<DocumentLinked> _documents;
/// Links to studies, results or reports, oldest first; removed ones
/// left out. Each one's id is its event's.
@override@JsonKey() List<DocumentLinked> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@override@JsonKey() final  bool isCancelled;
/// Number of changes applied, as for medications.
@override@JsonKey() final  int version;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentCopyWith<_Appointment> get copyWith => __$AppointmentCopyWithImpl<_Appointment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other.notes, _notes)&&const DeepCollectionEquality().equals(other.documents, _documents)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,details,const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_documents),isCancelled,version);
}

@override
String toString() {
    return 'Appointment(id: $id, details: $details, notes: $notes, documents: $documents, isCancelled: $isCancelled, version: $version)';
}


}

/// @nodoc
abstract mixin class _$AppointmentCopyWith<$Res> implements $AppointmentCopyWith<$Res> {
  factory _$AppointmentCopyWith(_Appointment value, $Res Function(_Appointment) _then) = __$AppointmentCopyWithImpl;
@override @useResult
$Res call({
 String id, AppointmentDetails details, List<VisitNoteAdded> notes, List<DocumentLinked> documents, bool isCancelled, int version
});


@override $AppointmentDetailsCopyWith<$Res> get details;

}
/// @nodoc
class __$AppointmentCopyWithImpl<$Res>
    implements _$AppointmentCopyWith<$Res> {
  __$AppointmentCopyWithImpl(this._self, this._then);

  final _Appointment _self;
  final $Res Function(_Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? details = null,Object? notes = null,Object? documents = null,Object? isCancelled = null,Object? version = null,}) {
  return _then(_Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as AppointmentDetails,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<VisitNoteAdded>,documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<DocumentLinked>,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDetailsCopyWith<$Res> get details {
  
  return $AppointmentDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

// dart format on
