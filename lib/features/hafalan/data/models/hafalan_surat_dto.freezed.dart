// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hafalan_surat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HafalanSuratDto {

 int get suratNomor; String get namaLatin; String get nama; int get jumlahAyat;/// Status disimpan sebagai string nama enum.
 String get status;/// Nomor ayat yang sudah hafal.
 List<int> get ayatHafal;/// Level spaced repetition (0–5).
 int get murajaahLevel;/// DateTime disimpan sebagai ISO 8601 string.
 String? get tanggalMulai; String? get tanggalSelesai; String? get tanggalMurajaahBerikutnya; String? get catatan;
/// Create a copy of HafalanSuratDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanSuratDtoCopyWith<HafalanSuratDto> get copyWith => _$HafalanSuratDtoCopyWithImpl<HafalanSuratDto>(this as HafalanSuratDto, _$identity);

  /// Serializes this HafalanSuratDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanSuratDto&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.ayatHafal, ayatHafal)&&(identical(other.murajaahLevel, murajaahLevel) || other.murajaahLevel == murajaahLevel)&&(identical(other.tanggalMulai, tanggalMulai) || other.tanggalMulai == tanggalMulai)&&(identical(other.tanggalSelesai, tanggalSelesai) || other.tanggalSelesai == tanggalSelesai)&&(identical(other.tanggalMurajaahBerikutnya, tanggalMurajaahBerikutnya) || other.tanggalMurajaahBerikutnya == tanggalMurajaahBerikutnya)&&(identical(other.catatan, catatan) || other.catatan == catatan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,namaLatin,nama,jumlahAyat,status,const DeepCollectionEquality().hash(ayatHafal),murajaahLevel,tanggalMulai,tanggalSelesai,tanggalMurajaahBerikutnya,catatan);

@override
String toString() {
  return 'HafalanSuratDto(suratNomor: $suratNomor, namaLatin: $namaLatin, nama: $nama, jumlahAyat: $jumlahAyat, status: $status, ayatHafal: $ayatHafal, murajaahLevel: $murajaahLevel, tanggalMulai: $tanggalMulai, tanggalSelesai: $tanggalSelesai, tanggalMurajaahBerikutnya: $tanggalMurajaahBerikutnya, catatan: $catatan)';
}


}

/// @nodoc
abstract mixin class $HafalanSuratDtoCopyWith<$Res>  {
  factory $HafalanSuratDtoCopyWith(HafalanSuratDto value, $Res Function(HafalanSuratDto) _then) = _$HafalanSuratDtoCopyWithImpl;
@useResult
$Res call({
 int suratNomor, String namaLatin, String nama, int jumlahAyat, String status, List<int> ayatHafal, int murajaahLevel, String? tanggalMulai, String? tanggalSelesai, String? tanggalMurajaahBerikutnya, String? catatan
});




}
/// @nodoc
class _$HafalanSuratDtoCopyWithImpl<$Res>
    implements $HafalanSuratDtoCopyWith<$Res> {
  _$HafalanSuratDtoCopyWithImpl(this._self, this._then);

  final HafalanSuratDto _self;
  final $Res Function(HafalanSuratDto) _then;

/// Create a copy of HafalanSuratDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suratNomor = null,Object? namaLatin = null,Object? nama = null,Object? jumlahAyat = null,Object? status = null,Object? ayatHafal = null,Object? murajaahLevel = null,Object? tanggalMulai = freezed,Object? tanggalSelesai = freezed,Object? tanggalMurajaahBerikutnya = freezed,Object? catatan = freezed,}) {
  return _then(_self.copyWith(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ayatHafal: null == ayatHafal ? _self.ayatHafal : ayatHafal // ignore: cast_nullable_to_non_nullable
as List<int>,murajaahLevel: null == murajaahLevel ? _self.murajaahLevel : murajaahLevel // ignore: cast_nullable_to_non_nullable
as int,tanggalMulai: freezed == tanggalMulai ? _self.tanggalMulai : tanggalMulai // ignore: cast_nullable_to_non_nullable
as String?,tanggalSelesai: freezed == tanggalSelesai ? _self.tanggalSelesai : tanggalSelesai // ignore: cast_nullable_to_non_nullable
as String?,tanggalMurajaahBerikutnya: freezed == tanggalMurajaahBerikutnya ? _self.tanggalMurajaahBerikutnya : tanggalMurajaahBerikutnya // ignore: cast_nullable_to_non_nullable
as String?,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HafalanSuratDto].
extension HafalanSuratDtoPatterns on HafalanSuratDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HafalanSuratDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HafalanSuratDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HafalanSuratDto value)  $default,){
final _that = this;
switch (_that) {
case _HafalanSuratDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HafalanSuratDto value)?  $default,){
final _that = this;
switch (_that) {
case _HafalanSuratDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int suratNomor,  String namaLatin,  String nama,  int jumlahAyat,  String status,  List<int> ayatHafal,  int murajaahLevel,  String? tanggalMulai,  String? tanggalSelesai,  String? tanggalMurajaahBerikutnya,  String? catatan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HafalanSuratDto() when $default != null:
return $default(_that.suratNomor,_that.namaLatin,_that.nama,_that.jumlahAyat,_that.status,_that.ayatHafal,_that.murajaahLevel,_that.tanggalMulai,_that.tanggalSelesai,_that.tanggalMurajaahBerikutnya,_that.catatan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int suratNomor,  String namaLatin,  String nama,  int jumlahAyat,  String status,  List<int> ayatHafal,  int murajaahLevel,  String? tanggalMulai,  String? tanggalSelesai,  String? tanggalMurajaahBerikutnya,  String? catatan)  $default,) {final _that = this;
switch (_that) {
case _HafalanSuratDto():
return $default(_that.suratNomor,_that.namaLatin,_that.nama,_that.jumlahAyat,_that.status,_that.ayatHafal,_that.murajaahLevel,_that.tanggalMulai,_that.tanggalSelesai,_that.tanggalMurajaahBerikutnya,_that.catatan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int suratNomor,  String namaLatin,  String nama,  int jumlahAyat,  String status,  List<int> ayatHafal,  int murajaahLevel,  String? tanggalMulai,  String? tanggalSelesai,  String? tanggalMurajaahBerikutnya,  String? catatan)?  $default,) {final _that = this;
switch (_that) {
case _HafalanSuratDto() when $default != null:
return $default(_that.suratNomor,_that.namaLatin,_that.nama,_that.jumlahAyat,_that.status,_that.ayatHafal,_that.murajaahLevel,_that.tanggalMulai,_that.tanggalSelesai,_that.tanggalMurajaahBerikutnya,_that.catatan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HafalanSuratDto implements HafalanSuratDto {
  const _HafalanSuratDto({required this.suratNomor, required this.namaLatin, required this.nama, required this.jumlahAyat, this.status = 'belum', final  List<int> ayatHafal = const [], this.murajaahLevel = 0, this.tanggalMulai, this.tanggalSelesai, this.tanggalMurajaahBerikutnya, this.catatan}): _ayatHafal = ayatHafal;
  factory _HafalanSuratDto.fromJson(Map<String, dynamic> json) => _$HafalanSuratDtoFromJson(json);

@override final  int suratNomor;
@override final  String namaLatin;
@override final  String nama;
@override final  int jumlahAyat;
/// Status disimpan sebagai string nama enum.
@override@JsonKey() final  String status;
/// Nomor ayat yang sudah hafal.
 final  List<int> _ayatHafal;
/// Nomor ayat yang sudah hafal.
@override@JsonKey() List<int> get ayatHafal {
  if (_ayatHafal is EqualUnmodifiableListView) return _ayatHafal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ayatHafal);
}

/// Level spaced repetition (0–5).
@override@JsonKey() final  int murajaahLevel;
/// DateTime disimpan sebagai ISO 8601 string.
@override final  String? tanggalMulai;
@override final  String? tanggalSelesai;
@override final  String? tanggalMurajaahBerikutnya;
@override final  String? catatan;

/// Create a copy of HafalanSuratDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HafalanSuratDtoCopyWith<_HafalanSuratDto> get copyWith => __$HafalanSuratDtoCopyWithImpl<_HafalanSuratDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HafalanSuratDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HafalanSuratDto&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._ayatHafal, _ayatHafal)&&(identical(other.murajaahLevel, murajaahLevel) || other.murajaahLevel == murajaahLevel)&&(identical(other.tanggalMulai, tanggalMulai) || other.tanggalMulai == tanggalMulai)&&(identical(other.tanggalSelesai, tanggalSelesai) || other.tanggalSelesai == tanggalSelesai)&&(identical(other.tanggalMurajaahBerikutnya, tanggalMurajaahBerikutnya) || other.tanggalMurajaahBerikutnya == tanggalMurajaahBerikutnya)&&(identical(other.catatan, catatan) || other.catatan == catatan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,namaLatin,nama,jumlahAyat,status,const DeepCollectionEquality().hash(_ayatHafal),murajaahLevel,tanggalMulai,tanggalSelesai,tanggalMurajaahBerikutnya,catatan);

@override
String toString() {
  return 'HafalanSuratDto(suratNomor: $suratNomor, namaLatin: $namaLatin, nama: $nama, jumlahAyat: $jumlahAyat, status: $status, ayatHafal: $ayatHafal, murajaahLevel: $murajaahLevel, tanggalMulai: $tanggalMulai, tanggalSelesai: $tanggalSelesai, tanggalMurajaahBerikutnya: $tanggalMurajaahBerikutnya, catatan: $catatan)';
}


}

/// @nodoc
abstract mixin class _$HafalanSuratDtoCopyWith<$Res> implements $HafalanSuratDtoCopyWith<$Res> {
  factory _$HafalanSuratDtoCopyWith(_HafalanSuratDto value, $Res Function(_HafalanSuratDto) _then) = __$HafalanSuratDtoCopyWithImpl;
@override @useResult
$Res call({
 int suratNomor, String namaLatin, String nama, int jumlahAyat, String status, List<int> ayatHafal, int murajaahLevel, String? tanggalMulai, String? tanggalSelesai, String? tanggalMurajaahBerikutnya, String? catatan
});




}
/// @nodoc
class __$HafalanSuratDtoCopyWithImpl<$Res>
    implements _$HafalanSuratDtoCopyWith<$Res> {
  __$HafalanSuratDtoCopyWithImpl(this._self, this._then);

  final _HafalanSuratDto _self;
  final $Res Function(_HafalanSuratDto) _then;

/// Create a copy of HafalanSuratDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suratNomor = null,Object? namaLatin = null,Object? nama = null,Object? jumlahAyat = null,Object? status = null,Object? ayatHafal = null,Object? murajaahLevel = null,Object? tanggalMulai = freezed,Object? tanggalSelesai = freezed,Object? tanggalMurajaahBerikutnya = freezed,Object? catatan = freezed,}) {
  return _then(_HafalanSuratDto(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ayatHafal: null == ayatHafal ? _self._ayatHafal : ayatHafal // ignore: cast_nullable_to_non_nullable
as List<int>,murajaahLevel: null == murajaahLevel ? _self.murajaahLevel : murajaahLevel // ignore: cast_nullable_to_non_nullable
as int,tanggalMulai: freezed == tanggalMulai ? _self.tanggalMulai : tanggalMulai // ignore: cast_nullable_to_non_nullable
as String?,tanggalSelesai: freezed == tanggalSelesai ? _self.tanggalSelesai : tanggalSelesai // ignore: cast_nullable_to_non_nullable
as String?,tanggalMurajaahBerikutnya: freezed == tanggalMurajaahBerikutnya ? _self.tanggalMurajaahBerikutnya : tanggalMurajaahBerikutnya // ignore: cast_nullable_to_non_nullable
as String?,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
