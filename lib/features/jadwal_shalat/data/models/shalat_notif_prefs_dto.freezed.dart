// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shalat_notif_prefs_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShalatNotifPrefsDto {

 bool get subuh; bool get dzuhur; bool get ashar; bool get maghrib; bool get isya; int get menitSebelum;
/// Create a copy of ShalatNotifPrefsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalatNotifPrefsDtoCopyWith<ShalatNotifPrefsDto> get copyWith => _$ShalatNotifPrefsDtoCopyWithImpl<ShalatNotifPrefsDto>(this as ShalatNotifPrefsDto, _$identity);

  /// Serializes this ShalatNotifPrefsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalatNotifPrefsDto&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya)&&(identical(other.menitSebelum, menitSebelum) || other.menitSebelum == menitSebelum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subuh,dzuhur,ashar,maghrib,isya,menitSebelum);

@override
String toString() {
  return 'ShalatNotifPrefsDto(subuh: $subuh, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya, menitSebelum: $menitSebelum)';
}


}

/// @nodoc
abstract mixin class $ShalatNotifPrefsDtoCopyWith<$Res>  {
  factory $ShalatNotifPrefsDtoCopyWith(ShalatNotifPrefsDto value, $Res Function(ShalatNotifPrefsDto) _then) = _$ShalatNotifPrefsDtoCopyWithImpl;
@useResult
$Res call({
 bool subuh, bool dzuhur, bool ashar, bool maghrib, bool isya, int menitSebelum
});




}
/// @nodoc
class _$ShalatNotifPrefsDtoCopyWithImpl<$Res>
    implements $ShalatNotifPrefsDtoCopyWith<$Res> {
  _$ShalatNotifPrefsDtoCopyWithImpl(this._self, this._then);

  final ShalatNotifPrefsDto _self;
  final $Res Function(ShalatNotifPrefsDto) _then;

/// Create a copy of ShalatNotifPrefsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subuh = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,Object? menitSebelum = null,}) {
  return _then(_self.copyWith(
subuh: null == subuh ? _self.subuh : subuh // ignore: cast_nullable_to_non_nullable
as bool,dzuhur: null == dzuhur ? _self.dzuhur : dzuhur // ignore: cast_nullable_to_non_nullable
as bool,ashar: null == ashar ? _self.ashar : ashar // ignore: cast_nullable_to_non_nullable
as bool,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as bool,isya: null == isya ? _self.isya : isya // ignore: cast_nullable_to_non_nullable
as bool,menitSebelum: null == menitSebelum ? _self.menitSebelum : menitSebelum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShalatNotifPrefsDto].
extension ShalatNotifPrefsDtoPatterns on ShalatNotifPrefsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShalatNotifPrefsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShalatNotifPrefsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShalatNotifPrefsDto value)  $default,){
final _that = this;
switch (_that) {
case _ShalatNotifPrefsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShalatNotifPrefsDto value)?  $default,){
final _that = this;
switch (_that) {
case _ShalatNotifPrefsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool subuh,  bool dzuhur,  bool ashar,  bool maghrib,  bool isya,  int menitSebelum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShalatNotifPrefsDto() when $default != null:
return $default(_that.subuh,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya,_that.menitSebelum);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool subuh,  bool dzuhur,  bool ashar,  bool maghrib,  bool isya,  int menitSebelum)  $default,) {final _that = this;
switch (_that) {
case _ShalatNotifPrefsDto():
return $default(_that.subuh,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya,_that.menitSebelum);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool subuh,  bool dzuhur,  bool ashar,  bool maghrib,  bool isya,  int menitSebelum)?  $default,) {final _that = this;
switch (_that) {
case _ShalatNotifPrefsDto() when $default != null:
return $default(_that.subuh,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya,_that.menitSebelum);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShalatNotifPrefsDto implements ShalatNotifPrefsDto {
  const _ShalatNotifPrefsDto({this.subuh = true, this.dzuhur = true, this.ashar = true, this.maghrib = true, this.isya = true, this.menitSebelum = 0});
  factory _ShalatNotifPrefsDto.fromJson(Map<String, dynamic> json) => _$ShalatNotifPrefsDtoFromJson(json);

@override@JsonKey() final  bool subuh;
@override@JsonKey() final  bool dzuhur;
@override@JsonKey() final  bool ashar;
@override@JsonKey() final  bool maghrib;
@override@JsonKey() final  bool isya;
@override@JsonKey() final  int menitSebelum;

/// Create a copy of ShalatNotifPrefsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShalatNotifPrefsDtoCopyWith<_ShalatNotifPrefsDto> get copyWith => __$ShalatNotifPrefsDtoCopyWithImpl<_ShalatNotifPrefsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShalatNotifPrefsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShalatNotifPrefsDto&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya)&&(identical(other.menitSebelum, menitSebelum) || other.menitSebelum == menitSebelum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subuh,dzuhur,ashar,maghrib,isya,menitSebelum);

@override
String toString() {
  return 'ShalatNotifPrefsDto(subuh: $subuh, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya, menitSebelum: $menitSebelum)';
}


}

/// @nodoc
abstract mixin class _$ShalatNotifPrefsDtoCopyWith<$Res> implements $ShalatNotifPrefsDtoCopyWith<$Res> {
  factory _$ShalatNotifPrefsDtoCopyWith(_ShalatNotifPrefsDto value, $Res Function(_ShalatNotifPrefsDto) _then) = __$ShalatNotifPrefsDtoCopyWithImpl;
@override @useResult
$Res call({
 bool subuh, bool dzuhur, bool ashar, bool maghrib, bool isya, int menitSebelum
});




}
/// @nodoc
class __$ShalatNotifPrefsDtoCopyWithImpl<$Res>
    implements _$ShalatNotifPrefsDtoCopyWith<$Res> {
  __$ShalatNotifPrefsDtoCopyWithImpl(this._self, this._then);

  final _ShalatNotifPrefsDto _self;
  final $Res Function(_ShalatNotifPrefsDto) _then;

/// Create a copy of ShalatNotifPrefsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subuh = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,Object? menitSebelum = null,}) {
  return _then(_ShalatNotifPrefsDto(
subuh: null == subuh ? _self.subuh : subuh // ignore: cast_nullable_to_non_nullable
as bool,dzuhur: null == dzuhur ? _self.dzuhur : dzuhur // ignore: cast_nullable_to_non_nullable
as bool,ashar: null == ashar ? _self.ashar : ashar // ignore: cast_nullable_to_non_nullable
as bool,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as bool,isya: null == isya ? _self.isya : isya // ignore: cast_nullable_to_non_nullable
as bool,menitSebelum: null == menitSebelum ? _self.menitSebelum : menitSebelum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
