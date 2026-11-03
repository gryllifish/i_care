// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rejected_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RejectedEvent {

 CareEvent get event; RejectionReason get reason;
/// Create a copy of RejectedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RejectedEventCopyWith<RejectedEvent> get copyWith => _$RejectedEventCopyWithImpl<RejectedEvent>(this as RejectedEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RejectedEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RejectedEvent&&(identical(other.event, _this.event) || other.event == _this.event)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}


@override
int get hashCode {
  final _this = this as RejectedEvent;
  return Object.hash(runtimeType,_this.event,_this.reason);
}

@override
String toString() {
  final _this = this as RejectedEvent;
  return 'RejectedEvent(event: ${_this.event}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $RejectedEventCopyWith<$Res>  {
  factory $RejectedEventCopyWith(RejectedEvent value, $Res Function(RejectedEvent) _then) = _$RejectedEventCopyWithImpl;
@useResult
$Res call({
 CareEvent event, RejectionReason reason
});


$CareEventCopyWith<$Res> get event;

}
/// @nodoc
class _$RejectedEventCopyWithImpl<$Res>
    implements $RejectedEventCopyWith<$Res> {
  _$RejectedEventCopyWithImpl(this._self, this._then);

  final RejectedEvent _self;
  final $Res Function(RejectedEvent) _then;

/// Create a copy of RejectedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? reason = null,}) {
  return _then(RejectedEvent(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as CareEvent,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RejectionReason,
  ));
}
/// Create a copy of RejectedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareEventCopyWith<$Res> get event {
  
  return $CareEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [RejectedEvent].
extension RejectedEventPatterns on RejectedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RejectedEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RejectedEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RejectedEvent value)  $default,){
final _that = this;
switch (_that) {
case _RejectedEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RejectedEvent value)?  $default,){
final _that = this;
switch (_that) {
case _RejectedEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CareEvent event,  RejectionReason reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RejectedEvent() when $default != null:
return $default(_that.event,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CareEvent event,  RejectionReason reason)  $default,) {final _that = this;
switch (_that) {
case _RejectedEvent():
return $default(_that.event,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CareEvent event,  RejectionReason reason)?  $default,) {final _that = this;
switch (_that) {
case _RejectedEvent() when $default != null:
return $default(_that.event,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _RejectedEvent implements RejectedEvent {
  const _RejectedEvent({required this.event, required this.reason});
  

@override final  CareEvent event;
@override final  RejectionReason reason;

/// Create a copy of RejectedEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RejectedEventCopyWith<_RejectedEvent> get copyWith => __$RejectedEventCopyWithImpl<_RejectedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RejectedEvent&&(identical(other.event, event) || other.event == event)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,event,reason);
}

@override
String toString() {
    return 'RejectedEvent(event: $event, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RejectedEventCopyWith<$Res> implements $RejectedEventCopyWith<$Res> {
  factory _$RejectedEventCopyWith(_RejectedEvent value, $Res Function(_RejectedEvent) _then) = __$RejectedEventCopyWithImpl;
@override @useResult
$Res call({
 CareEvent event, RejectionReason reason
});


@override $CareEventCopyWith<$Res> get event;

}
/// @nodoc
class __$RejectedEventCopyWithImpl<$Res>
    implements _$RejectedEventCopyWith<$Res> {
  __$RejectedEventCopyWithImpl(this._self, this._then);

  final _RejectedEvent _self;
  final $Res Function(_RejectedEvent) _then;

/// Create a copy of RejectedEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? reason = null,}) {
  return _then(_RejectedEvent(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as CareEvent,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RejectionReason,
  ));
}

/// Create a copy of RejectedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareEventCopyWith<$Res> get event {
  
  return $CareEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
