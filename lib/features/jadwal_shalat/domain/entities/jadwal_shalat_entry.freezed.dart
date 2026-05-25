// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jadwal_shalat_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JadwalShalatEntry {

 int get tanggal; String get tanggalLengkap; String get hari; String get imsak; String get subuh; String get terbit; String get dhuha; String get dzuhur; String get ashar; String get maghrib; String get isya;
/// Create a copy of JadwalShalatEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadwalShalatEntryCopyWith<JadwalShalatEntry> get copyWith => _$JadwalShalatEntryCopyWithImpl<JadwalShalatEntry>(this as JadwalShalatEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadwalShalatEntry&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.tanggalLengkap, tanggalLengkap) || other.tanggalLengkap == tanggalLengkap)&&(identical(other.hari, hari) || other.hari == hari)&&(identical(other.imsak, imsak) || other.imsak == imsak)&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.terbit, terbit) || other.terbit == terbit)&&(identical(other.dhuha, dhuha) || other.dhuha == dhuha)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya));
}


@override
int get hashCode => Object.hash(runtimeType,tanggal,tanggalLengkap,hari,imsak,subuh,terbit,dhuha,dzuhur,ashar,maghrib,isya);

@override
String toString() {
  return 'JadwalShalatEntry(tanggal: $tanggal, tanggalLengkap: $tanggalLengkap, hari: $hari, imsak: $imsak, subuh: $subuh, terbit: $terbit, dhuha: $dhuha, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya)';
}


}

/// @nodoc
abstract mixin class $JadwalShalatEntryCopyWith<$Res>  {
  factory $JadwalShalatEntryCopyWith(JadwalShalatEntry value, $Res Function(JadwalShalatEntry) _then) = _$JadwalShalatEntryCopyWithImpl;
@useResult
$Res call({
 int tanggal, String tanggalLengkap, String hari, String imsak, String subuh, String terbit, String dhuha, String dzuhur, String ashar, String maghrib, String isya
});




}
/// @nodoc
class _$JadwalShalatEntryCopyWithImpl<$Res>
    implements $JadwalShalatEntryCopyWith<$Res> {
  _$JadwalShalatEntryCopyWithImpl(this._self, this._then);

  final JadwalShalatEntry _self;
  final $Res Function(JadwalShalatEntry) _then;

/// Create a copy of JadwalShalatEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tanggal = null,Object? tanggalLengkap = null,Object? hari = null,Object? imsak = null,Object? subuh = null,Object? terbit = null,Object? dhuha = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,}) {
  return _then(_self.copyWith(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as int,tanggalLengkap: null == tanggalLengkap ? _self.tanggalLengkap : tanggalLengkap // ignore: cast_nullable_to_non_nullable
as String,hari: null == hari ? _self.hari : hari // ignore: cast_nullable_to_non_nullable
as String,imsak: null == imsak ? _self.imsak : imsak // ignore: cast_nullable_to_non_nullable
as String,subuh: null == subuh ? _self.subuh : subuh // ignore: cast_nullable_to_non_nullable
as String,terbit: null == terbit ? _self.terbit : terbit // ignore: cast_nullable_to_non_nullable
as String,dhuha: null == dhuha ? _self.dhuha : dhuha // ignore: cast_nullable_to_non_nullable
as String,dzuhur: null == dzuhur ? _self.dzuhur : dzuhur // ignore: cast_nullable_to_non_nullable
as String,ashar: null == ashar ? _self.ashar : ashar // ignore: cast_nullable_to_non_nullable
as String,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as String,isya: null == isya ? _self.isya : isya // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JadwalShalatEntry].
extension JadwalShalatEntryPatterns on JadwalShalatEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JadwalShalatEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JadwalShalatEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JadwalShalatEntry value)  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JadwalShalatEntry value)?  $default,){
final _that = this;
switch (_that) {
case _JadwalShalatEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tanggal,  String tanggalLengkap,  String hari,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JadwalShalatEntry() when $default != null:
return $default(_that.tanggal,_that.tanggalLengkap,_that.hari,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tanggal,  String tanggalLengkap,  String hari,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatEntry():
return $default(_that.tanggal,_that.tanggalLengkap,_that.hari,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tanggal,  String tanggalLengkap,  String hari,  String imsak,  String subuh,  String terbit,  String dhuha,  String dzuhur,  String ashar,  String maghrib,  String isya)?  $default,) {final _that = this;
switch (_that) {
case _JadwalShalatEntry() when $default != null:
return $default(_that.tanggal,_that.tanggalLengkap,_that.hari,_that.imsak,_that.subuh,_that.terbit,_that.dhuha,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya);case _:
  return null;

}
}

}

/// @nodoc


class _JadwalShalatEntry implements JadwalShalatEntry {
  const _JadwalShalatEntry({required this.tanggal, required this.tanggalLengkap, required this.hari, required this.imsak, required this.subuh, required this.terbit, required this.dhuha, required this.dzuhur, required this.ashar, required this.maghrib, required this.isya});
  

@override final  int tanggal;
@override final  String tanggalLengkap;
@override final  String hari;
@override final  String imsak;
@override final  String subuh;
@override final  String terbit;
@override final  String dhuha;
@override final  String dzuhur;
@override final  String ashar;
@override final  String maghrib;
@override final  String isya;

/// Create a copy of JadwalShalatEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JadwalShalatEntryCopyWith<_JadwalShalatEntry> get copyWith => __$JadwalShalatEntryCopyWithImpl<_JadwalShalatEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JadwalShalatEntry&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.tanggalLengkap, tanggalLengkap) || other.tanggalLengkap == tanggalLengkap)&&(identical(other.hari, hari) || other.hari == hari)&&(identical(other.imsak, imsak) || other.imsak == imsak)&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.terbit, terbit) || other.terbit == terbit)&&(identical(other.dhuha, dhuha) || other.dhuha == dhuha)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya));
}


@override
int get hashCode => Object.hash(runtimeType,tanggal,tanggalLengkap,hari,imsak,subuh,terbit,dhuha,dzuhur,ashar,maghrib,isya);

@override
String toString() {
  return 'JadwalShalatEntry(tanggal: $tanggal, tanggalLengkap: $tanggalLengkap, hari: $hari, imsak: $imsak, subuh: $subuh, terbit: $terbit, dhuha: $dhuha, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya)';
}


}

/// @nodoc
abstract mixin class _$JadwalShalatEntryCopyWith<$Res> implements $JadwalShalatEntryCopyWith<$Res> {
  factory _$JadwalShalatEntryCopyWith(_JadwalShalatEntry value, $Res Function(_JadwalShalatEntry) _then) = __$JadwalShalatEntryCopyWithImpl;
@override @useResult
$Res call({
 int tanggal, String tanggalLengkap, String hari, String imsak, String subuh, String terbit, String dhuha, String dzuhur, String ashar, String maghrib, String isya
});




}
/// @nodoc
class __$JadwalShalatEntryCopyWithImpl<$Res>
    implements _$JadwalShalatEntryCopyWith<$Res> {
  __$JadwalShalatEntryCopyWithImpl(this._self, this._then);

  final _JadwalShalatEntry _self;
  final $Res Function(_JadwalShalatEntry) _then;

/// Create a copy of JadwalShalatEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tanggal = null,Object? tanggalLengkap = null,Object? hari = null,Object? imsak = null,Object? subuh = null,Object? terbit = null,Object? dhuha = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,}) {
  return _then(_JadwalShalatEntry(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as int,tanggalLengkap: null == tanggalLengkap ? _self.tanggalLengkap : tanggalLengkap // ignore: cast_nullable_to_non_nullable
as String,hari: null == hari ? _self.hari : hari // ignore: cast_nullable_to_non_nullable
as String,imsak: null == imsak ? _self.imsak : imsak // ignore: cast_nullable_to_non_nullable
as String,subuh: null == subuh ? _self.subuh : subuh // ignore: cast_nullable_to_non_nullable
as String,terbit: null == terbit ? _self.terbit : terbit // ignore: cast_nullable_to_non_nullable
as String,dhuha: null == dhuha ? _self.dhuha : dhuha // ignore: cast_nullable_to_non_nullable
as String,dzuhur: null == dzuhur ? _self.dzuhur : dzuhur // ignore: cast_nullable_to_non_nullable
as String,ashar: null == ashar ? _self.ashar : ashar // ignore: cast_nullable_to_non_nullable
as String,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as String,isya: null == isya ? _self.isya : isya // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
