// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AsNeededItem {

 Medication get medication; DoseGiven? get lastDose; StockLevel? get stock;
/// Create a copy of AsNeededItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AsNeededItemCopyWith<AsNeededItem> get copyWith => _$AsNeededItemCopyWithImpl<AsNeededItem>(this as AsNeededItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsNeededItem&&(identical(other.medication, medication) || other.medication == medication)&&const DeepCollectionEquality().equals(other.lastDose, lastDose)&&(identical(other.stock, stock) || other.stock == stock));
}


@override
int get hashCode => Object.hash(runtimeType,medication,const DeepCollectionEquality().hash(lastDose),stock);

@override
String toString() {
  return 'AsNeededItem(medication: $medication, lastDose: $lastDose, stock: $stock)';
}


}

/// @nodoc
abstract mixin class $AsNeededItemCopyWith<$Res>  {
  factory $AsNeededItemCopyWith(AsNeededItem value, $Res Function(AsNeededItem) _then) = _$AsNeededItemCopyWithImpl;
@useResult
$Res call({
 Medication medication, DoseGiven? lastDose, StockLevel? stock
});


$MedicationCopyWith<$Res> get medication;$StockLevelCopyWith<$Res>? get stock;

}
/// @nodoc
class _$AsNeededItemCopyWithImpl<$Res>
    implements $AsNeededItemCopyWith<$Res> {
  _$AsNeededItemCopyWithImpl(this._self, this._then);

  final AsNeededItem _self;
  final $Res Function(AsNeededItem) _then;

/// Create a copy of AsNeededItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medication = null,Object? lastDose = freezed,Object? stock = freezed,}) {
  return _then(_self.copyWith(
medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,lastDose: freezed == lastDose ? _self.lastDose : lastDose // ignore: cast_nullable_to_non_nullable
as DoseGiven?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockLevel?,
  ));
}
/// Create a copy of AsNeededItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}/// Create a copy of AsNeededItem
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


/// Adds pattern-matching-related methods to [AsNeededItem].
extension AsNeededItemPatterns on AsNeededItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AsNeededItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AsNeededItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AsNeededItem value)  $default,){
final _that = this;
switch (_that) {
case _AsNeededItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AsNeededItem value)?  $default,){
final _that = this;
switch (_that) {
case _AsNeededItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Medication medication,  DoseGiven? lastDose,  StockLevel? stock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AsNeededItem() when $default != null:
return $default(_that.medication,_that.lastDose,_that.stock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Medication medication,  DoseGiven? lastDose,  StockLevel? stock)  $default,) {final _that = this;
switch (_that) {
case _AsNeededItem():
return $default(_that.medication,_that.lastDose,_that.stock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Medication medication,  DoseGiven? lastDose,  StockLevel? stock)?  $default,) {final _that = this;
switch (_that) {
case _AsNeededItem() when $default != null:
return $default(_that.medication,_that.lastDose,_that.stock);case _:
  return null;

}
}

}

/// @nodoc


class _AsNeededItem implements AsNeededItem {
  const _AsNeededItem({required this.medication, this.lastDose, this.stock});
  

@override final  Medication medication;
@override final  DoseGiven? lastDose;
@override final  StockLevel? stock;

/// Create a copy of AsNeededItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AsNeededItemCopyWith<_AsNeededItem> get copyWith => __$AsNeededItemCopyWithImpl<_AsNeededItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AsNeededItem&&(identical(other.medication, medication) || other.medication == medication)&&const DeepCollectionEquality().equals(other.lastDose, lastDose)&&(identical(other.stock, stock) || other.stock == stock));
}


@override
int get hashCode => Object.hash(runtimeType,medication,const DeepCollectionEquality().hash(lastDose),stock);

@override
String toString() {
  return 'AsNeededItem(medication: $medication, lastDose: $lastDose, stock: $stock)';
}


}

/// @nodoc
abstract mixin class _$AsNeededItemCopyWith<$Res> implements $AsNeededItemCopyWith<$Res> {
  factory _$AsNeededItemCopyWith(_AsNeededItem value, $Res Function(_AsNeededItem) _then) = __$AsNeededItemCopyWithImpl;
@override @useResult
$Res call({
 Medication medication, DoseGiven? lastDose, StockLevel? stock
});


@override $MedicationCopyWith<$Res> get medication;@override $StockLevelCopyWith<$Res>? get stock;

}
/// @nodoc
class __$AsNeededItemCopyWithImpl<$Res>
    implements _$AsNeededItemCopyWith<$Res> {
  __$AsNeededItemCopyWithImpl(this._self, this._then);

  final _AsNeededItem _self;
  final $Res Function(_AsNeededItem) _then;

/// Create a copy of AsNeededItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medication = null,Object? lastDose = freezed,Object? stock = freezed,}) {
  return _then(_AsNeededItem(
medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,lastDose: freezed == lastDose ? _self.lastDose : lastDose // ignore: cast_nullable_to_non_nullable
as DoseGiven?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockLevel?,
  ));
}

/// Create a copy of AsNeededItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}/// Create a copy of AsNeededItem
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

/// @nodoc
mixin _$ConflictItem {

 DoseConflict get conflict; Medication get medication;/// The scheduled time the doses were for; null for as-needed doses or
/// doses for different times given too close together.
 DateTime? get slotAt;
/// Create a copy of ConflictItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictItemCopyWith<ConflictItem> get copyWith => _$ConflictItemCopyWithImpl<ConflictItem>(this as ConflictItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictItem&&const DeepCollectionEquality().equals(other.conflict, conflict)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(conflict),medication,slotAt);

@override
String toString() {
  return 'ConflictItem(conflict: $conflict, medication: $medication, slotAt: $slotAt)';
}


}

/// @nodoc
abstract mixin class $ConflictItemCopyWith<$Res>  {
  factory $ConflictItemCopyWith(ConflictItem value, $Res Function(ConflictItem) _then) = _$ConflictItemCopyWithImpl;
@useResult
$Res call({
 DoseConflict conflict, Medication medication, DateTime? slotAt
});


$MedicationCopyWith<$Res> get medication;

}
/// @nodoc
class _$ConflictItemCopyWithImpl<$Res>
    implements $ConflictItemCopyWith<$Res> {
  _$ConflictItemCopyWithImpl(this._self, this._then);

  final ConflictItem _self;
  final $Res Function(ConflictItem) _then;

/// Create a copy of ConflictItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conflict = freezed,Object? medication = null,Object? slotAt = freezed,}) {
  return _then(_self.copyWith(
conflict: freezed == conflict ? _self.conflict : conflict // ignore: cast_nullable_to_non_nullable
as DoseConflict,medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,slotAt: freezed == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ConflictItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConflictItem].
extension ConflictItemPatterns on ConflictItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConflictItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConflictItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConflictItem value)  $default,){
final _that = this;
switch (_that) {
case _ConflictItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConflictItem value)?  $default,){
final _that = this;
switch (_that) {
case _ConflictItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DoseConflict conflict,  Medication medication,  DateTime? slotAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConflictItem() when $default != null:
return $default(_that.conflict,_that.medication,_that.slotAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DoseConflict conflict,  Medication medication,  DateTime? slotAt)  $default,) {final _that = this;
switch (_that) {
case _ConflictItem():
return $default(_that.conflict,_that.medication,_that.slotAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DoseConflict conflict,  Medication medication,  DateTime? slotAt)?  $default,) {final _that = this;
switch (_that) {
case _ConflictItem() when $default != null:
return $default(_that.conflict,_that.medication,_that.slotAt);case _:
  return null;

}
}

}

/// @nodoc


class _ConflictItem implements ConflictItem {
  const _ConflictItem({required this.conflict, required this.medication, this.slotAt});
  

@override final  DoseConflict conflict;
@override final  Medication medication;
/// The scheduled time the doses were for; null for as-needed doses or
/// doses for different times given too close together.
@override final  DateTime? slotAt;

/// Create a copy of ConflictItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConflictItemCopyWith<_ConflictItem> get copyWith => __$ConflictItemCopyWithImpl<_ConflictItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConflictItem&&const DeepCollectionEquality().equals(other.conflict, conflict)&&(identical(other.medication, medication) || other.medication == medication)&&(identical(other.slotAt, slotAt) || other.slotAt == slotAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(conflict),medication,slotAt);

@override
String toString() {
  return 'ConflictItem(conflict: $conflict, medication: $medication, slotAt: $slotAt)';
}


}

/// @nodoc
abstract mixin class _$ConflictItemCopyWith<$Res> implements $ConflictItemCopyWith<$Res> {
  factory _$ConflictItemCopyWith(_ConflictItem value, $Res Function(_ConflictItem) _then) = __$ConflictItemCopyWithImpl;
@override @useResult
$Res call({
 DoseConflict conflict, Medication medication, DateTime? slotAt
});


@override $MedicationCopyWith<$Res> get medication;

}
/// @nodoc
class __$ConflictItemCopyWithImpl<$Res>
    implements _$ConflictItemCopyWith<$Res> {
  __$ConflictItemCopyWithImpl(this._self, this._then);

  final _ConflictItem _self;
  final $Res Function(_ConflictItem) _then;

/// Create a copy of ConflictItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conflict = freezed,Object? medication = null,Object? slotAt = freezed,}) {
  return _then(_ConflictItem(
conflict: freezed == conflict ? _self.conflict : conflict // ignore: cast_nullable_to_non_nullable
as DoseConflict,medication: null == medication ? _self.medication : medication // ignore: cast_nullable_to_non_nullable
as Medication,slotAt: freezed == slotAt ? _self.slotAt : slotAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ConflictItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res> get medication {
  
  return $MedicationCopyWith<$Res>(_self.medication, (value) {
    return _then(_self.copyWith(medication: value));
  });
}
}

/// @nodoc
mixin _$TimelineEntry {

 Object get slot;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEntry&&const DeepCollectionEquality().equals(other.slot, slot));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(slot));

@override
String toString() {
  return 'TimelineEntry(slot: $slot)';
}


}

/// @nodoc
class $TimelineEntryCopyWith<$Res>  {
$TimelineEntryCopyWith(TimelineEntry _, $Res Function(TimelineEntry) __);
}


/// Adds pattern-matching-related methods to [TimelineEntry].
extension TimelineEntryPatterns on TimelineEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DoseEntry value)?  dose,TResult Function( TaskEntry value)?  task,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DoseEntry() when dose != null:
return dose(_that);case TaskEntry() when task != null:
return task(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DoseEntry value)  dose,required TResult Function( TaskEntry value)  task,}){
final _that = this;
switch (_that) {
case DoseEntry():
return dose(_that);case TaskEntry():
return task(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DoseEntry value)?  dose,TResult? Function( TaskEntry value)?  task,}){
final _that = this;
switch (_that) {
case DoseEntry() when dose != null:
return dose(_that);case TaskEntry() when task != null:
return task(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DoseSlot slot)?  dose,TResult Function( TaskSlot slot)?  task,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DoseEntry() when dose != null:
return dose(_that.slot);case TaskEntry() when task != null:
return task(_that.slot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DoseSlot slot)  dose,required TResult Function( TaskSlot slot)  task,}) {final _that = this;
switch (_that) {
case DoseEntry():
return dose(_that.slot);case TaskEntry():
return task(_that.slot);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DoseSlot slot)?  dose,TResult? Function( TaskSlot slot)?  task,}) {final _that = this;
switch (_that) {
case DoseEntry() when dose != null:
return dose(_that.slot);case TaskEntry() when task != null:
return task(_that.slot);case _:
  return null;

}
}

}

/// @nodoc


class DoseEntry extends TimelineEntry {
  const DoseEntry(this.slot): super._();
  

@override final  DoseSlot slot;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseEntryCopyWith<DoseEntry> get copyWith => _$DoseEntryCopyWithImpl<DoseEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseEntry&&(identical(other.slot, slot) || other.slot == slot));
}


@override
int get hashCode => Object.hash(runtimeType,slot);

@override
String toString() {
  return 'TimelineEntry.dose(slot: $slot)';
}


}

/// @nodoc
abstract mixin class $DoseEntryCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory $DoseEntryCopyWith(DoseEntry value, $Res Function(DoseEntry) _then) = _$DoseEntryCopyWithImpl;
@useResult
$Res call({
 DoseSlot slot
});


$DoseSlotCopyWith<$Res> get slot;

}
/// @nodoc
class _$DoseEntryCopyWithImpl<$Res>
    implements $DoseEntryCopyWith<$Res> {
  _$DoseEntryCopyWithImpl(this._self, this._then);

  final DoseEntry _self;
  final $Res Function(DoseEntry) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? slot = null,}) {
  return _then(DoseEntry(
null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as DoseSlot,
  ));
}

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoseSlotCopyWith<$Res> get slot {
  
  return $DoseSlotCopyWith<$Res>(_self.slot, (value) {
    return _then(_self.copyWith(slot: value));
  });
}
}

/// @nodoc


class TaskEntry extends TimelineEntry {
  const TaskEntry(this.slot): super._();
  

@override final  TaskSlot slot;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEntryCopyWith<TaskEntry> get copyWith => _$TaskEntryCopyWithImpl<TaskEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEntry&&(identical(other.slot, slot) || other.slot == slot));
}


@override
int get hashCode => Object.hash(runtimeType,slot);

@override
String toString() {
  return 'TimelineEntry.task(slot: $slot)';
}


}

/// @nodoc
abstract mixin class $TaskEntryCopyWith<$Res> implements $TimelineEntryCopyWith<$Res> {
  factory $TaskEntryCopyWith(TaskEntry value, $Res Function(TaskEntry) _then) = _$TaskEntryCopyWithImpl;
@useResult
$Res call({
 TaskSlot slot
});


$TaskSlotCopyWith<$Res> get slot;

}
/// @nodoc
class _$TaskEntryCopyWithImpl<$Res>
    implements $TaskEntryCopyWith<$Res> {
  _$TaskEntryCopyWithImpl(this._self, this._then);

  final TaskEntry _self;
  final $Res Function(TaskEntry) _then;

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? slot = null,}) {
  return _then(TaskEntry(
null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TaskSlot,
  ));
}

/// Create a copy of TimelineEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSlotCopyWith<$Res> get slot {
  
  return $TaskSlotCopyWith<$Res>(_self.slot, (value) {
    return _then(_self.copyWith(slot: value));
  });
}
}

/// @nodoc
mixin _$TodayView {

 DateTime get day;/// Today's scheduled doses, and how many are given or skipped.
 int get totalToday; int get resolvedToday;/// The dose to attend to first: the earliest due or late one, else
/// the next upcoming one; null when the day is done.
 DoseSlot? get next;/// Yesterday's doses still unresolved, or resolved today.
 List<DoseSlot> get fromYesterday;/// Today's doses and timed tasks by part of the day, in day order;
/// empty parts left out. At the same time, doses come first.
 Map<DayPart, List<TimelineEntry>> get byDayPart;/// Today's tasks with no set time.
 List<TaskSlot> get anyTimeTasks;/// For the day's summary: doses and tasks past their time and not
/// resolved (yesterday's too), today's tasks and how many are done or
/// skipped, and the latest dose or task record made today.
 int get lateCount; int get tasksToday; int get tasksResolvedToday; CareEvent? get lastRecord; List<AsNeededItem> get asNeeded;/// The next appointment if it is within [upcomingAppointmentWindow].
 Appointment? get nextAppointment;/// Stock per medication, for low-stock badges.
 Map<String, StockLevel> get stock;/// Dose conflicts nobody has reviewed. Edit conflicts are shown with
/// the medication they affect.
 List<ConflictItem> get conflicts;
/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayViewCopyWith<TodayView> get copyWith => _$TodayViewCopyWithImpl<TodayView>(this as TodayView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayView&&(identical(other.day, day) || other.day == day)&&(identical(other.totalToday, totalToday) || other.totalToday == totalToday)&&(identical(other.resolvedToday, resolvedToday) || other.resolvedToday == resolvedToday)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other.fromYesterday, fromYesterday)&&const DeepCollectionEquality().equals(other.byDayPart, byDayPart)&&const DeepCollectionEquality().equals(other.anyTimeTasks, anyTimeTasks)&&(identical(other.lateCount, lateCount) || other.lateCount == lateCount)&&(identical(other.tasksToday, tasksToday) || other.tasksToday == tasksToday)&&(identical(other.tasksResolvedToday, tasksResolvedToday) || other.tasksResolvedToday == tasksResolvedToday)&&(identical(other.lastRecord, lastRecord) || other.lastRecord == lastRecord)&&const DeepCollectionEquality().equals(other.asNeeded, asNeeded)&&(identical(other.nextAppointment, nextAppointment) || other.nextAppointment == nextAppointment)&&const DeepCollectionEquality().equals(other.stock, stock)&&const DeepCollectionEquality().equals(other.conflicts, conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,day,totalToday,resolvedToday,next,const DeepCollectionEquality().hash(fromYesterday),const DeepCollectionEquality().hash(byDayPart),const DeepCollectionEquality().hash(anyTimeTasks),lateCount,tasksToday,tasksResolvedToday,lastRecord,const DeepCollectionEquality().hash(asNeeded),nextAppointment,const DeepCollectionEquality().hash(stock),const DeepCollectionEquality().hash(conflicts));

@override
String toString() {
  return 'TodayView(day: $day, totalToday: $totalToday, resolvedToday: $resolvedToday, next: $next, fromYesterday: $fromYesterday, byDayPart: $byDayPart, anyTimeTasks: $anyTimeTasks, lateCount: $lateCount, tasksToday: $tasksToday, tasksResolvedToday: $tasksResolvedToday, lastRecord: $lastRecord, asNeeded: $asNeeded, nextAppointment: $nextAppointment, stock: $stock, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class $TodayViewCopyWith<$Res>  {
  factory $TodayViewCopyWith(TodayView value, $Res Function(TodayView) _then) = _$TodayViewCopyWithImpl;
@useResult
$Res call({
 DateTime day, int totalToday, int resolvedToday, DoseSlot? next, List<DoseSlot> fromYesterday, Map<DayPart, List<TimelineEntry>> byDayPart, List<TaskSlot> anyTimeTasks, int lateCount, int tasksToday, int tasksResolvedToday, CareEvent? lastRecord, List<AsNeededItem> asNeeded, Appointment? nextAppointment, Map<String, StockLevel> stock, List<ConflictItem> conflicts
});


$DoseSlotCopyWith<$Res>? get next;$CareEventCopyWith<$Res>? get lastRecord;$AppointmentCopyWith<$Res>? get nextAppointment;

}
/// @nodoc
class _$TodayViewCopyWithImpl<$Res>
    implements $TodayViewCopyWith<$Res> {
  _$TodayViewCopyWithImpl(this._self, this._then);

  final TodayView _self;
  final $Res Function(TodayView) _then;

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? totalToday = null,Object? resolvedToday = null,Object? next = freezed,Object? fromYesterday = null,Object? byDayPart = null,Object? anyTimeTasks = null,Object? lateCount = null,Object? tasksToday = null,Object? tasksResolvedToday = null,Object? lastRecord = freezed,Object? asNeeded = null,Object? nextAppointment = freezed,Object? stock = null,Object? conflicts = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,totalToday: null == totalToday ? _self.totalToday : totalToday // ignore: cast_nullable_to_non_nullable
as int,resolvedToday: null == resolvedToday ? _self.resolvedToday : resolvedToday // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as DoseSlot?,fromYesterday: null == fromYesterday ? _self.fromYesterday : fromYesterday // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,byDayPart: null == byDayPart ? _self.byDayPart : byDayPart // ignore: cast_nullable_to_non_nullable
as Map<DayPart, List<TimelineEntry>>,anyTimeTasks: null == anyTimeTasks ? _self.anyTimeTasks : anyTimeTasks // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,lateCount: null == lateCount ? _self.lateCount : lateCount // ignore: cast_nullable_to_non_nullable
as int,tasksToday: null == tasksToday ? _self.tasksToday : tasksToday // ignore: cast_nullable_to_non_nullable
as int,tasksResolvedToday: null == tasksResolvedToday ? _self.tasksResolvedToday : tasksResolvedToday // ignore: cast_nullable_to_non_nullable
as int,lastRecord: freezed == lastRecord ? _self.lastRecord : lastRecord // ignore: cast_nullable_to_non_nullable
as CareEvent?,asNeeded: null == asNeeded ? _self.asNeeded : asNeeded // ignore: cast_nullable_to_non_nullable
as List<AsNeededItem>,nextAppointment: freezed == nextAppointment ? _self.nextAppointment : nextAppointment // ignore: cast_nullable_to_non_nullable
as Appointment?,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as Map<String, StockLevel>,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<ConflictItem>,
  ));
}
/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoseSlotCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $DoseSlotCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareEventCopyWith<$Res>? get lastRecord {
    if (_self.lastRecord == null) {
    return null;
  }

  return $CareEventCopyWith<$Res>(_self.lastRecord!, (value) {
    return _then(_self.copyWith(lastRecord: value));
  });
}/// Create a copy of TodayView
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


/// Adds pattern-matching-related methods to [TodayView].
extension TodayViewPatterns on TodayView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayView value)  $default,){
final _that = this;
switch (_that) {
case _TodayView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayView value)?  $default,){
final _that = this;
switch (_that) {
case _TodayView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  int totalToday,  int resolvedToday,  DoseSlot? next,  List<DoseSlot> fromYesterday,  Map<DayPart, List<TimelineEntry>> byDayPart,  List<TaskSlot> anyTimeTasks,  int lateCount,  int tasksToday,  int tasksResolvedToday,  CareEvent? lastRecord,  List<AsNeededItem> asNeeded,  Appointment? nextAppointment,  Map<String, StockLevel> stock,  List<ConflictItem> conflicts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayView() when $default != null:
return $default(_that.day,_that.totalToday,_that.resolvedToday,_that.next,_that.fromYesterday,_that.byDayPart,_that.anyTimeTasks,_that.lateCount,_that.tasksToday,_that.tasksResolvedToday,_that.lastRecord,_that.asNeeded,_that.nextAppointment,_that.stock,_that.conflicts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  int totalToday,  int resolvedToday,  DoseSlot? next,  List<DoseSlot> fromYesterday,  Map<DayPart, List<TimelineEntry>> byDayPart,  List<TaskSlot> anyTimeTasks,  int lateCount,  int tasksToday,  int tasksResolvedToday,  CareEvent? lastRecord,  List<AsNeededItem> asNeeded,  Appointment? nextAppointment,  Map<String, StockLevel> stock,  List<ConflictItem> conflicts)  $default,) {final _that = this;
switch (_that) {
case _TodayView():
return $default(_that.day,_that.totalToday,_that.resolvedToday,_that.next,_that.fromYesterday,_that.byDayPart,_that.anyTimeTasks,_that.lateCount,_that.tasksToday,_that.tasksResolvedToday,_that.lastRecord,_that.asNeeded,_that.nextAppointment,_that.stock,_that.conflicts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  int totalToday,  int resolvedToday,  DoseSlot? next,  List<DoseSlot> fromYesterday,  Map<DayPart, List<TimelineEntry>> byDayPart,  List<TaskSlot> anyTimeTasks,  int lateCount,  int tasksToday,  int tasksResolvedToday,  CareEvent? lastRecord,  List<AsNeededItem> asNeeded,  Appointment? nextAppointment,  Map<String, StockLevel> stock,  List<ConflictItem> conflicts)?  $default,) {final _that = this;
switch (_that) {
case _TodayView() when $default != null:
return $default(_that.day,_that.totalToday,_that.resolvedToday,_that.next,_that.fromYesterday,_that.byDayPart,_that.anyTimeTasks,_that.lateCount,_that.tasksToday,_that.tasksResolvedToday,_that.lastRecord,_that.asNeeded,_that.nextAppointment,_that.stock,_that.conflicts);case _:
  return null;

}
}

}

/// @nodoc


class _TodayView implements TodayView {
  const _TodayView({required this.day, this.totalToday = 0, this.resolvedToday = 0, this.next, final  List<DoseSlot> fromYesterday = const <DoseSlot>[], final  Map<DayPart, List<TimelineEntry>> byDayPart = const <DayPart, List<TimelineEntry>>{}, final  List<TaskSlot> anyTimeTasks = const <TaskSlot>[], this.lateCount = 0, this.tasksToday = 0, this.tasksResolvedToday = 0, this.lastRecord, final  List<AsNeededItem> asNeeded = const <AsNeededItem>[], this.nextAppointment, final  Map<String, StockLevel> stock = const <String, StockLevel>{}, final  List<ConflictItem> conflicts = const <ConflictItem>[]}): _fromYesterday = fromYesterday,_byDayPart = byDayPart,_anyTimeTasks = anyTimeTasks,_asNeeded = asNeeded,_stock = stock,_conflicts = conflicts;
  

@override final  DateTime day;
/// Today's scheduled doses, and how many are given or skipped.
@override@JsonKey() final  int totalToday;
@override@JsonKey() final  int resolvedToday;
/// The dose to attend to first: the earliest due or late one, else
/// the next upcoming one; null when the day is done.
@override final  DoseSlot? next;
/// Yesterday's doses still unresolved, or resolved today.
 final  List<DoseSlot> _fromYesterday;
/// Yesterday's doses still unresolved, or resolved today.
@override@JsonKey() List<DoseSlot> get fromYesterday {
  if (_fromYesterday is EqualUnmodifiableListView) return _fromYesterday;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fromYesterday);
}

/// Today's doses and timed tasks by part of the day, in day order;
/// empty parts left out. At the same time, doses come first.
 final  Map<DayPart, List<TimelineEntry>> _byDayPart;
/// Today's doses and timed tasks by part of the day, in day order;
/// empty parts left out. At the same time, doses come first.
@override@JsonKey() Map<DayPart, List<TimelineEntry>> get byDayPart {
  if (_byDayPart is EqualUnmodifiableMapView) return _byDayPart;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byDayPart);
}

/// Today's tasks with no set time.
 final  List<TaskSlot> _anyTimeTasks;
/// Today's tasks with no set time.
@override@JsonKey() List<TaskSlot> get anyTimeTasks {
  if (_anyTimeTasks is EqualUnmodifiableListView) return _anyTimeTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_anyTimeTasks);
}

/// For the day's summary: doses and tasks past their time and not
/// resolved (yesterday's too), today's tasks and how many are done or
/// skipped, and the latest dose or task record made today.
@override@JsonKey() final  int lateCount;
@override@JsonKey() final  int tasksToday;
@override@JsonKey() final  int tasksResolvedToday;
@override final  CareEvent? lastRecord;
 final  List<AsNeededItem> _asNeeded;
@override@JsonKey() List<AsNeededItem> get asNeeded {
  if (_asNeeded is EqualUnmodifiableListView) return _asNeeded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_asNeeded);
}

/// The next appointment if it is within [upcomingAppointmentWindow].
@override final  Appointment? nextAppointment;
/// Stock per medication, for low-stock badges.
 final  Map<String, StockLevel> _stock;
/// Stock per medication, for low-stock badges.
@override@JsonKey() Map<String, StockLevel> get stock {
  if (_stock is EqualUnmodifiableMapView) return _stock;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stock);
}

/// Dose conflicts nobody has reviewed. Edit conflicts are shown with
/// the medication they affect.
 final  List<ConflictItem> _conflicts;
/// Dose conflicts nobody has reviewed. Edit conflicts are shown with
/// the medication they affect.
@override@JsonKey() List<ConflictItem> get conflicts {
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conflicts);
}


/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayViewCopyWith<_TodayView> get copyWith => __$TodayViewCopyWithImpl<_TodayView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayView&&(identical(other.day, day) || other.day == day)&&(identical(other.totalToday, totalToday) || other.totalToday == totalToday)&&(identical(other.resolvedToday, resolvedToday) || other.resolvedToday == resolvedToday)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other._fromYesterday, _fromYesterday)&&const DeepCollectionEquality().equals(other._byDayPart, _byDayPart)&&const DeepCollectionEquality().equals(other._anyTimeTasks, _anyTimeTasks)&&(identical(other.lateCount, lateCount) || other.lateCount == lateCount)&&(identical(other.tasksToday, tasksToday) || other.tasksToday == tasksToday)&&(identical(other.tasksResolvedToday, tasksResolvedToday) || other.tasksResolvedToday == tasksResolvedToday)&&(identical(other.lastRecord, lastRecord) || other.lastRecord == lastRecord)&&const DeepCollectionEquality().equals(other._asNeeded, _asNeeded)&&(identical(other.nextAppointment, nextAppointment) || other.nextAppointment == nextAppointment)&&const DeepCollectionEquality().equals(other._stock, _stock)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,day,totalToday,resolvedToday,next,const DeepCollectionEquality().hash(_fromYesterday),const DeepCollectionEquality().hash(_byDayPart),const DeepCollectionEquality().hash(_anyTimeTasks),lateCount,tasksToday,tasksResolvedToday,lastRecord,const DeepCollectionEquality().hash(_asNeeded),nextAppointment,const DeepCollectionEquality().hash(_stock),const DeepCollectionEquality().hash(_conflicts));

@override
String toString() {
  return 'TodayView(day: $day, totalToday: $totalToday, resolvedToday: $resolvedToday, next: $next, fromYesterday: $fromYesterday, byDayPart: $byDayPart, anyTimeTasks: $anyTimeTasks, lateCount: $lateCount, tasksToday: $tasksToday, tasksResolvedToday: $tasksResolvedToday, lastRecord: $lastRecord, asNeeded: $asNeeded, nextAppointment: $nextAppointment, stock: $stock, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class _$TodayViewCopyWith<$Res> implements $TodayViewCopyWith<$Res> {
  factory _$TodayViewCopyWith(_TodayView value, $Res Function(_TodayView) _then) = __$TodayViewCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, int totalToday, int resolvedToday, DoseSlot? next, List<DoseSlot> fromYesterday, Map<DayPart, List<TimelineEntry>> byDayPart, List<TaskSlot> anyTimeTasks, int lateCount, int tasksToday, int tasksResolvedToday, CareEvent? lastRecord, List<AsNeededItem> asNeeded, Appointment? nextAppointment, Map<String, StockLevel> stock, List<ConflictItem> conflicts
});


@override $DoseSlotCopyWith<$Res>? get next;@override $CareEventCopyWith<$Res>? get lastRecord;@override $AppointmentCopyWith<$Res>? get nextAppointment;

}
/// @nodoc
class __$TodayViewCopyWithImpl<$Res>
    implements _$TodayViewCopyWith<$Res> {
  __$TodayViewCopyWithImpl(this._self, this._then);

  final _TodayView _self;
  final $Res Function(_TodayView) _then;

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? totalToday = null,Object? resolvedToday = null,Object? next = freezed,Object? fromYesterday = null,Object? byDayPart = null,Object? anyTimeTasks = null,Object? lateCount = null,Object? tasksToday = null,Object? tasksResolvedToday = null,Object? lastRecord = freezed,Object? asNeeded = null,Object? nextAppointment = freezed,Object? stock = null,Object? conflicts = null,}) {
  return _then(_TodayView(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,totalToday: null == totalToday ? _self.totalToday : totalToday // ignore: cast_nullable_to_non_nullable
as int,resolvedToday: null == resolvedToday ? _self.resolvedToday : resolvedToday // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as DoseSlot?,fromYesterday: null == fromYesterday ? _self._fromYesterday : fromYesterday // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,byDayPart: null == byDayPart ? _self._byDayPart : byDayPart // ignore: cast_nullable_to_non_nullable
as Map<DayPart, List<TimelineEntry>>,anyTimeTasks: null == anyTimeTasks ? _self._anyTimeTasks : anyTimeTasks // ignore: cast_nullable_to_non_nullable
as List<TaskSlot>,lateCount: null == lateCount ? _self.lateCount : lateCount // ignore: cast_nullable_to_non_nullable
as int,tasksToday: null == tasksToday ? _self.tasksToday : tasksToday // ignore: cast_nullable_to_non_nullable
as int,tasksResolvedToday: null == tasksResolvedToday ? _self.tasksResolvedToday : tasksResolvedToday // ignore: cast_nullable_to_non_nullable
as int,lastRecord: freezed == lastRecord ? _self.lastRecord : lastRecord // ignore: cast_nullable_to_non_nullable
as CareEvent?,asNeeded: null == asNeeded ? _self._asNeeded : asNeeded // ignore: cast_nullable_to_non_nullable
as List<AsNeededItem>,nextAppointment: freezed == nextAppointment ? _self.nextAppointment : nextAppointment // ignore: cast_nullable_to_non_nullable
as Appointment?,stock: null == stock ? _self._stock : stock // ignore: cast_nullable_to_non_nullable
as Map<String, StockLevel>,conflicts: null == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<ConflictItem>,
  ));
}

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoseSlotCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $DoseSlotCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareEventCopyWith<$Res>? get lastRecord {
    if (_self.lastRecord == null) {
    return null;
  }

  return $CareEventCopyWith<$Res>(_self.lastRecord!, (value) {
    return _then(_self.copyWith(lastRecord: value));
  });
}/// Create a copy of TodayView
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
