// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'last_read.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LastRead {

 int get suratNomor; int get ayatNomor; String get namaLatin; DateTime get readAt;/// Progress membaca: 0.0 (awal) – 1.0 (selesai).
/// Dihitung otomatis: ayatNomor / totalAyat.
 double get scrollPercent;/// Total ayat dalam surat — digunakan untuk hitung scrollPercent.
 int get totalAyat;
/// Create a copy of LastRead
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastReadCopyWith<LastRead> get copyWith => _$LastReadCopyWithImpl<LastRead>(this as LastRead, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastRead&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.scrollPercent, scrollPercent) || other.scrollPercent == scrollPercent)&&(identical(other.totalAyat, totalAyat) || other.totalAyat == totalAyat));
}


@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,readAt,scrollPercent,totalAyat);

@override
String toString() {
  return 'LastRead(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, readAt: $readAt, scrollPercent: $scrollPercent, totalAyat: $totalAyat)';
}


}

/// @nodoc
abstract mixin class $LastReadCopyWith<$Res>  {
  factory $LastReadCopyWith(LastRead value, $Res Function(LastRead) _then) = _$LastReadCopyWithImpl;
@useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, DateTime readAt, double scrollPercent, int totalAyat
});




}
/// @nodoc
class _$LastReadCopyWithImpl<$Res>
    implements $LastReadCopyWith<$Res> {
  _$LastReadCopyWithImpl(this._self, this._then);

  final LastRead _self;
  final $Res Function(LastRead) _then;

/// Create a copy of LastRead
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? readAt = null,Object? scrollPercent = null,Object? totalAyat = null,}) {
  return _then(_self.copyWith(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,scrollPercent: null == scrollPercent ? _self.scrollPercent : scrollPercent // ignore: cast_nullable_to_non_nullable
as double,totalAyat: null == totalAyat ? _self.totalAyat : totalAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LastRead].
extension LastReadPatterns on LastRead {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastRead value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastRead() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastRead value)  $default,){
final _that = this;
switch (_that) {
case _LastRead():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastRead value)?  $default,){
final _that = this;
switch (_that) {
case _LastRead() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  DateTime readAt,  double scrollPercent,  int totalAyat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastRead() when $default != null:
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.readAt,_that.scrollPercent,_that.totalAyat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  DateTime readAt,  double scrollPercent,  int totalAyat)  $default,) {final _that = this;
switch (_that) {
case _LastRead():
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.readAt,_that.scrollPercent,_that.totalAyat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int suratNomor,  int ayatNomor,  String namaLatin,  DateTime readAt,  double scrollPercent,  int totalAyat)?  $default,) {final _that = this;
switch (_that) {
case _LastRead() when $default != null:
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.readAt,_that.scrollPercent,_that.totalAyat);case _:
  return null;

}
}

}

/// @nodoc


class _LastRead implements LastRead {
  const _LastRead({required this.suratNomor, required this.ayatNomor, required this.namaLatin, required this.readAt, this.scrollPercent = 0.0, this.totalAyat = 0});
  

@override final  int suratNomor;
@override final  int ayatNomor;
@override final  String namaLatin;
@override final  DateTime readAt;
/// Progress membaca: 0.0 (awal) – 1.0 (selesai).
/// Dihitung otomatis: ayatNomor / totalAyat.
@override@JsonKey() final  double scrollPercent;
/// Total ayat dalam surat — digunakan untuk hitung scrollPercent.
@override@JsonKey() final  int totalAyat;

/// Create a copy of LastRead
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastReadCopyWith<_LastRead> get copyWith => __$LastReadCopyWithImpl<_LastRead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastRead&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.scrollPercent, scrollPercent) || other.scrollPercent == scrollPercent)&&(identical(other.totalAyat, totalAyat) || other.totalAyat == totalAyat));
}


@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,readAt,scrollPercent,totalAyat);

@override
String toString() {
  return 'LastRead(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, readAt: $readAt, scrollPercent: $scrollPercent, totalAyat: $totalAyat)';
}


}

/// @nodoc
abstract mixin class _$LastReadCopyWith<$Res> implements $LastReadCopyWith<$Res> {
  factory _$LastReadCopyWith(_LastRead value, $Res Function(_LastRead) _then) = __$LastReadCopyWithImpl;
@override @useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, DateTime readAt, double scrollPercent, int totalAyat
});




}
/// @nodoc
class __$LastReadCopyWithImpl<$Res>
    implements _$LastReadCopyWith<$Res> {
  __$LastReadCopyWithImpl(this._self, this._then);

  final _LastRead _self;
  final $Res Function(_LastRead) _then;

/// Create a copy of LastRead
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? readAt = null,Object? scrollPercent = null,Object? totalAyat = null,}) {
  return _then(_LastRead(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,scrollPercent: null == scrollPercent ? _self.scrollPercent : scrollPercent // ignore: cast_nullable_to_non_nullable
as double,totalAyat: null == totalAyat ? _self.totalAyat : totalAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
