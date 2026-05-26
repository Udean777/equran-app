// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hafalan_surat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HafalanSurat {

 int get suratNomor; String get namaLatin; String get nama; int get jumlahAyat; HafalanStatus get status;/// Nomor ayat yang sudah ditandai hafal.
 List<int> get ayatHafal;/// Level spaced repetition muraja'ah (0–5).
/// 5 = hafalan dianggap kuat, tidak ada reminder lagi.
 int get murajaahLevel;/// Tanggal pertama kali mulai menghafal surat ini.
 DateTime? get tanggalMulai;/// Tanggal semua ayat selesai ditandai hafal.
 DateTime? get tanggalSelesai;/// Tanggal muraja'ah berikutnya (dari spaced repetition).
 DateTime? get tanggalMurajaahBerikutnya;/// Catatan pribadi opsional untuk surat ini.
 String? get catatan;
/// Create a copy of HafalanSurat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanSuratCopyWith<HafalanSurat> get copyWith => _$HafalanSuratCopyWithImpl<HafalanSurat>(this as HafalanSurat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanSurat&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.ayatHafal, ayatHafal)&&(identical(other.murajaahLevel, murajaahLevel) || other.murajaahLevel == murajaahLevel)&&(identical(other.tanggalMulai, tanggalMulai) || other.tanggalMulai == tanggalMulai)&&(identical(other.tanggalSelesai, tanggalSelesai) || other.tanggalSelesai == tanggalSelesai)&&(identical(other.tanggalMurajaahBerikutnya, tanggalMurajaahBerikutnya) || other.tanggalMurajaahBerikutnya == tanggalMurajaahBerikutnya)&&(identical(other.catatan, catatan) || other.catatan == catatan));
}


@override
int get hashCode => Object.hash(runtimeType,suratNomor,namaLatin,nama,jumlahAyat,status,const DeepCollectionEquality().hash(ayatHafal),murajaahLevel,tanggalMulai,tanggalSelesai,tanggalMurajaahBerikutnya,catatan);

@override
String toString() {
  return 'HafalanSurat(suratNomor: $suratNomor, namaLatin: $namaLatin, nama: $nama, jumlahAyat: $jumlahAyat, status: $status, ayatHafal: $ayatHafal, murajaahLevel: $murajaahLevel, tanggalMulai: $tanggalMulai, tanggalSelesai: $tanggalSelesai, tanggalMurajaahBerikutnya: $tanggalMurajaahBerikutnya, catatan: $catatan)';
}


}

/// @nodoc
abstract mixin class $HafalanSuratCopyWith<$Res>  {
  factory $HafalanSuratCopyWith(HafalanSurat value, $Res Function(HafalanSurat) _then) = _$HafalanSuratCopyWithImpl;
@useResult
$Res call({
 int suratNomor, String namaLatin, String nama, int jumlahAyat, HafalanStatus status, List<int> ayatHafal, int murajaahLevel, DateTime? tanggalMulai, DateTime? tanggalSelesai, DateTime? tanggalMurajaahBerikutnya, String? catatan
});




}
/// @nodoc
class _$HafalanSuratCopyWithImpl<$Res>
    implements $HafalanSuratCopyWith<$Res> {
  _$HafalanSuratCopyWithImpl(this._self, this._then);

  final HafalanSurat _self;
  final $Res Function(HafalanSurat) _then;

/// Create a copy of HafalanSurat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suratNomor = null,Object? namaLatin = null,Object? nama = null,Object? jumlahAyat = null,Object? status = null,Object? ayatHafal = null,Object? murajaahLevel = null,Object? tanggalMulai = freezed,Object? tanggalSelesai = freezed,Object? tanggalMurajaahBerikutnya = freezed,Object? catatan = freezed,}) {
  return _then(_self.copyWith(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HafalanStatus,ayatHafal: null == ayatHafal ? _self.ayatHafal : ayatHafal // ignore: cast_nullable_to_non_nullable
as List<int>,murajaahLevel: null == murajaahLevel ? _self.murajaahLevel : murajaahLevel // ignore: cast_nullable_to_non_nullable
as int,tanggalMulai: freezed == tanggalMulai ? _self.tanggalMulai : tanggalMulai // ignore: cast_nullable_to_non_nullable
as DateTime?,tanggalSelesai: freezed == tanggalSelesai ? _self.tanggalSelesai : tanggalSelesai // ignore: cast_nullable_to_non_nullable
as DateTime?,tanggalMurajaahBerikutnya: freezed == tanggalMurajaahBerikutnya ? _self.tanggalMurajaahBerikutnya : tanggalMurajaahBerikutnya // ignore: cast_nullable_to_non_nullable
as DateTime?,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HafalanSurat].
extension HafalanSuratPatterns on HafalanSurat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HafalanSurat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HafalanSurat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HafalanSurat value)  $default,){
final _that = this;
switch (_that) {
case _HafalanSurat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HafalanSurat value)?  $default,){
final _that = this;
switch (_that) {
case _HafalanSurat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int suratNomor,  String namaLatin,  String nama,  int jumlahAyat,  HafalanStatus status,  List<int> ayatHafal,  int murajaahLevel,  DateTime? tanggalMulai,  DateTime? tanggalSelesai,  DateTime? tanggalMurajaahBerikutnya,  String? catatan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HafalanSurat() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int suratNomor,  String namaLatin,  String nama,  int jumlahAyat,  HafalanStatus status,  List<int> ayatHafal,  int murajaahLevel,  DateTime? tanggalMulai,  DateTime? tanggalSelesai,  DateTime? tanggalMurajaahBerikutnya,  String? catatan)  $default,) {final _that = this;
switch (_that) {
case _HafalanSurat():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int suratNomor,  String namaLatin,  String nama,  int jumlahAyat,  HafalanStatus status,  List<int> ayatHafal,  int murajaahLevel,  DateTime? tanggalMulai,  DateTime? tanggalSelesai,  DateTime? tanggalMurajaahBerikutnya,  String? catatan)?  $default,) {final _that = this;
switch (_that) {
case _HafalanSurat() when $default != null:
return $default(_that.suratNomor,_that.namaLatin,_that.nama,_that.jumlahAyat,_that.status,_that.ayatHafal,_that.murajaahLevel,_that.tanggalMulai,_that.tanggalSelesai,_that.tanggalMurajaahBerikutnya,_that.catatan);case _:
  return null;

}
}

}

/// @nodoc


class _HafalanSurat extends HafalanSurat {
  const _HafalanSurat({required this.suratNomor, required this.namaLatin, required this.nama, required this.jumlahAyat, this.status = HafalanStatus.belum, final  List<int> ayatHafal = const [], this.murajaahLevel = 0, this.tanggalMulai, this.tanggalSelesai, this.tanggalMurajaahBerikutnya, this.catatan}): _ayatHafal = ayatHafal,super._();
  

@override final  int suratNomor;
@override final  String namaLatin;
@override final  String nama;
@override final  int jumlahAyat;
@override@JsonKey() final  HafalanStatus status;
/// Nomor ayat yang sudah ditandai hafal.
 final  List<int> _ayatHafal;
/// Nomor ayat yang sudah ditandai hafal.
@override@JsonKey() List<int> get ayatHafal {
  if (_ayatHafal is EqualUnmodifiableListView) return _ayatHafal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ayatHafal);
}

/// Level spaced repetition muraja'ah (0–5).
/// 5 = hafalan dianggap kuat, tidak ada reminder lagi.
@override@JsonKey() final  int murajaahLevel;
/// Tanggal pertama kali mulai menghafal surat ini.
@override final  DateTime? tanggalMulai;
/// Tanggal semua ayat selesai ditandai hafal.
@override final  DateTime? tanggalSelesai;
/// Tanggal muraja'ah berikutnya (dari spaced repetition).
@override final  DateTime? tanggalMurajaahBerikutnya;
/// Catatan pribadi opsional untuk surat ini.
@override final  String? catatan;

/// Create a copy of HafalanSurat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HafalanSuratCopyWith<_HafalanSurat> get copyWith => __$HafalanSuratCopyWithImpl<_HafalanSurat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HafalanSurat&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._ayatHafal, _ayatHafal)&&(identical(other.murajaahLevel, murajaahLevel) || other.murajaahLevel == murajaahLevel)&&(identical(other.tanggalMulai, tanggalMulai) || other.tanggalMulai == tanggalMulai)&&(identical(other.tanggalSelesai, tanggalSelesai) || other.tanggalSelesai == tanggalSelesai)&&(identical(other.tanggalMurajaahBerikutnya, tanggalMurajaahBerikutnya) || other.tanggalMurajaahBerikutnya == tanggalMurajaahBerikutnya)&&(identical(other.catatan, catatan) || other.catatan == catatan));
}


@override
int get hashCode => Object.hash(runtimeType,suratNomor,namaLatin,nama,jumlahAyat,status,const DeepCollectionEquality().hash(_ayatHafal),murajaahLevel,tanggalMulai,tanggalSelesai,tanggalMurajaahBerikutnya,catatan);

@override
String toString() {
  return 'HafalanSurat(suratNomor: $suratNomor, namaLatin: $namaLatin, nama: $nama, jumlahAyat: $jumlahAyat, status: $status, ayatHafal: $ayatHafal, murajaahLevel: $murajaahLevel, tanggalMulai: $tanggalMulai, tanggalSelesai: $tanggalSelesai, tanggalMurajaahBerikutnya: $tanggalMurajaahBerikutnya, catatan: $catatan)';
}


}

/// @nodoc
abstract mixin class _$HafalanSuratCopyWith<$Res> implements $HafalanSuratCopyWith<$Res> {
  factory _$HafalanSuratCopyWith(_HafalanSurat value, $Res Function(_HafalanSurat) _then) = __$HafalanSuratCopyWithImpl;
@override @useResult
$Res call({
 int suratNomor, String namaLatin, String nama, int jumlahAyat, HafalanStatus status, List<int> ayatHafal, int murajaahLevel, DateTime? tanggalMulai, DateTime? tanggalSelesai, DateTime? tanggalMurajaahBerikutnya, String? catatan
});




}
/// @nodoc
class __$HafalanSuratCopyWithImpl<$Res>
    implements _$HafalanSuratCopyWith<$Res> {
  __$HafalanSuratCopyWithImpl(this._self, this._then);

  final _HafalanSurat _self;
  final $Res Function(_HafalanSurat) _then;

/// Create a copy of HafalanSurat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suratNomor = null,Object? namaLatin = null,Object? nama = null,Object? jumlahAyat = null,Object? status = null,Object? ayatHafal = null,Object? murajaahLevel = null,Object? tanggalMulai = freezed,Object? tanggalSelesai = freezed,Object? tanggalMurajaahBerikutnya = freezed,Object? catatan = freezed,}) {
  return _then(_HafalanSurat(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HafalanStatus,ayatHafal: null == ayatHafal ? _self._ayatHafal : ayatHafal // ignore: cast_nullable_to_non_nullable
as List<int>,murajaahLevel: null == murajaahLevel ? _self.murajaahLevel : murajaahLevel // ignore: cast_nullable_to_non_nullable
as int,tanggalMulai: freezed == tanggalMulai ? _self.tanggalMulai : tanggalMulai // ignore: cast_nullable_to_non_nullable
as DateTime?,tanggalSelesai: freezed == tanggalSelesai ? _self.tanggalSelesai : tanggalSelesai // ignore: cast_nullable_to_non_nullable
as DateTime?,tanggalMurajaahBerikutnya: freezed == tanggalMurajaahBerikutnya ? _self.tanggalMurajaahBerikutnya : tanggalMurajaahBerikutnya // ignore: cast_nullable_to_non_nullable
as DateTime?,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
