// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SuratListResponseDto {

 int get code; String get message; List<SuratDto> get data;
/// Create a copy of SuratListResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratListResponseDtoCopyWith<SuratListResponseDto> get copyWith => _$SuratListResponseDtoCopyWithImpl<SuratListResponseDto>(this as SuratListResponseDto, _$identity);

  /// Serializes this SuratListResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratListResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'SuratListResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $SuratListResponseDtoCopyWith<$Res>  {
  factory $SuratListResponseDtoCopyWith(SuratListResponseDto value, $Res Function(SuratListResponseDto) _then) = _$SuratListResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, List<SuratDto> data
});




}
/// @nodoc
class _$SuratListResponseDtoCopyWithImpl<$Res>
    implements $SuratListResponseDtoCopyWith<$Res> {
  _$SuratListResponseDtoCopyWithImpl(this._self, this._then);

  final SuratListResponseDto _self;
  final $Res Function(SuratListResponseDto) _then;

/// Create a copy of SuratListResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<SuratDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SuratListResponseDto].
extension SuratListResponseDtoPatterns on SuratListResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratListResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratListResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratListResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SuratListResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratListResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SuratListResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  List<SuratDto> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratListResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  List<SuratDto> data)  $default,) {final _that = this;
switch (_that) {
case _SuratListResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  List<SuratDto> data)?  $default,) {final _that = this;
switch (_that) {
case _SuratListResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuratListResponseDto implements SuratListResponseDto {
  const _SuratListResponseDto({required this.code, required this.message, required final  List<SuratDto> data}): _data = data;
  factory _SuratListResponseDto.fromJson(Map<String, dynamic> json) => _$SuratListResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
 final  List<SuratDto> _data;
@override List<SuratDto> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of SuratListResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratListResponseDtoCopyWith<_SuratListResponseDto> get copyWith => __$SuratListResponseDtoCopyWithImpl<_SuratListResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuratListResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratListResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'SuratListResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SuratListResponseDtoCopyWith<$Res> implements $SuratListResponseDtoCopyWith<$Res> {
  factory _$SuratListResponseDtoCopyWith(_SuratListResponseDto value, $Res Function(_SuratListResponseDto) _then) = __$SuratListResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, List<SuratDto> data
});




}
/// @nodoc
class __$SuratListResponseDtoCopyWithImpl<$Res>
    implements _$SuratListResponseDtoCopyWith<$Res> {
  __$SuratListResponseDtoCopyWithImpl(this._self, this._then);

  final _SuratListResponseDto _self;
  final $Res Function(_SuratListResponseDto) _then;

/// Create a copy of SuratListResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_SuratListResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<SuratDto>,
  ));
}


}


/// @nodoc
mixin _$SuratDto {

 int get nomor; String get nama;@JsonKey(name: 'namaLatin') String get namaLatin;@JsonKey(name: 'jumlahAyat') int get jumlahAyat;@JsonKey(name: 'tempatTurun') String get tempatTurun; String get arti;
/// Create a copy of SuratDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratDtoCopyWith<SuratDto> get copyWith => _$SuratDtoCopyWithImpl<SuratDto>(this as SuratDto, _$identity);

  /// Serializes this SuratDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti);

@override
String toString() {
  return 'SuratDto(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti)';
}


}

/// @nodoc
abstract mixin class $SuratDtoCopyWith<$Res>  {
  factory $SuratDtoCopyWith(SuratDto value, $Res Function(SuratDto) _then) = _$SuratDtoCopyWithImpl;
@useResult
$Res call({
 int nomor, String nama,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat,@JsonKey(name: 'tempatTurun') String tempatTurun, String arti
});




}
/// @nodoc
class _$SuratDtoCopyWithImpl<$Res>
    implements $SuratDtoCopyWith<$Res> {
  _$SuratDtoCopyWithImpl(this._self, this._then);

  final SuratDto _self;
  final $Res Function(SuratDto) _then;

/// Create a copy of SuratDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,}) {
  return _then(_self.copyWith(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as String,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SuratDto].
extension SuratDtoPatterns on SuratDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratDto value)  $default,){
final _that = this;
switch (_that) {
case _SuratDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratDto value)?  $default,){
final _that = this;
switch (_that) {
case _SuratDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratDto() when $default != null:
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti)  $default,) {final _that = this;
switch (_that) {
case _SuratDto():
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti)?  $default,) {final _that = this;
switch (_that) {
case _SuratDto() when $default != null:
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuratDto implements SuratDto {
  const _SuratDto({required this.nomor, required this.nama, @JsonKey(name: 'namaLatin') required this.namaLatin, @JsonKey(name: 'jumlahAyat') required this.jumlahAyat, @JsonKey(name: 'tempatTurun') required this.tempatTurun, required this.arti});
  factory _SuratDto.fromJson(Map<String, dynamic> json) => _$SuratDtoFromJson(json);

@override final  int nomor;
@override final  String nama;
@override@JsonKey(name: 'namaLatin') final  String namaLatin;
@override@JsonKey(name: 'jumlahAyat') final  int jumlahAyat;
@override@JsonKey(name: 'tempatTurun') final  String tempatTurun;
@override final  String arti;

/// Create a copy of SuratDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratDtoCopyWith<_SuratDto> get copyWith => __$SuratDtoCopyWithImpl<_SuratDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuratDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti);

@override
String toString() {
  return 'SuratDto(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti)';
}


}

/// @nodoc
abstract mixin class _$SuratDtoCopyWith<$Res> implements $SuratDtoCopyWith<$Res> {
  factory _$SuratDtoCopyWith(_SuratDto value, $Res Function(_SuratDto) _then) = __$SuratDtoCopyWithImpl;
@override @useResult
$Res call({
 int nomor, String nama,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat,@JsonKey(name: 'tempatTurun') String tempatTurun, String arti
});




}
/// @nodoc
class __$SuratDtoCopyWithImpl<$Res>
    implements _$SuratDtoCopyWith<$Res> {
  __$SuratDtoCopyWithImpl(this._self, this._then);

  final _SuratDto _self;
  final $Res Function(_SuratDto) _then;

/// Create a copy of SuratDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,}) {
  return _then(_SuratDto(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as String,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
