// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'handoff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Handoff {

 DateTime get at;/// Doses given today, in the order they were given.
 List<GivenDose> get given; List<DoseSlot> get skipped;/// Notes left within [recentNotesWindow], newest first: the ones the
/// day's summary quotes.
 List<CareNoteAdded> get notes;/// Notes left within [handoffHorizon], newest first: the notes screen.
/// Older ones are in Activity.
 List<CareNoteAdded> get notesThisWeek;/// Doses still to give: unresolved from yesterday, then today's.
 List<DoseSlot> get pending; int get conflicts;/// Today's care tasks by what happened to them, in day order.
 List<TaskSlot> get tasksDone; List<TaskSlot> get tasksSkipped; List<TaskSlot> get tasksPending; List<LowStock> get lowStock; Appointment? get nextAppointment;/// The latest visit note within [handoffHorizon], and its appointment.
 ({Appointment appointment, VisitNoteAdded note})? get latestNote;
/// Create a copy of Handoff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandoffCopyWith<Handoff> get copyWith => _$HandoffCopyWithImpl<Handoff>(this as Handoff, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Handoff&&(identical(other.at, at) || other.at == at)&&const DeepCollectionEquality().equals(other.given, given)&&const DeepCollectionEquality().equals(other.skipped, skipped)&&const DeepCollectionEquality().equals(other.notes, notes)&&const DeepCollectionEquality().equals(other.notesThisWeek, notesThisWeek)&&const DeepCollectionEquality().equals(other.pending, pending)&&(identical(other.conflicts, conflicts) || other.conflicts == conflicts)&&const DeepCollectionEquality().equals(other.tasksDone, tasksDone)&&const DeepCollectionEquality().equals(other.tasksSkipped, tasksSkipped)&&const DeepCollectionEquality().equals(other.tasksPending, tasksPending)&&const DeepCollectionEquality().equals(other.lowStock, lowStock)&&(identical(other.nextAppointment, nextAppointment) || other.nextAppointment == nextAppointment)&&(identical(other.latestNote, latestNote) || other.latestNote == latestNote));
}


@override
int get hashCode => Object.hash(runtimeType,at,const DeepCollectionEquality().hash(given),const DeepCollectionEquality().hash(skipped),const DeepCollectionEquality().hash(notes),const DeepCollectionEquality().hash(notesThisWeek),const DeepCollectionEquality().hash(pending),conflicts,const DeepCollectionEquality().hash(tasksDone),const DeepCollectionEquality().hash(tasksSkipped),const DeepCollectionEquality().hash(tasksPending),const DeepCollectionEquality().hash(lowStock),nextAppointment,latestNote);

@override
String toString() {
  return 'Handoff(at: $at, given: $given, skipped: $skipped, notes: $notes, notesThisWeek: $notesThisWeek, pending: $pending, conflicts: $conflicts, tasksDone: $tasksDone, tasksSkipped: $tasksSkipped, tasksPending: $tasksPending, lowStock: $lowStock, nextAppointment: $nextAppointment, latestNote: $latestNote)';
}


}

/// @nodoc
abstract mixin class $HandoffCopyWith<$Res>  {
  factory $HandoffCopyWith(Handoff value, $Res Function(Handoff) _then) = _$HandoffCopyWithImpl;
@useResult
$Res call({
 DateTime at, List<GivenDose> given, List<DoseSlot> skipped, List<CareNoteAdded> notes, List<CareNoteAdded> notesThisWeek, List<DoseSlot> pending, int conflicts, List<TaskSlot> tasksDone, List<TaskSlot> tasksSkipped, List<TaskSlot> tasksPending, List<LowStock> lowStock, Appointment? nextAppointment, ({Appointment appointment, VisitNoteAdded note})? latestNote
});


$AppointmentCopyWith<$Res>? get nextAppointment;

}
/// @nodoc
class _$HandoffCopyWithImpl<$Res>
    implements $HandoffCopyWith<$Res> {
  _$HandoffCopyWithImpl(this._self, this._then);

  final Handoff _self;
  final $Res Function(Handoff) _then;

/// Create a copy of Handoff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? given = null,Object? skipped = null,Object? notes = null,Object? notesThisWeek = null,Object? pending = null,Object? conflicts = null,Object? tasksDone = null,Object? tasksSkipped = null,Object? tasksPending = null,Object? lowStock = null,Object? nextAppointment = freezed,Object? latestNote = freezed,}) {
  return _then(_self.copyWith(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,given: null == given ? _self.given : given // ignore: cast_nullable_to_non_nullable
as List<GivenDose>,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<CareNoteAdded>,notesThisWeek: null == notesThisWeek ? _self.notesThisWeek : notesThisWeek // ignore: cast_nullable_to_non_nullable
as List<CareNoteAdded>,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as int,tasksDone: null == tasksDone ? _self.tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,tasksSkipped: null == tasksSkipped ? _self.tasksSkipped : tasksSkipped // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,tasksPending: null == tasksPending ? _self.tasksPending : tasksPending // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,lowStock: null == lowStock ? _self.lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as List<LowStock>,nextAppointment: freezed == nextAppointment ? _self.nextAppointment : nextAppointment // ignore: cast_nullable_to_non_nullable
as Appointment?,latestNote: freezed == latestNote ? _self.latestNote : latestNote // ignore: cast_nullable_to_non_nullable
as ({Appointment appointment, VisitNoteAdded note})?,
  ));
}
/// Create a copy of Handoff
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentCopyWith<$Res>? get nextAppointment {
    if (_self.nextAppointment == null) {
    return null;
  }

  return $AppointmentCopyWith<$Res>(_self.nextAppointment!, (value) {
    return _then(_self.copyWith(nextAppointment: value));
  });
}
}


/// Adds pattern-matching-related methods to [Handoff].
extension HandoffPatterns on Handoff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Handoff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Handoff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Handoff value)  $default,){
final _that = this;
switch (_that) {
case _Handoff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Handoff value)?  $default,){
final _that = this;
switch (_that) {
case _Handoff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  List<GivenDose> given,  List<DoseSlot> skipped,  List<CareNoteAdded> notes,  List<CareNoteAdded> notesThisWeek,  List<DoseSlot> pending,  int conflicts,  List<TaskSlot> tasksDone,  List<TaskSlot> tasksSkipped,  List<TaskSlot> tasksPending,  List<LowStock> lowStock,  Appointment? nextAppointment,  ({Appointment appointment, VisitNoteAdded note})? latestNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Handoff() when $default != null:
return $default(_that.at,_that.given,_that.skipped,_that.notes,_that.notesThisWeek,_that.pending,_that.conflicts,_that.tasksDone,_that.tasksSkipped,_that.tasksPending,_that.lowStock,_that.nextAppointment,_that.latestNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  List<GivenDose> given,  List<DoseSlot> skipped,  List<CareNoteAdded> notes,  List<CareNoteAdded> notesThisWeek,  List<DoseSlot> pending,  int conflicts,  List<TaskSlot> tasksDone,  List<TaskSlot> tasksSkipped,  List<TaskSlot> tasksPending,  List<LowStock> lowStock,  Appointment? nextAppointment,  ({Appointment appointment, VisitNoteAdded note})? latestNote)  $default,) {final _that = this;
switch (_that) {
case _Handoff():
return $default(_that.at,_that.given,_that.skipped,_that.notes,_that.notesThisWeek,_that.pending,_that.conflicts,_that.tasksDone,_that.tasksSkipped,_that.tasksPending,_that.lowStock,_that.nextAppointment,_that.latestNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  List<GivenDose> given,  List<DoseSlot> skipped,  List<CareNoteAdded> notes,  List<CareNoteAdded> notesThisWeek,  List<DoseSlot> pending,  int conflicts,  List<TaskSlot> tasksDone,  List<TaskSlot> tasksSkipped,  List<TaskSlot> tasksPending,  List<LowStock> lowStock,  Appointment? nextAppointment,  ({Appointment appointment, VisitNoteAdded note})? latestNote)?  $default,) {final _that = this;
switch (_that) {
case _Handoff() when $default != null:
return $default(_that.at,_that.given,_that.skipped,_that.notes,_that.notesThisWeek,_that.pending,_that.conflicts,_that.tasksDone,_that.tasksSkipped,_that.tasksPending,_that.lowStock,_that.nextAppointment,_that.latestNote);case _:
  return null;

}
}

}

/// @nodoc


class _Handoff implements Handoff {
  const _Handoff({required this.at, final  List<GivenDose> given = const <GivenDose>[], final  List<DoseSlot> skipped = const <DoseSlot>[], final  List<CareNoteAdded> notes = const <CareNoteAdded>[], final  List<CareNoteAdded> notesThisWeek = const <CareNoteAdded>[], final  List<DoseSlot> pending = const <DoseSlot>[], this.conflicts = 0, final  List<TaskSlot> tasksDone = const <TaskSlot>[], final  List<TaskSlot> tasksSkipped = const <TaskSlot>[], final  List<TaskSlot> tasksPending = const <TaskSlot>[], final  List<LowStock> lowStock = const <LowStock>[], this.nextAppointment, this.latestNote}): _given = given,_skipped = skipped,_notes = notes,_notesThisWeek = notesThisWeek,_pending = pending,_tasksDone = tasksDone,_tasksSkipped = tasksSkipped,_tasksPending = tasksPending,_lowStock = lowStock;
  

@override final  DateTime at;
/// Doses given today, in the order they were given.
 final  List<GivenDose> _given;
/// Doses given today, in the order they were given.
@override@JsonKey() List<GivenDose> get given {
  if (_given is EqualUnmodifiableListView) return _given;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_given);
}

 final  List<DoseSlot> _skipped;
@override@JsonKey() List<DoseSlot> get skipped {
  if (_skipped is EqualUnmodifiableListView) return _skipped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skipped);
}

/// Notes left within [recentNotesWindow], newest first: the ones the
/// day's summary quotes.
 final  List<CareNoteAdded> _notes;
/// Notes left within [recentNotesWindow], newest first: the ones the
/// day's summary quotes.
@override@JsonKey() List<CareNoteAdded> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

/// Notes left within [handoffHorizon], newest first: the notes screen.
/// Older ones are in Activity.
 final  List<CareNoteAdded> _notesThisWeek;
/// Notes left within [handoffHorizon], newest first: the notes screen.
/// Older ones are in Activity.
@override@JsonKey() List<CareNoteAdded> get notesThisWeek {
  if (_notesThisWeek is EqualUnmodifiableListView) return _notesThisWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notesThisWeek);
}

/// Doses still to give: unresolved from yesterday, then today's.
 final  List<DoseSlot> _pending;
/// Doses still to give: unresolved from yesterday, then today's.
@override@JsonKey() List<DoseSlot> get pending {
  if (_pending is EqualUnmodifiableListView) return _pending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pending);
}

@override@JsonKey() final  int conflicts;
/// Today's care tasks by what happened to them, in day order.
 final  List<TaskSlot> _tasksDone;
/// Today's care tasks by what happened to them, in day order.
@override@JsonKey() List<TaskSlot> get tasksDone {
  if (_tasksDone is EqualUnmodifiableListView) return _tasksDone;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasksDone);
}

 final  List<TaskSlot> _tasksSkipped;
@override@JsonKey() List<TaskSlot> get tasksSkipped {
  if (_tasksSkipped is EqualUnmodifiableListView) return _tasksSkipped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasksSkipped);
}

 final  List<TaskSlot> _tasksPending;
@override@JsonKey() List<TaskSlot> get tasksPending {
  if (_tasksPending is EqualUnmodifiableListView) return _tasksPending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasksPending);
}

 final  List<LowStock> _lowStock;
@override@JsonKey() List<LowStock> get lowStock {
  if (_lowStock is EqualUnmodifiableListView) return _lowStock;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lowStock);
}

@override final  Appointment? nextAppointment;
/// The latest visit note within [handoffHorizon], and its appointment.
@override final  ({Appointment appointment, VisitNoteAdded note})? latestNote;

/// Create a copy of Handoff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HandoffCopyWith<_Handoff> get copyWith => __$HandoffCopyWithImpl<_Handoff>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Handoff&&(identical(other.at, at) || other.at == at)&&const DeepCollectionEquality().equals(other._given, _given)&&const DeepCollectionEquality().equals(other._skipped, _skipped)&&const DeepCollectionEquality().equals(other._notes, _notes)&&const DeepCollectionEquality().equals(other._notesThisWeek, _notesThisWeek)&&const DeepCollectionEquality().equals(other._pending, _pending)&&(identical(other.conflicts, conflicts) || other.conflicts == conflicts)&&const DeepCollectionEquality().equals(other._tasksDone, _tasksDone)&&const DeepCollectionEquality().equals(other._tasksSkipped, _tasksSkipped)&&const DeepCollectionEquality().equals(other._tasksPending, _tasksPending)&&const DeepCollectionEquality().equals(other._lowStock, _lowStock)&&(identical(other.nextAppointment, nextAppointment) || other.nextAppointment == nextAppointment)&&(identical(other.latestNote, latestNote) || other.latestNote == latestNote));
}


@override
int get hashCode => Object.hash(runtimeType,at,const DeepCollectionEquality().hash(_given),const DeepCollectionEquality().hash(_skipped),const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_notesThisWeek),const DeepCollectionEquality().hash(_pending),conflicts,const DeepCollectionEquality().hash(_tasksDone),const DeepCollectionEquality().hash(_tasksSkipped),const DeepCollectionEquality().hash(_tasksPending),const DeepCollectionEquality().hash(_lowStock),nextAppointment,latestNote);

@override
String toString() {
  return 'Handoff(at: $at, given: $given, skipped: $skipped, notes: $notes, notesThisWeek: $notesThisWeek, pending: $pending, conflicts: $conflicts, tasksDone: $tasksDone, tasksSkipped: $tasksSkipped, tasksPending: $tasksPending, lowStock: $lowStock, nextAppointment: $nextAppointment, latestNote: $latestNote)';
}


}

/// @nodoc
abstract mixin class _$HandoffCopyWith<$Res> implements $HandoffCopyWith<$Res> {
  factory _$HandoffCopyWith(_Handoff value, $Res Function(_Handoff) _then) = __$HandoffCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, List<GivenDose> given, List<DoseSlot> skipped, List<CareNoteAdded> notes, List<CareNoteAdded> notesThisWeek, List<DoseSlot> pending, int conflicts, List<TaskSlot> tasksDone, List<TaskSlot> tasksSkipped, List<TaskSlot> tasksPending, List<LowStock> lowStock, Appointment? nextAppointment, ({Appointment appointment, VisitNoteAdded note})? latestNote
});


@override $AppointmentCopyWith<$Res>? get nextAppointment;

}
/// @nodoc
class __$HandoffCopyWithImpl<$Res>
    implements _$HandoffCopyWith<$Res> {
  __$HandoffCopyWithImpl(this._self, this._then);

  final _Handoff _self;
  final $Res Function(_Handoff) _then;

/// Create a copy of Handoff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? given = null,Object? skipped = null,Object? notes = null,Object? notesThisWeek = null,Object? pending = null,Object? conflicts = null,Object? tasksDone = null,Object? tasksSkipped = null,Object? tasksPending = null,Object? lowStock = null,Object? nextAppointment = freezed,Object? latestNote = freezed,}) {
  return _then(_Handoff(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,given: null == given ? _self._given : given // ignore: cast_nullable_to_non_nullable
as List<GivenDose>,skipped: null == skipped ? _self._skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<CareNoteAdded>,notesThisWeek: null == notesThisWeek ? _self._notesThisWeek : notesThisWeek // ignore: cast_nullable_to_non_nullable
as List<CareNoteAdded>,pending: null == pending ? _self._pending : pending // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as int,tasksDone: null == tasksDone ? _self._tasksDone : tasksDone // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,tasksSkipped: null == tasksSkipped ? _self._tasksSkipped : tasksSkipped // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,tasksPending: null == tasksPending ? _self._tasksPending : tasksPending // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,lowStock: null == lowStock ? _self._lowStock : lowStock // ignore: cast_nullable_to_non_nullable
as List<LowStock>,nextAppointment: freezed == nextAppointment ? _self.nextAppointment : nextAppointment // ignore: cast_nullable_to_non_nullable
as Appointment?,latestNote: freezed == latestNote ? _self.latestNote : latestNote // ignore: cast_nullable_to_non_nullable
as ({Appointment appointment, VisitNoteAdded note})?,
  ));
}

/// Create a copy of Handoff
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentCopyWith<$Res>? get nextAppointment {
    if (_self.nextAppointment == null) {
    return null;
  }

  return $AppointmentCopyWith<$Res>(_self.nextAppointment!, (value) {
    return _then(_self.copyWith(nextAppointment: value));
  });
}
}

// dart format on
