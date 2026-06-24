// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_test_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationTestState {

 Map<String, bool> get statuses;
/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTestStateCopyWith<NotificationTestState> get copyWith => _$NotificationTestStateCopyWithImpl<NotificationTestState>(this as NotificationTestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTestState&&const DeepCollectionEquality().equals(other.statuses, statuses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statuses));

@override
String toString() {
  return 'NotificationTestState(statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class $NotificationTestStateCopyWith<$Res>  {
  factory $NotificationTestStateCopyWith(NotificationTestState value, $Res Function(NotificationTestState) _then) = _$NotificationTestStateCopyWithImpl;
@useResult
$Res call({
 Map<String, bool> statuses
});




}
/// @nodoc
class _$NotificationTestStateCopyWithImpl<$Res>
    implements $NotificationTestStateCopyWith<$Res> {
  _$NotificationTestStateCopyWithImpl(this._self, this._then);

  final NotificationTestState _self;
  final $Res Function(NotificationTestState) _then;

/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statuses = null,}) {
  return _then(_self.copyWith(
statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationTestState].
extension NotificationTestStatePatterns on NotificationTestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotificationTestInitial value)?  initial,TResult Function( NotificationTestRunning value)?  running,TResult Function( NotificationTestError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotificationTestInitial() when initial != null:
return initial(_that);case NotificationTestRunning() when running != null:
return running(_that);case NotificationTestError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotificationTestInitial value)  initial,required TResult Function( NotificationTestRunning value)  running,required TResult Function( NotificationTestError value)  error,}){
final _that = this;
switch (_that) {
case NotificationTestInitial():
return initial(_that);case NotificationTestRunning():
return running(_that);case NotificationTestError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotificationTestInitial value)?  initial,TResult? Function( NotificationTestRunning value)?  running,TResult? Function( NotificationTestError value)?  error,}){
final _that = this;
switch (_that) {
case NotificationTestInitial() when initial != null:
return initial(_that);case NotificationTestRunning() when running != null:
return running(_that);case NotificationTestError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Map<String, bool> statuses)?  initial,TResult Function( Map<String, bool> statuses)?  running,TResult Function( Map<String, bool> statuses,  Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotificationTestInitial() when initial != null:
return initial(_that.statuses);case NotificationTestRunning() when running != null:
return running(_that.statuses);case NotificationTestError() when error != null:
return error(_that.statuses,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Map<String, bool> statuses)  initial,required TResult Function( Map<String, bool> statuses)  running,required TResult Function( Map<String, bool> statuses,  Failure failure)  error,}) {final _that = this;
switch (_that) {
case NotificationTestInitial():
return initial(_that.statuses);case NotificationTestRunning():
return running(_that.statuses);case NotificationTestError():
return error(_that.statuses,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Map<String, bool> statuses)?  initial,TResult? Function( Map<String, bool> statuses)?  running,TResult? Function( Map<String, bool> statuses,  Failure failure)?  error,}) {final _that = this;
switch (_that) {
case NotificationTestInitial() when initial != null:
return initial(_that.statuses);case NotificationTestRunning() when running != null:
return running(_that.statuses);case NotificationTestError() when error != null:
return error(_that.statuses,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class NotificationTestInitial implements NotificationTestState {
  const NotificationTestInitial({final  Map<String, bool> statuses = const {}}): _statuses = statuses;
  

 final  Map<String, bool> _statuses;
@override@JsonKey() Map<String, bool> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}


/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTestInitialCopyWith<NotificationTestInitial> get copyWith => _$NotificationTestInitialCopyWithImpl<NotificationTestInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTestInitial&&const DeepCollectionEquality().equals(other._statuses, _statuses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_statuses));

@override
String toString() {
  return 'NotificationTestState.initial(statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class $NotificationTestInitialCopyWith<$Res> implements $NotificationTestStateCopyWith<$Res> {
  factory $NotificationTestInitialCopyWith(NotificationTestInitial value, $Res Function(NotificationTestInitial) _then) = _$NotificationTestInitialCopyWithImpl;
@override @useResult
$Res call({
 Map<String, bool> statuses
});




}
/// @nodoc
class _$NotificationTestInitialCopyWithImpl<$Res>
    implements $NotificationTestInitialCopyWith<$Res> {
  _$NotificationTestInitialCopyWithImpl(this._self, this._then);

  final NotificationTestInitial _self;
  final $Res Function(NotificationTestInitial) _then;

/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statuses = null,}) {
  return _then(NotificationTestInitial(
statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

/// @nodoc


class NotificationTestRunning implements NotificationTestState {
  const NotificationTestRunning({required final  Map<String, bool> statuses}): _statuses = statuses;
  

 final  Map<String, bool> _statuses;
@override Map<String, bool> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}


/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTestRunningCopyWith<NotificationTestRunning> get copyWith => _$NotificationTestRunningCopyWithImpl<NotificationTestRunning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTestRunning&&const DeepCollectionEquality().equals(other._statuses, _statuses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_statuses));

@override
String toString() {
  return 'NotificationTestState.running(statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class $NotificationTestRunningCopyWith<$Res> implements $NotificationTestStateCopyWith<$Res> {
  factory $NotificationTestRunningCopyWith(NotificationTestRunning value, $Res Function(NotificationTestRunning) _then) = _$NotificationTestRunningCopyWithImpl;
@override @useResult
$Res call({
 Map<String, bool> statuses
});




}
/// @nodoc
class _$NotificationTestRunningCopyWithImpl<$Res>
    implements $NotificationTestRunningCopyWith<$Res> {
  _$NotificationTestRunningCopyWithImpl(this._self, this._then);

  final NotificationTestRunning _self;
  final $Res Function(NotificationTestRunning) _then;

/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statuses = null,}) {
  return _then(NotificationTestRunning(
statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

/// @nodoc


class NotificationTestError implements NotificationTestState {
  const NotificationTestError({required final  Map<String, bool> statuses, required this.failure}): _statuses = statuses;
  

 final  Map<String, bool> _statuses;
@override Map<String, bool> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

 final  Failure failure;

/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTestErrorCopyWith<NotificationTestError> get copyWith => _$NotificationTestErrorCopyWithImpl<NotificationTestError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTestError&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_statuses),failure);

@override
String toString() {
  return 'NotificationTestState.error(statuses: $statuses, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $NotificationTestErrorCopyWith<$Res> implements $NotificationTestStateCopyWith<$Res> {
  factory $NotificationTestErrorCopyWith(NotificationTestError value, $Res Function(NotificationTestError) _then) = _$NotificationTestErrorCopyWithImpl;
@override @useResult
$Res call({
 Map<String, bool> statuses, Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$NotificationTestErrorCopyWithImpl<$Res>
    implements $NotificationTestErrorCopyWith<$Res> {
  _$NotificationTestErrorCopyWithImpl(this._self, this._then);

  final NotificationTestError _self;
  final $Res Function(NotificationTestError) _then;

/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statuses = null,Object? failure = null,}) {
  return _then(NotificationTestError(
statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of NotificationTestState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
