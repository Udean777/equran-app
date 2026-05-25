// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qibla_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QiblaState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QiblaState()';
}


}

/// @nodoc
class $QiblaStateCopyWith<$Res>  {
$QiblaStateCopyWith(QiblaState _, $Res Function(QiblaState) __);
}


/// Adds pattern-matching-related methods to [QiblaState].
extension QiblaStatePatterns on QiblaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QiblaInitial value)?  initial,TResult Function( QiblaLoading value)?  loading,TResult Function( QiblaLoaded value)?  loaded,TResult Function( QiblaError value)?  error,TResult Function( QiblaNoSensor value)?  noSensor,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QiblaInitial() when initial != null:
return initial(_that);case QiblaLoading() when loading != null:
return loading(_that);case QiblaLoaded() when loaded != null:
return loaded(_that);case QiblaError() when error != null:
return error(_that);case QiblaNoSensor() when noSensor != null:
return noSensor(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QiblaInitial value)  initial,required TResult Function( QiblaLoading value)  loading,required TResult Function( QiblaLoaded value)  loaded,required TResult Function( QiblaError value)  error,required TResult Function( QiblaNoSensor value)  noSensor,}){
final _that = this;
switch (_that) {
case QiblaInitial():
return initial(_that);case QiblaLoading():
return loading(_that);case QiblaLoaded():
return loaded(_that);case QiblaError():
return error(_that);case QiblaNoSensor():
return noSensor(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QiblaInitial value)?  initial,TResult? Function( QiblaLoading value)?  loading,TResult? Function( QiblaLoaded value)?  loaded,TResult? Function( QiblaError value)?  error,TResult? Function( QiblaNoSensor value)?  noSensor,}){
final _that = this;
switch (_that) {
case QiblaInitial() when initial != null:
return initial(_that);case QiblaLoading() when loading != null:
return loading(_that);case QiblaLoaded() when loaded != null:
return loaded(_that);case QiblaError() when error != null:
return error(_that);case QiblaNoSensor() when noSensor != null:
return noSensor(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( QiblaDirection direction)?  loaded,TResult Function( String message)?  error,TResult Function()?  noSensor,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QiblaInitial() when initial != null:
return initial();case QiblaLoading() when loading != null:
return loading();case QiblaLoaded() when loaded != null:
return loaded(_that.direction);case QiblaError() when error != null:
return error(_that.message);case QiblaNoSensor() when noSensor != null:
return noSensor();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( QiblaDirection direction)  loaded,required TResult Function( String message)  error,required TResult Function()  noSensor,}) {final _that = this;
switch (_that) {
case QiblaInitial():
return initial();case QiblaLoading():
return loading();case QiblaLoaded():
return loaded(_that.direction);case QiblaError():
return error(_that.message);case QiblaNoSensor():
return noSensor();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( QiblaDirection direction)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  noSensor,}) {final _that = this;
switch (_that) {
case QiblaInitial() when initial != null:
return initial();case QiblaLoading() when loading != null:
return loading();case QiblaLoaded() when loaded != null:
return loaded(_that.direction);case QiblaError() when error != null:
return error(_that.message);case QiblaNoSensor() when noSensor != null:
return noSensor();case _:
  return null;

}
}

}

/// @nodoc


class QiblaInitial implements QiblaState {
  const QiblaInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QiblaState.initial()';
}


}




/// @nodoc


class QiblaLoading implements QiblaState {
  const QiblaLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QiblaState.loading()';
}


}




/// @nodoc


class QiblaLoaded implements QiblaState {
  const QiblaLoaded({required this.direction});
  

 final  QiblaDirection direction;

/// Create a copy of QiblaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QiblaLoadedCopyWith<QiblaLoaded> get copyWith => _$QiblaLoadedCopyWithImpl<QiblaLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaLoaded&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode => Object.hash(runtimeType,direction);

@override
String toString() {
  return 'QiblaState.loaded(direction: $direction)';
}


}

/// @nodoc
abstract mixin class $QiblaLoadedCopyWith<$Res> implements $QiblaStateCopyWith<$Res> {
  factory $QiblaLoadedCopyWith(QiblaLoaded value, $Res Function(QiblaLoaded) _then) = _$QiblaLoadedCopyWithImpl;
@useResult
$Res call({
 QiblaDirection direction
});


$QiblaDirectionCopyWith<$Res> get direction;

}
/// @nodoc
class _$QiblaLoadedCopyWithImpl<$Res>
    implements $QiblaLoadedCopyWith<$Res> {
  _$QiblaLoadedCopyWithImpl(this._self, this._then);

  final QiblaLoaded _self;
  final $Res Function(QiblaLoaded) _then;

/// Create a copy of QiblaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? direction = null,}) {
  return _then(QiblaLoaded(
direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as QiblaDirection,
  ));
}

/// Create a copy of QiblaState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QiblaDirectionCopyWith<$Res> get direction {
  
  return $QiblaDirectionCopyWith<$Res>(_self.direction, (value) {
    return _then(_self.copyWith(direction: value));
  });
}
}

/// @nodoc


class QiblaError implements QiblaState {
  const QiblaError({required this.message});
  

 final  String message;

/// Create a copy of QiblaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QiblaErrorCopyWith<QiblaError> get copyWith => _$QiblaErrorCopyWithImpl<QiblaError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'QiblaState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $QiblaErrorCopyWith<$Res> implements $QiblaStateCopyWith<$Res> {
  factory $QiblaErrorCopyWith(QiblaError value, $Res Function(QiblaError) _then) = _$QiblaErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$QiblaErrorCopyWithImpl<$Res>
    implements $QiblaErrorCopyWith<$Res> {
  _$QiblaErrorCopyWithImpl(this._self, this._then);

  final QiblaError _self;
  final $Res Function(QiblaError) _then;

/// Create a copy of QiblaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(QiblaError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QiblaNoSensor implements QiblaState {
  const QiblaNoSensor();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaNoSensor);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QiblaState.noSensor()';
}


}




// dart format on
