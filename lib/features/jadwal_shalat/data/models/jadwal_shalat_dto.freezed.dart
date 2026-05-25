// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jadwal_shalat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProvinsiShalatResponseDto {

 int get code; String get message; List<String> get data;
/// Create a copy of ProvinsiShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvinsiShalatResponseDtoCopyWith<ProvinsiShalatResponseDto> get copyWith => _$ProvinsiShalatResponseDtoCopyWithImpl<ProvinsiShalatResponseDto>(this as ProvinsiShalatResponseDto, _$identity);

  /// Serializes this ProvinsiShalatResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvinsiShalatResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ProvinsiShalatResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $ProvinsiShalatResponseDtoCopyWith<$Res>  {
  factory $ProvinsiShalatResponseDtoCopyWith(ProvinsiShalatResponseDto value, $Res Function(ProvinsiShalatResponseDto) _then) = _$ProvinsiShalatResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class _$ProvinsiShalatResponseDtoCopyWithImpl<$Res>
    implements $ProvinsiShalatResponseDtoCopyWith<$Res> {
  _$ProvinsiShalatResponseDtoCopyWithImpl(this._self, this._then);

  final ProvinsiShalatResponseDto _self;
  final $Res Function(ProvinsiShalatResponseDto) _then;

/// Create a copy of ProvinsiShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProvinsiShalatResponseDto].
extension ProvinsiShalatResponseDtoPatterns on ProvinsiShalatResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProvinsiShalatResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProvinsiShalatResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProvinsiShalatResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ProvinsiShalatResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProvinsiShalatResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProvinsiShalatResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  List<String> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProvinsiShalatResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  List<String> data)  $default,) {final _that = this;
switch (_that) {
case _ProvinsiShalatResponseDto():
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  List<String> data)?  $default,) {final _that = this;
switch (_that) {
case _ProvinsiShalatResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProvinsiShalatResponseDto implements ProvinsiShalatResponseDto {
  const _ProvinsiShalatResponseDto({required this.code, required this.message, required final  List<String> data}): _data = data;
  factory _ProvinsiShalatResponseDto.fromJson(Map<String, dynamic> json) => _$ProvinsiShalatResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
 final  List<String> _data;
@override List<String> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of ProvinsiShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProvinsiShalatResponseDtoCopyWith<_ProvinsiShalatResponseDto> get copyWith => __$ProvinsiShalatResponseDtoCopyWithImpl<_ProvinsiShalatResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProvinsiShalatResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProvinsiShalatResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ProvinsiShalatResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ProvinsiShalatResponseDtoCopyWith<$Res> implements $ProvinsiShalatResponseDtoCopyWith<$Res> {
  factory _$ProvinsiShalatResponseDtoCopyWith(_ProvinsiShalatResponseDto value, $Res Function(_ProvinsiShalatResponseDto) _then) = __$ProvinsiShalatResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class __$ProvinsiShalatResponseDtoCopyWithImpl<$Res>
    implements _$ProvinsiShalatResponseDtoCopyWith<$Res> {
  __$ProvinsiShalatResponseDtoCopyWithImpl(this._self, this._then);

  final _ProvinsiShalatResponseDto _self;
  final $Res Function(_ProvinsiShalatResponseDto) _then;

/// Create a copy of ProvinsiShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_ProvinsiShalatResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$KabkotaShalatResponseDto {

 int get code; String get message; List<String> get data;
/// Create a copy of KabkotaShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KabkotaShalatResponseDtoCopyWith<KabkotaShalatResponseDto> get copyWith => _$KabkotaShalatResponseDtoCopyWithImpl<KabkotaShalatResponseDto>(this as KabkotaShalatResponseDto, _$identity);

  /// Serializes this KabkotaShalatResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KabkotaShalatResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'KabkotaShalatResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $KabkotaShalatResponseDtoCopyWith<$Res>  {
  factory $KabkotaShalatResponseDtoCopyWith(KabkotaShalatResponseDto value, $Res Function(KabkotaShalatResponseDto) _then) = _$KabkotaShalatResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class _$KabkotaShalatResponseDtoCopyWithImpl<$Res>
    implements $KabkotaShalatResponseDtoCopyWith<$Res> {
  _$KabkotaShalatResponseDtoCopyWithImpl(this._self, this._then);

  final KabkotaShalatResponseDto _self;
  final $Res Function(KabkotaShalatResponseDto) _then;

/// Create a copy of KabkotaShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [KabkotaShalatResponseDto].
extension KabkotaShalatResponseDtoPatterns on KabkotaShalatResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KabkotaShalatResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KabkotaShalatResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KabkotaShalatResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _KabkotaShalatResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KabkotaShalatResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _KabkotaShalatResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  List<String> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KabkotaShalatResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  List<String> data)  $default,) {final _that = this;
switch (_that) {
case _KabkotaShalatResponseDto():
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  List<String> data)?  $default,) {final _that = this;
switch (_that) {
case _KabkotaShalatResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KabkotaShalatResponseDto implements KabkotaShalatResponseDto {
  const _KabkotaShalatResponseDto({required this.code, required this.message, required final  List<String> data}): _data = data;
  factory _KabkotaShalatResponseDto.fromJson(Map<String, dynamic> json) => _$KabkotaShalatResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
 final  List<String> _data;
@override List<String> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of KabkotaShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KabkotaShalatResponseDtoCopyWith<_KabkotaShalatResponseDto> get copyWith => __$KabkotaShalatResponseDtoCopyWithImpl<_KabkotaShalatResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KabkotaShalatResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KabkotaShalatResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'KabkotaShalatResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$KabkotaShalatResponseDtoCopyWith<$Res> implements $KabkotaShalatResponseDtoCopyWith<$Res> {
  factory _$KabkotaShalatResponseDtoCopyWith(_KabkotaShalatResponseDto value, $Res Function(_KabkotaShalatResponseDto) _then) = __$KabkotaShalatResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class __$KabkotaShalatResponseDtoCopyWithImpl<$Res>
    implements _$KabkotaShalatResponseDtoCopyWith<$Res> {
  __$KabkotaShalatResponseDtoCopyWithImpl(this._self, this._then);

  final _KabkotaShalatResponseDto _self;
  final $Res Function(_KabkotaShalatResponseDto) _then;

/// Create a copy of KabkotaShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_KabkotaShalatResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$JadwalShalatResponseDto {

 int get code; String get message; JadwalShalatDto get data;
/// Create a copy of JadwalShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadwalShalatResponseDtoCopyWith<JadwalShalatResponseDto> get copyWith => _$JadwalShalatResponseDtoCopyWithImpl<JadwalShalatResponseDto>(this as JadwalShalatResponseDto, _$identity);

  /// Serializes this JadwalShalatResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadwalShalatResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'JadwalShalatResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $JadwalShalatResponseDtoCopyWith<$Res>  {
  factory $JadwalShalatResponseDtoCopyWith(JadwalShalatResponseDto value, $Res Function(JadwalShalatResponseDto) _then) = _$JadwalShalatResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, JadwalShalatDto data
});


$JadwalShalatDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$JadwalShalatResponseDtoCopyWithImpl<$Res>
    implements $JadwalShalatResponseDtoCopyWith<$Res> {
  _$JadwalShalatResponseDtoCopyWithImpl(this._self, this._then);

  final JadwalShalatResponseDto _self;
  final $Res Function(JadwalShalatResponseDto) _then;

/// Create a copy of JadwalShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as JadwalShalatDto,
  ));
}
/// Create a copy of JadwalShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JadwalShalatDtoCopyWith<$Res> get data {
  
  return $JadwalShalatDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [JadwalShalatResponseDto].
extension JadwalShalatResponseDtoPatterns on JadwalShalatResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JadwalShalatResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JadwalShalatResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JadwalShalatResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JadwalShalatResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  JadwalShalatDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JadwalShalatResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  JadwalShalatDto data)  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatResponseDto():
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  JadwalShalatDto data)?  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JadwalShalatResponseDto implements JadwalShalatResponseDto {
  const _JadwalShalatResponseDto({required this.code, required this.message, required this.data});
  factory _JadwalShalatResponseDto.fromJson(Map<String, dynamic> json) => _$JadwalShalatResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
@override final  JadwalShalatDto data;

/// Create a copy of JadwalShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JadwalShalatResponseDtoCopyWith<_JadwalShalatResponseDto> get copyWith => __$JadwalShalatResponseDtoCopyWithImpl<_JadwalShalatResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JadwalShalatResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JadwalShalatResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'JadwalShalatResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$JadwalShalatResponseDtoCopyWith<$Res> implements $JadwalShalatResponseDtoCopyWith<$Res> {
  factory _$JadwalShalatResponseDtoCopyWith(_JadwalShalatResponseDto value, $Res Function(_JadwalShalatResponseDto) _then) = __$JadwalShalatResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, JadwalShalatDto data
});


@override $JadwalShalatDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$JadwalShalatResponseDtoCopyWithImpl<$Res>
    implements _$JadwalShalatResponseDtoCopyWith<$Res> {
  __$JadwalShalatResponseDtoCopyWithImpl(this._self, this._then);

  final _JadwalShalatResponseDto _self;
  final $Res Function(_JadwalShalatResponseDto) _then;

/// Create a copy of JadwalShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_JadwalShalatResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as JadwalShalatDto,
  ));
}

/// Create a copy of JadwalShalatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JadwalShalatDtoCopyWith<$Res> get data {
  
  return $JadwalShalatDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$JadwalShalatDto {

 String get provinsi; String get kabkota; int get bulan; int get tahun;@JsonKey(name: 'bulan_nama') String get bulanNama; List<JadwalShalatEntryDto> get jadwal;
/// Create a copy of JadwalShalatDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadwalShalatDtoCopyWith<JadwalShalatDto> get copyWith => _$JadwalShalatDtoCopyWithImpl<JadwalShalatDto>(this as JadwalShalatDto, _$identity);

  /// Serializes this JadwalShalatDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadwalShalatDto&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.bulan, bulan) || other.bulan == bulan)&&(identical(other.tahun, tahun) || other.tahun == tahun)&&(identical(other.bulanNama, bulanNama) || other.bulanNama == bulanNama)&&const DeepCollectionEquality().equals(other.jadwal, jadwal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,bulan,tahun,bulanNama,const DeepCollectionEquality().hash(jadwal));

@override
String toString() {
  return 'JadwalShalatDto(provinsi: $provinsi, kabkota: $kabkota, bulan: $bulan, tahun: $tahun, bulanNama: $bulanNama, jadwal: $jadwal)';
}


}

/// @nodoc
abstract mixin class $JadwalShalatDtoCopyWith<$Res>  {
  factory $JadwalShalatDtoCopyWith(JadwalShalatDto value, $Res Function(JadwalShalatDto) _then) = _$JadwalShalatDtoCopyWithImpl;
@useResult
$Res call({
 String provinsi, String kabkota, int bulan, int tahun,@JsonKey(name: 'bulan_nama') String bulanNama, List<JadwalShalatEntryDto> jadwal
});




}
/// @nodoc
class _$JadwalShalatDtoCopyWithImpl<$Res>
    implements $JadwalShalatDtoCopyWith<$Res> {
  _$JadwalShalatDtoCopyWithImpl(this._self, this._then);

  final JadwalShalatDto _self;
  final $Res Function(JadwalShalatDto) _then;

/// Create a copy of JadwalShalatDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provinsi = null,Object? kabkota = null,Object? bulan = null,Object? tahun = null,Object? bulanNama = null,Object? jadwal = null,}) {
  return _then(_self.copyWith(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,bulan: null == bulan ? _self.bulan : bulan // ignore: cast_nullable_to_non_nullable
as int,tahun: null == tahun ? _self.tahun : tahun // ignore: cast_nullable_to_non_nullable
as int,bulanNama: null == bulanNama ? _self.bulanNama : bulanNama // ignore: cast_nullable_to_non_nullable
as String,jadwal: null == jadwal ? _self.jadwal : jadwal // ignore: cast_nullable_to_non_nullable
as List<JadwalShalatEntryDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [JadwalShalatDto].
extension JadwalShalatDtoPatterns on JadwalShalatDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JadwalShalatDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JadwalShalatDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JadwalShalatDto value)  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JadwalShalatDto value)?  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  int bulan,  int tahun, @JsonKey(name: 'bulan_nama')  String bulanNama,  List<JadwalShalatEntryDto> jadwal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JadwalShalatDto() when $default != null:
return $default(_that.provinsi,_that.kabkota,_that.bulan,_that.tahun,_that.bulanNama,_that.jadwal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  int bulan,  int tahun, @JsonKey(name: 'bulan_nama')  String bulanNama,  List<JadwalShalatEntryDto> jadwal)  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatDto():
return $default(_that.provinsi,_that.kabkota,_that.bulan,_that.tahun,_that.bulanNama,_that.jadwal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provinsi,  String kabkota,  int bulan,  int tahun, @JsonKey(name: 'bulan_nama')  String bulanNama,  List<JadwalShalatEntryDto> jadwal)?  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatDto() when $default != null:
return $default(_that.provinsi,_that.kabkota,_that.bulan,_that.tahun,_that.bulanNama,_that.jadwal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JadwalShalatDto implements JadwalShalatDto {
  const _JadwalShalatDto({required this.provinsi, required this.kabkota, required this.bulan, required this.tahun, @JsonKey(name: 'bulan_nama') required this.bulanNama, required final  List<JadwalShalatEntryDto> jadwal}): _jadwal = jadwal;
  factory _JadwalShalatDto.fromJson(Map<String, dynamic> json) => _$JadwalShalatDtoFromJson(json);

@override final  String provinsi;
@override final  String kabkota;
@override final  int bulan;
@override final  int tahun;
@override@JsonKey(name: 'bulan_nama') final  String bulanNama;
 final  List<JadwalShalatEntryDto> _jadwal;
@override List<JadwalShalatEntryDto> get jadwal {
  if (_jadwal is EqualUnmodifiableListView) return _jadwal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jadwal);
}


/// Create a copy of JadwalShalatDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JadwalShalatDtoCopyWith<_JadwalShalatDto> get copyWith => __$JadwalShalatDtoCopyWithImpl<_JadwalShalatDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JadwalShalatDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JadwalShalatDto&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.bulan, bulan) || other.bulan == bulan)&&(identical(other.tahun, tahun) || other.tahun == tahun)&&(identical(other.bulanNama, bulanNama) || other.bulanNama == bulanNama)&&const DeepCollectionEquality().equals(other._jadwal, _jadwal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,bulan,tahun,bulanNama,const DeepCollectionEquality().hash(_jadwal));

@override
String toString() {
  return 'JadwalShalatDto(provinsi: $provinsi, kabkota: $kabkota, bulan: $bulan, tahun: $tahun, bulanNama: $bulanNama, jadwal: $jadwal)';
}


}

/// @nodoc
abstract mixin class _$JadwalShalatDtoCopyWith<$Res> implements $JadwalShalatDtoCopyWith<$Res> {
  factory _$JadwalShalatDtoCopyWith(_JadwalShalatDto value, $Res Function(_JadwalShalatDto) _then) = __$JadwalShalatDtoCopyWithImpl;
@override @useResult
$Res call({
 String provinsi, String kabkota, int bulan, int tahun,@JsonKey(name: 'bulan_nama') String bulanNama, List<JadwalShalatEntryDto> jadwal
});




}
/// @nodoc
class __$JadwalShalatDtoCopyWithImpl<$Res>
    implements _$JadwalShalatDtoCopyWith<$Res> {
  __$JadwalShalatDtoCopyWithImpl(this._self, this._then);

  final _JadwalShalatDto _self;
  final $Res Function(_JadwalShalatDto) _then;

/// Create a copy of JadwalShalatDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provinsi = null,Object? kabkota = null,Object? bulan = null,Object? tahun = null,Object? bulanNama = null,Object? jadwal = null,}) {
  return _then(_JadwalShalatDto(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,bulan: null == bulan ? _self.bulan : bulan // ignore: cast_nullable_to_non_nullable
as int,tahun: null == tahun ? _self.tahun : tahun // ignore: cast_nullable_to_non_nullable
as int,bulanNama: null == bulanNama ? _self.bulanNama : bulanNama // ignore: cast_nullable_to_non_nullable
as String,jadwal: null == jadwal ? _self._jadwal : jadwal // ignore: cast_nullable_to_non_nullable
as List<JadwalShalatEntryDto>,
  ));
}


}


/// @nodoc
mixin _$JadwalShalatEntryDto {

 int get tanggal;@JsonKey(name: 'tanggal_lengkap') String get tanggalLengkap; String get hari; String get imsak; String get subuh; String get terbit; String get dhuha; String get dzuhur; String get ashar; String get maghrib; String get isya;
/// Create a copy of JadwalShalatEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadwalShalatEntryDtoCopyWith<JadwalShalatEntryDto> get copyWith => _$JadwalShalatEntryDtoCopyWithImpl<JadwalShalatEntryDto>(this as JadwalShalatEntryDto, _$identity);

  /// Serializes this JadwalShalatEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadwalShalatEntryDto&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.tanggalLengkap, tanggalLengkap) || other.tanggalLengkap == tanggalLengkap)&&(identical(other.hari, hari) || other.hari == hari)&&(identical(other.imsak, imsak) || other.imsak == imsak)&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.terbit, terbit) || other.terbit == terbit)&&(identical(other.dhuha, dhuha) || other.dhuha == dhuha)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,tanggalLengkap,hari,imsak,subuh,terbit,dhuha,dzuhur,ashar,maghrib,isya);

@override
String toString() {
  return 'JadwalShalatEntryDto(tanggal: $tanggal, tanggalLengkap: $tanggalLengkap, hari: $hari, imsak: $imsak, subuh: $subuh, terbit: $terbit, dhuha: $dhuha, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya)';
}


}

/// @nodoc
abstract mixin class $JadwalShalatEntryDtoCopyWith<$Res>  {
  factory $JadwalShalatEntryDtoCopyWith(JadwalShalatEntryDto value, $Res Function(JadwalShalatEntryDto) _then) = _$JadwalShalatEntryDtoCopyWithImpl;
@useResult
$Res call({
 int tanggal,@JsonKey(name: 'tanggal_lengkap') String tanggalLengkap, String hari, String imsak, String subuh, String terbit, String dhuha, String dzuhur, String ashar, String maghrib, String isya
});




}
/// @nodoc
class _$JadwalShalatEntryDtoCopyWithImpl<$Res>
    implements $JadwalShalatEntryDtoCopyWith<$Res> {
  _$JadwalShalatEntryDtoCopyWithImpl(this._self, this._then);

  final JadwalShalatEntryDto _self;
  final $Res Function(JadwalShalatEntryDto) _then;

/// Create a copy of JadwalShalatEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tanggal = null,Object? tanggalLengkap = null,Object? hari = null,Object? imsak = null,Object? subuh = null,Object? terbit = null,Object? dhuha = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,}) {
  return _then(_self.copyWith(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as int,tanggalLengkap: null == tanggalLengkap ? _self.tanggalLengkap : tanggalLengkap // ignore: cast_nullable_to_non_nullable
as String,hari: null == hari ? _self.hari : hari // ignore: cast_nullable_to_non_nullable
as String,imsak: null == imsak ? _self.imsak : imsak // ignore: cast_nullable_to_non_nullable
as String,subuh: null == subuh ? _self.subuh : subuh // ignore: cast_nullable_to_non_nullable
as String,terbit: null == terbit ? _self.terbit : terbit // ignore: cast_nullable_to_non_nullable
as String,dhuha: null == dhuha ? _self.dhuha : dhuha // ignore: cast_nullable_to_non_nullable
as String,dzuhur: null == dzuhur ? _self.dzuhur : dzuhur // ignore: cast_nullable_to_non_nullable
as String,ashar: null == ashar ? _self.ashar : ashar // ignore: cast_nullable_to_non_nullable
as String,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as String,isya: null == isya ? _self.isya : isya // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JadwalShalatEntryDto].
extension JadwalShalatEntryDtoPatterns on JadwalShalatEntryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JadwalShalatEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JadwalShalatEntryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JadwalShalatEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatEntryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JadwalShalatEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatEntryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tanggal, @JsonKey(name: 'tanggal_lengkap')  String tanggalLengkap,  String hari,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JadwalShalatEntryDto() when $default != null:
return $default(_that.tanggal,_that.tanggalLengkap,_that.hari,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tanggal, @JsonKey(name: 'tanggal_lengkap')  String tanggalLengkap,  String hari,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatEntryDto():
return $default(_that.tanggal,_that.tanggalLengkap,_that.hari,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tanggal, @JsonKey(name: 'tanggal_lengkap')  String tanggalLengkap,  String hari,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)?  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatEntryDto() when $default != null:
return $default(_that.tanggal,_that.tanggalLengkap,_that.hari,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JadwalShalatEntryDto implements JadwalShalatEntryDto {
  const _JadwalShalatEntryDto({required this.tanggal, @JsonKey(name: 'tanggal_lengkap') required this.tanggalLengkap, required this.hari, required this.imsak, required this.subuh, required this.terbit, required this.dhuha, required this.dzuhur, required this.ashar, required this.maghrib, required this.isya});
  factory _JadwalShalatEntryDto.fromJson(Map<String, dynamic> json) => _$JadwalShalatEntryDtoFromJson(json);

@override final  int tanggal;
@override@JsonKey(name: 'tanggal_lengkap') final  String tanggalLengkap;
@override final  String hari;
@override final  String imsak;
@override final  String subuh;
@override final  String terbit;
@override final  String dhuha;
@override final  String dzuhur;
@override final  String ashar;
@override final  String maghrib;
@override final  String isya;

/// Create a copy of JadwalShalatEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JadwalShalatEntryDtoCopyWith<_JadwalShalatEntryDto> get copyWith => __$JadwalShalatEntryDtoCopyWithImpl<_JadwalShalatEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JadwalShalatEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JadwalShalatEntryDto&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.tanggalLengkap, tanggalLengkap) || other.tanggalLengkap == tanggalLengkap)&&(identical(other.hari, hari) || other.hari == hari)&&(identical(other.imsak, imsak) || other.imsak == imsak)&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.terbit, terbit) || other.terbit == terbit)&&(identical(other.dhuha, dhuha) || other.dhuha == dhuha)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,tanggalLengkap,hari,imsak,subuh,terbit,dhuha,dzuhur,ashar,maghrib,isya);

@override
String toString() {
  return 'JadwalShalatEntryDto(tanggal: $tanggal, tanggalLengkap: $tanggalLengkap, hari: $hari, imsak: $imsak, subuh: $subuh, terbit: $terbit, dhuha: $dhuha, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya)';
}


}

/// @nodoc
abstract mixin class _$JadwalShalatEntryDtoCopyWith<$Res> implements $JadwalShalatEntryDtoCopyWith<$Res> {
  factory _$JadwalShalatEntryDtoCopyWith(_JadwalShalatEntryDto value, $Res Function(_JadwalShalatEntryDto) _then) = __$JadwalShalatEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 int tanggal,@JsonKey(name: 'tanggal_lengkap') String tanggalLengkap, String hari, String imsak, String subuh, String terbit, String dhuha, String dzuhur, String ashar, String maghrib, String isya
});




}
/// @nodoc
class __$JadwalShalatEntryDtoCopyWithImpl<$Res>
    implements _$JadwalShalatEntryDtoCopyWith<$Res> {
  __$JadwalShalatEntryDtoCopyWithImpl(this._self, this._then);

  final _JadwalShalatEntryDto _self;
  final $Res Function(_JadwalShalatEntryDto) _then;

/// Create a copy of JadwalShalatEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tanggal = null,Object? tanggalLengkap = null,Object? hari = null,Object? imsak = null,Object? subuh = null,Object? terbit = null,Object? dhuha = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,}) {
  return _then(_JadwalShalatEntryDto(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as int,tanggalLengkap: null == tanggalLengkap ? _self.tanggalLengkap : tanggalLengkap // ignore: cast_nullable_to_non_nullable
as String,hari: null == hari ? _self.hari : hari // ignore: cast_nullable_to_non_nullable
as String,imsak: null == imsak ? _self.imsak : imsak // ignore: cast_nullable_to_non_nullable
as String,subuh: null == subuh ? _self.subuh : subuh // ignore: cast_nullable_to_non_nullable
as String,terbit: null == terbit ? _self.terbit : terbit // ignore: cast_nullable_to_non_nullable
as String,dhuha: null == dhuha ? _self.dhuha : dhuha // ignore: cast_nullable_to_non_nullable
as String,dzuhur: null == dzuhur ? _self.dzuhur : dzuhur // ignore: cast_nullable_to_non_nullable
as String,ashar: null == ashar ? _self.ashar : ashar // ignore: cast_nullable_to_non_nullable
as String,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as String,isya: null == isya ? _self.isya : isya // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
