// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imsakiyah.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Imsakiyah {

 String get provinsi; String get kabkota; String get hijriah; String get masehi; List<ImsakiyahEntry> get imsakiyah;
/// Create a copy of Imsakiyah
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImsakiyahCopyWith<Imsakiyah> get copyWith => _$ImsakiyahCopyWithImpl<Imsakiyah>(this as Imsakiyah, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Imsakiyah&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.hijriah, hijriah) || other.hijriah == hijriah)&&(identical(other.masehi, masehi) || other.masehi == masehi)&&const DeepCollectionEquality().equals(other.imsakiyah, imsakiyah));
}


@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,hijriah,masehi,const DeepCollectionEquality().hash(imsakiyah));

@override
String toString() {
  return 'Imsakiyah(provinsi: $provinsi, kabkota: $kabkota, hijriah: $hijriah, masehi: $masehi, imsakiyah: $imsakiyah)';
}


}

/// @nodoc
abstract mixin class $ImsakiyahCopyWith<$Res>  {
  factory $ImsakiyahCopyWith(Imsakiyah value, $Res Function(Imsakiyah) _then) = _$ImsakiyahCopyWithImpl;
@useResult
$Res call({
 String provinsi, String kabkota, String hijriah, String masehi, List<ImsakiyahEntry> imsakiyah
});




}
/// @nodoc
class _$ImsakiyahCopyWithImpl<$Res>
    implements $ImsakiyahCopyWith<$Res> {
  _$ImsakiyahCopyWithImpl(this._self, this._then);

  final Imsakiyah _self;
  final $Res Function(Imsakiyah) _then;

/// Create a copy of Imsakiyah
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provinsi = null,Object? kabkota = null,Object? hijriah = null,Object? masehi = null,Object? imsakiyah = null,}) {
  return _then(_self.copyWith(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,hijriah: null == hijriah ? _self.hijriah : hijriah // ignore: cast_nullable_to_non_nullable
as String,masehi: null == masehi ? _self.masehi : masehi // ignore: cast_nullable_to_non_nullable
as String,imsakiyah: null == imsakiyah ? _self.imsakiyah : imsakiyah // ignore: cast_nullable_to_non_nullable
as List<ImsakiyahEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [Imsakiyah].
extension ImsakiyahPatterns on Imsakiyah {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Imsakiyah value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Imsakiyah() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Imsakiyah value)  $default,){
final _that = this;
switch (_that) {
case _Imsakiyah():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Imsakiyah value)?  $default,){
final _that = this;
switch (_that) {
case _Imsakiyah() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  String hijriah,  String masehi,  List<ImsakiyahEntry> imsakiyah)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Imsakiyah() when $default != null:
return $default(_that.provinsi,_that.kabkota,_that.hijriah,_that.masehi,_that.imsakiyah);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provinsi,  String kabkota,  String hijriah,  String masehi,  List<ImsakiyahEntry> imsakiyah)  $default,) {final _that = this;
switch (_that) {
case _Imsakiyah():
return $default(_that.provinsi,_that.kabkota,_that.hijriah,_that.masehi,_that.imsakiyah);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provinsi,  String kabkota,  String hijriah,  String masehi,  List<ImsakiyahEntry> imsakiyah)?  $default,) {final _that = this;
switch (_that) {
case _Imsakiyah() when $default != null:
return $default(_that.provinsi,_that.kabkota,_that.hijriah,_that.masehi,_that.imsakiyah);case _:
  return null;

}
}

}

/// @nodoc


class _Imsakiyah implements Imsakiyah {
  const _Imsakiyah({required this.provinsi, required this.kabkota, required this.hijriah, required this.masehi, required final  List<ImsakiyahEntry> imsakiyah}): _imsakiyah = imsakiyah;
  

@override final  String provinsi;
@override final  String kabkota;
@override final  String hijriah;
@override final  String masehi;
 final  List<ImsakiyahEntry> _imsakiyah;
@override List<ImsakiyahEntry> get imsakiyah {
  if (_imsakiyah is EqualUnmodifiableListView) return _imsakiyah;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imsakiyah);
}


/// Create a copy of Imsakiyah
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImsakiyahCopyWith<_Imsakiyah> get copyWith => __$ImsakiyahCopyWithImpl<_Imsakiyah>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Imsakiyah&&(identical(other.provinsi, provinsi) || other.provinsi == provinsi)&&(identical(other.kabkota, kabkota) || other.kabkota == kabkota)&&(identical(other.hijriah, hijriah) || other.hijriah == hijriah)&&(identical(other.masehi, masehi) || other.masehi == masehi)&&const DeepCollectionEquality().equals(other._imsakiyah, _imsakiyah));
}


@override
int get hashCode => Object.hash(runtimeType,provinsi,kabkota,hijriah,masehi,const DeepCollectionEquality().hash(_imsakiyah));

@override
String toString() {
  return 'Imsakiyah(provinsi: $provinsi, kabkota: $kabkota, hijriah: $hijriah, masehi: $masehi, imsakiyah: $imsakiyah)';
}


}

/// @nodoc
abstract mixin class _$ImsakiyahCopyWith<$Res> implements $ImsakiyahCopyWith<$Res> {
  factory _$ImsakiyahCopyWith(_Imsakiyah value, $Res Function(_Imsakiyah) _then) = __$ImsakiyahCopyWithImpl;
@override @useResult
$Res call({
 String provinsi, String kabkota, String hijriah, String masehi, List<ImsakiyahEntry> imsakiyah
});




}
/// @nodoc
class __$ImsakiyahCopyWithImpl<$Res>
    implements _$ImsakiyahCopyWith<$Res> {
  __$ImsakiyahCopyWithImpl(this._self, this._then);

  final _Imsakiyah _self;
  final $Res Function(_Imsakiyah) _then;

/// Create a copy of Imsakiyah
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provinsi = null,Object? kabkota = null,Object? hijriah = null,Object? masehi = null,Object? imsakiyah = null,}) {
  return _then(_Imsakiyah(
provinsi: null == provinsi ? _self.provinsi : provinsi // ignore: cast_nullable_to_non_nullable
as String,kabkota: null == kabkota ? _self.kabkota : kabkota // ignore: cast_nullable_to_non_nullable
as String,hijriah: null == hijriah ? _self.hijriah : hijriah // ignore: cast_nullable_to_non_nullable
as String,masehi: null == masehi ? _self.masehi : masehi // ignore: cast_nullable_to_non_nullable
as String,imsakiyah: null == imsakiyah ? _self._imsakiyah : imsakiyah // ignore: cast_nullable_to_non_nullable
as List<ImsakiyahEntry>,
  ));
}


}

// dart format on
