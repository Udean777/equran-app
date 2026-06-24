// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imsak_alarm_prefs_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImsakAlarmPrefsDto {

 bool get imsakEnabled; bool get sahurEnabled; int get menitSebelumImsak;
/// Create a copy of ImsakAlarmPrefsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImsakAlarmPrefsDtoCopyWith<ImsakAlarmPrefsDto> get copyWith => _$ImsakAlarmPrefsDtoCopyWithImpl<ImsakAlarmPrefsDto>(this as ImsakAlarmPrefsDto, _$identity);

  /// Serializes this ImsakAlarmPrefsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImsakAlarmPrefsDto&&(identical(other.imsakEnabled, imsakEnabled) || other.imsakEnabled == imsakEnabled)&&(identical(other.sahurEnabled, sahurEnabled) || other.sahurEnabled == sahurEnabled)&&(identical(other.menitSebelumImsak, menitSebelumImsak) || other.menitSebelumImsak == menitSebelumImsak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imsakEnabled,sahurEnabled,menitSebelumImsak);

@override
String toString() {
  return 'ImsakAlarmPrefsDto(imsakEnabled: $imsakEnabled, sahurEnabled: $sahurEnabled, menitSebelumImsak: $menitSebelumImsak)';
}


}

/// @nodoc
abstract mixin class $ImsakAlarmPrefsDtoCopyWith<$Res>  {
  factory $ImsakAlarmPrefsDtoCopyWith(ImsakAlarmPrefsDto value, $Res Function(ImsakAlarmPrefsDto) _then) = _$ImsakAlarmPrefsDtoCopyWithImpl;
@useResult
$Res call({
 bool imsakEnabled, bool sahurEnabled, int menitSebelumImsak
});




}
/// @nodoc
class _$ImsakAlarmPrefsDtoCopyWithImpl<$Res>
    implements $ImsakAlarmPrefsDtoCopyWith<$Res> {
  _$ImsakAlarmPrefsDtoCopyWithImpl(this._self, this._then);

  final ImsakAlarmPrefsDto _self;
  final $Res Function(ImsakAlarmPrefsDto) _then;

/// Create a copy of ImsakAlarmPrefsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imsakEnabled = null,Object? sahurEnabled = null,Object? menitSebelumImsak = null,}) {
  return _then(_self.copyWith(
imsakEnabled: null == imsakEnabled ? _self.imsakEnabled : imsakEnabled // ignore: cast_nullable_to_non_nullable
as bool,sahurEnabled: null == sahurEnabled ? _self.sahurEnabled : sahurEnabled // ignore: cast_nullable_to_non_nullable
as bool,menitSebelumImsak: null == menitSebelumImsak ? _self.menitSebelumImsak : menitSebelumImsak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImsakAlarmPrefsDto].
extension ImsakAlarmPrefsDtoPatterns on ImsakAlarmPrefsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImsakAlarmPrefsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImsakAlarmPrefsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImsakAlarmPrefsDto value)  $default,){
final _that = this;
switch (_that) {
case _ImsakAlarmPrefsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImsakAlarmPrefsDto value)?  $default,){
final _that = this;
switch (_that) {
case _ImsakAlarmPrefsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool imsakEnabled,  bool sahurEnabled,  int menitSebelumImsak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImsakAlarmPrefsDto() when $default != null:
return $default(_that.imsakEnabled,_that.sahurEnabled,_that.menitSebelumImsak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool imsakEnabled,  bool sahurEnabled,  int menitSebelumImsak)  $default,) {final _that = this;
switch (_that) {
case _ImsakAlarmPrefsDto():
return $default(_that.imsakEnabled,_that.sahurEnabled,_that.menitSebelumImsak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool imsakEnabled,  bool sahurEnabled,  int menitSebelumImsak)?  $default,) {final _that = this;
switch (_that) {
case _ImsakAlarmPrefsDto() when $default != null:
return $default(_that.imsakEnabled,_that.sahurEnabled,_that.menitSebelumImsak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImsakAlarmPrefsDto implements ImsakAlarmPrefsDto {
  const _ImsakAlarmPrefsDto({this.imsakEnabled = false, this.sahurEnabled = false, this.menitSebelumImsak = 60});
  factory _ImsakAlarmPrefsDto.fromJson(Map<String, dynamic> json) => _$ImsakAlarmPrefsDtoFromJson(json);

@override@JsonKey() final  bool imsakEnabled;
@override@JsonKey() final  bool sahurEnabled;
@override@JsonKey() final  int menitSebelumImsak;

/// Create a copy of ImsakAlarmPrefsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImsakAlarmPrefsDtoCopyWith<_ImsakAlarmPrefsDto> get copyWith => __$ImsakAlarmPrefsDtoCopyWithImpl<_ImsakAlarmPrefsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImsakAlarmPrefsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImsakAlarmPrefsDto&&(identical(other.imsakEnabled, imsakEnabled) || other.imsakEnabled == imsakEnabled)&&(identical(other.sahurEnabled, sahurEnabled) || other.sahurEnabled == sahurEnabled)&&(identical(other.menitSebelumImsak, menitSebelumImsak) || other.menitSebelumImsak == menitSebelumImsak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imsakEnabled,sahurEnabled,menitSebelumImsak);

@override
String toString() {
  return 'ImsakAlarmPrefsDto(imsakEnabled: $imsakEnabled, sahurEnabled: $sahurEnabled, menitSebelumImsak: $menitSebelumImsak)';
}


}

/// @nodoc
abstract mixin class _$ImsakAlarmPrefsDtoCopyWith<$Res> implements $ImsakAlarmPrefsDtoCopyWith<$Res> {
  factory _$ImsakAlarmPrefsDtoCopyWith(_ImsakAlarmPrefsDto value, $Res Function(_ImsakAlarmPrefsDto) _then) = __$ImsakAlarmPrefsDtoCopyWithImpl;
@override @useResult
$Res call({
 bool imsakEnabled, bool sahurEnabled, int menitSebelumImsak
});




}
/// @nodoc
class __$ImsakAlarmPrefsDtoCopyWithImpl<$Res>
    implements _$ImsakAlarmPrefsDtoCopyWith<$Res> {
  __$ImsakAlarmPrefsDtoCopyWithImpl(this._self, this._then);

  final _ImsakAlarmPrefsDto _self;
  final $Res Function(_ImsakAlarmPrefsDto) _then;

/// Create a copy of ImsakAlarmPrefsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imsakEnabled = null,Object? sahurEnabled = null,Object? menitSebelumImsak = null,}) {
  return _then(_ImsakAlarmPrefsDto(
imsakEnabled: null == imsakEnabled ? _self.imsakEnabled : imsakEnabled // ignore: cast_nullable_to_non_nullable
as bool,sahurEnabled: null == sahurEnabled ? _self.sahurEnabled : sahurEnabled // ignore: cast_nullable_to_non_nullable
as bool,menitSebelumImsak: null == menitSebelumImsak ? _self.menitSebelumImsak : menitSebelumImsak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
