// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventMeta {

/// UUID generated on the device, so retries never duplicate an event.
 String get id; String get caregiverId;/// When it happened, by the device clock. Shown to people; never used
/// to order or resolve anything, since device clocks drift.
 DateTime get occurredAt;/// When the server received it; null until synced. Orders the log.
 DateTime? get receivedAt;
/// Create a copy of EventMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventMetaCopyWith<EventMeta> get copyWith => _$EventMetaCopyWithImpl<EventMeta>(this as EventMeta, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,caregiverId,occurredAt,receivedAt);

@override
String toString() {
  return 'EventMeta(id: $id, caregiverId: $caregiverId, occurredAt: $occurredAt, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class $EventMetaCopyWith<$Res>  {
  factory $EventMetaCopyWith(EventMeta value, $Res Function(EventMeta) _then) = _$EventMetaCopyWithImpl;
@useResult
$Res call({
 String id, String caregiverId, DateTime occurredAt, DateTime? receivedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? caregiverId = null,Object? occurredAt = null,Object? receivedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String caregiverId,  DateTime occurredAt,  DateTime? receivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventMeta() when $default != null:
return $default(_that.id,_that.caregiverId,_that.occurredAt,_that.receivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String caregiverId,  DateTime occurredAt,  DateTime? receivedAt)  $default,) {final _that = this;
switch (_that) {
case _EventMeta():
return $default(_that.id,_that.caregiverId,_that.occurredAt,_that.receivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String caregiverId,  DateTime occurredAt,  DateTime? receivedAt)?  $default,) {final _that = this;
switch (_that) {
case _EventMeta() when $default != null:
return $default(_that.id,_that.caregiverId,_that.occurredAt,_that.receivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _EventMeta extends EventMeta {
  const _EventMeta({required this.id, required this.caregiverId, required this.occurredAt, this.receivedAt}): super._();
  

/// UUID generated on the device, so retries never duplicate an event.
@override final  String id;
@override final  String caregiverId;
/// When it happened, by the device clock. Shown to people; never used
/// to order or resolve anything, since device clocks drift.
@override final  DateTime occurredAt;
/// When the server received it; null until synced. Orders the log.
@override final  DateTime? receivedAt;

/// Create a copy of EventMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventMetaCopyWith<_EventMeta> get copyWith => __$EventMetaCopyWithImpl<_EventMeta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,caregiverId,occurredAt,receivedAt);

@override
String toString() {
  return 'EventMeta(id: $id, caregiverId: $caregiverId, occurredAt: $occurredAt, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class _$EventMetaCopyWith<$Res> implements $EventMetaCopyWith<$Res> {
  factory _$EventMetaCopyWith(_EventMeta value, $Res Function(_EventMeta) _then) = __$EventMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, String caregiverId, DateTime occurredAt, DateTime? receivedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? caregiverId = null,Object? occurredAt = null,Object? receivedAt = freezed,}) {
  return _then(_EventMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareEvent&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,meta);

@override
String toString() {
  return 'CareEvent(meta: $meta)';
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MedicationCreated value)?  medicationCreated,TResult Function( MedicationUpdated value)?  medicationUpdated,TResult Function( ScheduleChanged value)?  scheduleChanged,TResult Function( MedicationArchived value)?  medicationArchived,TResult Function( DoseGiven value)?  doseGiven,TResult Function( DoseSkipped value)?  doseSkipped,TResult Function( DoseUndone value)?  doseUndone,TResult Function( StockCounted value)?  stockCounted,TResult Function( StockRefilled value)?  stockRefilled,TResult Function( AppointmentCreated value)?  appointmentCreated,TResult Function( AppointmentUpdated value)?  appointmentUpdated,TResult Function( AppointmentCancelled value)?  appointmentCancelled,TResult Function( VisitNoteAdded value)?  visitNoteAdded,TResult Function( RecipientProfileUpdated value)?  recipientProfileUpdated,TResult Function( ConflictAcknowledged value)?  conflictAcknowledged,required TResult orElse(),}){
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
return visitNoteAdded(_that);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that);case ConflictAcknowledged() when conflictAcknowledged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MedicationCreated value)  medicationCreated,required TResult Function( MedicationUpdated value)  medicationUpdated,required TResult Function( ScheduleChanged value)  scheduleChanged,required TResult Function( MedicationArchived value)  medicationArchived,required TResult Function( DoseGiven value)  doseGiven,required TResult Function( DoseSkipped value)  doseSkipped,required TResult Function( DoseUndone value)  doseUndone,required TResult Function( StockCounted value)  stockCounted,required TResult Function( StockRefilled value)  stockRefilled,required TResult Function( AppointmentCreated value)  appointmentCreated,required TResult Function( AppointmentUpdated value)  appointmentUpdated,required TResult Function( AppointmentCancelled value)  appointmentCancelled,required TResult Function( VisitNoteAdded value)  visitNoteAdded,required TResult Function( RecipientProfileUpdated value)  recipientProfileUpdated,required TResult Function( ConflictAcknowledged value)  conflictAcknowledged,}){
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
return visitNoteAdded(_that);case RecipientProfileUpdated():
return recipientProfileUpdated(_that);case ConflictAcknowledged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MedicationCreated value)?  medicationCreated,TResult? Function( MedicationUpdated value)?  medicationUpdated,TResult? Function( ScheduleChanged value)?  scheduleChanged,TResult? Function( MedicationArchived value)?  medicationArchived,TResult? Function( DoseGiven value)?  doseGiven,TResult? Function( DoseSkipped value)?  doseSkipped,TResult? Function( DoseUndone value)?  doseUndone,TResult? Function( StockCounted value)?  stockCounted,TResult? Function( StockRefilled value)?  stockRefilled,TResult? Function( AppointmentCreated value)?  appointmentCreated,TResult? Function( AppointmentUpdated value)?  appointmentUpdated,TResult? Function( AppointmentCancelled value)?  appointmentCancelled,TResult? Function( VisitNoteAdded value)?  visitNoteAdded,TResult? Function( RecipientProfileUpdated value)?  recipientProfileUpdated,TResult? Function( ConflictAcknowledged value)?  conflictAcknowledged,}){
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
return visitNoteAdded(_that);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that);case ConflictAcknowledged() when conflictAcknowledged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( EventMeta meta,  String medicationId,  MedicationDetails details,  DoseSchedule schedule,  DateTime effectiveFrom)?  medicationCreated,TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  MedicationDetails details)?  medicationUpdated,TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  DoseSchedule schedule,  DateTime effectiveFrom)?  scheduleChanged,TResult Function( EventMeta meta,  String medicationId,  int baseVersion)?  medicationArchived,TResult Function( EventMeta meta,  String medicationId,  DateTime? slotAt,  DateTime givenAt,  double units,  List<String> knownDoseIds,  String? note)?  doseGiven,TResult Function( EventMeta meta,  String medicationId,  DateTime slotAt,  SkipReason reason,  String? note)?  doseSkipped,TResult Function( EventMeta meta,  String targetEventId)?  doseUndone,TResult Function( EventMeta meta,  String medicationId,  double units)?  stockCounted,TResult Function( EventMeta meta,  String medicationId,  double units)?  stockRefilled,TResult Function( EventMeta meta,  String appointmentId,  AppointmentDetails details)?  appointmentCreated,TResult Function( EventMeta meta,  String appointmentId,  int baseVersion,  AppointmentDetails details)?  appointmentUpdated,TResult Function( EventMeta meta,  String appointmentId,  int baseVersion)?  appointmentCancelled,TResult Function( EventMeta meta,  String appointmentId,  String text)?  visitNoteAdded,TResult Function( EventMeta meta,  int baseVersion,  RecipientProfile profile)?  recipientProfileUpdated,TResult Function( EventMeta meta,  String conflictKey)?  conflictAcknowledged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MedicationCreated() when medicationCreated != null:
return medicationCreated(_that.meta,_that.medicationId,_that.details,_that.schedule,_that.effectiveFrom);case MedicationUpdated() when medicationUpdated != null:
return medicationUpdated(_that.meta,_that.medicationId,_that.baseVersion,_that.details);case ScheduleChanged() when scheduleChanged != null:
return scheduleChanged(_that.meta,_that.medicationId,_that.baseVersion,_that.schedule,_that.effectiveFrom);case MedicationArchived() when medicationArchived != null:
return medicationArchived(_that.meta,_that.medicationId,_that.baseVersion);case DoseGiven() when doseGiven != null:
return doseGiven(_that.meta,_that.medicationId,_that.slotAt,_that.givenAt,_that.units,_that.knownDoseIds,_that.note);case DoseSkipped() when doseSkipped != null:
return doseSkipped(_that.meta,_that.medicationId,_that.slotAt,_that.reason,_that.note);case DoseUndone() when doseUndone != null:
return doseUndone(_that.meta,_that.targetEventId);case StockCounted() when stockCounted != null:
return stockCounted(_that.meta,_that.medicationId,_that.units);case StockRefilled() when stockRefilled != null:
return stockRefilled(_that.meta,_that.medicationId,_that.units);case AppointmentCreated() when appointmentCreated != null:
return appointmentCreated(_that.meta,_that.appointmentId,_that.details);case AppointmentUpdated() when appointmentUpdated != null:
return appointmentUpdated(_that.meta,_that.appointmentId,_that.baseVersion,_that.details);case AppointmentCancelled() when appointmentCancelled != null:
return appointmentCancelled(_that.meta,_that.appointmentId,_that.baseVersion);case VisitNoteAdded() when visitNoteAdded != null:
return visitNoteAdded(_that.meta,_that.appointmentId,_that.text);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that.meta,_that.baseVersion,_that.profile);case ConflictAcknowledged() when conflictAcknowledged != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( EventMeta meta,  String medicationId,  MedicationDetails details,  DoseSchedule schedule,  DateTime effectiveFrom)  medicationCreated,required TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  MedicationDetails details)  medicationUpdated,required TResult Function( EventMeta meta,  String medicationId,  int baseVersion,  DoseSchedule schedule,  DateTime effectiveFrom)  scheduleChanged,required TResult Function( EventMeta meta,  String medicationId,  int baseVersion)  medicationArchived,required TResult Function( EventMeta meta,  String medicationId,  DateTime? slotAt,  DateTime givenAt,  double units,  List<String> knownDoseIds,  String? note)  doseGiven,required TResult Function( EventMeta meta,  String medicationId,  DateTime slotAt,  SkipReason reason,  String? note)  doseSkipped,required TResult Function( EventMeta meta,  String targetEventId)  doseUndone,required TResult Function( EventMeta meta,  String medicationId,  double units)  stockCounted,required TResult Function( EventMeta meta,  String medicationId,  double units)  stockRefilled,required TResult Function( EventMeta meta,  String appointmentId,  AppointmentDetails details)  appointmentCreated,required TResult Function( EventMeta meta,  String appointmentId,  int baseVersion,  AppointmentDetails details)  appointmentUpdated,required TResult Function( EventMeta meta,  String appointmentId,  int baseVersion)  appointmentCancelled,required TResult Function( EventMeta meta,  String appointmentId,  String text)  visitNoteAdded,required TResult Function( EventMeta meta,  int baseVersion,  RecipientProfile profile)  recipientProfileUpdated,required TResult Function( EventMeta meta,  String conflictKey)  conflictAcknowledged,}) {final _that = this;
switch (_that) {
case MedicationCreated():
return medicationCreated(_that.meta,_that.medicationId,_that.details,_that.schedule,_that.effectiveFrom);case MedicationUpdated():
return medicationUpdated(_that.meta,_that.medicationId,_that.baseVersion,_that.details);case ScheduleChanged():
return scheduleChanged(_that.meta,_that.medicationId,_that.baseVersion,_that.schedule,_that.effectiveFrom);case MedicationArchived():
return medicationArchived(_that.meta,_that.medicationId,_that.baseVersion);case DoseGiven():
return doseGiven(_that.meta,_that.medicationId,_that.slotAt,_that.givenAt,_that.units,_that.knownDoseIds,_that.note);case DoseSkipped():
return doseSkipped(_that.meta,_that.medicationId,_that.slotAt,_that.reason,_that.note);case DoseUndone():
return doseUndone(_that.meta,_that.targetEventId);case StockCounted():
return stockCounted(_that.meta,_that.medicationId,_that.units);case StockRefilled():
return stockRefilled(_that.meta,_that.medicationId,_that.units);case AppointmentCreated():
return appointmentCreated(_that.meta,_that.appointmentId,_that.details);case AppointmentUpdated():
return appointmentUpdated(_that.meta,_that.appointmentId,_that.baseVersion,_that.details);case AppointmentCancelled():
return appointmentCancelled(_that.meta,_that.appointmentId,_that.baseVersion);case VisitNoteAdded():
return visitNoteAdded(_that.meta,_that.appointmentId,_that.text);case RecipientProfileUpdated():
return recipientProfileUpdated(_that.meta,_that.baseVersion,_that.profile);case ConflictAcknowledged():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( EventMeta meta,  String medicationId,  MedicationDetails details,  DoseSchedule schedule,  DateTime effectiveFrom)?  medicationCreated,TResult? Function( EventMeta meta,  String medicationId,  int baseVersion,  MedicationDetails details)?  medicationUpdated,TResult? Function( EventMeta meta,  String medicationId,  int baseVersion,  DoseSchedule schedule,  DateTime effectiveFrom)?  scheduleChanged,TResult? Function( EventMeta meta,  String medicationId,  int baseVersion)?  medicationArchived,TResult? Function( EventMeta meta,  String medicationId,  DateTime? slotAt,  DateTime givenAt,  double units,  List<String> knownDoseIds,  String? note)?  doseGiven,TResult? Function( EventMeta meta,  String medicationId,  DateTime slotAt,  SkipReason reason,  String? note)?  doseSkipped,TResult? Function( EventMeta meta,  String targetEventId)?  doseUndone,TResult? Function( EventMeta meta,  String medicationId,  double units)?  stockCounted,TResult? Function( EventMeta meta,  String medicationId,  double units)?  stockRefilled,TResult? Function( EventMeta meta,  String appointmentId,  AppointmentDetails details)?  appointmentCreated,TResult? Function( EventMeta meta,  String appointmentId,  int baseVersion,  AppointmentDetails details)?  appointmentUpdated,TResult? Function( EventMeta meta,  String appointmentId,  int baseVersion)?  appointmentCancelled,TResult? Function( EventMeta meta,  String appointmentId,  String text)?  visitNoteAdded,TResult? Function( EventMeta meta,  int baseVersion,  RecipientProfile profile)?  recipientProfileUpdated,TResult? Function( EventMeta meta,  String conflictKey)?  conflictAcknowledged,}) {final _that = this;
switch (_that) {
case MedicationCreated() when medicationCreated != null:
return medicationCreated(_that.meta,_that.medicationId,_that.details,_that.schedule,_that.effectiveFrom);case MedicationUpdated() when medicationUpdated != null:
return medicationUpdated(_that.meta,_that.medicationId,_that.baseVersion,_that.details);case ScheduleChanged() when scheduleChanged != null:
return scheduleChanged(_that.meta,_that.medicationId,_that.baseVersion,_that.schedule,_that.effectiveFrom);case MedicationArchived() when medicationArchived != null:
return medicationArchived(_that.meta,_that.medicationId,_that.baseVersion);case DoseGiven() when doseGiven != null:
return doseGiven(_that.meta,_that.medicationId,_that.slotAt,_that.givenAt,_that.units,_that.knownDoseIds,_that.note);case DoseSkipped() when doseSkipped != null:
return doseSkipped(_that.meta,_that.medicationId,_that.slotAt,_that.reason,_that.note);case DoseUndone() when doseUndone != null:
return doseUndone(_that.meta,_that.targetEventId);case StockCounted() when stockCounted != null:
return stockCounted(_that.meta,_that.medicationId,_that.units);case StockRefilled() when stockRefilled != null:
return stockRefilled(_that.meta,_that.medicationId,_that.units);case AppointmentCreated() when appointmentCreated != null:
return appointmentCreated(_that.meta,_that.appointmentId,_that.details);case AppointmentUpdated() when appointmentUpdated != null:
return appointmentUpdated(_that.meta,_that.appointmentId,_that.baseVersion,_that.details);case AppointmentCancelled() when appointmentCancelled != null:
return appointmentCancelled(_that.meta,_that.appointmentId,_that.baseVersion);case VisitNoteAdded() when visitNoteAdded != null:
return visitNoteAdded(_that.meta,_that.appointmentId,_that.text);case RecipientProfileUpdated() when recipientProfileUpdated != null:
return recipientProfileUpdated(_that.meta,_that.baseVersion,_that.profile);case ConflictAcknowledged() when conflictAcknowledged != null:
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
int get hashCode => Object.hash(runtimeType,meta,medicationId,details,schedule,effectiveFrom);

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
int get hashCode => Object.hash(runtimeType,meta,medicationId,baseVersion,details);

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
int get hashCode => Object.hash(runtimeType,meta,medicationId,baseVersion,schedule,effectiveFrom);

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
int get hashCode => Object.hash(runtimeType,meta,medicationId,baseVersion);

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
  const DoseGiven({required this.meta, required this.medicationId, required this.slotAt, required this.givenAt, required this.units, final  List<String> knownDoseIds = const <String>[], this.note}): _knownDoseIds = knownDoseIds;
  

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseGiven&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.givenAt, givenAt) || other.givenAt == givenAt)&&(identical(other.units, units) || other.units == units)&&const DeepCollectionEquality().equals(other._knownDoseIds, _knownDoseIds)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,meta,medicationId,slotAt,givenAt,units,const DeepCollectionEquality().hash(_knownDoseIds),note);

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
  const DoseSkipped({required this.meta, required this.medicationId, required this.slotAt, required this.reason, this.note});
  

@override final  EventMeta meta;
 final  String medicationId;
 final  DateTime slotAt;
 final  SkipReason reason;
 final  String? note;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseSkippedCopyWith<DoseSkipped> get copyWith => _$DoseSkippedCopyWithImpl<DoseSkipped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseSkipped&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,meta,medicationId,slotAt,reason,note);

@override
String toString() {
  return 'CareEvent.doseSkipped(meta: $meta, medicationId: $medicationId, slotAt: $slotAt, reason: $reason, note: $note)';
}


}

/// @nodoc
abstract mixin class $DoseSkippedCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $DoseSkippedCopyWith(DoseSkipped value, $Res Function(DoseSkipped) _then) = _$DoseSkippedCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String medicationId, DateTime slotAt, SkipReason reason, String? note
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
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? medicationId = null,Object? slotAt = null,Object? reason = null,Object? note = freezed,}) {
  return _then(DoseSkipped(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,slotAt: null == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as SkipReason,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
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
  const DoseUndone({required this.meta, required this.targetEventId});
  

@override final  EventMeta meta;
 final  String targetEventId;

/// Create a copy of CareEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseUndoneCopyWith<DoseUndone> get copyWith => _$DoseUndoneCopyWithImpl<DoseUndone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseUndone&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.targetEventId, targetEventId) || other.targetEventId == targetEventId));
}


@override
int get hashCode => Object.hash(runtimeType,meta,targetEventId);

@override
String toString() {
  return 'CareEvent.doseUndone(meta: $meta, targetEventId: $targetEventId)';
}


}

/// @nodoc
abstract mixin class $DoseUndoneCopyWith<$Res> implements $CareEventCopyWith<$Res> {
  factory $DoseUndoneCopyWith(DoseUndone value, $Res Function(DoseUndone) _then) = _$DoseUndoneCopyWithImpl;
@override @useResult
$Res call({
 EventMeta meta, String targetEventId
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
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? targetEventId = null,}) {
  return _then(DoseUndone(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as EventMeta,targetEventId: null == targetEventId ? _self.targetEventId : targetEventId // ignore: cast_nullable_to_non_nullable
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
int get hashCode => Object.hash(runtimeType,meta,medicationId,units);

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
int get hashCode => Object.hash(runtimeType,meta,medicationId,units);

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
int get hashCode => Object.hash(runtimeType,meta,appointmentId,details);

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
int get hashCode => Object.hash(runtimeType,meta,appointmentId,baseVersion,details);

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
int get hashCode => Object.hash(runtimeType,meta,appointmentId,baseVersion);

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
int get hashCode => Object.hash(runtimeType,meta,appointmentId,text);

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
int get hashCode => Object.hash(runtimeType,meta,baseVersion,profile);

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
int get hashCode => Object.hash(runtimeType,meta,conflictKey);

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
