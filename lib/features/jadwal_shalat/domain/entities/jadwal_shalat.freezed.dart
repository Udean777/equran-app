// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jadwal_shalat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JadwalShalat {

 String get provinsi; String get kabkota; int get bulan; int get tahun; String get bulanNama; List<JadwalShalatEntry> get jadwal;
/// Create a copy of JadwalShalat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadwalShalatCopyWith<JadwalShalat> get copyWith => _$JadwalShalatCopyWithImpl<JadwalShalat>(this as JadwalShalat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadwalShalat&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.bulan, bulan) || other.bulan == bulan)&&(identical(other.tahun, tahun) || other.tahun == tahun)&&(identical(other.bulanNama, bulanNama) || other.bulanNama == bulanNama)&&const DeepCollectionEquality().equals(other.jadwal, jadwal));
}


@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,bulan,tahun,bulanNama,const DeepCollectionEquality().hash(jadwal));

@override
String toString() {
  return 'JadwalShalat(provinsi: $provinsi, kabkota: $kabkota, bulan: $bulan, tahun: $tahun, bulanNama: $bulanNama, jadwal: $jadwal)';
}


}

/// @nodoc
abstract mixin class $JadwalShalatCopyWith<$Res>  {
  factory $JadwalShalatCopyWith(JadwalShalat value, $Res Function(JadwalShalat) _then) = _$JadwalShalatCopyWithImpl;
@useResult
$Res call({
 String provinsi, String kabkota, int bulan, int tahun, String bulanNama, List<JadwalShalatEntry> jadwal
});




}
/// @nodoc
class _$JadwalShalatCopyWithImpl<$Res>
    implements $JadwalShalatCopyWith<$Res> {
  _$JadwalShalatCopyWithImpl(this._self, this._then);

  final JadwalShalat _self;
  final $Res Function(JadwalShalat) _then;

/// Create a copy of JadwalShalat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provinsi = null,Object? kabkota = null,Object? bulan = null,Object? tahun = null,Object? bulanNama = null,Object? jadwal = null,}) {
  return _then(_self.copyWith(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,bulan: null == bulan ? _self.bulan : bulan // ignore: cast_nullable_to_non_nullable
as int,tahun: null == tahun ? _self.tahun : tahun // ignore: cast_nullable_to_non_nullable
as int,bulanNama: null == bulanNama ? _self.bulanNama : bulanNama // ignore: cast_nullable_to_non_nullable
as String,jadwal: null == jadwal ? _self.jadwal : jadwal // ignore: cast_nullable_to_non_nullable
as List<JadwalShalatEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [JadwalShalat].
extension JadwalShalatPatterns on JadwalShalat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JadwalShalat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JadwalShalat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JadwalShalat value)  $default,){
final _that = this;
switch (_that) {
case _JadwalShalat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JadwalShalat value)?  $default,){
final _that = this;
switch (_that) {
case _JadwalShalat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  int bulan,  int tahun,  String bulanNama,  List<JadwalShalatEntry> jadwal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JadwalShalat() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  int bulan,  int tahun,  String bulanNama,  List<JadwalShalatEntry> jadwal)  $default,) {final _that = this;
switch (_that) {
case _JadwalShalat():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provinsi,  String kabkota,  int bulan,  int tahun,  String bulanNama,  List<JadwalShalatEntry> jadwal)?  $default,) {final _that = this;
switch (_that) {
case _JadwalShalat() when $default != null:
return $default(_that.provinsi,_that.kabkota,_that.bulan,_that.tahun,_that.bulanNama,_that.jadwal);case _:
  return null;

}
}

}

/// @nodoc


class _JadwalShalat implements JadwalShalat {
  const _JadwalShalat({required this.provinsi, required this.kabkota, required this.bulan, required this.tahun, required this.bulanNama, required final  List<JadwalShalatEntry> jadwal}): _jadwal = jadwal;
  

@override final  String provinsi;
@override final  String kabkota;
@override final  int bulan;
@override final  int tahun;
@override final  String bulanNama;
 final  List<JadwalShalatEntry> _jadwal;
@override List<JadwalShalatEntry> get jadwal {
  if (_jadwal is EqualUnmodifiableListView) return _jadwal;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jadwal);
}


/// Create a copy of JadwalShalat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JadwalShalatCopyWith<_JadwalShalat> get copyWith => __$JadwalShalatCopyWithImpl<_JadwalShalat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JadwalShalat&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.bulan, bulan) || other.bulan == bulan)&&(identical(other.tahun, tahun) || other.tahun == tahun)&&(identical(other.bulanNama, bulanNama) || other.bulanNama == bulanNama)&&const DeepCollectionEquality().equals(other._jadwal, _jadwal));
}


@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,bulan,tahun,bulanNama,const DeepCollectionEquality().hash(_jadwal));

@override
String toString() {
  return 'JadwalShalat(provinsi: $provinsi, kabkota: $kabkota, bulan: $bulan, tahun: $tahun, bulanNama: $bulanNama, jadwal: $jadwal)';
}


}

/// @nodoc
abstract mixin class _$JadwalShalatCopyWith<$Res> implements $JadwalShalatCopyWith<$Res> {
  factory _$JadwalShalatCopyWith(_JadwalShalat value, $Res Function(_JadwalShalat) _then) = __$JadwalShalatCopyWithImpl;
@override @useResult
$Res call({
 String provinsi, String kabkota, int bulan, int tahun, String bulanNama, List<JadwalShalatEntry> jadwal
});




}
/// @nodoc
class __$JadwalShalatCopyWithImpl<$Res>
    implements _$JadwalShalatCopyWith<$Res> {
  __$JadwalShalatCopyWithImpl(this._self, this._then);

  final _JadwalShalat _self;
  final $Res Function(_JadwalShalat) _then;

/// Create a copy of JadwalShalat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provinsi = null,Object? kabkota = null,Object? bulan = null,Object? tahun = null,Object? bulanNama = null,Object? jadwal = null,}) {
  return _then(_JadwalShalat(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,bulan: null == bulan ? _self.bulan : bulan // ignore: cast_nullable_to_non_nullable
as int,tahun: null == tahun ? _self.tahun : tahun // ignore: cast_nullable_to_non_nullable
as int,bulanNama: null == bulanNama ? _self.bulanNama : bulanNama // ignore: cast_nullable_to_non_nullable
as String,jadwal: null == jadwal ? _self._jadwal : jadwal // ignore: cast_nullable_to_non_nullable
as List<JadwalShalatEntry>,
  ));
}


}

// dart format on
