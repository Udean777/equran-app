// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catatan_ayat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatatanAyat {

 int get suratNomor; int get ayatNomor; String get namaLatin; String get teksArab; String get isi; DateTime get savedAt;
/// Create a copy of CatatanAyat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatatanAyatCopyWith<CatatanAyat> get copyWith => _$CatatanAyatCopyWithImpl<CatatanAyat>(this as CatatanAyat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatatanAyat&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.isi, isi) || other.isi == isi)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,teksArab,isi,savedAt);

@override
String toString() {
  return 'CatatanAyat(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, teksArab: $teksArab, isi: $isi, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $CatatanAyatCopyWith<$Res>  {
  factory $CatatanAyatCopyWith(CatatanAyat value, $Res Function(CatatanAyat) _then) = _$CatatanAyatCopyWithImpl;
@useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, String teksArab, String isi, DateTime savedAt
});




}
/// @nodoc
class _$CatatanAyatCopyWithImpl<$Res>
    implements $CatatanAyatCopyWith<$Res> {
  _$CatatanAyatCopyWithImpl(this._self, this._then);

  final CatatanAyat _self;
  final $Res Function(CatatanAyat) _then;

/// Create a copy of CatatanAyat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? teksArab = null,Object? isi = null,Object? savedAt = null,}) {
  return _then(_self.copyWith(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,isi: null == isi ? _self.isi : isi // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CatatanAyat].
extension CatatanAyatPatterns on CatatanAyat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatatanAyat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatatanAyat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatatanAyat value)  $default,){
final _that = this;
switch (_that) {
case _CatatanAyat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatatanAyat value)?  $default,){
final _that = this;
switch (_that) {
case _CatatanAyat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  String teksArab,  String isi,  DateTime savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatatanAyat() when $default != null:
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.teksArab,_that.isi,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  String teksArab,  String isi,  DateTime savedAt)  $default,) {final _that = this;
switch (_that) {
case _CatatanAyat():
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.teksArab,_that.isi,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int suratNomor,  int ayatNomor,  String namaLatin,  String teksArab,  String isi,  DateTime savedAt)?  $default,) {final _that = this;
switch (_that) {
case _CatatanAyat() when $default != null:
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.teksArab,_that.isi,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc


class _CatatanAyat implements CatatanAyat {
  const _CatatanAyat({required this.suratNomor, required this.ayatNomor, required this.namaLatin, required this.teksArab, required this.isi, required this.savedAt});
  

@override final  int suratNomor;
@override final  int ayatNomor;
@override final  String namaLatin;
@override final  String teksArab;
@override final  String isi;
@override final  DateTime savedAt;

/// Create a copy of CatatanAyat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatatanAyatCopyWith<_CatatanAyat> get copyWith => __$CatatanAyatCopyWithImpl<_CatatanAyat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatatanAyat&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.isi, isi) || other.isi == isi)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,teksArab,isi,savedAt);

@override
String toString() {
  return 'CatatanAyat(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, teksArab: $teksArab, isi: $isi, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$CatatanAyatCopyWith<$Res> implements $CatatanAyatCopyWith<$Res> {
  factory _$CatatanAyatCopyWith(_CatatanAyat value, $Res Function(_CatatanAyat) _then) = __$CatatanAyatCopyWithImpl;
@override @useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, String teksArab, String isi, DateTime savedAt
});




}
/// @nodoc
class __$CatatanAyatCopyWithImpl<$Res>
    implements _$CatatanAyatCopyWith<$Res> {
  __$CatatanAyatCopyWithImpl(this._self, this._then);

  final _CatatanAyat _self;
  final $Res Function(_CatatanAyat) _then;

/// Create a copy of CatatanAyat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? teksArab = null,Object? isi = null,Object? savedAt = null,}) {
  return _then(_CatatanAyat(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,isi: null == isi ? _self.isi : isi // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
