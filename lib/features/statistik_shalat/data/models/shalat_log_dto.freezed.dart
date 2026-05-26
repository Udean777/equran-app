// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shalat_log_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShalatLogDto {

 String get date; String get waktu; String get status; String? get catatan; String? get updatedAt;
/// Create a copy of ShalatLogDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalatLogDtoCopyWith<ShalatLogDto> get copyWith => _$ShalatLogDtoCopyWithImpl<ShalatLogDto>(this as ShalatLogDto, _$identity);

  /// Serializes this ShalatLogDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalatLogDto&&(identical(other.date, date) || other.date == date)&&(identical(other.waktu, waktu) || other.waktu == waktu)&&(identical(other.status, status) || other.status == status)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,waktu,status,catatan,updatedAt);

@override
String toString() {
  return 'ShalatLogDto(date: $date, waktu: $waktu, status: $status, catatan: $catatan, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShalatLogDtoCopyWith<$Res>  {
  factory $ShalatLogDtoCopyWith(ShalatLogDto value, $Res Function(ShalatLogDto) _then) = _$ShalatLogDtoCopyWithImpl;
@useResult
$Res call({
 String date, String waktu, String status, String? catatan, String? updatedAt
});




}
/// @nodoc
class _$ShalatLogDtoCopyWithImpl<$Res>
    implements $ShalatLogDtoCopyWith<$Res> {
  _$ShalatLogDtoCopyWithImpl(this._self, this._then);

  final ShalatLogDto _self;
  final $Res Function(ShalatLogDto) _then;

/// Create a copy of ShalatLogDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? waktu = null,Object? status = null,Object? catatan = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,waktu: null == waktu ? _self.waktu : waktu // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShalatLogDto].
extension ShalatLogDtoPatterns on ShalatLogDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShalatLogDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShalatLogDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShalatLogDto value)  $default,){
final _that = this;
switch (_that) {
case _ShalatLogDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShalatLogDto value)?  $default,){
final _that = this;
switch (_that) {
case _ShalatLogDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String waktu,  String status,  String? catatan,  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShalatLogDto() when $default != null:
return $default(_that.date,_that.waktu,_that.status,_that.catatan,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String waktu,  String status,  String? catatan,  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShalatLogDto():
return $default(_that.date,_that.waktu,_that.status,_that.catatan,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String waktu,  String status,  String? catatan,  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShalatLogDto() when $default != null:
return $default(_that.date,_that.waktu,_that.status,_that.catatan,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShalatLogDto implements ShalatLogDto {
  const _ShalatLogDto({required this.date, required this.waktu, this.status = 'belumDicatat', this.catatan, this.updatedAt});
  factory _ShalatLogDto.fromJson(Map<String, dynamic> json) => _$ShalatLogDtoFromJson(json);

@override final  String date;
@override final  String waktu;
@override@JsonKey() final  String status;
@override final  String? catatan;
@override final  String? updatedAt;

/// Create a copy of ShalatLogDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShalatLogDtoCopyWith<_ShalatLogDto> get copyWith => __$ShalatLogDtoCopyWithImpl<_ShalatLogDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShalatLogDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShalatLogDto&&(identical(other.date, date) || other.date == date)&&(identical(other.waktu, waktu) || other.waktu == waktu)&&(identical(other.status, status) || other.status == status)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,waktu,status,catatan,updatedAt);

@override
String toString() {
  return 'ShalatLogDto(date: $date, waktu: $waktu, status: $status, catatan: $catatan, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShalatLogDtoCopyWith<$Res> implements $ShalatLogDtoCopyWith<$Res> {
  factory _$ShalatLogDtoCopyWith(_ShalatLogDto value, $Res Function(_ShalatLogDto) _then) = __$ShalatLogDtoCopyWithImpl;
@override @useResult
$Res call({
 String date, String waktu, String status, String? catatan, String? updatedAt
});




}
/// @nodoc
class __$ShalatLogDtoCopyWithImpl<$Res>
    implements _$ShalatLogDtoCopyWith<$Res> {
  __$ShalatLogDtoCopyWithImpl(this._self, this._then);

  final _ShalatLogDto _self;
  final $Res Function(_ShalatLogDto) _then;

/// Create a copy of ShalatLogDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? waktu = null,Object? status = null,Object? catatan = freezed,Object? updatedAt = freezed,}) {
  return _then(_ShalatLogDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,waktu: null == waktu ? _self.waktu : waktu // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ShalatDayDto {

 String get date; Map<String, ShalatLogDto> get logs;
/// Create a copy of ShalatDayDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalatDayDtoCopyWith<ShalatDayDto> get copyWith => _$ShalatDayDtoCopyWithImpl<ShalatDayDto>(this as ShalatDayDto, _$identity);

  /// Serializes this ShalatDayDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalatDayDto&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.logs, logs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(logs));

@override
String toString() {
  return 'ShalatDayDto(date: $date, logs: $logs)';
}


}

/// @nodoc
abstract mixin class $ShalatDayDtoCopyWith<$Res>  {
  factory $ShalatDayDtoCopyWith(ShalatDayDto value, $Res Function(ShalatDayDto) _then) = _$ShalatDayDtoCopyWithImpl;
@useResult
$Res call({
 String date, Map<String, ShalatLogDto> logs
});




}
/// @nodoc
class _$ShalatDayDtoCopyWithImpl<$Res>
    implements $ShalatDayDtoCopyWith<$Res> {
  _$ShalatDayDtoCopyWithImpl(this._self, this._then);

  final ShalatDayDto _self;
  final $Res Function(ShalatDayDto) _then;

/// Create a copy of ShalatDayDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? logs = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, ShalatLogDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShalatDayDto].
extension ShalatDayDtoPatterns on ShalatDayDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShalatDayDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShalatDayDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShalatDayDto value)  $default,){
final _that = this;
switch (_that) {
case _ShalatDayDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShalatDayDto value)?  $default,){
final _that = this;
switch (_that) {
case _ShalatDayDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  Map<String, ShalatLogDto> logs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShalatDayDto() when $default != null:
return $default(_that.date,_that.logs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  Map<String, ShalatLogDto> logs)  $default,) {final _that = this;
switch (_that) {
case _ShalatDayDto():
return $default(_that.date,_that.logs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  Map<String, ShalatLogDto> logs)?  $default,) {final _that = this;
switch (_that) {
case _ShalatDayDto() when $default != null:
return $default(_that.date,_that.logs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShalatDayDto implements ShalatDayDto {
  const _ShalatDayDto({required this.date, final  Map<String, ShalatLogDto> logs = const {}}): _logs = logs;
  factory _ShalatDayDto.fromJson(Map<String, dynamic> json) => _$ShalatDayDtoFromJson(json);

@override final  String date;
 final  Map<String, ShalatLogDto> _logs;
@override@JsonKey() Map<String, ShalatLogDto> get logs {
  if (_logs is EqualUnmodifiableMapView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_logs);
}


/// Create a copy of ShalatDayDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShalatDayDtoCopyWith<_ShalatDayDto> get copyWith => __$ShalatDayDtoCopyWithImpl<_ShalatDayDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShalatDayDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShalatDayDto&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._logs, _logs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_logs));

@override
String toString() {
  return 'ShalatDayDto(date: $date, logs: $logs)';
}


}

/// @nodoc
abstract mixin class _$ShalatDayDtoCopyWith<$Res> implements $ShalatDayDtoCopyWith<$Res> {
  factory _$ShalatDayDtoCopyWith(_ShalatDayDto value, $Res Function(_ShalatDayDto) _then) = __$ShalatDayDtoCopyWithImpl;
@override @useResult
$Res call({
 String date, Map<String, ShalatLogDto> logs
});




}
/// @nodoc
class __$ShalatDayDtoCopyWithImpl<$Res>
    implements _$ShalatDayDtoCopyWith<$Res> {
  __$ShalatDayDtoCopyWithImpl(this._self, this._then);

  final _ShalatDayDto _self;
  final $Res Function(_ShalatDayDto) _then;

/// Create a copy of ShalatDayDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? logs = null,}) {
  return _then(_ShalatDayDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, ShalatLogDto>,
  ));
}


}

// dart format on
