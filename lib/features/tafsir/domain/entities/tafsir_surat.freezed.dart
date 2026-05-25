// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tafsir_surat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TafsirSurat {

 Surat get info; List<TafsirAyat> get tafsirList;
/// Create a copy of TafsirSurat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafsirSuratCopyWith<TafsirSurat> get copyWith => _$TafsirSuratCopyWithImpl<TafsirSurat>(this as TafsirSurat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirSurat&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other.tafsirList, tafsirList));
}


@override
int get hashCode => Object.hash(runtimeType,info,const DeepCollectionEquality().hash(tafsirList));

@override
String toString() {
  return 'TafsirSurat(info: $info, tafsirList: $tafsirList)';
}


}

/// @nodoc
abstract mixin class $TafsirSuratCopyWith<$Res>  {
  factory $TafsirSuratCopyWith(TafsirSurat value, $Res Function(TafsirSurat) _then) = _$TafsirSuratCopyWithImpl;
@useResult
$Res call({
 Surat info, List<TafsirAyat> tafsirList
});


$SuratCopyWith<$Res> get info;

}
/// @nodoc
class _$TafsirSuratCopyWithImpl<$Res>
    implements $TafsirSuratCopyWith<$Res> {
  _$TafsirSuratCopyWithImpl(this._self, this._then);

  final TafsirSurat _self;
  final $Res Function(TafsirSurat) _then;

/// Create a copy of TafsirSurat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? info = null,Object? tafsirList = null,}) {
  return _then(_self.copyWith(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Surat,tafsirList: null == tafsirList ? _self.tafsirList : tafsirList // ignore: cast_nullable_to_non_nullable
as List<TafsirAyat>,
  ));
}
/// Create a copy of TafsirSurat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratCopyWith<$Res> get info {
  
  return $SuratCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// Adds pattern-matching-related methods to [TafsirSurat].
extension TafsirSuratPatterns on TafsirSurat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TafsirSurat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TafsirSurat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TafsirSurat value)  $default,){
final _that = this;
switch (_that) {
case _TafsirSurat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TafsirSurat value)?  $default,){
final _that = this;
switch (_that) {
case _TafsirSurat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Surat info,  List<TafsirAyat> tafsirList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TafsirSurat() when $default != null:
return $default(_that.info,_that.tafsirList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Surat info,  List<TafsirAyat> tafsirList)  $default,) {final _that = this;
switch (_that) {
case _TafsirSurat():
return $default(_that.info,_that.tafsirList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Surat info,  List<TafsirAyat> tafsirList)?  $default,) {final _that = this;
switch (_that) {
case _TafsirSurat() when $default != null:
return $default(_that.info,_that.tafsirList);case _:
  return null;

}
}

}

/// @nodoc


class _TafsirSurat implements TafsirSurat {
  const _TafsirSurat({required this.info, required final  List<TafsirAyat> tafsirList}): _tafsirList = tafsirList;
  

@override final  Surat info;
 final  List<TafsirAyat> _tafsirList;
@override List<TafsirAyat> get tafsirList {
  if (_tafsirList is EqualUnmodifiableListView) return _tafsirList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tafsirList);
}


/// Create a copy of TafsirSurat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TafsirSuratCopyWith<_TafsirSurat> get copyWith => __$TafsirSuratCopyWithImpl<_TafsirSurat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TafsirSurat&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other._tafsirList, _tafsirList));
}


@override
int get hashCode => Object.hash(runtimeType,info,const DeepCollectionEquality().hash(_tafsirList));

@override
String toString() {
  return 'TafsirSurat(info: $info, tafsirList: $tafsirList)';
}


}

/// @nodoc
abstract mixin class _$TafsirSuratCopyWith<$Res> implements $TafsirSuratCopyWith<$Res> {
  factory _$TafsirSuratCopyWith(_TafsirSurat value, $Res Function(_TafsirSurat) _then) = __$TafsirSuratCopyWithImpl;
@override @useResult
$Res call({
 Surat info, List<TafsirAyat> tafsirList
});


@override $SuratCopyWith<$Res> get info;

}
/// @nodoc
class __$TafsirSuratCopyWithImpl<$Res>
    implements _$TafsirSuratCopyWith<$Res> {
  __$TafsirSuratCopyWithImpl(this._self, this._then);

  final _TafsirSurat _self;
  final $Res Function(_TafsirSurat) _then;

/// Create a copy of TafsirSurat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? info = null,Object? tafsirList = null,}) {
  return _then(_TafsirSurat(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Surat,tafsirList: null == tafsirList ? _self._tafsirList : tafsirList // ignore: cast_nullable_to_non_nullable
as List<TafsirAyat>,
  ));
}

/// Create a copy of TafsirSurat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratCopyWith<$Res> get info {
  
  return $SuratCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc
mixin _$TafsirAyat {

 int get nomorAyat; String get teks;
/// Create a copy of TafsirAyat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafsirAyatCopyWith<TafsirAyat> get copyWith => _$TafsirAyatCopyWithImpl<TafsirAyat>(this as TafsirAyat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirAyat&&(identical(other.nomorAyat, nomorAyat) || other.nomorAyat == nomorAyat)&&(identical(other.teks, teks) || other.teks == teks));
}


@override
int get hashCode => Object.hash(runtimeType,nomorAyat,teks);

@override
String toString() {
  return 'TafsirAyat(nomorAyat: $nomorAyat, teks: $teks)';
}


}

/// @nodoc
abstract mixin class $TafsirAyatCopyWith<$Res>  {
  factory $TafsirAyatCopyWith(TafsirAyat value, $Res Function(TafsirAyat) _then) = _$TafsirAyatCopyWithImpl;
@useResult
$Res call({
 int nomorAyat, String teks
});




}
/// @nodoc
class _$TafsirAyatCopyWithImpl<$Res>
    implements $TafsirAyatCopyWith<$Res> {
  _$TafsirAyatCopyWithImpl(this._self, this._then);

  final TafsirAyat _self;
  final $Res Function(TafsirAyat) _then;

/// Create a copy of TafsirAyat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomorAyat = null,Object? teks = null,}) {
  return _then(_self.copyWith(
nomorAyat: null == nomorAyat ? _self.nomorAyat : nomorAyat // ignore: cast_nullable_to_non_nullable
as int,teks: null == teks ? _self.teks : teks // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TafsirAyat].
extension TafsirAyatPatterns on TafsirAyat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TafsirAyat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TafsirAyat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TafsirAyat value)  $default,){
final _that = this;
switch (_that) {
case _TafsirAyat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TafsirAyat value)?  $default,){
final _that = this;
switch (_that) {
case _TafsirAyat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomorAyat,  String teks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TafsirAyat() when $default != null:
return $default(_that.nomorAyat,_that.teks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomorAyat,  String teks)  $default,) {final _that = this;
switch (_that) {
case _TafsirAyat():
return $default(_that.nomorAyat,_that.teks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomorAyat,  String teks)?  $default,) {final _that = this;
switch (_that) {
case _TafsirAyat() when $default != null:
return $default(_that.nomorAyat,_that.teks);case _:
  return null;

}
}

}

/// @nodoc


class _TafsirAyat implements TafsirAyat {
  const _TafsirAyat({required this.nomorAyat, required this.teks});
  

@override final  int nomorAyat;
@override final  String teks;

/// Create a copy of TafsirAyat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TafsirAyatCopyWith<_TafsirAyat> get copyWith => __$TafsirAyatCopyWithImpl<_TafsirAyat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TafsirAyat&&(identical(other.nomorAyat, nomorAyat) || other.nomorAyat == nomorAyat)&&(identical(other.teks, teks) || other.teks == teks));
}


@override
int get hashCode => Object.hash(runtimeType,nomorAyat,teks);

@override
String toString() {
  return 'TafsirAyat(nomorAyat: $nomorAyat, teks: $teks)';
}


}

/// @nodoc
abstract mixin class _$TafsirAyatCopyWith<$Res> implements $TafsirAyatCopyWith<$Res> {
  factory _$TafsirAyatCopyWith(_TafsirAyat value, $Res Function(_TafsirAyat) _then) = __$TafsirAyatCopyWithImpl;
@override @useResult
$Res call({
 int nomorAyat, String teks
});




}
/// @nodoc
class __$TafsirAyatCopyWithImpl<$Res>
    implements _$TafsirAyatCopyWith<$Res> {
  __$TafsirAyatCopyWithImpl(this._self, this._then);

  final _TafsirAyat _self;
  final $Res Function(_TafsirAyat) _then;

/// Create a copy of TafsirAyat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomorAyat = null,Object? teks = null,}) {
  return _then(_TafsirAyat(
nomorAyat: null == nomorAyat ? _self.nomorAyat : nomorAyat // ignore: cast_nullable_to_non_nullable
as int,teks: null == teks ? _self.teks : teks // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
