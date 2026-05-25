// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shalat_notif_prefs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShalatNotifPrefs {

 bool get subuh; bool get dzuhur; bool get ashar; bool get maghrib; bool get isya;/// Menit sebelum waktu shalat untuk notifikasi.
/// Nilai valid: 0, 5, 10, 15.
 int get menitSebelum;
/// Create a copy of ShalatNotifPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalatNotifPrefsCopyWith<ShalatNotifPrefs> get copyWith => _$ShalatNotifPrefsCopyWithImpl<ShalatNotifPrefs>(this as ShalatNotifPrefs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalatNotifPrefs&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya)&&(identical(other.menitSebelum, menitSebelum) || other.menitSebelum == menitSebelum));
}


@override
int get hashCode => Object.hash(runtimeType,subuh,dzuhur,ashar,maghrib,isya,menitSebelum);

@override
String toString() {
  return 'ShalatNotifPrefs(subuh: $subuh, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya, menitSebelum: $menitSebelum)';
}


}

/// @nodoc
abstract mixin class $ShalatNotifPrefsCopyWith<$Res>  {
  factory $ShalatNotifPrefsCopyWith(ShalatNotifPrefs value, $Res Function(ShalatNotifPrefs) _then) = _$ShalatNotifPrefsCopyWithImpl;
@useResult
$Res call({
 bool subuh, bool dzuhur, bool ashar, bool maghrib, bool isya, int menitSebelum
});




}
/// @nodoc
class _$ShalatNotifPrefsCopyWithImpl<$Res>
    implements $ShalatNotifPrefsCopyWith<$Res> {
  _$ShalatNotifPrefsCopyWithImpl(this._self, this._then);

  final ShalatNotifPrefs _self;
  final $Res Function(ShalatNotifPrefs) _then;

/// Create a copy of ShalatNotifPrefs
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


/// Adds pattern-matching-related methods to [ShalatNotifPrefs].
extension ShalatNotifPrefsPatterns on ShalatNotifPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShalatNotifPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShalatNotifPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShalatNotifPrefs value)  $default,){
final _that = this;
switch (_that) {
case _ShalatNotifPrefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShalatNotifPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _ShalatNotifPrefs() when $default != null:
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
case _ShalatNotifPrefs() when $default != null:
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
case _ShalatNotifPrefs():
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
case _ShalatNotifPrefs() when $default != null:
return $default(_that.subuh,_that.dzuhur,_that.ashar,_that.maghrib,_that.isya,_that.menitSebelum);case _:
  return null;

}
}

}

/// @nodoc


class _ShalatNotifPrefs implements ShalatNotifPrefs {
  const _ShalatNotifPrefs({this.subuh = true, this.dzuhur = true, this.ashar = true, this.maghrib = true, this.isya = true, this.menitSebelum = 0});
  

@override@JsonKey() final  bool subuh;
@override@JsonKey() final  bool dzuhur;
@override@JsonKey() final  bool ashar;
@override@JsonKey() final  bool maghrib;
@override@JsonKey() final  bool isya;
/// Menit sebelum waktu shalat untuk notifikasi.
/// Nilai valid: 0, 5, 10, 15.
@override@JsonKey() final  int menitSebelum;

/// Create a copy of ShalatNotifPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShalatNotifPrefsCopyWith<_ShalatNotifPrefs> get copyWith => __$ShalatNotifPrefsCopyWithImpl<_ShalatNotifPrefs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShalatNotifPrefs&&(identical(other.subuh, subuh) || other.subuh == subuh)&&(identical(other.dzuhur, dzuhur) || other.dzuhur == dzuhur)&&(identical(other.ashar, ashar) || other.ashar == ashar)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isya, isya) || other.isya == isya)&&(identical(other.menitSebelum, menitSebelum) || other.menitSebelum == menitSebelum));
}


@override
int get hashCode => Object.hash(runtimeType,subuh,dzuhur,ashar,maghrib,isya,menitSebelum);

@override
String toString() {
  return 'ShalatNotifPrefs(subuh: $subuh, dzuhur: $dzuhur, ashar: $ashar, maghrib: $maghrib, isya: $isya, menitSebelum: $menitSebelum)';
}


}

/// @nodoc
abstract mixin class _$ShalatNotifPrefsCopyWith<$Res> implements $ShalatNotifPrefsCopyWith<$Res> {
  factory _$ShalatNotifPrefsCopyWith(_ShalatNotifPrefs value, $Res Function(_ShalatNotifPrefs) _then) = __$ShalatNotifPrefsCopyWithImpl;
@override @useResult
$Res call({
 bool subuh, bool dzuhur, bool ashar, bool maghrib, bool isya, int menitSebelum
});




}
/// @nodoc
class __$ShalatNotifPrefsCopyWithImpl<$Res>
    implements _$ShalatNotifPrefsCopyWith<$Res> {
  __$ShalatNotifPrefsCopyWithImpl(this._self, this._then);

  final _ShalatNotifPrefs _self;
  final $Res Function(_ShalatNotifPrefs) _then;

/// Create a copy of ShalatNotifPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subuh = null,Object? dzuhur = null,Object? ashar = null,Object? maghrib = null,Object? isya = null,Object? menitSebelum = null,}) {
  return _then(_ShalatNotifPrefs(
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
