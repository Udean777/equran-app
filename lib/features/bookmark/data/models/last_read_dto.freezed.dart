// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'last_read_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LastReadDto {

 int get suratNomor; int get ayatNomor; String get namaLatin; String get readAt; double get scrollPercent; double get maxScrollPercent; int get totalAyat;
/// Create a copy of LastReadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastReadDtoCopyWith<LastReadDto> get copyWith => _$LastReadDtoCopyWithImpl<LastReadDto>(this as LastReadDto, _$identity);

  /// Serializes this LastReadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastReadDto&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.scrollPercent, scrollPercent) || other.scrollPercent == scrollPercent)&&(identical(other.maxScrollPercent, maxScrollPercent) || other.maxScrollPercent == maxScrollPercent)&&(identical(other.totalAyat, totalAyat) || other.totalAyat == totalAyat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,readAt,scrollPercent,maxScrollPercent,totalAyat);

@override
String toString() {
  return 'LastReadDto(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, readAt: $readAt, scrollPercent: $scrollPercent, maxScrollPercent: $maxScrollPercent, totalAyat: $totalAyat)';
}


}

/// @nodoc
abstract mixin class $LastReadDtoCopyWith<$Res>  {
  factory $LastReadDtoCopyWith(LastReadDto value, $Res Function(LastReadDto) _then) = _$LastReadDtoCopyWithImpl;
@useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, String readAt, double scrollPercent, double maxScrollPercent, int totalAyat
});




}
/// @nodoc
class _$LastReadDtoCopyWithImpl<$Res>
    implements $LastReadDtoCopyWith<$Res> {
  _$LastReadDtoCopyWithImpl(this._self, this._then);

  final LastReadDto _self;
  final $Res Function(LastReadDto) _then;

/// Create a copy of LastReadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? readAt = null,Object? scrollPercent = null,Object? maxScrollPercent = null,Object? totalAyat = null,}) {
  return _then(_self.copyWith(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String,scrollPercent: null == scrollPercent ? _self.scrollPercent : scrollPercent // ignore: cast_nullable_to_non_nullable
as double,maxScrollPercent: null == maxScrollPercent ? _self.maxScrollPercent : maxScrollPercent // ignore: cast_nullable_to_non_nullable
as double,totalAyat: null == totalAyat ? _self.totalAyat : totalAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LastReadDto].
extension LastReadDtoPatterns on LastReadDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastReadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastReadDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastReadDto value)  $default,){
final _that = this;
switch (_that) {
case _LastReadDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastReadDto value)?  $default,){
final _that = this;
switch (_that) {
case _LastReadDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  String readAt,  double scrollPercent,  double maxScrollPercent,  int totalAyat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastReadDto() when $default != null:
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.readAt,_that.scrollPercent,_that.maxScrollPercent,_that.totalAyat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int suratNomor,  int ayatNomor,  String namaLatin,  String readAt,  double scrollPercent,  double maxScrollPercent,  int totalAyat)  $default,) {final _that = this;
switch (_that) {
case _LastReadDto():
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.readAt,_that.scrollPercent,_that.maxScrollPercent,_that.totalAyat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int suratNomor,  int ayatNomor,  String namaLatin,  String readAt,  double scrollPercent,  double maxScrollPercent,  int totalAyat)?  $default,) {final _that = this;
switch (_that) {
case _LastReadDto() when $default != null:
return $default(_that.suratNomor,_that.ayatNomor,_that.namaLatin,_that.readAt,_that.scrollPercent,_that.maxScrollPercent,_that.totalAyat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LastReadDto implements LastReadDto {
  const _LastReadDto({required this.suratNomor, required this.ayatNomor, required this.namaLatin, required this.readAt, this.scrollPercent = 0.0, this.maxScrollPercent = 0.0, this.totalAyat = 0});
  factory _LastReadDto.fromJson(Map<String, dynamic> json) => _$LastReadDtoFromJson(json);

@override final  int suratNomor;
@override final  int ayatNomor;
@override final  String namaLatin;
@override final  String readAt;
@override@JsonKey() final  double scrollPercent;
@override@JsonKey() final  double maxScrollPercent;
@override@JsonKey() final  int totalAyat;

/// Create a copy of LastReadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastReadDtoCopyWith<_LastReadDto> get copyWith => __$LastReadDtoCopyWithImpl<_LastReadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LastReadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastReadDto&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.scrollPercent, scrollPercent) || other.scrollPercent == scrollPercent)&&(identical(other.maxScrollPercent, maxScrollPercent) || other.maxScrollPercent == maxScrollPercent)&&(identical(other.totalAyat, totalAyat) || other.totalAyat == totalAyat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,ayatNomor,namaLatin,readAt,scrollPercent,maxScrollPercent,totalAyat);

@override
String toString() {
  return 'LastReadDto(suratNomor: $suratNomor, ayatNomor: $ayatNomor, namaLatin: $namaLatin, readAt: $readAt, scrollPercent: $scrollPercent, maxScrollPercent: $maxScrollPercent, totalAyat: $totalAyat)';
}


}

/// @nodoc
abstract mixin class _$LastReadDtoCopyWith<$Res> implements $LastReadDtoCopyWith<$Res> {
  factory _$LastReadDtoCopyWith(_LastReadDto value, $Res Function(_LastReadDto) _then) = __$LastReadDtoCopyWithImpl;
@override @useResult
$Res call({
 int suratNomor, int ayatNomor, String namaLatin, String readAt, double scrollPercent, double maxScrollPercent, int totalAyat
});




}
/// @nodoc
class __$LastReadDtoCopyWithImpl<$Res>
    implements _$LastReadDtoCopyWith<$Res> {
  __$LastReadDtoCopyWithImpl(this._self, this._then);

  final _LastReadDto _self;
  final $Res Function(_LastReadDto) _then;

/// Create a copy of LastReadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suratNomor = null,Object? ayatNomor = null,Object? namaLatin = null,Object? readAt = null,Object? scrollPercent = null,Object? maxScrollPercent = null,Object? totalAyat = null,}) {
  return _then(_LastReadDto(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String,scrollPercent: null == scrollPercent ? _self.scrollPercent : scrollPercent // ignore: cast_nullable_to_non_nullable
as double,maxScrollPercent: null == maxScrollPercent ? _self.maxScrollPercent : maxScrollPercent // ignore: cast_nullable_to_non_nullable
as double,totalAyat: null == totalAyat ? _self.totalAyat : totalAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
