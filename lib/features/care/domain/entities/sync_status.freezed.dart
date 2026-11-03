// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncStatus {

/// Last time the server confirmed this device was up to date; null if
/// it never synced.
 DateTime? get lastSyncedAt;/// Events recorded here that the server has not received yet.
 int get pendingCount;/// Events recorded here that the server refused (`docs/roles.md`).
 int get rejectedCount; bool get isConnected;/// False once the server says this device is not in the circle any
/// more: it was removed, or it left (`docs/roles.md`).
 bool get isMember;
/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStatusCopyWith<SyncStatus> get copyWith => _$SyncStatusCopyWithImpl<SyncStatus>(this as SyncStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SyncStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatus&&(identical(other.lastSyncedAt, _this.lastSyncedAt) || other.lastSyncedAt == _this.lastSyncedAt)&&(identical(other.pendingCount, _this.pendingCount) || other.pendingCount == _this.pendingCount)&&(identical(other.rejectedCount, _this.rejectedCount) || other.rejectedCount == _this.rejectedCount)&&(identical(other.isConnected, _this.isConnected) || other.isConnected == _this.isConnected)&&(identical(other.isMember, _this.isMember) || other.isMember == _this.isMember));
}


@override
int get hashCode {
  final _this = this as SyncStatus;
  return Object.hash(runtimeType,_this.lastSyncedAt,_this.pendingCount,_this.rejectedCount,_this.isConnected,_this.isMember);
}

@override
String toString() {
  final _this = this as SyncStatus;
  return 'SyncStatus(lastSyncedAt: ${_this.lastSyncedAt}, pendingCount: ${_this.pendingCount}, rejectedCount: ${_this.rejectedCount}, isConnected: ${_this.isConnected}, isMember: ${_this.isMember})';
}


}

/// @nodoc
abstract mixin class $SyncStatusCopyWith<$Res>  {
  factory $SyncStatusCopyWith(SyncStatus value, $Res Function(SyncStatus) _then) = _$SyncStatusCopyWithImpl;
@useResult
$Res call({
 DateTime? lastSyncedAt, int pendingCount, int rejectedCount, bool isConnected, bool isMember
});




}
/// @nodoc
class _$SyncStatusCopyWithImpl<$Res>
    implements $SyncStatusCopyWith<$Res> {
  _$SyncStatusCopyWithImpl(this._self, this._then);

  final SyncStatus _self;
  final $Res Function(SyncStatus) _then;

/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastSyncedAt = freezed,Object? pendingCount = null,Object? rejectedCount = null,Object? isConnected = null,Object? isMember = null,}) {
  return _then(SyncStatus(
lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,rejectedCount: null == rejectedCount ? _self.rejectedCount : rejectedCount // ignore: cast_nullable_to_non_nullable
as int,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncStatus].
extension SyncStatusPatterns on SyncStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncStatus value)  $default,){
final _that = this;
switch (_that) {
case _SyncStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncStatus value)?  $default,){
final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? lastSyncedAt,  int pendingCount,  int rejectedCount,  bool isConnected,  bool isMember)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
return $default(_that.lastSyncedAt,_that.pendingCount,_that.rejectedCount,_that.isConnected,_that.isMember);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? lastSyncedAt,  int pendingCount,  int rejectedCount,  bool isConnected,  bool isMember)  $default,) {final _that = this;
switch (_that) {
case _SyncStatus():
return $default(_that.lastSyncedAt,_that.pendingCount,_that.rejectedCount,_that.isConnected,_that.isMember);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? lastSyncedAt,  int pendingCount,  int rejectedCount,  bool isConnected,  bool isMember)?  $default,) {final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
return $default(_that.lastSyncedAt,_that.pendingCount,_that.rejectedCount,_that.isConnected,_that.isMember);case _:
  return null;

}
}

}

/// @nodoc


class _SyncStatus implements SyncStatus {
  const _SyncStatus({this.lastSyncedAt, this.pendingCount = 0, this.rejectedCount = 0, this.isConnected = true, this.isMember = true});
  

/// Last time the server confirmed this device was up to date; null if
/// it never synced.
@override final  DateTime? lastSyncedAt;
/// Events recorded here that the server has not received yet.
@override@JsonKey() final  int pendingCount;
/// Events recorded here that the server refused (`docs/roles.md`).
@override@JsonKey() final  int rejectedCount;
@override@JsonKey() final  bool isConnected;
/// False once the server says this device is not in the circle any
/// more: it was removed, or it left (`docs/roles.md`).
@override@JsonKey() final  bool isMember;

/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStatusCopyWith<_SyncStatus> get copyWith => __$SyncStatusCopyWithImpl<_SyncStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncStatus&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.rejectedCount, rejectedCount) || other.rejectedCount == rejectedCount)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isMember, isMember) || other.isMember == isMember));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lastSyncedAt,pendingCount,rejectedCount,isConnected,isMember);
}

@override
String toString() {
    return 'SyncStatus(lastSyncedAt: $lastSyncedAt, pendingCount: $pendingCount, rejectedCount: $rejectedCount, isConnected: $isConnected, isMember: $isMember)';
}


}

/// @nodoc
abstract mixin class _$SyncStatusCopyWith<$Res> implements $SyncStatusCopyWith<$Res> {
  factory _$SyncStatusCopyWith(_SyncStatus value, $Res Function(_SyncStatus) _then) = __$SyncStatusCopyWithImpl;
@override @useResult
$Res call({
 DateTime? lastSyncedAt, int pendingCount, int rejectedCount, bool isConnected, bool isMember
});




}
/// @nodoc
class __$SyncStatusCopyWithImpl<$Res>
    implements _$SyncStatusCopyWith<$Res> {
  __$SyncStatusCopyWithImpl(this._self, this._then);

  final _SyncStatus _self;
  final $Res Function(_SyncStatus) _then;

/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastSyncedAt = freezed,Object? pendingCount = null,Object? rejectedCount = null,Object? isConnected = null,Object? isMember = null,}) {
  return _then(_SyncStatus(
lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,rejectedCount: null == rejectedCount ? _self.rejectedCount : rejectedCount // ignore: cast_nullable_to_non_nullable
as int,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
