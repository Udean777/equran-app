// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imsakiyah_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProvinsiResponseDto {

 int get code; String get message; List<String> get data;
/// Create a copy of ProvinsiResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvinsiResponseDtoCopyWith<ProvinsiResponseDto> get copyWith => _$ProvinsiResponseDtoCopyWithImpl<ProvinsiResponseDto>(this as ProvinsiResponseDto, _$identity);

  /// Serializes this ProvinsiResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvinsiResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ProvinsiResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $ProvinsiResponseDtoCopyWith<$Res>  {
  factory $ProvinsiResponseDtoCopyWith(ProvinsiResponseDto value, $Res Function(ProvinsiResponseDto) _then) = _$ProvinsiResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class _$ProvinsiResponseDtoCopyWithImpl<$Res>
    implements $ProvinsiResponseDtoCopyWith<$Res> {
  _$ProvinsiResponseDtoCopyWithImpl(this._self, this._then);

  final ProvinsiResponseDto _self;
  final $Res Function(ProvinsiResponseDto) _then;

/// Create a copy of ProvinsiResponseDto
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


/// Adds pattern-matching-related methods to [ProvinsiResponseDto].
extension ProvinsiResponseDtoPatterns on ProvinsiResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProvinsiResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProvinsiResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProvinsiResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ProvinsiResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProvinsiResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProvinsiResponseDto() when $default != null:
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
case _ProvinsiResponseDto() when $default != null:
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
case _ProvinsiResponseDto():
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
case _ProvinsiResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProvinsiResponseDto implements ProvinsiResponseDto {
  const _ProvinsiResponseDto({required this.code, required this.message, required final  List<String> data}): _data = data;
  factory _ProvinsiResponseDto.fromJson(Map<String, dynamic> json) => _$ProvinsiResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
 final  List<String> _data;
@override List<String> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of ProvinsiResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProvinsiResponseDtoCopyWith<_ProvinsiResponseDto> get copyWith => __$ProvinsiResponseDtoCopyWithImpl<_ProvinsiResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProvinsiResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProvinsiResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ProvinsiResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ProvinsiResponseDtoCopyWith<$Res> implements $ProvinsiResponseDtoCopyWith<$Res> {
  factory _$ProvinsiResponseDtoCopyWith(_ProvinsiResponseDto value, $Res Function(_ProvinsiResponseDto) _then) = __$ProvinsiResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class __$ProvinsiResponseDtoCopyWithImpl<$Res>
    implements _$ProvinsiResponseDtoCopyWith<$Res> {
  __$ProvinsiResponseDtoCopyWithImpl(this._self, this._then);

  final _ProvinsiResponseDto _self;
  final $Res Function(_ProvinsiResponseDto) _then;

/// Create a copy of ProvinsiResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_ProvinsiResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$KabkotaResponseDto {

 int get code; String get message; List<String> get data;
/// Create a copy of KabkotaResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KabkotaResponseDtoCopyWith<KabkotaResponseDto> get copyWith => _$KabkotaResponseDtoCopyWithImpl<KabkotaResponseDto>(this as KabkotaResponseDto, _$identity);

  /// Serializes this KabkotaResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KabkotaResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'KabkotaResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $KabkotaResponseDtoCopyWith<$Res>  {
  factory $KabkotaResponseDtoCopyWith(KabkotaResponseDto value, $Res Function(KabkotaResponseDto) _then) = _$KabkotaResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class _$KabkotaResponseDtoCopyWithImpl<$Res>
    implements $KabkotaResponseDtoCopyWith<$Res> {
  _$KabkotaResponseDtoCopyWithImpl(this._self, this._then);

  final KabkotaResponseDto _self;
  final $Res Function(KabkotaResponseDto) _then;

/// Create a copy of KabkotaResponseDto
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


/// Adds pattern-matching-related methods to [KabkotaResponseDto].
extension KabkotaResponseDtoPatterns on KabkotaResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KabkotaResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KabkotaResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KabkotaResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _KabkotaResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KabkotaResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _KabkotaResponseDto() when $default != null:
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
case _KabkotaResponseDto() when $default != null:
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
case _KabkotaResponseDto():
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
case _KabkotaResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KabkotaResponseDto implements KabkotaResponseDto {
  const _KabkotaResponseDto({required this.code, required this.message, required final  List<String> data}): _data = data;
  factory _KabkotaResponseDto.fromJson(Map<String, dynamic> json) => _$KabkotaResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
 final  List<String> _data;
@override List<String> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of KabkotaResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KabkotaResponseDtoCopyWith<_KabkotaResponseDto> get copyWith => __$KabkotaResponseDtoCopyWithImpl<_KabkotaResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KabkotaResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KabkotaResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'KabkotaResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$KabkotaResponseDtoCopyWith<$Res> implements $KabkotaResponseDtoCopyWith<$Res> {
  factory _$KabkotaResponseDtoCopyWith(_KabkotaResponseDto value, $Res Function(_KabkotaResponseDto) _then) = __$KabkotaResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, List<String> data
});




}
/// @nodoc
class __$KabkotaResponseDtoCopyWithImpl<$Res>
    implements _$KabkotaResponseDtoCopyWith<$Res> {
  __$KabkotaResponseDtoCopyWithImpl(this._self, this._then);

  final _KabkotaResponseDto _self;
  final $Res Function(_KabkotaResponseDto) _then;

/// Create a copy of KabkotaResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_KabkotaResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ImsakiyahResponseDto {

 int get code; String get message; ImsakiyahDto get data;
/// Create a copy of ImsakiyahResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImsakiyahResponseDtoCopyWith<ImsakiyahResponseDto> get copyWith => _$ImsakiyahResponseDtoCopyWithImpl<ImsakiyahResponseDto>(this as ImsakiyahResponseDto, _$identity);

  /// Serializes this ImsakiyahResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImsakiyahResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'ImsakiyahResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $ImsakiyahResponseDtoCopyWith<$Res>  {
  factory $ImsakiyahResponseDtoCopyWith(ImsakiyahResponseDto value, $Res Function(ImsakiyahResponseDto) _then) = _$ImsakiyahResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, ImsakiyahDto data
});


$ImsakiyahDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$ImsakiyahResponseDtoCopyWithImpl<$Res>
    implements $ImsakiyahResponseDtoCopyWith<$Res> {
  _$ImsakiyahResponseDtoCopyWithImpl(this._self, this._then);

  final ImsakiyahResponseDto _self;
  final $Res Function(ImsakiyahResponseDto) _then;

/// Create a copy of ImsakiyahResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ImsakiyahDto,
  ));
}
/// Create a copy of ImsakiyahResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImsakiyahDtoCopyWith<$Res> get data {
  
  return $ImsakiyahDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImsakiyahResponseDto].
extension ImsakiyahResponseDtoPatterns on ImsakiyahResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImsakiyahResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImsakiyahResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImsakiyahResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ImsakiyahResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImsakiyahResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ImsakiyahResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  ImsakiyahDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImsakiyahResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  ImsakiyahDto data)  $default,) {final _that = this;
switch (_that) {
case _ImsakiyahResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  ImsakiyahDto data)?  $default,) {final _that = this;
switch (_that) {
case _ImsakiyahResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImsakiyahResponseDto implements ImsakiyahResponseDto {
  const _ImsakiyahResponseDto({required this.code, required this.message, required this.data});
  factory _ImsakiyahResponseDto.fromJson(Map<String, dynamic> json) => _$ImsakiyahResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
@override final  ImsakiyahDto data;

/// Create a copy of ImsakiyahResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImsakiyahResponseDtoCopyWith<_ImsakiyahResponseDto> get copyWith => __$ImsakiyahResponseDtoCopyWithImpl<_ImsakiyahResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImsakiyahResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImsakiyahResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'ImsakiyahResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ImsakiyahResponseDtoCopyWith<$Res> implements $ImsakiyahResponseDtoCopyWith<$Res> {
  factory _$ImsakiyahResponseDtoCopyWith(_ImsakiyahResponseDto value, $Res Function(_ImsakiyahResponseDto) _then) = __$ImsakiyahResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, ImsakiyahDto data
});


@override $ImsakiyahDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$ImsakiyahResponseDtoCopyWithImpl<$Res>
    implements _$ImsakiyahResponseDtoCopyWith<$Res> {
  __$ImsakiyahResponseDtoCopyWithImpl(this._self, this._then);

  final _ImsakiyahResponseDto _self;
  final $Res Function(_ImsakiyahResponseDto) _then;

/// Create a copy of ImsakiyahResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_ImsakiyahResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ImsakiyahDto,
  ));
}

/// Create a copy of ImsakiyahResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImsakiyahDtoCopyWith<$Res> get data {
  
  return $ImsakiyahDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ImsakiyahDto {

 String get provinsi; String get kabkota; String get hijriah; String get masehi; List<ImsakiyahEntryDto> get imsakiyah;
/// Create a copy of ImsakiyahDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImsakiyahDtoCopyWith<ImsakiyahDto> get copyWith => _$ImsakiyahDtoCopyWithImpl<ImsakiyahDto>(this as ImsakiyahDto, _$identity);

  /// Serializes this ImsakiyahDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImsakiyahDto&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.hijriah, hijriah) || other.hijriah == hijriah)&&(identical(other.masehi, masehi) || other.masehi == masehi)&&const DeepCollectionEquality().equals(other.imsakiyah, imsakiyah));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,hijriah,masehi,const DeepCollectionEquality().hash(imsakiyah));

@override
String toString() {
  return 'ImsakiyahDto(provinsi: $provinsi, kabkota: $kabkota, hijriah: $hijriah, masehi: $masehi, imsakiyah: $imsakiyah)';
}


}

/// @nodoc
abstract mixin class $ImsakiyahDtoCopyWith<$Res>  {
  factory $ImsakiyahDtoCopyWith(ImsakiyahDto value, $Res Function(ImsakiyahDto) _then) = _$ImsakiyahDtoCopyWithImpl;
@useResult
$Res call({
 String provinsi, String kabkota, String hijriah, String masehi, List<ImsakiyahEntryDto> imsakiyah
});




}
/// @nodoc
class _$ImsakiyahDtoCopyWithImpl<$Res>
    implements $ImsakiyahDtoCopyWith<$Res> {
  _$ImsakiyahDtoCopyWithImpl(this._self, this._then);

  final ImsakiyahDto _self;
  final $Res Function(ImsakiyahDto) _then;

/// Create a copy of ImsakiyahDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provinsi = null,Object? kabkota = null,Object? hijriah = null,Object? masehi = null,Object? imsakiyah = null,}) {
  return _then(_self.copyWith(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,hijriah: null == hijriah ? _self.hijriah : hijriah // ignore: cast_nullable_to_non_nullable
as String,masehi: null == masehi ? _self.masehi : masehi // ignore: cast_nullable_to_non_nullable
as String,imsakiyah: null == imsakiyah ? _self.imsakiyah : imsakiyah // ignore: cast_nullable_to_non_nullable
as List<ImsakiyahEntryDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImsakiyahDto].
extension ImsakiyahDtoPatterns on ImsakiyahDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImsakiyahDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImsakiyahDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImsakiyahDto value)  $default,){
final _that = this;
switch (_that) {
case _ImsakiyahDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImsakiyahDto value)?  $default,){
final _that = this;
switch (_that) {
case _ImsakiyahDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  String hijriah,  String masehi,  List<ImsakiyahEntryDto> imsakiyah)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImsakiyahDto() when $default != null:
return $default(_that.provinsi,_that.kabkota,_that.hijriah,_that.masehi,_that.imsakiyah);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  String hijriah,  String masehi,  List<ImsakiyahEntryDto> imsakiyah)  $default,) {final _that = this;
switch (_that) {
case _ImsakiyahDto():
return $default(_that.provinsi,_that.kabkota,_that.hijriah,_that.masehi,_that.imsakiyah);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provinsi,  String kabkota,  String hijriah,  String masehi,  List<ImsakiyahEntryDto> imsakiyah)?  $default,) {final _that = this;
switch (_that) {
case _ImsakiyahDto() when $default != null:
return $default(_that.provinsi,_that.kabkota,_that.hijriah,_that.masehi,_that.imsakiyah);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImsakiyahDto implements ImsakiyahDto {
  const _ImsakiyahDto({required this.provinsi, required this.kabkota, required this.hijriah, required this.masehi, required final  List<ImsakiyahEntryDto> imsakiyah}): _imsakiyah = imsakiyah;
  factory _ImsakiyahDto.fromJson(Map<String, dynamic> json) => _$ImsakiyahDtoFromJson(json);

@override final  String provinsi;
@override final  String kabkota;
@override final  String hijriah;
@override final  String masehi;
 final  List<ImsakiyahEntryDto> _imsakiyah;
@override List<ImsakiyahEntryDto> get imsakiyah {
  if (_imsakiyah is EqualUnmodifiableListView) return _imsakiyah;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imsakiyah);
}


/// Create a copy of ImsakiyahDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImsakiyahDtoCopyWith<_ImsakiyahDto> get copyWith => __$ImsakiyahDtoCopyWithImpl<_ImsakiyahDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImsakiyahDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImsakiyahDto&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.hijriah, hijriah) || other.hijriah == hijriah)&&(identical(other.masehi, masehi) || other.masehi == masehi)&&const DeepCollectionEquality().equals(other._imsakiyah, _imsakiyah));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,hijriah,masehi,const DeepCollectionEquality().hash(_imsakiyah));

@override
String toString() {
  return 'ImsakiyahDto(provinsi: $provinsi, kabkota: $kabkota, hijriah: $hijriah, masehi: $masehi, imsakiyah: $imsakiyah)';
}


}

/// @nodoc
abstract mixin class _$ImsakiyahDtoCopyWith<$Res> implements $ImsakiyahDtoCopyWith<$Res> {
  factory _$ImsakiyahDtoCopyWith(_ImsakiyahDto value, $Res Function(_ImsakiyahDto) _then) = __$ImsakiyahDtoCopyWithImpl;
@override @useResult
$Res call({
 String provinsi, String kabkota, String hijriah, String masehi, List<ImsakiyahEntryDto> imsakiyah
});




}
/// @nodoc
class __$ImsakiyahDtoCopyWithImpl<$Res>
    implements _$ImsakiyahDtoCopyWith<$Res> {
  __$ImsakiyahDtoCopyWithImpl(this._self, this._then);

  final _ImsakiyahDto _self;
  final $Res Function(_ImsakiyahDto) _then;

/// Create a copy of ImsakiyahDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provinsi = null,Object? kabkota = null,Object? hijriah = null,Object? masehi = null,Object? imsakiyah = null,}) {
  return _then(_ImsakiyahDto(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,hijriah: null == hijriah ? _self.hijriah : hijriah // ignore: cast_nullable_to_non_nullable
as String,masehi: null == masehi ? _self.masehi : masehi // ignore: cast_nullable_to_non_nullable
as String,imsakiyah: null == imsakiyah ? _self._imsakiyah : imsakiyah // ignore: cast_nullable_to_non_nullable
as List<ImsakiyahEntryDto>,
  ));
}


}


/// @nodoc
mixin _$ImsakiyahEntryDto {

 int get tanggal; String get imsak; String get subuh; String get terbit; String get dhuha; String get dzuhur; String get ashar; String get maghrib; String get isya;
/// Create a copy of ImsakiyahEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImsakiyahEntryDtoCopyWith<ImsakiyahEntryDto> get copyWith => _$ImsakiyahEntryDtoCopyWithImpl<ImsakiyahEntryDto>(this as ImsakiyahEntryDto, _$identity);

  /// Serializes this ImsakiyahEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImsakiyahEntryDto&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.imsak, imsak) || other.imsak == imsak)&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.terbit, terbit) || other.terbit == terbit)&&(identical(other.dhuha, dhuha) || other.dhuha == dhuha)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,imsak,subuh,terbit,dhuha,dzuhur,ashar,maghrib,isya);

@override
String toString() {
  return 'ImsakiyahEntryDto(tanggal: $tanggal, imsak: $imsak, subuh: $subuh, terbit: $terbit, dhuha: $dhuha, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya)';
}


}

/// @nodoc
abstract mixin class $ImsakiyahEntryDtoCopyWith<$Res>  {
  factory $ImsakiyahEntryDtoCopyWith(ImsakiyahEntryDto value, $Res Function(ImsakiyahEntryDto) _then) = _$ImsakiyahEntryDtoCopyWithImpl;
@useResult
$Res call({
 int tanggal, String imsak, String subuh, String terbit, String dhuha, String dzuhur, String ashar, String maghrib, String isya
});




}
/// @nodoc
class _$ImsakiyahEntryDtoCopyWithImpl<$Res>
    implements $ImsakiyahEntryDtoCopyWith<$Res> {
  _$ImsakiyahEntryDtoCopyWithImpl(this._self, this._then);

  final ImsakiyahEntryDto _self;
  final $Res Function(ImsakiyahEntryDto) _then;

/// Create a copy of ImsakiyahEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tanggal = null,Object? imsak = null,Object? subuh = null,Object? terbit = null,Object? dhuha = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,}) {
  return _then(_self.copyWith(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as int,imsak: null == imsak ? _self.imsak : imsak // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [ImsakiyahEntryDto].
extension ImsakiyahEntryDtoPatterns on ImsakiyahEntryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImsakiyahEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImsakiyahEntryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImsakiyahEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _ImsakiyahEntryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImsakiyahEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _ImsakiyahEntryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tanggal,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImsakiyahEntryDto() when $default != null:
return $default(_that.tanggal,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tanggal,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)  $default,) {final _that = this;
switch (_that) {
case _ImsakiyahEntryDto():
return $default(_that.tanggal,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tanggal,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)?  $default,) {final _that = this;
switch (_that) {
case _ImsakiyahEntryDto() when $default != null:
return $default(_that.tanggal,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImsakiyahEntryDto implements ImsakiyahEntryDto {
  const _ImsakiyahEntryDto({required this.tanggal, required this.imsak, required this.subuh, required this.terbit, required this.dhuha, required this.dzuhur, required this.ashar, required this.maghrib, required this.isya});
  factory _ImsakiyahEntryDto.fromJson(Map<String, dynamic> json) => _$ImsakiyahEntryDtoFromJson(json);

@override final  int tanggal;
@override final  String imsak;
@override final  String subuh;
@override final  String terbit;
@override final  String dhuha;
@override final  String dzuhur;
@override final  String ashar;
@override final  String maghrib;
@override final  String isya;

/// Create a copy of ImsakiyahEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImsakiyahEntryDtoCopyWith<_ImsakiyahEntryDto> get copyWith => __$ImsakiyahEntryDtoCopyWithImpl<_ImsakiyahEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImsakiyahEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImsakiyahEntryDto&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.imsak, imsak) || other.imsak == imsak)&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.terbit, terbit) || other.terbit == terbit)&&(identical(other.dhuha, dhuha) || other.dhuha == dhuha)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,imsak,subuh,terbit,dhuha,dzuhur,ashar,maghrib,isya);

@override
String toString() {
  return 'ImsakiyahEntryDto(tanggal: $tanggal, imsak: $imsak, subuh: $subuh, terbit: $terbit, dhuha: $dhuha, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya)';
}


}

/// @nodoc
abstract mixin class _$ImsakiyahEntryDtoCopyWith<$Res> implements $ImsakiyahEntryDtoCopyWith<$Res> {
  factory _$ImsakiyahEntryDtoCopyWith(_ImsakiyahEntryDto value, $Res Function(_ImsakiyahEntryDto) _then) = __$ImsakiyahEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 int tanggal, String imsak, String subuh, String terbit, String dhuha, String dzuhur, String ashar, String maghrib, String isya
});




}
/// @nodoc
class __$ImsakiyahEntryDtoCopyWithImpl<$Res>
    implements _$ImsakiyahEntryDtoCopyWith<$Res> {
  __$ImsakiyahEntryDtoCopyWithImpl(this._self, this._then);

  final _ImsakiyahEntryDto _self;
  final $Res Function(_ImsakiyahEntryDto) _then;

/// Create a copy of ImsakiyahEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tanggal = null,Object? imsak = null,Object? subuh = null,Object? terbit = null,Object? dhuha = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,}) {
  return _then(_ImsakiyahEntryDto(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as int,imsak: null == imsak ? _self.imsak : imsak // ignore: cast_nullable_to_non_nullable
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
