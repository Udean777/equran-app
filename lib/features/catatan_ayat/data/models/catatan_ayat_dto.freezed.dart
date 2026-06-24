// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catatan_ayat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatatanAyatDto {

 int get suratNomor; int get ayatNomor; String get namaLatin; String get teksArab; String get isi; String get savedAt;
/// Create a copy of CatatanAyatDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatatanAyatDtoCopyWith<CatatanAyatDto> get copyWith => _$CatatanAyatDtoCopyWithImpl<CatatanAyatDto>(this as CatatanAyatDto, _$identity);

  /// Serializes this CatatanAyatDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatatanAyatDto&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.isi, isi) || other.isi == isi)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,teksArab,isi,savedAt);

@override
String toString() {
  return 'CatatanAyatDto(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, teksArab: $teksArab, isi: $isi, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class $CatatanAyatDtoCopyWith<$Res>  {
  factory $CatatanAyatDtoCopyWith(CatatanAyatDto value, $Res Function(CatatanAyatDto) _then) = _$CatatanAyatDtoCopyWithImpl;
@useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, String teksArab, String isi, String savedAt
});




}
/// @nodoc
class _$CatatanAyatDtoCopyWithImpl<$Res>
    implements $CatatanAyatDtoCopyWith<$Res> {
  _$CatatanAyatDtoCopyWithImpl(this._self, this._then);

  final CatatanAyatDto _self;
  final $Res Function(CatatanAyatDto) _then;

/// Create a copy of CatatanAyatDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? teksArab = null,Object? isi = null,Object? savedAt = null,}) {
  return _then(_self.copyWith(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,isi: null == isi ? _self.isi : isi // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatatanAyatDto].
extension CatatanAyatDtoPatterns on CatatanAyatDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatatanAyatDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatatanAyatDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatatanAyatDto value)  $default,){
final _that = this;
switch (_that) {
case _CatatanAyatDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatatanAyatDto value)?  $default,){
final _that = this;
switch (_that) {
case _CatatanAyatDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  String teksArab,  String isi,  String savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatatanAyatDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  String teksArab,  String isi,  String savedAt)  $default,) {final _that = this;
switch (_that) {
case _CatatanAyatDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int suratNomor,  int ayatNomor,  String namaLatin,  String teksArab,  String isi,  String savedAt)?  $default,) {final _that = this;
switch (_that) {
case _CatatanAyatDto() when $default != null:
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.teksArab,_that.isi,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatatanAyatDto implements CatatanAyatDto {
  const _CatatanAyatDto({required this.suratNomor, required this.ayatNomor, required this.namaLatin, required this.teksArab, required this.isi, required this.savedAt});
  factory _CatatanAyatDto.fromJson(Map<String, dynamic> json) => _$CatatanAyatDtoFromJson(json);

@override final  int suratNomor;
@override final  int ayatNomor;
@override final  String namaLatin;
@override final  String teksArab;
@override final  String isi;
@override final  String savedAt;

/// Create a copy of CatatanAyatDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatatanAyatDtoCopyWith<_CatatanAyatDto> get copyWith => __$CatatanAyatDtoCopyWithImpl<_CatatanAyatDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatatanAyatDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatatanAyatDto&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.isi, isi) || other.isi == isi)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,teksArab,isi,savedAt);

@override
String toString() {
  return 'CatatanAyatDto(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, teksArab: $teksArab, isi: $isi, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$CatatanAyatDtoCopyWith<$Res> implements $CatatanAyatDtoCopyWith<$Res> {
  factory _$CatatanAyatDtoCopyWith(_CatatanAyatDto value, $Res Function(_CatatanAyatDto) _then) = __$CatatanAyatDtoCopyWithImpl;
@override @useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, String teksArab, String isi, String savedAt
});




}
/// @nodoc
class __$CatatanAyatDtoCopyWithImpl<$Res>
    implements _$CatatanAyatDtoCopyWith<$Res> {
  __$CatatanAyatDtoCopyWithImpl(this._self, this._then);

  final _CatatanAyatDto _self;
  final $Res Function(_CatatanAyatDto) _then;

/// Create a copy of CatatanAyatDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? teksArab = null,Object? isi = null,Object? savedAt = null,}) {
  return _then(_CatatanAyatDto(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,isi: null == isi ? _self.isi : isi // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
