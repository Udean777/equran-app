// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qibla_direction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QiblaDirection {

/// Bearing dari posisi user ke Kabah dalam derajat (0–360).
 double get bearing;/// Heading device dari sensor kompas dalam derajat (0–360).
 double get deviceHeading;/// Sudut jarum kompas relatif ke device: (bearing - deviceHeading + 360) % 360.
 double get qiblaAngle;/// Akurasi sensor kompas (null jika tidak tersedia).
 double? get accuracy;
/// Create a copy of QiblaDirection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QiblaDirectionCopyWith<QiblaDirection> get copyWith => _$QiblaDirectionCopyWithImpl<QiblaDirection>(this as QiblaDirection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaDirection&&(identical(other.bearing, bearing) || other.bearing == bearing)&&(identical(other.deviceHeading, deviceHeading) || other.deviceHeading == deviceHeading)&&(identical(other.qiblaAngle, qiblaAngle) || other.qiblaAngle == qiblaAngle)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}


@override
int get hashCode => Object.hash(runtimeType,bearing,deviceHeading,qiblaAngle,accuracy);

@override
String toString() {
  return 'QiblaDirection(bearing: $bearing, deviceHeading: $deviceHeading, qiblaAngle: $qiblaAngle, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class $QiblaDirectionCopyWith<$Res>  {
  factory $QiblaDirectionCopyWith(QiblaDirection value, $Res Function(QiblaDirection) _then) = _$QiblaDirectionCopyWithImpl;
@useResult
$Res call({
 double bearing, double deviceHeading, double qiblaAngle, double? accuracy
});




}
/// @nodoc
class _$QiblaDirectionCopyWithImpl<$Res>
    implements $QiblaDirectionCopyWith<$Res> {
  _$QiblaDirectionCopyWithImpl(this._self, this._then);

  final QiblaDirection _self;
  final $Res Function(QiblaDirection) _then;

/// Create a copy of QiblaDirection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bearing = null,Object? deviceHeading = null,Object? qiblaAngle = null,Object? accuracy = freezed,}) {
  return _then(_self.copyWith(
bearing: null == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double,deviceHeading: null == deviceHeading ? _self.deviceHeading : deviceHeading // ignore: cast_nullable_to_non_nullable
as double,qiblaAngle: null == qiblaAngle ? _self.qiblaAngle : qiblaAngle // ignore: cast_nullable_to_non_nullable
as double,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [QiblaDirection].
extension QiblaDirectionPatterns on QiblaDirection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QiblaDirection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QiblaDirection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QiblaDirection value)  $default,){
final _that = this;
switch (_that) {
case _QiblaDirection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QiblaDirection value)?  $default,){
final _that = this;
switch (_that) {
case _QiblaDirection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double bearing,  double deviceHeading,  double qiblaAngle,  double? accuracy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QiblaDirection() when $default != null:
return $default(_that.bearing,_that.deviceHeading,_that.qiblaAngle,_that.accuracy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double bearing,  double deviceHeading,  double qiblaAngle,  double? accuracy)  $default,) {final _that = this;
switch (_that) {
case _QiblaDirection():
return $default(_that.bearing,_that.deviceHeading,_that.qiblaAngle,_that.accuracy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double bearing,  double deviceHeading,  double qiblaAngle,  double? accuracy)?  $default,) {final _that = this;
switch (_that) {
case _QiblaDirection() when $default != null:
return $default(_that.bearing,_that.deviceHeading,_that.qiblaAngle,_that.accuracy);case _:
  return null;

}
}

}

/// @nodoc


class _QiblaDirection implements QiblaDirection {
  const _QiblaDirection({required this.bearing, required this.deviceHeading, required this.qiblaAngle, this.accuracy});
  

/// Bearing dari posisi user ke Kabah dalam derajat (0–360).
@override final  double bearing;
/// Heading device dari sensor kompas dalam derajat (0–360).
@override final  double deviceHeading;
/// Sudut jarum kompas relatif ke device: (bearing - deviceHeading + 360) % 360.
@override final  double qiblaAngle;
/// Akurasi sensor kompas (null jika tidak tersedia).
@override final  double? accuracy;

/// Create a copy of QiblaDirection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QiblaDirectionCopyWith<_QiblaDirection> get copyWith => __$QiblaDirectionCopyWithImpl<_QiblaDirection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QiblaDirection&&(identical(other.bearing, bearing) || other.bearing == bearing)&&(identical(other.deviceHeading, deviceHeading) || other.deviceHeading == deviceHeading)&&(identical(other.qiblaAngle, qiblaAngle) || other.qiblaAngle == qiblaAngle)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}


@override
int get hashCode => Object.hash(runtimeType,bearing,deviceHeading,qiblaAngle,accuracy);

@override
String toString() {
  return 'QiblaDirection(bearing: $bearing, deviceHeading: $deviceHeading, qiblaAngle: $qiblaAngle, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class _$QiblaDirectionCopyWith<$Res> implements $QiblaDirectionCopyWith<$Res> {
  factory _$QiblaDirectionCopyWith(_QiblaDirection value, $Res Function(_QiblaDirection) _then) = __$QiblaDirectionCopyWithImpl;
@override @useResult
$Res call({
 double bearing, double deviceHeading, double qiblaAngle, double? accuracy
});




}
/// @nodoc
class __$QiblaDirectionCopyWithImpl<$Res>
    implements _$QiblaDirectionCopyWith<$Res> {
  __$QiblaDirectionCopyWithImpl(this._self, this._then);

  final _QiblaDirection _self;
  final $Res Function(_QiblaDirection) _then;

/// Create a copy of QiblaDirection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bearing = null,Object? deviceHeading = null,Object? qiblaAngle = null,Object? accuracy = freezed,}) {
  return _then(_QiblaDirection(
bearing: null == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double,deviceHeading: null == deviceHeading ? _self.deviceHeading : deviceHeading // ignore: cast_nullable_to_non_nullable
as double,qiblaAngle: null == qiblaAngle ? _self.qiblaAngle : qiblaAngle // ignore: cast_nullable_to_non_nullable
as double,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
