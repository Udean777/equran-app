// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surat_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SuratDetailResponseDto {

 int get code; String get message; SuratDetailDto get data;
/// Create a copy of SuratDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratDetailResponseDtoCopyWith<SuratDetailResponseDto> get copyWith => _$SuratDetailResponseDtoCopyWithImpl<SuratDetailResponseDto>(this as SuratDetailResponseDto, _$identity);

  /// Serializes this SuratDetailResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetailResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'SuratDetailResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $SuratDetailResponseDtoCopyWith<$Res>  {
  factory $SuratDetailResponseDtoCopyWith(SuratDetailResponseDto value, $Res Function(SuratDetailResponseDto) _then) = _$SuratDetailResponseDtoCopyWithImpl;
@useResult
$Res call({
 int code, String message, SuratDetailDto data
});


$SuratDetailDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$SuratDetailResponseDtoCopyWithImpl<$Res>
    implements $SuratDetailResponseDtoCopyWith<$Res> {
  _$SuratDetailResponseDtoCopyWithImpl(this._self, this._then);

  final SuratDetailResponseDto _self;
  final $Res Function(SuratDetailResponseDto) _then;

/// Create a copy of SuratDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SuratDetailDto,
  ));
}
/// Create a copy of SuratDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratDetailDtoCopyWith<$Res> get data {
  
  return $SuratDetailDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [SuratDetailResponseDto].
extension SuratDetailResponseDtoPatterns on SuratDetailResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratDetailResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratDetailResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SuratDetailResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratDetailResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SuratDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String message,  SuratDetailDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String message,  SuratDetailDto data)  $default,) {final _that = this;
switch (_that) {
case _SuratDetailResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String message,  SuratDetailDto data)?  $default,) {final _that = this;
switch (_that) {
case _SuratDetailResponseDto() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuratDetailResponseDto implements SuratDetailResponseDto {
  const _SuratDetailResponseDto({required this.code, required this.message, required this.data});
  factory _SuratDetailResponseDto.fromJson(Map<String, dynamic> json) => _$SuratDetailResponseDtoFromJson(json);

@override final  int code;
@override final  String message;
@override final  SuratDetailDto data;

/// Create a copy of SuratDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratDetailResponseDtoCopyWith<_SuratDetailResponseDto> get copyWith => __$SuratDetailResponseDtoCopyWithImpl<_SuratDetailResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuratDetailResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratDetailResponseDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'SuratDetailResponseDto(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SuratDetailResponseDtoCopyWith<$Res> implements $SuratDetailResponseDtoCopyWith<$Res> {
  factory _$SuratDetailResponseDtoCopyWith(_SuratDetailResponseDto value, $Res Function(_SuratDetailResponseDto) _then) = __$SuratDetailResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String message, SuratDetailDto data
});


@override $SuratDetailDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$SuratDetailResponseDtoCopyWithImpl<$Res>
    implements _$SuratDetailResponseDtoCopyWith<$Res> {
  __$SuratDetailResponseDtoCopyWithImpl(this._self, this._then);

  final _SuratDetailResponseDto _self;
  final $Res Function(_SuratDetailResponseDto) _then;

/// Create a copy of SuratDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_SuratDetailResponseDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SuratDetailDto,
  ));
}

/// Create a copy of SuratDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratDetailDtoCopyWith<$Res> get data {
  
  return $SuratDetailDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$SuratDetailDto {

 int get nomor; String get nama;@JsonKey(name: 'namaLatin') String get namaLatin;@JsonKey(name: 'jumlahAyat') int get jumlahAyat;@JsonKey(name: 'tempatTurun') String get tempatTurun; String get arti; String get deskripsi;@JsonKey(name: 'audioFull') Map<String, String> get audioFull;@JsonKey(name: 'ayat') List<AyatDto> get ayat;@JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter() SuratNavDto? get suratSelanjutnya;@JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter() SuratNavDto? get suratSebelumnya;
/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratDetailDtoCopyWith<SuratDetailDto> get copyWith => _$SuratDetailDtoCopyWithImpl<SuratDetailDto>(this as SuratDetailDto, _$identity);

  /// Serializes this SuratDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetailDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti)&&(identical(other.deskripsi, deskripsi) || other.deskripsi == deskripsi)&&const DeepCollectionEquality().equals(other.audioFull, audioFull)&&const DeepCollectionEquality().equals(other.ayat, ayat)&&(identical(other.suratSelanjutnya, suratSelanjutnya) || other.suratSelanjutnya == suratSelanjutnya)&&(identical(other.suratSebelumnya, suratSebelumnya) || other.suratSebelumnya == suratSebelumnya));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti,deskripsi,const DeepCollectionEquality().hash(audioFull),const DeepCollectionEquality().hash(ayat),suratSelanjutnya,suratSebelumnya);

@override
String toString() {
  return 'SuratDetailDto(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti, deskripsi: $deskripsi, audioFull: $audioFull, ayat: $ayat, suratSelanjutnya: $suratSelanjutnya, suratSebelumnya: $suratSebelumnya)';
}


}

/// @nodoc
abstract mixin class $SuratDetailDtoCopyWith<$Res>  {
  factory $SuratDetailDtoCopyWith(SuratDetailDto value, $Res Function(SuratDetailDto) _then) = _$SuratDetailDtoCopyWithImpl;
@useResult
$Res call({
 int nomor, String nama,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat,@JsonKey(name: 'tempatTurun') String tempatTurun, String arti, String deskripsi,@JsonKey(name: 'audioFull') Map<String, String> audioFull,@JsonKey(name: 'ayat') List<AyatDto> ayat,@JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter() SuratNavDto? suratSelanjutnya,@JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter() SuratNavDto? suratSebelumnya
});


$SuratNavDtoCopyWith<$Res>? get suratSelanjutnya;$SuratNavDtoCopyWith<$Res>? get suratSebelumnya;

}
/// @nodoc
class _$SuratDetailDtoCopyWithImpl<$Res>
    implements $SuratDetailDtoCopyWith<$Res> {
  _$SuratDetailDtoCopyWithImpl(this._self, this._then);

  final SuratDetailDto _self;
  final $Res Function(SuratDetailDto) _then;

/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,Object? deskripsi = null,Object? audioFull = null,Object? ayat = null,Object? suratSelanjutnya = freezed,Object? suratSebelumnya = freezed,}) {
  return _then(_self.copyWith(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as String,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,deskripsi: null == deskripsi ? _self.deskripsi : deskripsi // ignore: cast_nullable_to_non_nullable
as String,audioFull: null == audioFull ? _self.audioFull : audioFull // ignore: cast_nullable_to_non_nullable
as Map<String, String>,ayat: null == ayat ? _self.ayat : ayat // ignore: cast_nullable_to_non_nullable
as List<AyatDto>,suratSelanjutnya: freezed == suratSelanjutnya ? _self.suratSelanjutnya : suratSelanjutnya // ignore: cast_nullable_to_non_nullable
as SuratNavDto?,suratSebelumnya: freezed == suratSebelumnya ? _self.suratSebelumnya : suratSebelumnya // ignore: cast_nullable_to_non_nullable
as SuratNavDto?,
  ));
}
/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavDtoCopyWith<$Res>? get suratSelanjutnya {
    if (_self.suratSelanjutnya == null) {
    return null;
  }

  return $SuratNavDtoCopyWith<$Res>(_self.suratSelanjutnya!, (value) {
    return _then(_self.copyWith(suratSelanjutnya: value));
  });
}/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavDtoCopyWith<$Res>? get suratSebelumnya {
    if (_self.suratSebelumnya == null) {
    return null;
  }

  return $SuratNavDtoCopyWith<$Res>(_self.suratSebelumnya!, (value) {
    return _then(_self.copyWith(suratSebelumnya: value));
  });
}
}


/// Adds pattern-matching-related methods to [SuratDetailDto].
extension SuratDetailDtoPatterns on SuratDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _SuratDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _SuratDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti,  String deskripsi, @JsonKey(name: 'audioFull')  Map<String, String> audioFull, @JsonKey(name: 'ayat')  List<AyatDto> ayat, @JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter()  SuratNavDto? suratSelanjutnya, @JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter()  SuratNavDto? suratSebelumnya)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratDetailDto() when $default != null:
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti,_that.deskripsi,_that.audioFull,_that.ayat,_that.suratSelanjutnya,_that.suratSebelumnya);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti,  String deskripsi, @JsonKey(name: 'audioFull')  Map<String, String> audioFull, @JsonKey(name: 'ayat')  List<AyatDto> ayat, @JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter()  SuratNavDto? suratSelanjutnya, @JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter()  SuratNavDto? suratSebelumnya)  $default,) {final _that = this;
switch (_that) {
case _SuratDetailDto():
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti,_that.deskripsi,_that.audioFull,_that.ayat,_that.suratSelanjutnya,_that.suratSebelumnya);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomor,  String nama, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat, @JsonKey(name: 'tempatTurun')  String tempatTurun,  String arti,  String deskripsi, @JsonKey(name: 'audioFull')  Map<String, String> audioFull, @JsonKey(name: 'ayat')  List<AyatDto> ayat, @JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter()  SuratNavDto? suratSelanjutnya, @JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter()  SuratNavDto? suratSebelumnya)?  $default,) {final _that = this;
switch (_that) {
case _SuratDetailDto() when $default != null:
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti,_that.deskripsi,_that.audioFull,_that.ayat,_that.suratSelanjutnya,_that.suratSebelumnya);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuratDetailDto implements SuratDetailDto {
  const _SuratDetailDto({required this.nomor, required this.nama, @JsonKey(name: 'namaLatin') required this.namaLatin, @JsonKey(name: 'jumlahAyat') required this.jumlahAyat, @JsonKey(name: 'tempatTurun') required this.tempatTurun, required this.arti, required this.deskripsi, @JsonKey(name: 'audioFull') final  Map<String, String> audioFull = const {}, @JsonKey(name: 'ayat') final  List<AyatDto> ayat = const [], @JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter() this.suratSelanjutnya, @JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter() this.suratSebelumnya}): _audioFull = audioFull,_ayat = ayat;
  factory _SuratDetailDto.fromJson(Map<String, dynamic> json) => _$SuratDetailDtoFromJson(json);

@override final  int nomor;
@override final  String nama;
@override@JsonKey(name: 'namaLatin') final  String namaLatin;
@override@JsonKey(name: 'jumlahAyat') final  int jumlahAyat;
@override@JsonKey(name: 'tempatTurun') final  String tempatTurun;
@override final  String arti;
@override final  String deskripsi;
 final  Map<String, String> _audioFull;
@override@JsonKey(name: 'audioFull') Map<String, String> get audioFull {
  if (_audioFull is EqualUnmodifiableMapView) return _audioFull;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_audioFull);
}

 final  List<AyatDto> _ayat;
@override@JsonKey(name: 'ayat') List<AyatDto> get ayat {
  if (_ayat is EqualUnmodifiableListView) return _ayat;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ayat);
}

@override@JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter() final  SuratNavDto? suratSelanjutnya;
@override@JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter() final  SuratNavDto? suratSebelumnya;

/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratDetailDtoCopyWith<_SuratDetailDto> get copyWith => __$SuratDetailDtoCopyWithImpl<_SuratDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuratDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratDetailDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti)&&(identical(other.deskripsi, deskripsi) || other.deskripsi == deskripsi)&&const DeepCollectionEquality().equals(other._audioFull, _audioFull)&&const DeepCollectionEquality().equals(other._ayat, _ayat)&&(identical(other.suratSelanjutnya, suratSelanjutnya) || other.suratSelanjutnya == suratSelanjutnya)&&(identical(other.suratSebelumnya, suratSebelumnya) || other.suratSebelumnya == suratSebelumnya));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti,deskripsi,const DeepCollectionEquality().hash(_audioFull),const DeepCollectionEquality().hash(_ayat),suratSelanjutnya,suratSebelumnya);

@override
String toString() {
  return 'SuratDetailDto(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti, deskripsi: $deskripsi, audioFull: $audioFull, ayat: $ayat, suratSelanjutnya: $suratSelanjutnya, suratSebelumnya: $suratSebelumnya)';
}


}

/// @nodoc
abstract mixin class _$SuratDetailDtoCopyWith<$Res> implements $SuratDetailDtoCopyWith<$Res> {
  factory _$SuratDetailDtoCopyWith(_SuratDetailDto value, $Res Function(_SuratDetailDto) _then) = __$SuratDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 int nomor, String nama,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat,@JsonKey(name: 'tempatTurun') String tempatTurun, String arti, String deskripsi,@JsonKey(name: 'audioFull') Map<String, String> audioFull,@JsonKey(name: 'ayat') List<AyatDto> ayat,@JsonKey(name: 'suratSelanjutnya')@SuratNavOrFalseConverter() SuratNavDto? suratSelanjutnya,@JsonKey(name: 'suratSebelumnya')@SuratNavOrFalseConverter() SuratNavDto? suratSebelumnya
});


@override $SuratNavDtoCopyWith<$Res>? get suratSelanjutnya;@override $SuratNavDtoCopyWith<$Res>? get suratSebelumnya;

}
/// @nodoc
class __$SuratDetailDtoCopyWithImpl<$Res>
    implements _$SuratDetailDtoCopyWith<$Res> {
  __$SuratDetailDtoCopyWithImpl(this._self, this._then);

  final _SuratDetailDto _self;
  final $Res Function(_SuratDetailDto) _then;

/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,Object? deskripsi = null,Object? audioFull = null,Object? ayat = null,Object? suratSelanjutnya = freezed,Object? suratSebelumnya = freezed,}) {
  return _then(_SuratDetailDto(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as String,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,deskripsi: null == deskripsi ? _self.deskripsi : deskripsi // ignore: cast_nullable_to_non_nullable
as String,audioFull: null == audioFull ? _self._audioFull : audioFull // ignore: cast_nullable_to_non_nullable
as Map<String, String>,ayat: null == ayat ? _self._ayat : ayat // ignore: cast_nullable_to_non_nullable
as List<AyatDto>,suratSelanjutnya: freezed == suratSelanjutnya ? _self.suratSelanjutnya : suratSelanjutnya // ignore: cast_nullable_to_non_nullable
as SuratNavDto?,suratSebelumnya: freezed == suratSebelumnya ? _self.suratSebelumnya : suratSebelumnya // ignore: cast_nullable_to_non_nullable
as SuratNavDto?,
  ));
}

/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavDtoCopyWith<$Res>? get suratSelanjutnya {
    if (_self.suratSelanjutnya == null) {
    return null;
  }

  return $SuratNavDtoCopyWith<$Res>(_self.suratSelanjutnya!, (value) {
    return _then(_self.copyWith(suratSelanjutnya: value));
  });
}/// Create a copy of SuratDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavDtoCopyWith<$Res>? get suratSebelumnya {
    if (_self.suratSebelumnya == null) {
    return null;
  }

  return $SuratNavDtoCopyWith<$Res>(_self.suratSebelumnya!, (value) {
    return _then(_self.copyWith(suratSebelumnya: value));
  });
}
}


/// @nodoc
mixin _$AyatDto {

@JsonKey(name: 'nomorAyat') int get nomorAyat;@JsonKey(name: 'teksArab') String get teksArab;@JsonKey(name: 'teksLatin') String get teksLatin;@JsonKey(name: 'teksIndonesia') String get teksIndonesia; Map<String, String> get audio;
/// Create a copy of AyatDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AyatDtoCopyWith<AyatDto> get copyWith => _$AyatDtoCopyWithImpl<AyatDto>(this as AyatDto, _$identity);

  /// Serializes this AyatDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AyatDto&&(identical(other.nomorAyat, nomorAyat) || other.nomorAyat == nomorAyat)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.teksLatin, teksLatin) || other.teksLatin == teksLatin)&&(identical(other.teksIndonesia, teksIndonesia) || other.teksIndonesia == teksIndonesia)&&const DeepCollectionEquality().equals(other.audio, audio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomorAyat,teksArab,teksLatin,teksIndonesia,const DeepCollectionEquality().hash(audio));

@override
String toString() {
  return 'AyatDto(nomorAyat: $nomorAyat, teksArab: $teksArab, teksLatin: $teksLatin, teksIndonesia: $teksIndonesia, audio: $audio)';
}


}

/// @nodoc
abstract mixin class $AyatDtoCopyWith<$Res>  {
  factory $AyatDtoCopyWith(AyatDto value, $Res Function(AyatDto) _then) = _$AyatDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'nomorAyat') int nomorAyat,@JsonKey(name: 'teksArab') String teksArab,@JsonKey(name: 'teksLatin') String teksLatin,@JsonKey(name: 'teksIndonesia') String teksIndonesia, Map<String, String> audio
});




}
/// @nodoc
class _$AyatDtoCopyWithImpl<$Res>
    implements $AyatDtoCopyWith<$Res> {
  _$AyatDtoCopyWithImpl(this._self, this._then);

  final AyatDto _self;
  final $Res Function(AyatDto) _then;

/// Create a copy of AyatDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomorAyat = null,Object? teksArab = null,Object? teksLatin = null,Object? teksIndonesia = null,Object? audio = null,}) {
  return _then(_self.copyWith(
nomorAyat: null == nomorAyat ? _self.nomorAyat : nomorAyat // ignore: cast_nullable_to_non_nullable
as int,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,teksLatin: null == teksLatin ? _self.teksLatin : teksLatin // ignore: cast_nullable_to_non_nullable
as String,teksIndonesia: null == teksIndonesia ? _self.teksIndonesia : teksIndonesia // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AyatDto].
extension AyatDtoPatterns on AyatDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AyatDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AyatDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AyatDto value)  $default,){
final _that = this;
switch (_that) {
case _AyatDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AyatDto value)?  $default,){
final _that = this;
switch (_that) {
case _AyatDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'nomorAyat')  int nomorAyat, @JsonKey(name: 'teksArab')  String teksArab, @JsonKey(name: 'teksLatin')  String teksLatin, @JsonKey(name: 'teksIndonesia')  String teksIndonesia,  Map<String, String> audio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AyatDto() when $default != null:
return $default(_that.nomorAyat,_that.teksArab,_that.teksLatin,_that.teksIndonesia,_that.audio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'nomorAyat')  int nomorAyat, @JsonKey(name: 'teksArab')  String teksArab, @JsonKey(name: 'teksLatin')  String teksLatin, @JsonKey(name: 'teksIndonesia')  String teksIndonesia,  Map<String, String> audio)  $default,) {final _that = this;
switch (_that) {
case _AyatDto():
return $default(_that.nomorAyat,_that.teksArab,_that.teksLatin,_that.teksIndonesia,_that.audio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'nomorAyat')  int nomorAyat, @JsonKey(name: 'teksArab')  String teksArab, @JsonKey(name: 'teksLatin')  String teksLatin, @JsonKey(name: 'teksIndonesia')  String teksIndonesia,  Map<String, String> audio)?  $default,) {final _that = this;
switch (_that) {
case _AyatDto() when $default != null:
return $default(_that.nomorAyat,_that.teksArab,_that.teksLatin,_that.teksIndonesia,_that.audio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AyatDto implements AyatDto {
  const _AyatDto({@JsonKey(name: 'nomorAyat') required this.nomorAyat, @JsonKey(name: 'teksArab') required this.teksArab, @JsonKey(name: 'teksLatin') required this.teksLatin, @JsonKey(name: 'teksIndonesia') required this.teksIndonesia, final  Map<String, String> audio = const {}}): _audio = audio;
  factory _AyatDto.fromJson(Map<String, dynamic> json) => _$AyatDtoFromJson(json);

@override@JsonKey(name: 'nomorAyat') final  int nomorAyat;
@override@JsonKey(name: 'teksArab') final  String teksArab;
@override@JsonKey(name: 'teksLatin') final  String teksLatin;
@override@JsonKey(name: 'teksIndonesia') final  String teksIndonesia;
 final  Map<String, String> _audio;
@override@JsonKey() Map<String, String> get audio {
  if (_audio is EqualUnmodifiableMapView) return _audio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_audio);
}


/// Create a copy of AyatDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AyatDtoCopyWith<_AyatDto> get copyWith => __$AyatDtoCopyWithImpl<_AyatDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AyatDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AyatDto&&(identical(other.nomorAyat, nomorAyat) || other.nomorAyat == nomorAyat)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.teksLatin, teksLatin) || other.teksLatin == teksLatin)&&(identical(other.teksIndonesia, teksIndonesia) || other.teksIndonesia == teksIndonesia)&&const DeepCollectionEquality().equals(other._audio, _audio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomorAyat,teksArab,teksLatin,teksIndonesia,const DeepCollectionEquality().hash(_audio));

@override
String toString() {
  return 'AyatDto(nomorAyat: $nomorAyat, teksArab: $teksArab, teksLatin: $teksLatin, teksIndonesia: $teksIndonesia, audio: $audio)';
}


}

/// @nodoc
abstract mixin class _$AyatDtoCopyWith<$Res> implements $AyatDtoCopyWith<$Res> {
  factory _$AyatDtoCopyWith(_AyatDto value, $Res Function(_AyatDto) _then) = __$AyatDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'nomorAyat') int nomorAyat,@JsonKey(name: 'teksArab') String teksArab,@JsonKey(name: 'teksLatin') String teksLatin,@JsonKey(name: 'teksIndonesia') String teksIndonesia, Map<String, String> audio
});




}
/// @nodoc
class __$AyatDtoCopyWithImpl<$Res>
    implements _$AyatDtoCopyWith<$Res> {
  __$AyatDtoCopyWithImpl(this._self, this._then);

  final _AyatDto _self;
  final $Res Function(_AyatDto) _then;

/// Create a copy of AyatDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomorAyat = null,Object? teksArab = null,Object? teksLatin = null,Object? teksIndonesia = null,Object? audio = null,}) {
  return _then(_AyatDto(
nomorAyat: null == nomorAyat ? _self.nomorAyat : nomorAyat // ignore: cast_nullable_to_non_nullable
as int,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,teksLatin: null == teksLatin ? _self.teksLatin : teksLatin // ignore: cast_nullable_to_non_nullable
as String,teksIndonesia: null == teksIndonesia ? _self.teksIndonesia : teksIndonesia // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self._audio : audio // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$SuratNavDto {

 int get nomor;@JsonKey(name: 'namaLatin') String get namaLatin;@JsonKey(name: 'jumlahAyat') int get jumlahAyat;
/// Create a copy of SuratNavDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratNavDtoCopyWith<SuratNavDto> get copyWith => _$SuratNavDtoCopyWithImpl<SuratNavDto>(this as SuratNavDto, _$identity);

  /// Serializes this SuratNavDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratNavDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,namaLatin,jumlahAyat);

@override
String toString() {
  return 'SuratNavDto(nomor: $nomor, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat)';
}


}

/// @nodoc
abstract mixin class $SuratNavDtoCopyWith<$Res>  {
  factory $SuratNavDtoCopyWith(SuratNavDto value, $Res Function(SuratNavDto) _then) = _$SuratNavDtoCopyWithImpl;
@useResult
$Res call({
 int nomor,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat
});




}
/// @nodoc
class _$SuratNavDtoCopyWithImpl<$Res>
    implements $SuratNavDtoCopyWith<$Res> {
  _$SuratNavDtoCopyWithImpl(this._self, this._then);

  final SuratNavDto _self;
  final $Res Function(SuratNavDto) _then;

/// Create a copy of SuratNavDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomor = null,Object? namaLatin = null,Object? jumlahAyat = null,}) {
  return _then(_self.copyWith(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SuratNavDto].
extension SuratNavDtoPatterns on SuratNavDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratNavDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratNavDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratNavDto value)  $default,){
final _that = this;
switch (_that) {
case _SuratNavDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratNavDto value)?  $default,){
final _that = this;
switch (_that) {
case _SuratNavDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomor, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratNavDto() when $default != null:
return $default(_that.nomor,_that.namaLatin,_that.jumlahAyat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomor, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat)  $default,) {final _that = this;
switch (_that) {
case _SuratNavDto():
return $default(_that.nomor,_that.namaLatin,_that.jumlahAyat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomor, @JsonKey(name: 'namaLatin')  String namaLatin, @JsonKey(name: 'jumlahAyat')  int jumlahAyat)?  $default,) {final _that = this;
switch (_that) {
case _SuratNavDto() when $default != null:
return $default(_that.nomor,_that.namaLatin,_that.jumlahAyat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuratNavDto implements SuratNavDto {
  const _SuratNavDto({required this.nomor, @JsonKey(name: 'namaLatin') required this.namaLatin, @JsonKey(name: 'jumlahAyat') required this.jumlahAyat});
  factory _SuratNavDto.fromJson(Map<String, dynamic> json) => _$SuratNavDtoFromJson(json);

@override final  int nomor;
@override@JsonKey(name: 'namaLatin') final  String namaLatin;
@override@JsonKey(name: 'jumlahAyat') final  int jumlahAyat;

/// Create a copy of SuratNavDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratNavDtoCopyWith<_SuratNavDto> get copyWith => __$SuratNavDtoCopyWithImpl<_SuratNavDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuratNavDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratNavDto&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomor,namaLatin,jumlahAyat);

@override
String toString() {
  return 'SuratNavDto(nomor: $nomor, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat)';
}


}

/// @nodoc
abstract mixin class _$SuratNavDtoCopyWith<$Res> implements $SuratNavDtoCopyWith<$Res> {
  factory _$SuratNavDtoCopyWith(_SuratNavDto value, $Res Function(_SuratNavDto) _then) = __$SuratNavDtoCopyWithImpl;
@override @useResult
$Res call({
 int nomor,@JsonKey(name: 'namaLatin') String namaLatin,@JsonKey(name: 'jumlahAyat') int jumlahAyat
});




}
/// @nodoc
class __$SuratNavDtoCopyWithImpl<$Res>
    implements _$SuratNavDtoCopyWith<$Res> {
  __$SuratNavDtoCopyWithImpl(this._self, this._then);

  final _SuratNavDto _self;
  final $Res Function(_SuratNavDto) _then;

/// Create a copy of SuratNavDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomor = null,Object? namaLatin = null,Object? jumlahAyat = null,}) {
  return _then(_SuratNavDto(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
