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
mixin _$TodayView {

 DateTime get day;/// The dose to attend to first: the earliest due or late one, else
/// the next upcoming one; null when the day is done.
 DoseSlot? get next;/// Yesterday's doses nobody resolved.
 List<DoseSlot> get fromYesterday;/// Today's doses by part of the day, in day order; empty parts left
/// out.
 Map<DayPart, List<DoseSlot>> get byDayPart; List<AsNeededItem> get asNeeded;/// Stock per medication, for low-stock badges.
 Map<String, StockLevel> get stock; List<Conflict> get conflicts;
/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayViewCopyWith<TodayView> get copyWith => _$TodayViewCopyWithImpl<TodayView>(this as TodayView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayView&&(identical(other.day, day) || other.day == day)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other.fromYesterday, fromYesterday)&&const DeepCollectionEquality().equals(other.byDayPart, byDayPart)&&const DeepCollectionEquality().equals(other.asNeeded, asNeeded)&&const DeepCollectionEquality().equals(other.stock, stock)&&const DeepCollectionEquality().equals(other.conflicts, conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,day,next,const DeepCollectionEquality().hash(fromYesterday),const DeepCollectionEquality().hash(byDayPart),const DeepCollectionEquality().hash(asNeeded),const DeepCollectionEquality().hash(stock),const DeepCollectionEquality().hash(conflicts));

@override
String toString() {
  return 'TodayView(day: $day, next: $next, fromYesterday: $fromYesterday, byDayPart: $byDayPart, asNeeded: $asNeeded, stock: $stock, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class $TodayViewCopyWith<$Res>  {
  factory $TodayViewCopyWith(TodayView value, $Res Function(TodayView) _then) = _$TodayViewCopyWithImpl;
@useResult
$Res call({
 DateTime day, DoseSlot? next, List<DoseSlot> fromYesterday, Map<DayPart, List<DoseSlot>> byDayPart, List<AsNeededItem> asNeeded, Map<String, StockLevel> stock, List<Conflict> conflicts
});


$DoseSlotCopyWith<$Res>? get next;

}
/// @nodoc
class _$TodayViewCopyWithImpl<$Res>
    implements $TodayViewCopyWith<$Res> {
  _$TodayViewCopyWithImpl(this._self, this._then);

  final TodayView _self;
  final $Res Function(TodayView) _then;

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? next = freezed,Object? fromYesterday = null,Object? byDayPart = null,Object? asNeeded = null,Object? stock = null,Object? conflicts = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as DoseSlot?,fromYesterday: null == fromYesterday ? _self.fromYesterday : fromYesterday // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,byDayPart: null == byDayPart ? _self.byDayPart : byDayPart // ignore: cast_nullable_to_non_nullable
as Map<DayPart, List<DoseSlot>>,asNeeded: null == asNeeded ? _self.asNeeded : asNeeded // ignore: cast_nullable_to_non_nullable
as List<AsNeededItem>,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as Map<String, StockLevel>,conflicts: null == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<Conflict>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  DoseSlot? next,  List<DoseSlot> fromYesterday,  Map<DayPart, List<DoseSlot>> byDayPart,  List<AsNeededItem> asNeeded,  Map<String, StockLevel> stock,  List<Conflict> conflicts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayView() when $default != null:
return $default(_that.day,_that.next,_that.fromYesterday,_that.byDayPart,_that.asNeeded,_that.stock,_that.conflicts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  DoseSlot? next,  List<DoseSlot> fromYesterday,  Map<DayPart, List<DoseSlot>> byDayPart,  List<AsNeededItem> asNeeded,  Map<String, StockLevel> stock,  List<Conflict> conflicts)  $default,) {final _that = this;
switch (_that) {
case _TodayView():
return $default(_that.day,_that.next,_that.fromYesterday,_that.byDayPart,_that.asNeeded,_that.stock,_that.conflicts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  DoseSlot? next,  List<DoseSlot> fromYesterday,  Map<DayPart, List<DoseSlot>> byDayPart,  List<AsNeededItem> asNeeded,  Map<String, StockLevel> stock,  List<Conflict> conflicts)?  $default,) {final _that = this;
switch (_that) {
case _TodayView() when $default != null:
return $default(_that.day,_that.next,_that.fromYesterday,_that.byDayPart,_that.asNeeded,_that.stock,_that.conflicts);case _:
  return null;

}
}

}

/// @nodoc


class _TodayView implements TodayView {
  const _TodayView({required this.day, this.next, final  List<DoseSlot> fromYesterday = const <DoseSlot>[], final  Map<DayPart, List<DoseSlot>> byDayPart = const <DayPart, List<DoseSlot>>{}, final  List<AsNeededItem> asNeeded = const <AsNeededItem>[], final  Map<String, StockLevel> stock = const <String, StockLevel>{}, final  List<Conflict> conflicts = const <Conflict>[]}): _fromYesterday = fromYesterday,_byDayPart = byDayPart,_asNeeded = asNeeded,_stock = stock,_conflicts = conflicts;
  

@override final  DateTime day;
/// The dose to attend to first: the earliest due or late one, else
/// the next upcoming one; null when the day is done.
@override final  DoseSlot? next;
/// Yesterday's doses nobody resolved.
 final  List<DoseSlot> _fromYesterday;
/// Yesterday's doses nobody resolved.
@override@JsonKey() List<DoseSlot> get fromYesterday {
  if (_fromYesterday is EqualUnmodifiableListView) return _fromYesterday;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fromYesterday);
}

/// Today's doses by part of the day, in day order; empty parts left
/// out.
 final  Map<DayPart, List<DoseSlot>> _byDayPart;
/// Today's doses by part of the day, in day order; empty parts left
/// out.
@override@JsonKey() Map<DayPart, List<DoseSlot>> get byDayPart {
  if (_byDayPart is EqualUnmodifiableMapView) return _byDayPart;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byDayPart);
}

 final  List<AsNeededItem> _asNeeded;
@override@JsonKey() List<AsNeededItem> get asNeeded {
  if (_asNeeded is EqualUnmodifiableListView) return _asNeeded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_asNeeded);
}

/// Stock per medication, for low-stock badges.
 final  Map<String, StockLevel> _stock;
/// Stock per medication, for low-stock badges.
@override@JsonKey() Map<String, StockLevel> get stock {
  if (_stock is EqualUnmodifiableMapView) return _stock;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stock);
}

 final  List<Conflict> _conflicts;
@override@JsonKey() List<Conflict> get conflicts {
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayView&&(identical(other.day, day) || other.day == day)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other._fromYesterday, _fromYesterday)&&const DeepCollectionEquality().equals(other._byDayPart, _byDayPart)&&const DeepCollectionEquality().equals(other._asNeeded, _asNeeded)&&const DeepCollectionEquality().equals(other._stock, _stock)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,day,next,const DeepCollectionEquality().hash(_fromYesterday),const DeepCollectionEquality().hash(_byDayPart),const DeepCollectionEquality().hash(_asNeeded),const DeepCollectionEquality().hash(_stock),const DeepCollectionEquality().hash(_conflicts));

@override
String toString() {
  return 'TodayView(day: $day, next: $next, fromYesterday: $fromYesterday, byDayPart: $byDayPart, asNeeded: $asNeeded, stock: $stock, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class _$TodayViewCopyWith<$Res> implements $TodayViewCopyWith<$Res> {
  factory _$TodayViewCopyWith(_TodayView value, $Res Function(_TodayView) _then) = __$TodayViewCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, DoseSlot? next, List<DoseSlot> fromYesterday, Map<DayPart, List<DoseSlot>> byDayPart, List<AsNeededItem> asNeeded, Map<String, StockLevel> stock, List<Conflict> conflicts
});


@override $DoseSlotCopyWith<$Res>? get next;

}
/// @nodoc
class __$TodayViewCopyWithImpl<$Res>
    implements _$TodayViewCopyWith<$Res> {
  __$TodayViewCopyWithImpl(this._self, this._then);

  final _TodayView _self;
  final $Res Function(_TodayView) _then;

/// Create a copy of TodayView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? next = freezed,Object? fromYesterday = null,Object? byDayPart = null,Object? asNeeded = null,Object? stock = null,Object? conflicts = null,}) {
  return _then(_TodayView(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as DoseSlot?,fromYesterday: null == fromYesterday ? _self._fromYesterday : fromYesterday // ignore: cast_nullable_to_non_nullable
as List<DoseSlot>,byDayPart: null == byDayPart ? _self._byDayPart : byDayPart // ignore: cast_nullable_to_non_nullable
as Map<DayPart, List<DoseSlot>>,asNeeded: null == asNeeded ? _self._asNeeded : asNeeded // ignore: cast_nullable_to_non_nullable
as List<AsNeededItem>,stock: null == stock ? _self._stock : stock // ignore: cast_nullable_to_non_nullable
as Map<String, StockLevel>,conflicts: null == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<Conflict>,
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
}
}

// dart format on
