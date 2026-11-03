// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventMeta {

/// UUID generated on the device, so retries never duplicate an event.
 String get id;/// The member who wrote it, or [systemAuthor] for events the server
/// writes. The name predates roles; the wire format keeps it.
 String get caregiverId;/// When it happened, by the device clock. Shown to people; never used
/// to order or resolve anything, since device clocks drift.
 DateTime get occurredAt;/// When the server received it; null until synced. Orders the log.
 DateTime? get receivedAt;/// Set by the server on a fact (a dose or task record) from a device
/// whose member had left the circle by the time it synced: accepted,
/// since it may be true, and flagged for admins (`docs/roles.md`).
 bool get fromFormerMember;
/// Create a copy of EventMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventMetaCopyWith<EventMeta> get copyWith => _$EventMetaCopyWithImpl<EventMeta>(this as EventMeta, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EventMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventMeta&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.caregiverId, _this.caregiverId) || other.caregiverId == _this.caregiverId)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt)&&(identical(other.fromFormerMember, _this.fromFormerMember) || other.fromFormerMember == _this.fromFormerMember));
}


@override
int get hashCode {
  final _this = this as EventMeta;
  return Object.hash(runtimeType,_this.id,_this.caregiverId,_this.occurredAt,_this.receivedAt,_this.fromFormerMember);
}

@override
String toString() {
  final _this = this as EventMeta;
  return 'EventMeta(id: ${_this.id}, caregiverId: ${_this.caregiverId}, occurredAt: ${_this.occurredAt}, receivedAt: ${_this.receivedAt}, fromFormerMember: ${_this.fromFormerMember})';
}


}

/// @nodoc
abstract mixin class $EventMetaCopyWith<$Res>  {
  factory $EventMetaCopyWith(EventMeta value, $Res Function(EventMeta) _then) = _$EventMetaCopyWithImpl;
@useResult
$Res call({
 String id, String caregiverId, DateTime occurredAt, DateTime? receivedAt, bool fromFormerMember
});




}
/// @nodoc
class _$EventMetaCopyWithImpl<$Res>
    implements $EventMetaCopyWith<$Res> {
  _$EventMetaCopyWithImpl(this._self, this._then);

  final EventMeta _self;
  final $Res Function(EventMeta) _then;

/// Create a copy of EventMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? caregiverId = null,Object? occurredAt = null,Object? receivedAt = freezed,Object? fromFormerMember = null,}) {
  return _then(EventMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fromFormerMember: null == fromFormerMember ? _self.fromFormerMember : fromFormerMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventMeta].
extension EventMetaPatterns on EventMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventMeta value)  $default,){
final _that = this;
switch (_that) {
case _EventMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventMeta value)?  $default,){
final _that = this;
switch (_that) {
case _EventMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String caregiverId,  DateTime occurredAt,  DateTime? receivedAt,  bool fromFormerMember)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventMeta() when $default != null:
return $default(_that.id,_that.caregiverId,_that.occurredAt,_that.receivedAt,_that.fromFormerMember);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String caregiverId,  DateTime occurredAt,  DateTime? receivedAt,  bool fromFormerMember)  $default,) {final _that = this;
switch (_that) {
case _EventMeta():
return $default(_that.id,_that.caregiverId,_that.occurredAt,_that.receivedAt,_that.fromFormerMember);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String caregiverId,  DateTime occurredAt,  DateTime? receivedAt,  bool fromFormerMember)?  $default,) {final _that = this;
switch (_that) {
case _EventMeta() when $default != null:
return $default(_that.id,_that.caregiverId,_that.occurredAt,_that.receivedAt,_that.fromFormerMember);case _:
  return null;

}
}

}

/// @nodoc


class _EventMeta extends EventMeta {
  const _EventMeta({required this.id, required this.caregiverId, required this.occurredAt, this.receivedAt, this.fromFormerMember = false}): super._();
  

/// UUID generated on the device, so retries never duplicate an event.
@override final  String id;
/// The member who wrote it, or [systemAuthor] for events the server
/// writes. The name predates roles; the wire format keeps it.
@override final  String caregiverId;
/// When it happened, by the device clock. Shown to people; never used
/// to order or resolve anything, since device clocks drift.
@override final  DateTime occurredAt;
/// When the server received it; null until synced. Orders the log.
@override final  DateTime? receivedAt;
/// Set by the server on a fact (a dose or task record) from a device
/// whose member had left the circle by the time it synced: accepted,
/// since it may be true, and flagged for admins (`docs/roles.md`).
@override@JsonKey() final  bool fromFormerMember;

/// Create a copy of EventMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventMetaCopyWith<_EventMeta> get copyWith => __$EventMetaCopyWithImpl<_EventMeta>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.fromFormerMember, fromFormerMember) || other.fromFormerMember == fromFormerMember));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,caregiverId,occurredAt,receivedAt,fromFormerMember);
}

@override
String toString() {
    return 'EventMeta(id: $id, caregiverId: $caregiverId, occurredAt: $occurredAt, receivedAt: $receivedAt, fromFormerMember: $fromFormerMember)';
}


}

/// @nodoc
abstract mixin class _$EventMetaCopyWith<$Res> implements $EventMetaCopyWith<$Res> {
  factory _$EventMetaCopyWith(_EventMeta value, $Res Function(_EventMeta) _then) = __$EventMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, String caregiverId, DateTime occurredAt, DateTime? receivedAt, bool fromFormerMember
});




}
/// @nodoc
class __$EventMetaCopyWithImpl<$Res>
    implements _$EventMetaCopyWith<$Res> {
  __$EventMetaCopyWithImpl(this._self, this._then);

  final _EventMeta _self;
  final $Res Function(_EventMeta) _then;

/// Create a copy of EventMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? caregiverId = null,Object? occurredAt = null,Object? receivedAt = freezed,Object? fromFormerMember = null,}) {
  return _then(_EventMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fromFormerMember: null == fromFormerMember ? _self.fromFormerMember : fromFormerMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CareEvent {

 EventMeta get meta;
/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareEventCopyWith<CareEvent> get copyWith => _$CareEventCopyWithImpl<CareEvent>(this as CareEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CareEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareEvent&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}


@override
int get hashCode {
  final _this = this as CareEvent;
  return Object.hash(runtimeType,_this.meta);
}

@override
String toString() {
  final _this = this as CareEvent;
  return 'CareEvent(meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $CareEventCopyWith<$Res>  {
  factory $CareEventCopyWith(CareEvent value, $Res Function(CareEvent) _then) = _$CareEventCopyWithImpl;
@useResult
$Res call({
 EventMeta meta
});


$EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$CareEventCopyWithImpl<$Res>
    implements $CareEventCopyWith<$Res> {
  _$CareEventCopyWithImpl(this._self, this._then);

  final CareEvent _self;
  final $Res Function(CareEvent) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meta = null,}) {
  return _then(_self.copyWith(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,
  ));
}
/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [CareEvent].
extension CareEventPatterns on CareEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MedicationCreated value)?  medicationCreated,TResult Function( MedicationUpdated value)?  medicationUpdated,TResult Function( ScheduleChanged value)?  scheduleChanged,TResult Function( MedicationArchived value)?  medicationArchived,TResult Function( DoseGiven value)?  doseGiven,TResult Function( DoseSkipped value)?  doseSkipped,TResult Function( DoseUndone value)?  doseUndone,TResult Function( StockCounted value)?  stockCounted,TResult Function( StockRefilled value)?  stockRefilled,TResult Function( AppointmentCreated value)?  appointmentCreated,TResult Function( AppointmentUpdated value)?  appointmentUpdated,TResult Function( AppointmentCancelled value)?  appointmentCancelled,TResult Function( VisitNoteAdded value)?  visitNoteAdded,TResult Function( CareNoteAdded value)?  careNoteAdded,TResult Function( DocumentLinked value)?  documentLinked,TResult Function( DocumentRemoved value)?  documentRemoved,TResult Function( RecipientProfileUpdated value)?  recipientProfileUpdated,TResult Function( TaskCreated value)?  taskCreated,TResult Function( TaskUpdated value)?  taskUpdated,TResult Function( TaskArchived value)?  taskArchived,TResult Function( TaskDone value)?  taskDone,TResult Function( TaskSkipped value)?  taskSkipped,TResult Function( CircleCreated value)?  circleCreated,TResult Function( SkipReasonAdded value)?  skipReasonAdded,TResult Function( SkipReasonHidden value)?  skipReasonHidden,TResult Function( SkipReasonShown value)?  skipReasonShown,TResult Function( MemberInvited value)?  memberInvited,TResult Function( InvitationRevoked value)?  invitationRevoked,TResult Function( MemberJoined value)?  memberJoined,TResult Function( RoleChanged value)?  roleChanged,TResult Function( MemberRemoved value)?  memberRemoved,TResult Function( MemberLeft value)?  memberLeft,TResult Function( ConflictAcknowledged value)?  conflictAcknowledged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MedicationCreated() when medicationCreated != null:
return medicationCreated(_that);case MedicationUpdated() when medicationUpdated != null:
return medicationUpdated(_that);case ScheduleChanged() when scheduleChanged != null:
return scheduleChanged(_that);case MedicationArchived() when medicationArchived != null:
return medicationArchived(_that);case DoseGiven() when doseGiven != null:
return doseGiven(_that);case DoseSkipped() when doseSkipped != null:
return doseSkipped(_that);case DoseUndone() when doseUndone != null:
return doseUndone(_that);case StockCounted() when stockCounted != null:
return stockCounted(_that);case StockRefilled() when stockRefilled != null:
return stockRefilled(_that);case AppointmentCreated() when appointmentCreated != null:
return appointmentCreated(_that);case AppointmentUpdated() when appointmentUpdated != null:
return appointmentUpdated(_that);case AppointmentCancelled() when appointmentCancelled != null:
return appointmentCancelled(_that);case VisitNoteAdded() when visitNoteAdded != null:
return visitNoteAdded(_that);case CareNoteAdded() when careNoteAdded != null:
return careNoteAdded(_that);case DocumentLinked() when documentLinked != null:
return documentLinked(_that);case DocumentRemoved() when documentRemoved != null:
return documentRemoved(_that);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that);case TaskCreated() when taskCreated != null:
return taskCreated(_that);case TaskUpdated() when taskUpdated != null:
return taskUpdated(_that);case TaskArchived() when taskArchived != null:
return taskArchived(_that);case TaskDone() when taskDone != null:
return taskDone(_that);case TaskSkipped() when taskSkipped != null:
return taskSkipped(_that);case CircleCreated() when circleCreated != null:
return circleCreated(_that);case SkipReasonAdded() when skipReasonAdded != null:
return skipReasonAdded(_that);case SkipReasonHidden() when skipReasonHidden != null:
return skipReasonHidden(_that);case SkipReasonShown() when skipReasonShown != null:
return skipReasonShown(_that);case MemberInvited() when memberInvited != null:
return memberInvited(_that);case InvitationRevoked() when invitationRevoked != null:
return invitationRevoked(_that);case MemberJoined() when memberJoined != null:
return memberJoined(_that);case RoleChanged() when roleChanged != null:
return roleChanged(_that);case MemberRemoved() when memberRemoved != null:
return memberRemoved(_that);case MemberLeft() when memberLeft != null:
return memberLeft(_that);case ConflictAcknowledged() when conflictAcknowledged != null:
return conflictAcknowledged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MedicationCreated value)  medicationCreated,required TResult Function( MedicationUpdated value)  medicationUpdated,required TResult Function( ScheduleChanged value)  scheduleChanged,required TResult Function( MedicationArchived value)  medicationArchived,required TResult Function( DoseGiven value)  doseGiven,required TResult Function( DoseSkipped value)  doseSkipped,required TResult Function( DoseUndone value)  doseUndone,required TResult Function( StockCounted value)  stockCounted,required TResult Function( StockRefilled value)  stockRefilled,required TResult Function( AppointmentCreated value)  appointmentCreated,required TResult Function( AppointmentUpdated value)  appointmentUpdated,required TResult Function( AppointmentCancelled value)  appointmentCancelled,required TResult Function( VisitNoteAdded value)  visitNoteAdded,required TResult Function( CareNoteAdded value)  careNoteAdded,required TResult Function( DocumentLinked value)  documentLinked,required TResult Function( DocumentRemoved value)  documentRemoved,required TResult Function( RecipientProfileUpdated value)  recipientProfileUpdated,required TResult Function( TaskCreated value)  taskCreated,required TResult Function( TaskUpdated value)  taskUpdated,required TResult Function( TaskArchived value)  taskArchived,required TResult Function( TaskDone value)  taskDone,required TResult Function( TaskSkipped value)  taskSkipped,required TResult Function( CircleCreated value)  circleCreated,required TResult Function( SkipReasonAdded value)  skipReasonAdded,required TResult Function( SkipReasonHidden value)  skipReasonHidden,required TResult Function( SkipReasonShown value)  skipReasonShown,required TResult Function( MemberInvited value)  memberInvited,required TResult Function( InvitationRevoked value)  invitationRevoked,required TResult Function( MemberJoined value)  memberJoined,required TResult Function( RoleChanged value)  roleChanged,required TResult Function( MemberRemoved value)  memberRemoved,required TResult Function( MemberLeft value)  memberLeft,required TResult Function( ConflictAcknowledged value)  conflictAcknowledged,}){
final _that = this;
switch (_that) {
case MedicationCreated():
return medicationCreated(_that);case MedicationUpdated():
return medicationUpdated(_that);case ScheduleChanged():
return scheduleChanged(_that);case MedicationArchived():
return medicationArchived(_that);case DoseGiven():
return doseGiven(_that);case DoseSkipped():
return doseSkipped(_that);case DoseUndone():
return doseUndone(_that);case StockCounted():
return stockCounted(_that);case StockRefilled():
return stockRefilled(_that);case AppointmentCreated():
return appointmentCreated(_that);case AppointmentUpdated():
return appointmentUpdated(_that);case AppointmentCancelled():
return appointmentCancelled(_that);case VisitNoteAdded():
return visitNoteAdded(_that);case CareNoteAdded():
return careNoteAdded(_that);case DocumentLinked():
return documentLinked(_that);case DocumentRemoved():
return documentRemoved(_that);case RecipientProfileUpdated():
return recipientProfileUpdated(_that);case TaskCreated():
return taskCreated(_that);case TaskUpdated():
return taskUpdated(_that);case TaskArchived():
return taskArchived(_that);case TaskDone():
return taskDone(_that);case TaskSkipped():
return taskSkipped(_that);case CircleCreated():
return circleCreated(_that);case SkipReasonAdded():
return skipReasonAdded(_that);case SkipReasonHidden():
return skipReasonHidden(_that);case SkipReasonShown():
return skipReasonShown(_that);case MemberInvited():
return memberInvited(_that);case InvitationRevoked():
return invitationRevoked(_that);case MemberJoined():
return memberJoined(_that);case RoleChanged():
return roleChanged(_that);case MemberRemoved():
return memberRemoved(_that);case MemberLeft():
return memberLeft(_that);case ConflictAcknowledged():
return conflictAcknowledged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MedicationCreated value)?  medicationCreated,TResult? Function( MedicationUpdated value)?  medicationUpdated,TResult? Function( ScheduleChanged value)?  scheduleChanged,TResult? Function( MedicationArchived value)?  medicationArchived,TResult? Function( DoseGiven value)?  doseGiven,TResult? Function( DoseSkipped value)?  doseSkipped,TResult? Function( DoseUndone value)?  doseUndone,TResult? Function( StockCounted value)?  stockCounted,TResult? Function( StockRefilled value)?  stockRefilled,TResult? Function( AppointmentCreated value)?  appointmentCreated,TResult? Function( AppointmentUpdated value)?  appointmentUpdated,TResult? Function( AppointmentCancelled value)?  appointmentCancelled,TResult? Function( VisitNoteAdded value)?  visitNoteAdded,TResult? Function( CareNoteAdded value)?  careNoteAdded,TResult? Function( DocumentLinked value)?  documentLinked,TResult? Function( DocumentRemoved value)?  documentRemoved,TResult? Function( RecipientProfileUpdated value)?  recipientProfileUpdated,TResult? Function( TaskCreated value)?  taskCreated,TResult? Function( TaskUpdated value)?  taskUpdated,TResult? Function( TaskArchived value)?  taskArchived,TResult? Function( TaskDone value)?  taskDone,TResult? Function( TaskSkipped value)?  taskSkipped,TResult? Function( CircleCreated value)?  circleCreated,TResult? Function( SkipReasonAdded value)?  skipReasonAdded,TResult? Function( SkipReasonHidden value)?  skipReasonHidden,TResult? Function( SkipReasonShown value)?  skipReasonShown,TResult? Function( MemberInvited value)?  memberInvited,TResult? Function( InvitationRevoked value)?  invitationRevoked,TResult? Function( MemberJoined value)?  memberJoined,TResult? Function( RoleChanged value)?  roleChanged,TResult? Function( MemberRemoved value)?  memberRemoved,TResult? Function( MemberLeft value)?  memberLeft,TResult? Function( ConflictAcknowledged value)?  conflictAcknowledged,}){
final _that = this;
switch (_that) {
case MedicationCreated() when medicationCreated != null:
return medicationCreated(_that);case MedicationUpdated() when medicationUpdated != null:
return medicationUpdated(_that);case ScheduleChanged() when scheduleChanged != null:
return scheduleChanged(_that);case MedicationArchived() when medicationArchived != null:
return medicationArchived(_that);case DoseGiven() when doseGiven != null:
return doseGiven(_that);case DoseSkipped() when doseSkipped != null:
return doseSkipped(_that);case DoseUndone() when doseUndone != null:
return doseUndone(_that);case StockCounted() when stockCounted != null:
return stockCounted(_that);case StockRefilled() when stockRefilled != null:
return stockRefilled(_that);case AppointmentCreated() when appointmentCreated != null:
return appointmentCreated(_that);case AppointmentUpdated() when appointmentUpdated != null:
return appointmentUpdated(_that);case AppointmentCancelled() when appointmentCancelled != null:
return appointmentCancelled(_that);case VisitNoteAdded() when visitNoteAdded != null:
return visitNoteAdded(_that);case CareNoteAdded() when careNoteAdded != null:
return careNoteAdded(_that);case DocumentLinked() when documentLinked != null:
return documentLinked(_that);case DocumentRemoved() when documentRemoved != null:
return documentRemoved(_that);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that);case TaskCreated() when taskCreated != null:
return taskCreated(_that);case TaskUpdated() when taskUpdated != null:
return taskUpdated(_that);case TaskArchived() when taskArchived != null:
return taskArchived(_that);case TaskDone() when taskDone != null:
return taskDone(_that);case TaskSkipped() when taskSkipped != null:
return taskSkipped(_that);case CircleCreated() when circleCreated != null:
return circleCreated(_that);case SkipReasonAdded() when skipReasonAdded != null:
return skipReasonAdded(_that);case SkipReasonHidden() when skipReasonHidden != null:
return skipReasonHidden(_that);case SkipReasonShown() when skipReasonShown != null:
return skipReasonShown(_that);case MemberInvited() when memberInvited != null:
return memberInvited(_that);case InvitationRevoked() when invitationRevoked != null:
return invitationRevoked(_that);case MemberJoined() when memberJoined != null:
return memberJoined(_that);case RoleChanged() when roleChanged != null:
return roleChanged(_that);case MemberRemoved() when memberRemoved != null:
return memberRemoved(_that);case MemberLeft() when memberLeft != null:
return memberLeft(_that);case ConflictAcknowledged() when conflictAcknowledged != null:
return conflictAcknowledged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( EventMeta meta,  String medicationId,  MedicationDetails details,  DoseSchedule schedule,  DateTime effectiveFrom)?  medicationCreated,TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  MedicationDetails details)?  medicationUpdated,TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  DoseSchedule schedule,  DateTime effectiveFrom)?  scheduleChanged,TResult Function( EventMeta meta,  String medicationId,  int baseVersion)?  medicationArchived,TResult Function( EventMeta meta,  String medicationId,  DateTime? slotAt,  DateTime givenAt,  double units,  List<String> knownDoseIds,  String? note)?  doseGiven,TResult Function( EventMeta meta,  String medicationId,  DateTime slotAt,  String reasonId,  String? note)?  doseSkipped,TResult Function( EventMeta meta,  String targetEventId,  String? conflictKey)?  doseUndone,TResult Function( EventMeta meta,  String medicationId,  double units)?  stockCounted,TResult Function( EventMeta meta,  String medicationId,  double units)?  stockRefilled,TResult Function( EventMeta meta,  String appointmentId,  AppointmentDetails details)?  appointmentCreated,TResult Function( EventMeta meta,  String appointmentId,  int baseVersion,  AppointmentDetails details)?  appointmentUpdated,TResult Function( EventMeta meta,  String appointmentId,  int baseVersion)?  appointmentCancelled,TResult Function( EventMeta meta,  String appointmentId,  String text)?  visitNoteAdded,TResult Function( EventMeta meta,  String text)?  careNoteAdded,TResult Function( EventMeta meta,  String appointmentId,  String title,  String url)?  documentLinked,TResult Function( EventMeta meta,  String appointmentId,  String documentId)?  documentRemoved,TResult Function( EventMeta meta,  int baseVersion,  RecipientProfile profile)?  recipientProfileUpdated,TResult Function( EventMeta meta,  String taskId,  TaskDetails details,  TaskSchedule schedule)?  taskCreated,TResult Function( EventMeta meta,  String taskId,  int baseVersion,  TaskDetails details,  TaskSchedule schedule)?  taskUpdated,TResult Function( EventMeta meta,  String taskId,  int baseVersion)?  taskArchived,TResult Function( EventMeta meta,  String taskId,  DateTime slotAt)?  taskDone,TResult Function( EventMeta meta,  String taskId,  DateTime slotAt,  String reasonId,  String? note)?  taskSkipped,TResult Function( EventMeta meta,  String recipientName,  bool isSample)?  circleCreated,TResult Function( EventMeta meta,  String reasonId,  String label)?  skipReasonAdded,TResult Function( EventMeta meta,  String reasonId)?  skipReasonHidden,TResult Function( EventMeta meta,  String reasonId)?  skipReasonShown,TResult Function( EventMeta meta,  String memberId,  String name,  MemberRole role,  int colorIndex)?  memberInvited,TResult Function( EventMeta meta,  String memberId)?  invitationRevoked,TResult Function( EventMeta meta,  String memberId)?  memberJoined,TResult Function( EventMeta meta,  String memberId,  int baseVersion,  MemberRole role)?  roleChanged,TResult Function( EventMeta meta,  String memberId,  int baseVersion)?  memberRemoved,TResult Function( EventMeta meta,  String memberId)?  memberLeft,TResult Function( EventMeta meta,  String conflictKey)?  conflictAcknowledged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MedicationCreated() when medicationCreated != null:
return medicationCreated(_that.meta,_that.medicationId,_that.details,_that.schedule,_that.effectiveFrom);case MedicationUpdated() when medicationUpdated != null:
return medicationUpdated(_that.meta,_that.medicationId,_that.baseVersion,_that.details);case ScheduleChanged() when scheduleChanged != null:
return scheduleChanged(_that.meta,_that.medicationId,_that.baseVersion,_that.schedule,_that.effectiveFrom);case MedicationArchived() when medicationArchived != null:
return medicationArchived(_that.meta,_that.medicationId,_that.baseVersion);case DoseGiven() when doseGiven != null:
return doseGiven(_that.meta,_that.medicationId,_that.slotAt,_that.givenAt,_that.units,_that.knownDoseIds,_that.note);case DoseSkipped() when doseSkipped != null:
return doseSkipped(_that.meta,_that.medicationId,_that.slotAt,_that.reasonId,_that.note);case DoseUndone() when doseUndone != null:
return doseUndone(_that.meta,_that.targetEventId,_that.conflictKey);case StockCounted() when stockCounted != null:
return stockCounted(_that.meta,_that.medicationId,_that.units);case StockRefilled() when stockRefilled != null:
return stockRefilled(_that.meta,_that.medicationId,_that.units);case AppointmentCreated() when appointmentCreated != null:
return appointmentCreated(_that.meta,_that.appointmentId,_that.details);case AppointmentUpdated() when appointmentUpdated != null:
return appointmentUpdated(_that.meta,_that.appointmentId,_that.baseVersion,_that.details);case AppointmentCancelled() when appointmentCancelled != null:
return appointmentCancelled(_that.meta,_that.appointmentId,_that.baseVersion);case VisitNoteAdded() when visitNoteAdded != null:
return visitNoteAdded(_that.meta,_that.appointmentId,_that.text);case CareNoteAdded() when careNoteAdded != null:
return careNoteAdded(_that.meta,_that.text);case DocumentLinked() when documentLinked != null:
return documentLinked(_that.meta,_that.appointmentId,_that.title,_that.url);case DocumentRemoved() when documentRemoved != null:
return documentRemoved(_that.meta,_that.appointmentId,_that.documentId);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that.meta,_that.baseVersion,_that.profile);case TaskCreated() when taskCreated != null:
return taskCreated(_that.meta,_that.taskId,_that.details,_that.schedule);case TaskUpdated() when taskUpdated != null:
return taskUpdated(_that.meta,_that.taskId,_that.baseVersion,_that.details,_that.schedule);case TaskArchived() when taskArchived != null:
return taskArchived(_that.meta,_that.taskId,_that.baseVersion);case TaskDone() when taskDone != null:
return taskDone(_that.meta,_that.taskId,_that.slotAt);case TaskSkipped() when taskSkipped != null:
return taskSkipped(_that.meta,_that.taskId,_that.slotAt,_that.reasonId,_that.note);case CircleCreated() when circleCreated != null:
return circleCreated(_that.meta,_that.recipientName,_that.isSample);case SkipReasonAdded() when skipReasonAdded != null:
return skipReasonAdded(_that.meta,_that.reasonId,_that.label);case SkipReasonHidden() when skipReasonHidden != null:
return skipReasonHidden(_that.meta,_that.reasonId);case SkipReasonShown() when skipReasonShown != null:
return skipReasonShown(_that.meta,_that.reasonId);case MemberInvited() when memberInvited != null:
return memberInvited(_that.meta,_that.memberId,_that.name,_that.role,_that.colorIndex);case InvitationRevoked() when invitationRevoked != null:
return invitationRevoked(_that.meta,_that.memberId);case MemberJoined() when memberJoined != null:
return memberJoined(_that.meta,_that.memberId);case RoleChanged() when roleChanged != null:
return roleChanged(_that.meta,_that.memberId,_that.baseVersion,_that.role);case MemberRemoved() when memberRemoved != null:
return memberRemoved(_that.meta,_that.memberId,_that.baseVersion);case MemberLeft() when memberLeft != null:
return memberLeft(_that.meta,_that.memberId);case ConflictAcknowledged() when conflictAcknowledged != null:
return conflictAcknowledged(_that.meta,_that.conflictKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( EventMeta meta,  String medicationId,  MedicationDetails details,  DoseSchedule schedule,  DateTime effectiveFrom)  medicationCreated,required TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  MedicationDetails details)  medicationUpdated,required TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  DoseSchedule schedule,  DateTime effectiveFrom)  scheduleChanged,required TResult Function( EventMeta meta,  String medicationId,  int baseVersion)  medicationArchived,required TResult Function( EventMeta meta,  String medicationId,  DateTime? slotAt,  DateTime givenAt,  double units,  List<String> knownDoseIds,  String? note)  doseGiven,required TResult Function( EventMeta meta,  String medicationId,  DateTime slotAt,  String reasonId,  String? note)  doseSkipped,required TResult Function( EventMeta meta,  String targetEventId,  String? conflictKey)  doseUndone,required TResult Function( EventMeta meta,  String medicationId,  double units)  stockCounted,required TResult Function( EventMeta meta,  String medicationId,  double units)  stockRefilled,required TResult Function( EventMeta meta,  String appointmentId,  AppointmentDetails details)  appointmentCreated,required TResult Function( EventMeta meta,  String appointmentId,  int baseVersion,  AppointmentDetails details)  appointmentUpdated,required TResult Function( EventMeta meta,  String appointmentId,  int baseVersion)  appointmentCancelled,required TResult Function( EventMeta meta,  String appointmentId,  String text)  visitNoteAdded,required TResult Function( EventMeta meta,  String text)  careNoteAdded,required TResult Function( EventMeta meta,  String appointmentId,  String title,  String url)  documentLinked,required TResult Function( EventMeta meta,  String appointmentId,  String documentId)  documentRemoved,required TResult Function( EventMeta meta,  int baseVersion,  RecipientProfile profile)  recipientProfileUpdated,required TResult Function( EventMeta meta,  String taskId,  TaskDetails details,  TaskSchedule schedule)  taskCreated,required TResult Function( EventMeta meta,  String taskId,  int baseVersion,  TaskDetails details,  TaskSchedule schedule)  taskUpdated,required TResult Function( EventMeta meta,  String taskId,  int baseVersion)  taskArchived,required TResult Function( EventMeta meta,  String taskId,  DateTime slotAt)  taskDone,required TResult Function( EventMeta meta,  String taskId,  DateTime slotAt,  String reasonId,  String? note)  taskSkipped,required TResult Function( EventMeta meta,  String recipientName,  bool isSample)  circleCreated,required TResult Function( EventMeta meta,  String reasonId,  String label)  skipReasonAdded,required TResult Function( EventMeta meta,  String reasonId)  skipReasonHidden,required TResult Function( EventMeta meta,  String reasonId)  skipReasonShown,required TResult Function( EventMeta meta,  String memberId,  String name,  MemberRole role,  int colorIndex)  memberInvited,required TResult Function( EventMeta meta,  String memberId)  invitationRevoked,required TResult Function( EventMeta meta,  String memberId)  memberJoined,required TResult Function( EventMeta meta,  String memberId,  int baseVersion,  MemberRole role)  roleChanged,required TResult Function( EventMeta meta,  String memberId,  int baseVersion)  memberRemoved,required TResult Function( EventMeta meta,  String memberId)  memberLeft,required TResult Function( EventMeta meta,  String conflictKey)  conflictAcknowledged,}) {final _that = this;
switch (_that) {
case MedicationCreated():
return medicationCreated(_that.meta,_that.medicationId,_that.details,_that.schedule,_that.effectiveFrom);case MedicationUpdated():
return medicationUpdated(_that.meta,_that.medicationId,_that.baseVersion,_that.details);case ScheduleChanged():
return scheduleChanged(_that.meta,_that.medicationId,_that.baseVersion,_that.schedule,_that.effectiveFrom);case MedicationArchived():
return medicationArchived(_that.meta,_that.medicationId,_that.baseVersion);case DoseGiven():
return doseGiven(_that.meta,_that.medicationId,_that.slotAt,_that.givenAt,_that.units,_that.knownDoseIds,_that.note);case DoseSkipped():
return doseSkipped(_that.meta,_that.medicationId,_that.slotAt,_that.reasonId,_that.note);case DoseUndone():
return doseUndone(_that.meta,_that.targetEventId,_that.conflictKey);case StockCounted():
return stockCounted(_that.meta,_that.medicationId,_that.units);case StockRefilled():
return stockRefilled(_that.meta,_that.medicationId,_that.units);case AppointmentCreated():
return appointmentCreated(_that.meta,_that.appointmentId,_that.details);case AppointmentUpdated():
return appointmentUpdated(_that.meta,_that.appointmentId,_that.baseVersion,_that.details);case AppointmentCancelled():
return appointmentCancelled(_that.meta,_that.appointmentId,_that.baseVersion);case VisitNoteAdded():
return visitNoteAdded(_that.meta,_that.appointmentId,_that.text);case CareNoteAdded():
return careNoteAdded(_that.meta,_that.text);case DocumentLinked():
return documentLinked(_that.meta,_that.appointmentId,_that.title,_that.url);case DocumentRemoved():
return documentRemoved(_that.meta,_that.appointmentId,_that.documentId);case RecipientProfileUpdated():
return recipientProfileUpdated(_that.meta,_that.baseVersion,_that.profile);case TaskCreated():
return taskCreated(_that.meta,_that.taskId,_that.details,_that.schedule);case TaskUpdated():
return taskUpdated(_that.meta,_that.taskId,_that.baseVersion,_that.details,_that.schedule);case TaskArchived():
return taskArchived(_that.meta,_that.taskId,_that.baseVersion);case TaskDone():
return taskDone(_that.meta,_that.taskId,_that.slotAt);case TaskSkipped():
return taskSkipped(_that.meta,_that.taskId,_that.slotAt,_that.reasonId,_that.note);case CircleCreated():
return circleCreated(_that.meta,_that.recipientName,_that.isSample);case SkipReasonAdded():
return skipReasonAdded(_that.meta,_that.reasonId,_that.label);case SkipReasonHidden():
return skipReasonHidden(_that.meta,_that.reasonId);case SkipReasonShown():
return skipReasonShown(_that.meta,_that.reasonId);case MemberInvited():
return memberInvited(_that.meta,_that.memberId,_that.name,_that.role,_that.colorIndex);case InvitationRevoked():
return invitationRevoked(_that.meta,_that.memberId);case MemberJoined():
return memberJoined(_that.meta,_that.memberId);case RoleChanged():
return roleChanged(_that.meta,_that.memberId,_that.baseVersion,_that.role);case MemberRemoved():
return memberRemoved(_that.meta,_that.memberId,_that.baseVersion);case MemberLeft():
return memberLeft(_that.meta,_that.memberId);case ConflictAcknowledged():
return conflictAcknowledged(_that.meta,_that.conflictKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( EventMeta meta,  String medicationId,  MedicationDetails details,  DoseSchedule schedule,  DateTime effectiveFrom)?  medicationCreated,TResult? Function( EventMeta meta,  String medicationId,  int baseVersion,  MedicationDetails details)?  medicationUpdated,TResult? Function( EventMeta meta,  String medicationId,  int baseVersion,  DoseSchedule schedule,  DateTime effectiveFrom)?  scheduleChanged,TResult? Function( EventMeta meta,  String medicationId,  int baseVersion)?  medicationArchived,TResult? Function( EventMeta meta,  String medicationId,  DateTime? slotAt,  DateTime givenAt,  double units,  List<String> knownDoseIds,  String? note)?  doseGiven,TResult? Function( EventMeta meta,  String medicationId,  DateTime slotAt,  String reasonId,  String? note)?  doseSkipped,TResult? Function( EventMeta meta,  String targetEventId,  String? conflictKey)?  doseUndone,TResult? Function( EventMeta meta,  String medicationId,  double units)?  stockCounted,TResult? Function( EventMeta meta,  String medicationId,  double units)?  stockRefilled,TResult? Function( EventMeta meta,  String appointmentId,  AppointmentDetails details)?  appointmentCreated,TResult? Function( EventMeta meta,  String appointmentId,  int baseVersion,  AppointmentDetails details)?  appointmentUpdated,TResult? Function( EventMeta meta,  String appointmentId,  int baseVersion)?  appointmentCancelled,TResult? Function( EventMeta meta,  String appointmentId,  String text)?  visitNoteAdded,TResult? Function( EventMeta meta,  String text)?  careNoteAdded,TResult? Function( EventMeta meta,  String appointmentId,  String title,  String url)?  documentLinked,TResult? Function( EventMeta meta,  String appointmentId,  String documentId)?  documentRemoved,TResult? Function( EventMeta meta,  int baseVersion,  RecipientProfile profile)?  recipientProfileUpdated,TResult? Function( EventMeta meta,  String taskId,  TaskDetails details,  TaskSchedule schedule)?  taskCreated,TResult? Function( EventMeta meta,  String taskId,  int baseVersion,  TaskDetails details,  TaskSchedule schedule)?  taskUpdated,TResult? Function( EventMeta meta,  String taskId,  int baseVersion)?  taskArchived,TResult? Function( EventMeta meta,  String taskId,  DateTime slotAt)?  taskDone,TResult? Function( EventMeta meta,  String taskId,  DateTime slotAt,  String reasonId,  String? note)?  taskSkipped,TResult? Function( EventMeta meta,  String recipientName,  bool isSample)?  circleCreated,TResult? Function( EventMeta meta,  String reasonId,  String label)?  skipReasonAdded,TResult? Function( EventMeta meta,  String reasonId)?  skipReasonHidden,TResult? Function( EventMeta meta,  String reasonId)?  skipReasonShown,TResult? Function( EventMeta meta,  String memberId,  String name,  MemberRole role,  int colorIndex)?  memberInvited,TResult? Function( EventMeta meta,  String memberId)?  invitationRevoked,TResult? Function( EventMeta meta,  String memberId)?  memberJoined,TResult? Function( EventMeta meta,  String memberId,  int baseVersion,  MemberRole role)?  roleChanged,TResult? Function( EventMeta meta,  String memberId,  int baseVersion)?  memberRemoved,TResult? Function( EventMeta meta,  String memberId)?  memberLeft,TResult? Function( EventMeta meta,  String conflictKey)?  conflictAcknowledged,}) {final _that = this;
switch (_that) {
case MedicationCreated() when medicationCreated != null:
return medicationCreated(_that.meta,_that.medicationId,_that.details,_that.schedule,_that.effectiveFrom);case MedicationUpdated() when medicationUpdated != null:
return medicationUpdated(_that.meta,_that.medicationId,_that.baseVersion,_that.details);case ScheduleChanged() when scheduleChanged != null:
return scheduleChanged(_that.meta,_that.medicationId,_that.baseVersion,_that.schedule,_that.effectiveFrom);case MedicationArchived() when medicationArchived != null:
return medicationArchived(_that.meta,_that.medicationId,_that.baseVersion);case DoseGiven() when doseGiven != null:
return doseGiven(_that.meta,_that.medicationId,_that.slotAt,_that.givenAt,_that.units,_that.knownDoseIds,_that.note);case DoseSkipped() when doseSkipped != null:
return doseSkipped(_that.meta,_that.medicationId,_that.slotAt,_that.reasonId,_that.note);case DoseUndone() when doseUndone != null:
return doseUndone(_that.meta,_that.targetEventId,_that.conflictKey);case StockCounted() when stockCounted != null:
return stockCounted(_that.meta,_that.medicationId,_that.units);case StockRefilled() when stockRefilled != null:
return stockRefilled(_that.meta,_that.medicationId,_that.units);case AppointmentCreated() when appointmentCreated != null:
return appointmentCreated(_that.meta,_that.appointmentId,_that.details);case AppointmentUpdated() when appointmentUpdated != null:
return appointmentUpdated(_that.meta,_that.appointmentId,_that.baseVersion,_that.details);case AppointmentCancelled() when appointmentCancelled != null:
return appointmentCancelled(_that.meta,_that.appointmentId,_that.baseVersion);case VisitNoteAdded() when visitNoteAdded != null:
return visitNoteAdded(_that.meta,_that.appointmentId,_that.text);case CareNoteAdded() when careNoteAdded != null:
return careNoteAdded(_that.meta,_that.text);case DocumentLinked() when documentLinked != null:
return documentLinked(_that.meta,_that.appointmentId,_that.title,_that.url);case DocumentRemoved() when documentRemoved != null:
return documentRemoved(_that.meta,_that.appointmentId,_that.documentId);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that.meta,_that.baseVersion,_that.profile);case TaskCreated() when taskCreated != null:
return taskCreated(_that.meta,_that.taskId,_that.details,_that.schedule);case TaskUpdated() when taskUpdated != null:
return taskUpdated(_that.meta,_that.taskId,_that.baseVersion,_that.details,_that.schedule);case TaskArchived() when taskArchived != null:
return taskArchived(_that.meta,_that.taskId,_that.baseVersion);case TaskDone() when taskDone != null:
return taskDone(_that.meta,_that.taskId,_that.slotAt);case TaskSkipped() when taskSkipped != null:
return taskSkipped(_that.meta,_that.taskId,_that.slotAt,_that.reasonId,_that.note);case CircleCreated() when circleCreated != null:
return circleCreated(_that.meta,_that.recipientName,_that.isSample);case SkipReasonAdded() when skipReasonAdded != null:
return skipReasonAdded(_that.meta,_that.reasonId,_that.label);case SkipReasonHidden() when skipReasonHidden != null:
return skipReasonHidden(_that.meta,_that.reasonId);case SkipReasonShown() when skipReasonShown != null:
return skipReasonShown(_that.meta,_that.reasonId);case MemberInvited() when memberInvited != null:
return memberInvited(_that.meta,_that.memberId,_that.name,_that.role,_that.colorIndex);case InvitationRevoked() when invitationRevoked != null:
return invitationRevoked(_that.meta,_that.memberId);case MemberJoined() when memberJoined != null:
return memberJoined(_that.meta,_that.memberId);case RoleChanged() when roleChanged != null:
return roleChanged(_that.meta,_that.memberId,_that.baseVersion,_that.role);case MemberRemoved() when memberRemoved != null:
return memberRemoved(_that.meta,_that.memberId,_that.baseVersion);case MemberLeft() when memberLeft != null:
return memberLeft(_that.meta,_that.memberId);case ConflictAcknowledged() when conflictAcknowledged != null:
return conflictAcknowledged(_that.meta,_that.conflictKey);case _:
  return null;

}
}

}

/// @nodoc


class MedicationCreated implements CareEvent {
  const MedicationCreated({required this.meta, required this.medicationId, required this.details, required this.schedule, required this.effectiveFrom});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  MedicationDetails details;
 final  DoseSchedule schedule;
 final  DateTime effectiveFrom;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCreatedCopyWith<MedicationCreated> get copyWith => _$MedicationCreatedCopyWithImpl<MedicationCreated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationCreated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.details, details) || other.details == details)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,details,schedule,effectiveFrom);
}

@override
String toString() {
    return 'CareEvent.medicationCreated(meta: $meta, medicationId: $medicationId, details: $details, schedule: $schedule, effectiveFrom: $effectiveFrom)';
}


}

/// @nodoc
abstract mixin class $MedicationCreatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $MedicationCreatedCopyWith(MedicationCreated value, $Res Function(MedicationCreated) _then) = _$MedicationCreatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, MedicationDetails details, DoseSchedule schedule, DateTime effectiveFrom
});


@override $EventMetaCopyWith<$Res> get meta;$MedicationDetailsCopyWith<$Res> get details;$DoseScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$MedicationCreatedCopyWithImpl<$Res>
    implements $MedicationCreatedCopyWith<$Res> {
  _$MedicationCreatedCopyWithImpl(this._self, this._then);

  final MedicationCreated _self;
  final $Res Function(MedicationCreated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? details = null,Object? schedule = null,Object? effectiveFrom = null,}) {
  return _then(MedicationCreated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as MedicationDetails,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DoseSchedule,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDetailsCopyWith<$Res> get details {
  
  return $MedicationDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoseScheduleCopyWith<$Res> get schedule {
  
  return $DoseScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

/// @nodoc


class MedicationUpdated implements CareEvent {
  const MedicationUpdated({required this.meta, required this.medicationId, required this.baseVersion, required this.details});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  int baseVersion;
 final  MedicationDetails details;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationUpdatedCopyWith<MedicationUpdated> get copyWith => _$MedicationUpdatedCopyWithImpl<MedicationUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationUpdated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,baseVersion,details);
}

@override
String toString() {
    return 'CareEvent.medicationUpdated(meta: $meta, medicationId: $medicationId, baseVersion: $baseVersion, details: $details)';
}


}

/// @nodoc
abstract mixin class $MedicationUpdatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $MedicationUpdatedCopyWith(MedicationUpdated value, $Res Function(MedicationUpdated) _then) = _$MedicationUpdatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, int baseVersion, MedicationDetails details
});


@override $EventMetaCopyWith<$Res> get meta;$MedicationDetailsCopyWith<$Res> get details;

}
/// @nodoc
class _$MedicationUpdatedCopyWithImpl<$Res>
    implements $MedicationUpdatedCopyWith<$Res> {
  _$MedicationUpdatedCopyWithImpl(this._self, this._then);

  final MedicationUpdated _self;
  final $Res Function(MedicationUpdated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? baseVersion = null,Object? details = null,}) {
  return _then(MedicationUpdated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as MedicationDetails,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationDetailsCopyWith<$Res> get details {
  
  return $MedicationDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

/// @nodoc


class ScheduleChanged implements CareEvent {
  const ScheduleChanged({required this.meta, required this.medicationId, required this.baseVersion, required this.schedule, required this.effectiveFrom});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  int baseVersion;
 final  DoseSchedule schedule;
 final  DateTime effectiveFrom;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleChangedCopyWith<ScheduleChanged> get copyWith => _$ScheduleChangedCopyWithImpl<ScheduleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleChanged&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,baseVersion,schedule,effectiveFrom);
}

@override
String toString() {
    return 'CareEvent.scheduleChanged(meta: $meta, medicationId: $medicationId, baseVersion: $baseVersion, schedule: $schedule, effectiveFrom: $effectiveFrom)';
}


}

/// @nodoc
abstract mixin class $ScheduleChangedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $ScheduleChangedCopyWith(ScheduleChanged value, $Res Function(ScheduleChanged) _then) = _$ScheduleChangedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, int baseVersion, DoseSchedule schedule, DateTime effectiveFrom
});


@override $EventMetaCopyWith<$Res> get meta;$DoseScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$ScheduleChangedCopyWithImpl<$Res>
    implements $ScheduleChangedCopyWith<$Res> {
  _$ScheduleChangedCopyWithImpl(this._self, this._then);

  final ScheduleChanged _self;
  final $Res Function(ScheduleChanged) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? baseVersion = null,Object? schedule = null,Object? effectiveFrom = null,}) {
  return _then(ScheduleChanged(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DoseSchedule,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoseScheduleCopyWith<$Res> get schedule {
  
  return $DoseScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

/// @nodoc


class MedicationArchived implements CareEvent {
  const MedicationArchived({required this.meta, required this.medicationId, required this.baseVersion});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  int baseVersion;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationArchivedCopyWith<MedicationArchived> get copyWith => _$MedicationArchivedCopyWithImpl<MedicationArchived>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationArchived&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,baseVersion);
}

@override
String toString() {
    return 'CareEvent.medicationArchived(meta: $meta, medicationId: $medicationId, baseVersion: $baseVersion)';
}


}

/// @nodoc
abstract mixin class $MedicationArchivedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $MedicationArchivedCopyWith(MedicationArchived value, $Res Function(MedicationArchived) _then) = _$MedicationArchivedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, int baseVersion
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$MedicationArchivedCopyWithImpl<$Res>
    implements $MedicationArchivedCopyWith<$Res> {
  _$MedicationArchivedCopyWithImpl(this._self, this._then);

  final MedicationArchived _self;
  final $Res Function(MedicationArchived) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? baseVersion = null,}) {
  return _then(MedicationArchived(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class DoseGiven implements CareEvent {
  const DoseGiven({required this.meta, required this.medicationId, required this.slotAt, required this.givenAt, required this.units,  List<String> knownDoseIds = const <String>[], this.note}): _knownDoseIds = knownDoseIds;
  

@override final  EventMeta meta;
 final  String medicationId;
/// The scheduled time it covers; null for as-needed doses.
 final  DateTime? slotAt;
/// When the caregiver says it was given: now by default, earlier when
/// they record it late. Spacing between doses is measured with it.
 final  DateTime givenAt;
/// Stored with the dose, so later edits never change past stock.
 final  double units;
/// Earlier doses a warning showed before this one was confirmed. A
/// dose given knowing about another is not a conflict with it; with
/// any other dose it still is.
 final  List<String> _knownDoseIds;
/// Earlier doses a warning showed before this one was confirmed. A
/// dose given knowing about another is not a conflict with it; with
/// any other dose it still is.
@JsonKey() List<String> get knownDoseIds {
  if (_knownDoseIds is EqualUnmodifiableListView) return _knownDoseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_knownDoseIds);
}

 final  String? note;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseGivenCopyWith<DoseGiven> get copyWith => _$DoseGivenCopyWithImpl<DoseGiven>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseGiven&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.givenAt, givenAt) || other.givenAt == givenAt)&&(identical(other.units, units) || other.units == units)&&const DeepCollectionEquality().equals(other.knownDoseIds, _knownDoseIds)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,slotAt,givenAt,units,const DeepCollectionEquality().hash(_knownDoseIds),note);
}

@override
String toString() {
    return 'CareEvent.doseGiven(meta: $meta, medicationId: $medicationId, slotAt: $slotAt, givenAt: $givenAt, units: $units, knownDoseIds: $knownDoseIds, note: $note)';
}


}

/// @nodoc
abstract mixin class $DoseGivenCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $DoseGivenCopyWith(DoseGiven value, $Res Function(DoseGiven) _then) = _$DoseGivenCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, DateTime? slotAt, DateTime givenAt, double units, List<String> knownDoseIds, String? note
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$DoseGivenCopyWithImpl<$Res>
    implements $DoseGivenCopyWith<$Res> {
  _$DoseGivenCopyWithImpl(this._self, this._then);

  final DoseGiven _self;
  final $Res Function(DoseGiven) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? slotAt = freezed,Object? givenAt = null,Object? units = null,Object? knownDoseIds = null,Object? note = freezed,}) {
  return _then(DoseGiven(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,slotAt: freezed == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime?,givenAt: null == givenAt ? _self.givenAt : givenAt // ignore: cast_nullable_to_non_nullable
as DateTime,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,knownDoseIds: null == knownDoseIds ? _self._knownDoseIds : knownDoseIds // ignore: cast_nullable_to_non_nullable
as List<String>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class DoseSkipped implements CareEvent {
  const DoseSkipped({required this.meta, required this.medicationId, required this.slotAt, required this.reasonId, this.note});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  DateTime slotAt;
/// A [SkipReason]'s id, or one of the circle's own.
 final  String reasonId;
/// What happened, in the caregiver's words; mostly with "Other".
 final  String? note;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseSkippedCopyWith<DoseSkipped> get copyWith => _$DoseSkippedCopyWithImpl<DoseSkipped>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseSkipped&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.reasonId, reasonId) || other.reasonId == reasonId)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,slotAt,reasonId,note);
}

@override
String toString() {
    return 'CareEvent.doseSkipped(meta: $meta, medicationId: $medicationId, slotAt: $slotAt, reasonId: $reasonId, note: $note)';
}


}

/// @nodoc
abstract mixin class $DoseSkippedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $DoseSkippedCopyWith(DoseSkipped value, $Res Function(DoseSkipped) _then) = _$DoseSkippedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, DateTime slotAt, String reasonId, String? note
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$DoseSkippedCopyWithImpl<$Res>
    implements $DoseSkippedCopyWith<$Res> {
  _$DoseSkippedCopyWithImpl(this._self, this._then);

  final DoseSkipped _self;
  final $Res Function(DoseSkipped) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? slotAt = null,Object? reasonId = null,Object? note = freezed,}) {
  return _then(DoseSkipped(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,reasonId: null == reasonId ? _self.reasonId : reasonId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class DoseUndone implements CareEvent {
  const DoseUndone({required this.meta, required this.targetEventId, this.conflictKey});
  

@override final  EventMeta meta;
 final  String targetEventId;
/// The conflict being reviewed when this cancels a repeated record
/// ("No, only one"); null when someone takes back a mistake.
 final  String? conflictKey;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseUndoneCopyWith<DoseUndone> get copyWith => _$DoseUndoneCopyWithImpl<DoseUndone>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseUndone&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.targetEventId, targetEventId) || other.targetEventId == targetEventId)&&(identical(other.conflictKey, conflictKey) || other.conflictKey == conflictKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,targetEventId,conflictKey);
}

@override
String toString() {
    return 'CareEvent.doseUndone(meta: $meta, targetEventId: $targetEventId, conflictKey: $conflictKey)';
}


}

/// @nodoc
abstract mixin class $DoseUndoneCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $DoseUndoneCopyWith(DoseUndone value, $Res Function(DoseUndone) _then) = _$DoseUndoneCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String targetEventId, String? conflictKey
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$DoseUndoneCopyWithImpl<$Res>
    implements $DoseUndoneCopyWith<$Res> {
  _$DoseUndoneCopyWithImpl(this._self, this._then);

  final DoseUndone _self;
  final $Res Function(DoseUndone) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? targetEventId = null,Object? conflictKey = freezed,}) {
  return _then(DoseUndone(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,targetEventId: null == targetEventId ? _self.targetEventId : targetEventId // ignore: cast_nullable_to_non_nullable
as String,conflictKey: freezed == conflictKey ? _self.conflictKey : conflictKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class StockCounted implements CareEvent {
  const StockCounted({required this.meta, required this.medicationId, required this.units});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  double units;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockCountedCopyWith<StockCounted> get copyWith => _$StockCountedCopyWithImpl<StockCounted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StockCounted&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,units);
}

@override
String toString() {
    return 'CareEvent.stockCounted(meta: $meta, medicationId: $medicationId, units: $units)';
}


}

/// @nodoc
abstract mixin class $StockCountedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $StockCountedCopyWith(StockCounted value, $Res Function(StockCounted) _then) = _$StockCountedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, double units
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$StockCountedCopyWithImpl<$Res>
    implements $StockCountedCopyWith<$Res> {
  _$StockCountedCopyWithImpl(this._self, this._then);

  final StockCounted _self;
  final $Res Function(StockCounted) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? units = null,}) {
  return _then(StockCounted(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class StockRefilled implements CareEvent {
  const StockRefilled({required this.meta, required this.medicationId, required this.units});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  double units;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockRefilledCopyWith<StockRefilled> get copyWith => _$StockRefilledCopyWithImpl<StockRefilled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StockRefilled&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,medicationId,units);
}

@override
String toString() {
    return 'CareEvent.stockRefilled(meta: $meta, medicationId: $medicationId, units: $units)';
}


}

/// @nodoc
abstract mixin class $StockRefilledCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $StockRefilledCopyWith(StockRefilled value, $Res Function(StockRefilled) _then) = _$StockRefilledCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, double units
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$StockRefilledCopyWithImpl<$Res>
    implements $StockRefilledCopyWith<$Res> {
  _$StockRefilledCopyWithImpl(this._self, this._then);

  final StockRefilled _self;
  final $Res Function(StockRefilled) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? units = null,}) {
  return _then(StockRefilled(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class AppointmentCreated implements CareEvent {
  const AppointmentCreated({required this.meta, required this.appointmentId, required this.details});
  

@override final  EventMeta meta;
 final  String appointmentId;
 final  AppointmentDetails details;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCreatedCopyWith<AppointmentCreated> get copyWith => _$AppointmentCreatedCopyWithImpl<AppointmentCreated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentCreated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,appointmentId,details);
}

@override
String toString() {
    return 'CareEvent.appointmentCreated(meta: $meta, appointmentId: $appointmentId, details: $details)';
}


}

/// @nodoc
abstract mixin class $AppointmentCreatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $AppointmentCreatedCopyWith(AppointmentCreated value, $Res Function(AppointmentCreated) _then) = _$AppointmentCreatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String appointmentId, AppointmentDetails details
});


@override $EventMetaCopyWith<$Res> get meta;$AppointmentDetailsCopyWith<$Res> get details;

}
/// @nodoc
class _$AppointmentCreatedCopyWithImpl<$Res>
    implements $AppointmentCreatedCopyWith<$Res> {
  _$AppointmentCreatedCopyWithImpl(this._self, this._then);

  final AppointmentCreated _self;
  final $Res Function(AppointmentCreated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? appointmentId = null,Object? details = null,}) {
  return _then(AppointmentCreated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as AppointmentDetails,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDetailsCopyWith<$Res> get details {
  
  return $AppointmentDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

/// @nodoc


class AppointmentUpdated implements CareEvent {
  const AppointmentUpdated({required this.meta, required this.appointmentId, required this.baseVersion, required this.details});
  

@override final  EventMeta meta;
 final  String appointmentId;
 final  int baseVersion;
 final  AppointmentDetails details;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentUpdatedCopyWith<AppointmentUpdated> get copyWith => _$AppointmentUpdatedCopyWithImpl<AppointmentUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentUpdated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,appointmentId,baseVersion,details);
}

@override
String toString() {
    return 'CareEvent.appointmentUpdated(meta: $meta, appointmentId: $appointmentId, baseVersion: $baseVersion, details: $details)';
}


}

/// @nodoc
abstract mixin class $AppointmentUpdatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $AppointmentUpdatedCopyWith(AppointmentUpdated value, $Res Function(AppointmentUpdated) _then) = _$AppointmentUpdatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String appointmentId, int baseVersion, AppointmentDetails details
});


@override $EventMetaCopyWith<$Res> get meta;$AppointmentDetailsCopyWith<$Res> get details;

}
/// @nodoc
class _$AppointmentUpdatedCopyWithImpl<$Res>
    implements $AppointmentUpdatedCopyWith<$Res> {
  _$AppointmentUpdatedCopyWithImpl(this._self, this._then);

  final AppointmentUpdated _self;
  final $Res Function(AppointmentUpdated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? appointmentId = null,Object? baseVersion = null,Object? details = null,}) {
  return _then(AppointmentUpdated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as AppointmentDetails,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDetailsCopyWith<$Res> get details {
  
  return $AppointmentDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

/// @nodoc


class AppointmentCancelled implements CareEvent {
  const AppointmentCancelled({required this.meta, required this.appointmentId, required this.baseVersion});
  

@override final  EventMeta meta;
 final  String appointmentId;
 final  int baseVersion;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCancelledCopyWith<AppointmentCancelled> get copyWith => _$AppointmentCancelledCopyWithImpl<AppointmentCancelled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentCancelled&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,appointmentId,baseVersion);
}

@override
String toString() {
    return 'CareEvent.appointmentCancelled(meta: $meta, appointmentId: $appointmentId, baseVersion: $baseVersion)';
}


}

/// @nodoc
abstract mixin class $AppointmentCancelledCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $AppointmentCancelledCopyWith(AppointmentCancelled value, $Res Function(AppointmentCancelled) _then) = _$AppointmentCancelledCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String appointmentId, int baseVersion
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$AppointmentCancelledCopyWithImpl<$Res>
    implements $AppointmentCancelledCopyWith<$Res> {
  _$AppointmentCancelledCopyWithImpl(this._self, this._then);

  final AppointmentCancelled _self;
  final $Res Function(AppointmentCancelled) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? appointmentId = null,Object? baseVersion = null,}) {
  return _then(AppointmentCancelled(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class VisitNoteAdded implements CareEvent {
  const VisitNoteAdded({required this.meta, required this.appointmentId, required this.text});
  

@override final  EventMeta meta;
 final  String appointmentId;
 final  String text;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitNoteAddedCopyWith<VisitNoteAdded> get copyWith => _$VisitNoteAddedCopyWithImpl<VisitNoteAdded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitNoteAdded&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,appointmentId,text);
}

@override
String toString() {
    return 'CareEvent.visitNoteAdded(meta: $meta, appointmentId: $appointmentId, text: $text)';
}


}

/// @nodoc
abstract mixin class $VisitNoteAddedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $VisitNoteAddedCopyWith(VisitNoteAdded value, $Res Function(VisitNoteAdded) _then) = _$VisitNoteAddedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String appointmentId, String text
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$VisitNoteAddedCopyWithImpl<$Res>
    implements $VisitNoteAddedCopyWith<$Res> {
  _$VisitNoteAddedCopyWithImpl(this._self, this._then);

  final VisitNoteAdded _self;
  final $Res Function(VisitNoteAdded) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? appointmentId = null,Object? text = null,}) {
  return _then(VisitNoteAdded(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class CareNoteAdded implements CareEvent {
  const CareNoteAdded({required this.meta, required this.text});
  

@override final  EventMeta meta;
 final  String text;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareNoteAddedCopyWith<CareNoteAdded> get copyWith => _$CareNoteAddedCopyWithImpl<CareNoteAdded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CareNoteAdded&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,text);
}

@override
String toString() {
    return 'CareEvent.careNoteAdded(meta: $meta, text: $text)';
}


}

/// @nodoc
abstract mixin class $CareNoteAddedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $CareNoteAddedCopyWith(CareNoteAdded value, $Res Function(CareNoteAdded) _then) = _$CareNoteAddedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String text
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$CareNoteAddedCopyWithImpl<$Res>
    implements $CareNoteAddedCopyWith<$Res> {
  _$CareNoteAddedCopyWithImpl(this._self, this._then);

  final CareNoteAdded _self;
  final $Res Function(CareNoteAdded) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? text = null,}) {
  return _then(CareNoteAdded(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class DocumentLinked implements CareEvent {
  const DocumentLinked({required this.meta, required this.appointmentId, required this.title, required this.url});
  

@override final  EventMeta meta;
 final  String appointmentId;
 final  String title;
/// An http or https URL.
 final  String url;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentLinkedCopyWith<DocumentLinked> get copyWith => _$DocumentLinkedCopyWithImpl<DocumentLinked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentLinked&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,appointmentId,title,url);
}

@override
String toString() {
    return 'CareEvent.documentLinked(meta: $meta, appointmentId: $appointmentId, title: $title, url: $url)';
}


}

/// @nodoc
abstract mixin class $DocumentLinkedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $DocumentLinkedCopyWith(DocumentLinked value, $Res Function(DocumentLinked) _then) = _$DocumentLinkedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String appointmentId, String title, String url
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$DocumentLinkedCopyWithImpl<$Res>
    implements $DocumentLinkedCopyWith<$Res> {
  _$DocumentLinkedCopyWithImpl(this._self, this._then);

  final DocumentLinked _self;
  final $Res Function(DocumentLinked) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? appointmentId = null,Object? title = null,Object? url = null,}) {
  return _then(DocumentLinked(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class DocumentRemoved implements CareEvent {
  const DocumentRemoved({required this.meta, required this.appointmentId, required this.documentId});
  

@override final  EventMeta meta;
 final  String appointmentId;
/// The id of the [DocumentLinked] event.
 final  String documentId;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentRemovedCopyWith<DocumentRemoved> get copyWith => _$DocumentRemovedCopyWithImpl<DocumentRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentRemoved&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.documentId, documentId) || other.documentId == documentId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,appointmentId,documentId);
}

@override
String toString() {
    return 'CareEvent.documentRemoved(meta: $meta, appointmentId: $appointmentId, documentId: $documentId)';
}


}

/// @nodoc
abstract mixin class $DocumentRemovedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $DocumentRemovedCopyWith(DocumentRemoved value, $Res Function(DocumentRemoved) _then) = _$DocumentRemovedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String appointmentId, String documentId
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$DocumentRemovedCopyWithImpl<$Res>
    implements $DocumentRemovedCopyWith<$Res> {
  _$DocumentRemovedCopyWithImpl(this._self, this._then);

  final DocumentRemoved _self;
  final $Res Function(DocumentRemoved) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? appointmentId = null,Object? documentId = null,}) {
  return _then(DocumentRemoved(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class RecipientProfileUpdated implements CareEvent {
  const RecipientProfileUpdated({required this.meta, required this.baseVersion, required this.profile});
  

@override final  EventMeta meta;
 final  int baseVersion;
 final  RecipientProfile profile;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipientProfileUpdatedCopyWith<RecipientProfileUpdated> get copyWith => _$RecipientProfileUpdatedCopyWithImpl<RecipientProfileUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipientProfileUpdated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,baseVersion,profile);
}

@override
String toString() {
    return 'CareEvent.recipientProfileUpdated(meta: $meta, baseVersion: $baseVersion, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $RecipientProfileUpdatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $RecipientProfileUpdatedCopyWith(RecipientProfileUpdated value, $Res Function(RecipientProfileUpdated) _then) = _$RecipientProfileUpdatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, int baseVersion, RecipientProfile profile
});


@override $EventMetaCopyWith<$Res> get meta;$RecipientProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$RecipientProfileUpdatedCopyWithImpl<$Res>
    implements $RecipientProfileUpdatedCopyWith<$Res> {
  _$RecipientProfileUpdatedCopyWithImpl(this._self, this._then);

  final RecipientProfileUpdated _self;
  final $Res Function(RecipientProfileUpdated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? baseVersion = null,Object? profile = null,}) {
  return _then(RecipientProfileUpdated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as RecipientProfile,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipientProfileCopyWith<$Res> get profile {
  
  return $RecipientProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc


class TaskCreated implements CareEvent {
  const TaskCreated({required this.meta, required this.taskId, required this.details, required this.schedule});
  

@override final  EventMeta meta;
 final  String taskId;
 final  TaskDetails details;
 final  TaskSchedule schedule;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCreatedCopyWith<TaskCreated> get copyWith => _$TaskCreatedCopyWithImpl<TaskCreated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCreated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.details, details) || other.details == details)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,taskId,details,schedule);
}

@override
String toString() {
    return 'CareEvent.taskCreated(meta: $meta, taskId: $taskId, details: $details, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $TaskCreatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $TaskCreatedCopyWith(TaskCreated value, $Res Function(TaskCreated) _then) = _$TaskCreatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String taskId, TaskDetails details, TaskSchedule schedule
});


@override $EventMetaCopyWith<$Res> get meta;$TaskDetailsCopyWith<$Res> get details;$TaskScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$TaskCreatedCopyWithImpl<$Res>
    implements $TaskCreatedCopyWith<$Res> {
  _$TaskCreatedCopyWithImpl(this._self, this._then);

  final TaskCreated _self;
  final $Res Function(TaskCreated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? taskId = null,Object? details = null,Object? schedule = null,}) {
  return _then(TaskCreated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as TaskDetails,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as TaskSchedule,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskDetailsCopyWith<$Res> get details {
  
  return $TaskDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskScheduleCopyWith<$Res> get schedule {
  
  return $TaskScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

/// @nodoc


class TaskUpdated implements CareEvent {
  const TaskUpdated({required this.meta, required this.taskId, required this.baseVersion, required this.details, required this.schedule});
  

@override final  EventMeta meta;
 final  String taskId;
 final  int baseVersion;
 final  TaskDetails details;
 final  TaskSchedule schedule;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskUpdatedCopyWith<TaskUpdated> get copyWith => _$TaskUpdatedCopyWithImpl<TaskUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskUpdated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.details, details) || other.details == details)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,taskId,baseVersion,details,schedule);
}

@override
String toString() {
    return 'CareEvent.taskUpdated(meta: $meta, taskId: $taskId, baseVersion: $baseVersion, details: $details, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $TaskUpdatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $TaskUpdatedCopyWith(TaskUpdated value, $Res Function(TaskUpdated) _then) = _$TaskUpdatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String taskId, int baseVersion, TaskDetails details, TaskSchedule schedule
});


@override $EventMetaCopyWith<$Res> get meta;$TaskDetailsCopyWith<$Res> get details;$TaskScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$TaskUpdatedCopyWithImpl<$Res>
    implements $TaskUpdatedCopyWith<$Res> {
  _$TaskUpdatedCopyWithImpl(this._self, this._then);

  final TaskUpdated _self;
  final $Res Function(TaskUpdated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? taskId = null,Object? baseVersion = null,Object? details = null,Object? schedule = null,}) {
  return _then(TaskUpdated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as TaskDetails,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as TaskSchedule,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskDetailsCopyWith<$Res> get details {
  
  return $TaskDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskScheduleCopyWith<$Res> get schedule {
  
  return $TaskScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

/// @nodoc


class TaskArchived implements CareEvent {
  const TaskArchived({required this.meta, required this.taskId, required this.baseVersion});
  

@override final  EventMeta meta;
 final  String taskId;
 final  int baseVersion;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskArchivedCopyWith<TaskArchived> get copyWith => _$TaskArchivedCopyWithImpl<TaskArchived>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskArchived&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,taskId,baseVersion);
}

@override
String toString() {
    return 'CareEvent.taskArchived(meta: $meta, taskId: $taskId, baseVersion: $baseVersion)';
}


}

/// @nodoc
abstract mixin class $TaskArchivedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $TaskArchivedCopyWith(TaskArchived value, $Res Function(TaskArchived) _then) = _$TaskArchivedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String taskId, int baseVersion
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$TaskArchivedCopyWithImpl<$Res>
    implements $TaskArchivedCopyWith<$Res> {
  _$TaskArchivedCopyWithImpl(this._self, this._then);

  final TaskArchived _self;
  final $Res Function(TaskArchived) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? taskId = null,Object? baseVersion = null,}) {
  return _then(TaskArchived(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class TaskDone implements CareEvent {
  const TaskDone({required this.meta, required this.taskId, required this.slotAt});
  

@override final  EventMeta meta;
 final  String taskId;
/// The time it was due; the start of the day for a task with no set
/// time.
 final  DateTime slotAt;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDoneCopyWith<TaskDone> get copyWith => _$TaskDoneCopyWithImpl<TaskDone>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDone&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,taskId,slotAt);
}

@override
String toString() {
    return 'CareEvent.taskDone(meta: $meta, taskId: $taskId, slotAt: $slotAt)';
}


}

/// @nodoc
abstract mixin class $TaskDoneCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $TaskDoneCopyWith(TaskDone value, $Res Function(TaskDone) _then) = _$TaskDoneCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String taskId, DateTime slotAt
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$TaskDoneCopyWithImpl<$Res>
    implements $TaskDoneCopyWith<$Res> {
  _$TaskDoneCopyWithImpl(this._self, this._then);

  final TaskDone _self;
  final $Res Function(TaskDone) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? taskId = null,Object? slotAt = null,}) {
  return _then(TaskDone(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class TaskSkipped implements CareEvent {
  const TaskSkipped({required this.meta, required this.taskId, required this.slotAt, required this.reasonId, this.note});
  

@override final  EventMeta meta;
 final  String taskId;
 final  DateTime slotAt;
/// A [SkipReason]'s id, or one of the circle's own.
 final  String reasonId;
 final  String? note;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSkippedCopyWith<TaskSkipped> get copyWith => _$TaskSkippedCopyWithImpl<TaskSkipped>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSkipped&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.reasonId, reasonId) || other.reasonId == reasonId)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,taskId,slotAt,reasonId,note);
}

@override
String toString() {
    return 'CareEvent.taskSkipped(meta: $meta, taskId: $taskId, slotAt: $slotAt, reasonId: $reasonId, note: $note)';
}


}

/// @nodoc
abstract mixin class $TaskSkippedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $TaskSkippedCopyWith(TaskSkipped value, $Res Function(TaskSkipped) _then) = _$TaskSkippedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String taskId, DateTime slotAt, String reasonId, String? note
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$TaskSkippedCopyWithImpl<$Res>
    implements $TaskSkippedCopyWith<$Res> {
  _$TaskSkippedCopyWithImpl(this._self, this._then);

  final TaskSkipped _self;
  final $Res Function(TaskSkipped) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? taskId = null,Object? slotAt = null,Object? reasonId = null,Object? note = freezed,}) {
  return _then(TaskSkipped(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,reasonId: null == reasonId ? _self.reasonId : reasonId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class CircleCreated implements CareEvent {
  const CircleCreated({required this.meta, required this.recipientName, this.isSample = false});
  

@override final  EventMeta meta;
/// How the app names the person cared for ("Caring for Elena").
 final  String recipientName;
/// The demo's sample circle, labeled as such in the app.
@JsonKey() final  bool isSample;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleCreatedCopyWith<CircleCreated> get copyWith => _$CircleCreatedCopyWithImpl<CircleCreated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleCreated&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.isSample, isSample) || other.isSample == isSample));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,recipientName,isSample);
}

@override
String toString() {
    return 'CareEvent.circleCreated(meta: $meta, recipientName: $recipientName, isSample: $isSample)';
}


}

/// @nodoc
abstract mixin class $CircleCreatedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $CircleCreatedCopyWith(CircleCreated value, $Res Function(CircleCreated) _then) = _$CircleCreatedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String recipientName, bool isSample
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$CircleCreatedCopyWithImpl<$Res>
    implements $CircleCreatedCopyWith<$Res> {
  _$CircleCreatedCopyWithImpl(this._self, this._then);

  final CircleCreated _self;
  final $Res Function(CircleCreated) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? recipientName = null,Object? isSample = null,}) {
  return _then(CircleCreated(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,isSample: null == isSample ? _self.isSample : isSample // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class SkipReasonAdded implements CareEvent {
  const SkipReasonAdded({required this.meta, required this.reasonId, required this.label});
  

@override final  EventMeta meta;
 final  String reasonId;
 final  String label;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkipReasonAddedCopyWith<SkipReasonAdded> get copyWith => _$SkipReasonAddedCopyWithImpl<SkipReasonAdded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipReasonAdded&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.reasonId, reasonId) || other.reasonId == reasonId)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,reasonId,label);
}

@override
String toString() {
    return 'CareEvent.skipReasonAdded(meta: $meta, reasonId: $reasonId, label: $label)';
}


}

/// @nodoc
abstract mixin class $SkipReasonAddedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $SkipReasonAddedCopyWith(SkipReasonAdded value, $Res Function(SkipReasonAdded) _then) = _$SkipReasonAddedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String reasonId, String label
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$SkipReasonAddedCopyWithImpl<$Res>
    implements $SkipReasonAddedCopyWith<$Res> {
  _$SkipReasonAddedCopyWithImpl(this._self, this._then);

  final SkipReasonAdded _self;
  final $Res Function(SkipReasonAdded) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? reasonId = null,Object? label = null,}) {
  return _then(SkipReasonAdded(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,reasonId: null == reasonId ? _self.reasonId : reasonId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class SkipReasonHidden implements CareEvent {
  const SkipReasonHidden({required this.meta, required this.reasonId});
  

@override final  EventMeta meta;
 final  String reasonId;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkipReasonHiddenCopyWith<SkipReasonHidden> get copyWith => _$SkipReasonHiddenCopyWithImpl<SkipReasonHidden>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipReasonHidden&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.reasonId, reasonId) || other.reasonId == reasonId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,reasonId);
}

@override
String toString() {
    return 'CareEvent.skipReasonHidden(meta: $meta, reasonId: $reasonId)';
}


}

/// @nodoc
abstract mixin class $SkipReasonHiddenCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $SkipReasonHiddenCopyWith(SkipReasonHidden value, $Res Function(SkipReasonHidden) _then) = _$SkipReasonHiddenCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String reasonId
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$SkipReasonHiddenCopyWithImpl<$Res>
    implements $SkipReasonHiddenCopyWith<$Res> {
  _$SkipReasonHiddenCopyWithImpl(this._self, this._then);

  final SkipReasonHidden _self;
  final $Res Function(SkipReasonHidden) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? reasonId = null,}) {
  return _then(SkipReasonHidden(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,reasonId: null == reasonId ? _self.reasonId : reasonId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class SkipReasonShown implements CareEvent {
  const SkipReasonShown({required this.meta, required this.reasonId});
  

@override final  EventMeta meta;
 final  String reasonId;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkipReasonShownCopyWith<SkipReasonShown> get copyWith => _$SkipReasonShownCopyWithImpl<SkipReasonShown>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipReasonShown&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.reasonId, reasonId) || other.reasonId == reasonId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,reasonId);
}

@override
String toString() {
    return 'CareEvent.skipReasonShown(meta: $meta, reasonId: $reasonId)';
}


}

/// @nodoc
abstract mixin class $SkipReasonShownCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $SkipReasonShownCopyWith(SkipReasonShown value, $Res Function(SkipReasonShown) _then) = _$SkipReasonShownCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String reasonId
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$SkipReasonShownCopyWithImpl<$Res>
    implements $SkipReasonShownCopyWith<$Res> {
  _$SkipReasonShownCopyWithImpl(this._self, this._then);

  final SkipReasonShown _self;
  final $Res Function(SkipReasonShown) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? reasonId = null,}) {
  return _then(SkipReasonShown(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,reasonId: null == reasonId ? _self.reasonId : reasonId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class MemberInvited implements CareEvent {
  const MemberInvited({required this.meta, required this.memberId, required this.name, required this.role, required this.colorIndex});
  

@override final  EventMeta meta;
 final  String memberId;
 final  String name;
 final  MemberRole role;
 final  int colorIndex;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberInvitedCopyWith<MemberInvited> get copyWith => _$MemberInvitedCopyWithImpl<MemberInvited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberInvited&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,memberId,name,role,colorIndex);
}

@override
String toString() {
    return 'CareEvent.memberInvited(meta: $meta, memberId: $memberId, name: $name, role: $role, colorIndex: $colorIndex)';
}


}

/// @nodoc
abstract mixin class $MemberInvitedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $MemberInvitedCopyWith(MemberInvited value, $Res Function(MemberInvited) _then) = _$MemberInvitedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String memberId, String name, MemberRole role, int colorIndex
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$MemberInvitedCopyWithImpl<$Res>
    implements $MemberInvitedCopyWith<$Res> {
  _$MemberInvitedCopyWithImpl(this._self, this._then);

  final MemberInvited _self;
  final $Res Function(MemberInvited) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? memberId = null,Object? name = null,Object? role = null,Object? colorIndex = null,}) {
  return _then(MemberInvited(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class InvitationRevoked implements CareEvent {
  const InvitationRevoked({required this.meta, required this.memberId});
  

@override final  EventMeta meta;
 final  String memberId;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationRevokedCopyWith<InvitationRevoked> get copyWith => _$InvitationRevokedCopyWithImpl<InvitationRevoked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitationRevoked&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,memberId);
}

@override
String toString() {
    return 'CareEvent.invitationRevoked(meta: $meta, memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class $InvitationRevokedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $InvitationRevokedCopyWith(InvitationRevoked value, $Res Function(InvitationRevoked) _then) = _$InvitationRevokedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String memberId
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$InvitationRevokedCopyWithImpl<$Res>
    implements $InvitationRevokedCopyWith<$Res> {
  _$InvitationRevokedCopyWithImpl(this._self, this._then);

  final InvitationRevoked _self;
  final $Res Function(InvitationRevoked) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? memberId = null,}) {
  return _then(InvitationRevoked(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class MemberJoined implements CareEvent {
  const MemberJoined({required this.meta, required this.memberId});
  

@override final  EventMeta meta;
 final  String memberId;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberJoinedCopyWith<MemberJoined> get copyWith => _$MemberJoinedCopyWithImpl<MemberJoined>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberJoined&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,memberId);
}

@override
String toString() {
    return 'CareEvent.memberJoined(meta: $meta, memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class $MemberJoinedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $MemberJoinedCopyWith(MemberJoined value, $Res Function(MemberJoined) _then) = _$MemberJoinedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String memberId
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$MemberJoinedCopyWithImpl<$Res>
    implements $MemberJoinedCopyWith<$Res> {
  _$MemberJoinedCopyWithImpl(this._self, this._then);

  final MemberJoined _self;
  final $Res Function(MemberJoined) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? memberId = null,}) {
  return _then(MemberJoined(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class RoleChanged implements CareEvent {
  const RoleChanged({required this.meta, required this.memberId, required this.baseVersion, required this.role});
  

@override final  EventMeta meta;
 final  String memberId;
 final  int baseVersion;
 final  MemberRole role;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleChangedCopyWith<RoleChanged> get copyWith => _$RoleChangedCopyWithImpl<RoleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleChanged&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,memberId,baseVersion,role);
}

@override
String toString() {
    return 'CareEvent.roleChanged(meta: $meta, memberId: $memberId, baseVersion: $baseVersion, role: $role)';
}


}

/// @nodoc
abstract mixin class $RoleChangedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $RoleChangedCopyWith(RoleChanged value, $Res Function(RoleChanged) _then) = _$RoleChangedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String memberId, int baseVersion, MemberRole role
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$RoleChangedCopyWithImpl<$Res>
    implements $RoleChangedCopyWith<$Res> {
  _$RoleChangedCopyWithImpl(this._self, this._then);

  final RoleChanged _self;
  final $Res Function(RoleChanged) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? memberId = null,Object? baseVersion = null,Object? role = null,}) {
  return _then(RoleChanged(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class MemberRemoved implements CareEvent {
  const MemberRemoved({required this.meta, required this.memberId, required this.baseVersion});
  

@override final  EventMeta meta;
 final  String memberId;
 final  int baseVersion;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberRemovedCopyWith<MemberRemoved> get copyWith => _$MemberRemovedCopyWithImpl<MemberRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberRemoved&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,memberId,baseVersion);
}

@override
String toString() {
    return 'CareEvent.memberRemoved(meta: $meta, memberId: $memberId, baseVersion: $baseVersion)';
}


}

/// @nodoc
abstract mixin class $MemberRemovedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $MemberRemovedCopyWith(MemberRemoved value, $Res Function(MemberRemoved) _then) = _$MemberRemovedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String memberId, int baseVersion
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$MemberRemovedCopyWithImpl<$Res>
    implements $MemberRemovedCopyWith<$Res> {
  _$MemberRemovedCopyWithImpl(this._self, this._then);

  final MemberRemoved _self;
  final $Res Function(MemberRemoved) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? memberId = null,Object? baseVersion = null,}) {
  return _then(MemberRemoved(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class MemberLeft implements CareEvent {
  const MemberLeft({required this.meta, required this.memberId});
  

@override final  EventMeta meta;
 final  String memberId;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberLeftCopyWith<MemberLeft> get copyWith => _$MemberLeftCopyWithImpl<MemberLeft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberLeft&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,memberId);
}

@override
String toString() {
    return 'CareEvent.memberLeft(meta: $meta, memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class $MemberLeftCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $MemberLeftCopyWith(MemberLeft value, $Res Function(MemberLeft) _then) = _$MemberLeftCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String memberId
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$MemberLeftCopyWithImpl<$Res>
    implements $MemberLeftCopyWith<$Res> {
  _$MemberLeftCopyWithImpl(this._self, this._then);

  final MemberLeft _self;
  final $Res Function(MemberLeft) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? memberId = null,}) {
  return _then(MemberLeft(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc


class ConflictAcknowledged implements CareEvent {
  const ConflictAcknowledged({required this.meta, required this.conflictKey});
  

@override final  EventMeta meta;
 final  String conflictKey;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictAcknowledgedCopyWith<ConflictAcknowledged> get copyWith => _$ConflictAcknowledgedCopyWithImpl<ConflictAcknowledged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictAcknowledged&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.conflictKey, conflictKey) || other.conflictKey == conflictKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,meta,conflictKey);
}

@override
String toString() {
    return 'CareEvent.conflictAcknowledged(meta: $meta, conflictKey: $conflictKey)';
}


}

/// @nodoc
abstract mixin class $ConflictAcknowledgedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $ConflictAcknowledgedCopyWith(ConflictAcknowledged value, $Res Function(ConflictAcknowledged) _then) = _$ConflictAcknowledgedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String conflictKey
});


@override $EventMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$ConflictAcknowledgedCopyWithImpl<$Res>
    implements $ConflictAcknowledgedCopyWith<$Res> {
  _$ConflictAcknowledgedCopyWithImpl(this._self, this._then);

  final ConflictAcknowledged _self;
  final $Res Function(ConflictAcknowledged) _then;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? conflictKey = null,}) {
  return _then(ConflictAcknowledged(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,conflictKey: null == conflictKey ? _self.conflictKey : conflictKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventMetaCopyWith<$Res> get meta {
  
  return $EventMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
