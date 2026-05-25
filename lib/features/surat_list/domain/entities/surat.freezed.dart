// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Surat {

 int get nomor; String get nama; String get namaLatin; int get jumlahAyat; TempatTurun get tempatTurun; String get arti;
/// Create a copy of Surat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratCopyWith<Surat> get copyWith => _$SuratCopyWithImpl<Surat>(this as Surat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Surat&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti));
}


@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti);

@override
String toString() {
  return 'Surat(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti)';
}


}

/// @nodoc
abstract mixin class $SuratCopyWith<$Res>  {
  factory $SuratCopyWith(Surat value, $Res Function(Surat) _then) = _$SuratCopyWithImpl;
@useResult
$Res call({
 int nomor, String nama, String namaLatin, int jumlahAyat, TempatTurun tempatTurun, String arti
});




}
/// @nodoc
class _$SuratCopyWithImpl<$Res>
    implements $SuratCopyWith<$Res> {
  _$SuratCopyWithImpl(this._self, this._then);

  final Surat _self;
  final $Res Function(Surat) _then;

/// Create a copy of Surat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,}) {
  return _then(_self.copyWith(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as TempatTurun,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Surat].
extension SuratPatterns on Surat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Surat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Surat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Surat value)  $default,){
final _that = this;
switch (_that) {
case _Surat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Surat value)?  $default,){
final _that = this;
switch (_that) {
case _Surat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomor,  String nama,  String namaLatin,  int jumlahAyat,  TempatTurun tempatTurun,  String arti)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Surat() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomor,  String nama,  String namaLatin,  int jumlahAyat,  TempatTurun tempatTurun,  String arti)  $default,) {final _that = this;
switch (_that) {
case _Surat():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomor,  String nama,  String namaLatin,  int jumlahAyat,  TempatTurun tempatTurun,  String arti)?  $default,) {final _that = this;
switch (_that) {
case _Surat() when $default != null:
return $default(_that.nomor,_that.nama,_that.namaLatin,_that.jumlahAyat,_that.tempatTurun,_that.arti);case _:
  return null;

}
}

}

/// @nodoc


class _Surat implements Surat {
  const _Surat({required this.nomor, required this.nama, required this.namaLatin, required this.jumlahAyat, required this.tempatTurun, required this.arti});
  

@override final  int nomor;
@override final  String nama;
@override final  String namaLatin;
@override final  int jumlahAyat;
@override final  TempatTurun tempatTurun;
@override final  String arti;

/// Create a copy of Surat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratCopyWith<_Surat> get copyWith => __$SuratCopyWithImpl<_Surat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Surat&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat)&&(identical(other.tempatTurun, tempatTurun) || other.tempatTurun == tempatTurun)&&(identical(other.arti, arti) || other.arti == arti));
}


@override
int get hashCode => Object.hash(runtimeType,nomor,nama,namaLatin,jumlahAyat,tempatTurun,arti);

@override
String toString() {
  return 'Surat(nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti)';
}


}

/// @nodoc
abstract mixin class _$SuratCopyWith<$Res> implements $SuratCopyWith<$Res> {
  factory _$SuratCopyWith(_Surat value, $Res Function(_Surat) _then) = __$SuratCopyWithImpl;
@override @useResult
$Res call({
 int nomor, String nama, String namaLatin, int jumlahAyat, TempatTurun tempatTurun, String arti
});




}
/// @nodoc
class __$SuratCopyWithImpl<$Res>
    implements _$SuratCopyWith<$Res> {
  __$SuratCopyWithImpl(this._self, this._then);

  final _Surat _self;
  final $Res Function(_Surat) _then;

/// Create a copy of Surat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomor = null,Object? nama = null,Object? namaLatin = null,Object? jumlahAyat = null,Object? tempatTurun = null,Object? arti = null,}) {
  return _then(_Surat(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,tempatTurun: null == tempatTurun ? _self.tempatTurun : tempatTurun // ignore: cast_nullable_to_non_nullable
as TempatTurun,arti: null == arti ? _self.arti : arti // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
