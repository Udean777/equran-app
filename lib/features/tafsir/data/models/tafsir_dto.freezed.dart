// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tafsir_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TafsirResponseDto {

 int get code; String get message; TafsirDataDto get data;
/// Create a copy of TafsirResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafsirResponseDtoCopyWith<TafsirResponseDto> get copyWith => _$TafsirResponseDtoCopyWithImpl<TafsirResponseDto>(this as TafsirResponseDto, _$identity);

  /// Serializes this TafsirResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'TafsirResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $TafsirResponseDtoCopyWith<$Res>  {
  factory $TafsirResponseDtoCopyWith(TafsirResponseDto value, $Res Function(TafsirResponseDto) _then) = _$TafsirResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, TafsirDataDto data
});


$TafsirDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$TafsirResponseDtoCopyWithImpl<$Res>
    implements $TafsirResponseDtoCopyWith<$Res> {
  _$TafsirResponseDtoCopyWithImpl(this._self, this._then);

  final TafsirResponseDto _self;
  final $Res Function(TafsirResponseDto) _then;

/// Create a copy of TafsirResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TafsirDataDto,
  ));
}
/// Create a copy of TafsirResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TafsirDataDtoCopyWith<$Res> get data {
  
  return $TafsirDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TafsirResponseDto].
extension TafsirResponseDtoPatterns on TafsirResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TafsirResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TafsirResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TafsirResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _TafsirResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TafsirResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _TafsirResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  TafsirDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TafsirResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  TafsirDataDto data)  $default,) {final _that = this;
switch (_that) {
case _TafsirResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  TafsirDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _TafsirResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TafsirResponseDto implements TafsirResponseDto {
  const _TafsirResponseDto({required this.code, required this.message, required this.data});
  factory _TafsirResponseDto.fromJson(Map<String, dynamic> json) => _$TafsirResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
@override final  TafsirDataDto data;

/// Create a copy of TafsirResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TafsirResponseDtoCopyWith<_TafsirResponseDto> get copyWith => __$TafsirResponseDtoCopyWithImpl<_TafsirResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TafsirResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TafsirResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'TafsirResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TafsirResponseDtoCopyWith<$Res> implements $TafsirResponseDtoCopyWith<$Res> {
  factory _$TafsirResponseDtoCopyWith(_TafsirResponseDto value, $Res Function(_TafsirResponseDto) _then) = __$TafsirResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, TafsirDataDto data
});


@override $TafsirDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$TafsirResponseDtoCopyWithImpl<$Res>
    implements _$TafsirResponseDtoCopyWith<$Res> {
  __$TafsirResponseDtoCopyWithImpl(this._self, this._then);

  final _TafsirResponseDto _self;
  final $Res Function(_TafsirResponseDto) _then;

/// Create a copy of TafsirResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_TafsirResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TafsirDataDto,
  ));
}

/// Create a copy of TafsirResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TafsirDataDtoCopyWith<$Res> get data {
  
  return $TafsirDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$TafsirDataDto {

 int get nomor; String get nama;@JsonKey(name: 'namaLatin') String get namaLatin;@JsonKey(name: 'jumlahAyat') int get jumlahAyat;@JsonKey(name: 'tempatTurun') String get tempatTurun; String get arti; List<TafsirAyatDto> get tafsir;
/// Create a copy of TafsirDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafsirDataDtoCopyWith<TafsirDataDto> get copyWith => _$TafsirDataDtoCopyWithImpl<TafsirDataDto>(this as TafsirDataDto, _$identity);

  /// Serializes this TafsirDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirDataDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti)&&const DeepCollectionEquality().equals(other.tafsir, tafsir));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti,const DeepCollectionEquality().hash(tafsir));

@override
String toString() {
  return 'TafsirDataDto(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti, tafsir: $tafsir)';
}


}

/// @nodoc
abstract mixin class $TafsirDataDtoCopyWith<$Res>  {
  factory $TafsirDataDtoCopyWith(TafsirDataDto value, $Res Function(TafsirDataDto) _then) = _$TafsirDataDtoCopyWithImpl;
@useResult
$Res call({
 int nomor, String nama,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat,@JsonKey(name: 'tempatTurun') String tempatTurun, String arti, List<TafsirAyatDto> tafsir
});




}
/// @nodoc
class _$TafsirDataDtoCopyWithImpl<$Res>
    implements $TafsirDataDtoCopyWith<$Res> {
  _$TafsirDataDtoCopyWithImpl(this._self, this._then);

  final TafsirDataDto _self;
  final $Res Function(TafsirDataDto) _then;

/// Create a copy of TafsirDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,Object? tafsir = null,}) {
  return _then(_self.copyWith(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as String,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,tafsir: null == tafsir ? _self.tafsir : tafsir // ignore: cast_nullable_to_non_nullable
as List<TafsirAyatDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [TafsirDataDto].
extension TafsirDataDtoPatterns on TafsirDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TafsirDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TafsirDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TafsirDataDto value)  $default,){
final _that = this;
switch (_that) {
case _TafsirDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TafsirDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _TafsirDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti,  List<TafsirAyatDto> tafsir)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TafsirDataDto() when $default != null:
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti,_that.tafsir);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti,  List<TafsirAyatDto> tafsir)  $default,) {final _that = this;
switch (_that) {
case _TafsirDataDto():
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti,_that.tafsir);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti,  List<TafsirAyatDto> tafsir)?  $default,) {final _that = this;
switch (_that) {
case _TafsirDataDto() when $default != null:
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti,_that.tafsir);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TafsirDataDto implements TafsirDataDto {
  const _TafsirDataDto({required this.nomor, required this.nama, @JsonKey(name: 'namaLatin') required this.namaLatin, @JsonKey(name: 'jumlahAyat') required this.jumlahAyat, @JsonKey(name: 'tempatTurun') required this.tempatTurun, required this.arti, required final  List<TafsirAyatDto> tafsir}): _tafsir = tafsir;
  factory _TafsirDataDto.fromJson(Map<String, dynamic> json) => _$TafsirDataDtoFromJson(json);

@override final  int nomor;
@override final  String nama;
@override@JsonKey(name: 'namaLatin') final  String namaLatin;
@override@JsonKey(name: 'jumlahAyat') final  int jumlahAyat;
@override@JsonKey(name: 'tempatTurun') final  String tempatTurun;
@override final  String arti;
 final  List<TafsirAyatDto> _tafsir;
@override List<TafsirAyatDto> get tafsir {
  if (_tafsir is EqualUnmodifiableListView) return _tafsir;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tafsir);
}


/// Create a copy of TafsirDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TafsirDataDtoCopyWith<_TafsirDataDto> get copyWith => __$TafsirDataDtoCopyWithImpl<_TafsirDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TafsirDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TafsirDataDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti)&&const DeepCollectionEquality().equals(other._tafsir, _tafsir));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti,const DeepCollectionEquality().hash(_tafsir));

@override
String toString() {
  return 'TafsirDataDto(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti, tafsir: $tafsir)';
}


}

/// @nodoc
abstract mixin class _$TafsirDataDtoCopyWith<$Res> implements $TafsirDataDtoCopyWith<$Res> {
  factory _$TafsirDataDtoCopyWith(_TafsirDataDto value, $Res Function(_TafsirDataDto) _then) = __$TafsirDataDtoCopyWithImpl;
@override @useResult
$Res call({
 int nomor, String nama,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat,@JsonKey(name: 'tempatTurun') String tempatTurun, String arti, List<TafsirAyatDto> tafsir
});




}
/// @nodoc
class __$TafsirDataDtoCopyWithImpl<$Res>
    implements _$TafsirDataDtoCopyWith<$Res> {
  __$TafsirDataDtoCopyWithImpl(this._self, this._then);

  final _TafsirDataDto _self;
  final $Res Function(_TafsirDataDto) _then;

/// Create a copy of TafsirDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,Object? tafsir = null,}) {
  return _then(_TafsirDataDto(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as String,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,tafsir: null == tafsir ? _self._tafsir : tafsir // ignore: cast_nullable_to_non_nullable
as List<TafsirAyatDto>,
  ));
}


}


/// @nodoc
mixin _$TafsirAyatDto {

 int get ayat; String get teks;
/// Create a copy of TafsirAyatDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafsirAyatDtoCopyWith<TafsirAyatDto> get copyWith => _$TafsirAyatDtoCopyWithImpl<TafsirAyatDto>(this as TafsirAyatDto, _$identity);

  /// Serializes this TafsirAyatDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirAyatDto&&(identical(other.ayat, ayat) || other.ayat == ayat)&&(identical(other.teks, teks) || other.teks == teks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ayat,teks);

@override
String toString() {
  return 'TafsirAyatDto(ayat: $ayat, teks: $teks)';
}


}

/// @nodoc
abstract mixin class $TafsirAyatDtoCopyWith<$Res>  {
  factory $TafsirAyatDtoCopyWith(TafsirAyatDto value, $Res Function(TafsirAyatDto) _then) = _$TafsirAyatDtoCopyWithImpl;
@useResult
$Res call({
 int ayat, String teks
});




}
/// @nodoc
class _$TafsirAyatDtoCopyWithImpl<$Res>
    implements $TafsirAyatDtoCopyWith<$Res> {
  _$TafsirAyatDtoCopyWithImpl(this._self, this._then);

  final TafsirAyatDto _self;
  final $Res Function(TafsirAyatDto) _then;

/// Create a copy of TafsirAyatDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ayat = null,Object? teks = null,}) {
  return _then(_self.copyWith(
ayat: null == ayat ? _self.ayat : ayat // ignore: cast_nullable_to_non_nullable
as int,teks: null == teks ? _self.teks : teks // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TafsirAyatDto].
extension TafsirAyatDtoPatterns on TafsirAyatDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TafsirAyatDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TafsirAyatDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TafsirAyatDto value)  $default,){
final _that = this;
switch (_that) {
case _TafsirAyatDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TafsirAyatDto value)?  $default,){
final _that = this;
switch (_that) {
case _TafsirAyatDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int ayat,  String teks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TafsirAyatDto() when $default != null:
return $default(_that.ayat,_that.teks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int ayat,  String teks)  $default,) {final _that = this;
switch (_that) {
case _TafsirAyatDto():
return $default(_that.ayat,_that.teks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int ayat,  String teks)?  $default,) {final _that = this;
switch (_that) {
case _TafsirAyatDto() when $default != null:
return $default(_that.ayat,_that.teks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TafsirAyatDto implements TafsirAyatDto {
  const _TafsirAyatDto({required this.ayat, required this.teks});
  factory _TafsirAyatDto.fromJson(Map<String, dynamic> json) => _$TafsirAyatDtoFromJson(json);

@override final  int ayat;
@override final  String teks;

/// Create a copy of TafsirAyatDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TafsirAyatDtoCopyWith<_TafsirAyatDto> get copyWith => __$TafsirAyatDtoCopyWithImpl<_TafsirAyatDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TafsirAyatDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TafsirAyatDto&&(identical(other.ayat, ayat) || other.ayat == ayat)&&(identical(other.teks, teks) || other.teks == teks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ayat,teks);

@override
String toString() {
  return 'TafsirAyatDto(ayat: $ayat, teks: $teks)';
}


}

/// @nodoc
abstract mixin class _$TafsirAyatDtoCopyWith<$Res> implements $TafsirAyatDtoCopyWith<$Res> {
  factory _$TafsirAyatDtoCopyWith(_TafsirAyatDto value, $Res Function(_TafsirAyatDto) _then) = __$TafsirAyatDtoCopyWithImpl;
@override @useResult
$Res call({
 int ayat, String teks
});




}
/// @nodoc
class __$TafsirAyatDtoCopyWithImpl<$Res>
    implements _$TafsirAyatDtoCopyWith<$Res> {
  __$TafsirAyatDtoCopyWithImpl(this._self, this._then);

  final _TafsirAyatDto _self;
  final $Res Function(_TafsirAyatDto) _then;

/// Create a copy of TafsirAyatDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ayat = null,Object? teks = null,}) {
  return _then(_TafsirAyatDto(
ayat: null == ayat ? _self.ayat : ayat // ignore: cast_nullable_to_non_nullable
as int,teks: null == teks ? _self.teks : teks // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
