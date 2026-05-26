// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hafalan_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HafalanStats {

/// Total ayat yang sudah ditandai hafal dari semua surat.
 int get totalAyatHafal;/// Jumlah surat yang semua ayatnya sudah hafal.
 int get totalSuratSelesai;/// Persentase Al-Quran yang sudah dihafal (totalAyatHafal / 6236).
 double get persentaseQuran;/// Progress hafalan per juz: juzNomor → 0.0–1.0
 Map<int, double> get progressPerJuz;/// Jumlah surat yang sedang dalam proses hafalan.
 int get suratSedangDihafal;/// Jumlah surat yang jatuh tempo muraja'ah.
 int get suratPerluMurajaah;
/// Create a copy of HafalanStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanStatsCopyWith<HafalanStats> get copyWith => _$HafalanStatsCopyWithImpl<HafalanStats>(this as HafalanStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanStats&&(identical(other.totalAyatHafal, totalAyatHafal) || other.totalAyatHafal == totalAyatHafal)&&(identical(other.totalSuratSelesai, totalSuratSelesai) || other.totalSuratSelesai == totalSuratSelesai)&&(identical(other.persentaseQuran, persentaseQuran) || other.persentaseQuran == persentaseQuran)&&const DeepCollectionEquality().equals(other.progressPerJuz, progressPerJuz)&&(identical(other.suratSedangDihafal, suratSedangDihafal) || other.suratSedangDihafal == suratSedangDihafal)&&(identical(other.suratPerluMurajaah, suratPerluMurajaah) || other.suratPerluMurajaah == suratPerluMurajaah));
}


@override
int get hashCode => Object.hash(runtimeType,totalAyatHafal,totalSuratSelesai,persentaseQuran,const DeepCollectionEquality().hash(progressPerJuz),suratSedangDihafal,suratPerluMurajaah);

@override
String toString() {
  return 'HafalanStats(totalAyatHafal: $totalAyatHafal, totalSuratSelesai: $totalSuratSelesai, persentaseQuran: $persentaseQuran, progressPerJuz: $progressPerJuz, suratSedangDihafal: $suratSedangDihafal, suratPerluMurajaah: $suratPerluMurajaah)';
}


}

/// @nodoc
abstract mixin class $HafalanStatsCopyWith<$Res>  {
  factory $HafalanStatsCopyWith(HafalanStats value, $Res Function(HafalanStats) _then) = _$HafalanStatsCopyWithImpl;
@useResult
$Res call({
 int totalAyatHafal, int totalSuratSelesai, double persentaseQuran, Map<int, double> progressPerJuz, int suratSedangDihafal, int suratPerluMurajaah
});




}
/// @nodoc
class _$HafalanStatsCopyWithImpl<$Res>
    implements $HafalanStatsCopyWith<$Res> {
  _$HafalanStatsCopyWithImpl(this._self, this._then);

  final HafalanStats _self;
  final $Res Function(HafalanStats) _then;

/// Create a copy of HafalanStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalAyatHafal = null,Object? totalSuratSelesai = null,Object? persentaseQuran = null,Object? progressPerJuz = null,Object? suratSedangDihafal = null,Object? suratPerluMurajaah = null,}) {
  return _then(_self.copyWith(
totalAyatHafal: null == totalAyatHafal ? _self.totalAyatHafal : totalAyatHafal // ignore: cast_nullable_to_non_nullable
as int,totalSuratSelesai: null == totalSuratSelesai ? _self.totalSuratSelesai : totalSuratSelesai // ignore: cast_nullable_to_non_nullable
as int,persentaseQuran: null == persentaseQuran ? _self.persentaseQuran : persentaseQuran // ignore: cast_nullable_to_non_nullable
as double,progressPerJuz: null == progressPerJuz ? _self.progressPerJuz : progressPerJuz // ignore: cast_nullable_to_non_nullable
as Map<int, double>,suratSedangDihafal: null == suratSedangDihafal ? _self.suratSedangDihafal : suratSedangDihafal // ignore: cast_nullable_to_non_nullable
as int,suratPerluMurajaah: null == suratPerluMurajaah ? _self.suratPerluMurajaah : suratPerluMurajaah // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HafalanStats].
extension HafalanStatsPatterns on HafalanStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HafalanStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HafalanStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HafalanStats value)  $default,){
final _that = this;
switch (_that) {
case _HafalanStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HafalanStats value)?  $default,){
final _that = this;
switch (_that) {
case _HafalanStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalAyatHafal,  int totalSuratSelesai,  double persentaseQuran,  Map<int, double> progressPerJuz,  int suratSedangDihafal,  int suratPerluMurajaah)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HafalanStats() when $default != null:
return $default(_that.totalAyatHafal,_that.totalSuratSelesai,_that.persentaseQuran,_that.progressPerJuz,_that.suratSedangDihafal,_that.suratPerluMurajaah);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalAyatHafal,  int totalSuratSelesai,  double persentaseQuran,  Map<int, double> progressPerJuz,  int suratSedangDihafal,  int suratPerluMurajaah)  $default,) {final _that = this;
switch (_that) {
case _HafalanStats():
return $default(_that.totalAyatHafal,_that.totalSuratSelesai,_that.persentaseQuran,_that.progressPerJuz,_that.suratSedangDihafal,_that.suratPerluMurajaah);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalAyatHafal,  int totalSuratSelesai,  double persentaseQuran,  Map<int, double> progressPerJuz,  int suratSedangDihafal,  int suratPerluMurajaah)?  $default,) {final _that = this;
switch (_that) {
case _HafalanStats() when $default != null:
return $default(_that.totalAyatHafal,_that.totalSuratSelesai,_that.persentaseQuran,_that.progressPerJuz,_that.suratSedangDihafal,_that.suratPerluMurajaah);case _:
  return null;

}
}

}

/// @nodoc


class _HafalanStats extends HafalanStats {
  const _HafalanStats({required this.totalAyatHafal, required this.totalSuratSelesai, required this.persentaseQuran, required final  Map<int, double> progressPerJuz, required this.suratSedangDihafal, required this.suratPerluMurajaah}): _progressPerJuz = progressPerJuz,super._();
  

/// Total ayat yang sudah ditandai hafal dari semua surat.
@override final  int totalAyatHafal;
/// Jumlah surat yang semua ayatnya sudah hafal.
@override final  int totalSuratSelesai;
/// Persentase Al-Quran yang sudah dihafal (totalAyatHafal / 6236).
@override final  double persentaseQuran;
/// Progress hafalan per juz: juzNomor → 0.0–1.0
 final  Map<int, double> _progressPerJuz;
/// Progress hafalan per juz: juzNomor → 0.0–1.0
@override Map<int, double> get progressPerJuz {
  if (_progressPerJuz is EqualUnmodifiableMapView) return _progressPerJuz;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_progressPerJuz);
}

/// Jumlah surat yang sedang dalam proses hafalan.
@override final  int suratSedangDihafal;
/// Jumlah surat yang jatuh tempo muraja'ah.
@override final  int suratPerluMurajaah;

/// Create a copy of HafalanStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HafalanStatsCopyWith<_HafalanStats> get copyWith => __$HafalanStatsCopyWithImpl<_HafalanStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HafalanStats&&(identical(other.totalAyatHafal, totalAyatHafal) || other.totalAyatHafal == totalAyatHafal)&&(identical(other.totalSuratSelesai, totalSuratSelesai) || other.totalSuratSelesai == totalSuratSelesai)&&(identical(other.persentaseQuran, persentaseQuran) || other.persentaseQuran == persentaseQuran)&&const DeepCollectionEquality().equals(other._progressPerJuz, _progressPerJuz)&&(identical(other.suratSedangDihafal, suratSedangDihafal) || other.suratSedangDihafal == suratSedangDihafal)&&(identical(other.suratPerluMurajaah, suratPerluMurajaah) || other.suratPerluMurajaah == suratPerluMurajaah));
}


@override
int get hashCode => Object.hash(runtimeType,totalAyatHafal,totalSuratSelesai,persentaseQuran,const DeepCollectionEquality().hash(_progressPerJuz),suratSedangDihafal,suratPerluMurajaah);

@override
String toString() {
  return 'HafalanStats(totalAyatHafal: $totalAyatHafal, totalSuratSelesai: $totalSuratSelesai, persentaseQuran: $persentaseQuran, progressPerJuz: $progressPerJuz, suratSedangDihafal: $suratSedangDihafal, suratPerluMurajaah: $suratPerluMurajaah)';
}


}

/// @nodoc
abstract mixin class _$HafalanStatsCopyWith<$Res> implements $HafalanStatsCopyWith<$Res> {
  factory _$HafalanStatsCopyWith(_HafalanStats value, $Res Function(_HafalanStats) _then) = __$HafalanStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalAyatHafal, int totalSuratSelesai, double persentaseQuran, Map<int, double> progressPerJuz, int suratSedangDihafal, int suratPerluMurajaah
});




}
/// @nodoc
class __$HafalanStatsCopyWithImpl<$Res>
    implements _$HafalanStatsCopyWith<$Res> {
  __$HafalanStatsCopyWithImpl(this._self, this._then);

  final _HafalanStats _self;
  final $Res Function(_HafalanStats) _then;

/// Create a copy of HafalanStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalAyatHafal = null,Object? totalSuratSelesai = null,Object? persentaseQuran = null,Object? progressPerJuz = null,Object? suratSedangDihafal = null,Object? suratPerluMurajaah = null,}) {
  return _then(_HafalanStats(
totalAyatHafal: null == totalAyatHafal ? _self.totalAyatHafal : totalAyatHafal // ignore: cast_nullable_to_non_nullable
as int,totalSuratSelesai: null == totalSuratSelesai ? _self.totalSuratSelesai : totalSuratSelesai // ignore: cast_nullable_to_non_nullable
as int,persentaseQuran: null == persentaseQuran ? _self.persentaseQuran : persentaseQuran // ignore: cast_nullable_to_non_nullable
as double,progressPerJuz: null == progressPerJuz ? _self._progressPerJuz : progressPerJuz // ignore: cast_nullable_to_non_nullable
as Map<int, double>,suratSedangDihafal: null == suratSedangDihafal ? _self.suratSedangDihafal : suratSedangDihafal // ignore: cast_nullable_to_non_nullable
as int,suratPerluMurajaah: null == suratPerluMurajaah ? _self.suratPerluMurajaah : suratPerluMurajaah // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
