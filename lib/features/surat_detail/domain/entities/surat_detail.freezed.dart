// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surat_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SuratDetail {

 Surat get info; String get deskripsi; Map<String, String> get audioFull; List<Ayat> get ayatList; SuratNavigation? get suratSelanjutnya; SuratNavigation? get suratSebelumnya;
/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratDetailCopyWith<SuratDetail> get copyWith => _$SuratDetailCopyWithImpl<SuratDetail>(this as SuratDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetail&&(identical(other.info, info) || other.info == info)&&(identical(other.deskripsi, deskripsi) || other.deskripsi == deskripsi)&&const DeepCollectionEquality().equals(other.audioFull, audioFull)&&const DeepCollectionEquality().equals(other.ayatList, ayatList)&&(identical(other.suratSelanjutnya, suratSelanjutnya) || other.suratSelanjutnya == suratSelanjutnya)&&(identical(other.suratSebelumnya, suratSebelumnya) || other.suratSebelumnya == suratSebelumnya));
}


@override
int get hashCode => Object.hash(runtimeType,info,deskripsi,const DeepCollectionEquality().hash(audioFull),const DeepCollectionEquality().hash(ayatList),suratSelanjutnya,suratSebelumnya);

@override
String toString() {
  return 'SuratDetail(info: $info, deskripsi: $deskripsi, audioFull: $audioFull, ayatList: $ayatList, suratSelanjutnya: $suratSelanjutnya, suratSebelumnya: $suratSebelumnya)';
}


}

/// @nodoc
abstract mixin class $SuratDetailCopyWith<$Res>  {
  factory $SuratDetailCopyWith(SuratDetail value, $Res Function(SuratDetail) _then) = _$SuratDetailCopyWithImpl;
@useResult
$Res call({
 Surat info, String deskripsi, Map<String, String> audioFull, List<Ayat> ayatList, SuratNavigation? suratSelanjutnya, SuratNavigation? suratSebelumnya
});


$SuratCopyWith<$Res> get info;$SuratNavigationCopyWith<$Res>? get suratSelanjutnya;$SuratNavigationCopyWith<$Res>? get suratSebelumnya;

}
/// @nodoc
class _$SuratDetailCopyWithImpl<$Res>
    implements $SuratDetailCopyWith<$Res> {
  _$SuratDetailCopyWithImpl(this._self, this._then);

  final SuratDetail _self;
  final $Res Function(SuratDetail) _then;

/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? info = null,Object? deskripsi = null,Object? audioFull = null,Object? ayatList = null,Object? suratSelanjutnya = freezed,Object? suratSebelumnya = freezed,}) {
  return _then(_self.copyWith(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Surat,deskripsi: null == deskripsi ? _self.deskripsi : deskripsi // ignore: cast_nullable_to_non_nullable
as String,audioFull: null == audioFull ? _self.audioFull : audioFull // ignore: cast_nullable_to_non_nullable
as Map<String, String>,ayatList: null == ayatList ? _self.ayatList : ayatList // ignore: cast_nullable_to_non_nullable
as List<Ayat>,suratSelanjutnya: freezed == suratSelanjutnya ? _self.suratSelanjutnya : suratSelanjutnya // ignore: cast_nullable_to_non_nullable
as SuratNavigation?,suratSebelumnya: freezed == suratSebelumnya ? _self.suratSebelumnya : suratSebelumnya // ignore: cast_nullable_to_non_nullable
as SuratNavigation?,
  ));
}
/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratCopyWith<$Res> get info {
  
  return $SuratCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavigationCopyWith<$Res>? get suratSelanjutnya {
    if (_self.suratSelanjutnya == null) {
    return null;
  }

  return $SuratNavigationCopyWith<$Res>(_self.suratSelanjutnya!, (value) {
    return _then(_self.copyWith(suratSelanjutnya: value));
  });
}/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavigationCopyWith<$Res>? get suratSebelumnya {
    if (_self.suratSebelumnya == null) {
    return null;
  }

  return $SuratNavigationCopyWith<$Res>(_self.suratSebelumnya!, (value) {
    return _then(_self.copyWith(suratSebelumnya: value));
  });
}
}


/// Adds pattern-matching-related methods to [SuratDetail].
extension SuratDetailPatterns on SuratDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratDetail value)  $default,){
final _that = this;
switch (_that) {
case _SuratDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SuratDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Surat info,  String deskripsi,  Map<String, String> audioFull,  List<Ayat> ayatList,  SuratNavigation? suratSelanjutnya,  SuratNavigation? suratSebelumnya)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratDetail() when $default != null:
return $default(_that.info,_that.deskripsi,_that.audioFull,_that.ayatList,_that.suratSelanjutnya,_that.suratSebelumnya);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Surat info,  String deskripsi,  Map<String, String> audioFull,  List<Ayat> ayatList,  SuratNavigation? suratSelanjutnya,  SuratNavigation? suratSebelumnya)  $default,) {final _that = this;
switch (_that) {
case _SuratDetail():
return $default(_that.info,_that.deskripsi,_that.audioFull,_that.ayatList,_that.suratSelanjutnya,_that.suratSebelumnya);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Surat info,  String deskripsi,  Map<String, String> audioFull,  List<Ayat> ayatList,  SuratNavigation? suratSelanjutnya,  SuratNavigation? suratSebelumnya)?  $default,) {final _that = this;
switch (_that) {
case _SuratDetail() when $default != null:
return $default(_that.info,_that.deskripsi,_that.audioFull,_that.ayatList,_that.suratSelanjutnya,_that.suratSebelumnya);case _:
  return null;

}
}

}

/// @nodoc


class _SuratDetail implements SuratDetail {
  const _SuratDetail({required this.info, required this.deskripsi, required final  Map<String, String> audioFull, required final  List<Ayat> ayatList, this.suratSelanjutnya, this.suratSebelumnya}): _audioFull = audioFull,_ayatList = ayatList;
  

@override final  Surat info;
@override final  String deskripsi;
 final  Map<String, String> _audioFull;
@override Map<String, String> get audioFull {
  if (_audioFull is EqualUnmodifiableMapView) return _audioFull;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_audioFull);
}

 final  List<Ayat> _ayatList;
@override List<Ayat> get ayatList {
  if (_ayatList is EqualUnmodifiableListView) return _ayatList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ayatList);
}

@override final  SuratNavigation? suratSelanjutnya;
@override final  SuratNavigation? suratSebelumnya;

/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratDetailCopyWith<_SuratDetail> get copyWith => __$SuratDetailCopyWithImpl<_SuratDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratDetail&&(identical(other.info, info) || other.info == info)&&(identical(other.deskripsi, deskripsi) || other.deskripsi == deskripsi)&&const DeepCollectionEquality().equals(other._audioFull, _audioFull)&&const DeepCollectionEquality().equals(other._ayatList, _ayatList)&&(identical(other.suratSelanjutnya, suratSelanjutnya) || other.suratSelanjutnya == suratSelanjutnya)&&(identical(other.suratSebelumnya, suratSebelumnya) || other.suratSebelumnya == suratSebelumnya));
}


@override
int get hashCode => Object.hash(runtimeType,info,deskripsi,const DeepCollectionEquality().hash(_audioFull),const DeepCollectionEquality().hash(_ayatList),suratSelanjutnya,suratSebelumnya);

@override
String toString() {
  return 'SuratDetail(info: $info, deskripsi: $deskripsi, audioFull: $audioFull, ayatList: $ayatList, suratSelanjutnya: $suratSelanjutnya, suratSebelumnya: $suratSebelumnya)';
}


}

/// @nodoc
abstract mixin class _$SuratDetailCopyWith<$Res> implements $SuratDetailCopyWith<$Res> {
  factory _$SuratDetailCopyWith(_SuratDetail value, $Res Function(_SuratDetail) _then) = __$SuratDetailCopyWithImpl;
@override @useResult
$Res call({
 Surat info, String deskripsi, Map<String, String> audioFull, List<Ayat> ayatList, SuratNavigation? suratSelanjutnya, SuratNavigation? suratSebelumnya
});


@override $SuratCopyWith<$Res> get info;@override $SuratNavigationCopyWith<$Res>? get suratSelanjutnya;@override $SuratNavigationCopyWith<$Res>? get suratSebelumnya;

}
/// @nodoc
class __$SuratDetailCopyWithImpl<$Res>
    implements _$SuratDetailCopyWith<$Res> {
  __$SuratDetailCopyWithImpl(this._self, this._then);

  final _SuratDetail _self;
  final $Res Function(_SuratDetail) _then;

/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? info = null,Object? deskripsi = null,Object? audioFull = null,Object? ayatList = null,Object? suratSelanjutnya = freezed,Object? suratSebelumnya = freezed,}) {
  return _then(_SuratDetail(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Surat,deskripsi: null == deskripsi ? _self.deskripsi : deskripsi // ignore: cast_nullable_to_non_nullable
as String,audioFull: null == audioFull ? _self._audioFull : audioFull // ignore: cast_nullable_to_non_nullable
as Map<String, String>,ayatList: null == ayatList ? _self._ayatList : ayatList // ignore: cast_nullable_to_non_nullable
as List<Ayat>,suratSelanjutnya: freezed == suratSelanjutnya ? _self.suratSelanjutnya : suratSelanjutnya // ignore: cast_nullable_to_non_nullable
as SuratNavigation?,suratSebelumnya: freezed == suratSebelumnya ? _self.suratSebelumnya : suratSebelumnya // ignore: cast_nullable_to_non_nullable
as SuratNavigation?,
  ));
}

/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratCopyWith<$Res> get info {
  
  return $SuratCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavigationCopyWith<$Res>? get suratSelanjutnya {
    if (_self.suratSelanjutnya == null) {
    return null;
  }

  return $SuratNavigationCopyWith<$Res>(_self.suratSelanjutnya!, (value) {
    return _then(_self.copyWith(suratSelanjutnya: value));
  });
}/// Create a copy of SuratDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratNavigationCopyWith<$Res>? get suratSebelumnya {
    if (_self.suratSebelumnya == null) {
    return null;
  }

  return $SuratNavigationCopyWith<$Res>(_self.suratSebelumnya!, (value) {
    return _then(_self.copyWith(suratSebelumnya: value));
  });
}
}

/// @nodoc
mixin _$Ayat {

 int get nomorAyat; String get teksArab; String get teksLatin; String get teksIndonesia; Map<String, String> get audio;
/// Create a copy of Ayat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AyatCopyWith<Ayat> get copyWith => _$AyatCopyWithImpl<Ayat>(this as Ayat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ayat&&(identical(other.nomorAyat, nomorAyat) || other.nomorAyat == nomorAyat)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.teksLatin, teksLatin) || other.teksLatin == teksLatin)&&(identical(other.teksIndonesia, teksIndonesia) || other.teksIndonesia == teksIndonesia)&&const DeepCollectionEquality().equals(other.audio, audio));
}


@override
int get hashCode => Object.hash(runtimeType,nomorAyat,teksArab,teksLatin,teksIndonesia,const DeepCollectionEquality().hash(audio));

@override
String toString() {
  return 'Ayat(nomorAyat: $nomorAyat, teksArab: $teksArab, teksLatin: $teksLatin, teksIndonesia: $teksIndonesia, audio: $audio)';
}


}

/// @nodoc
abstract mixin class $AyatCopyWith<$Res>  {
  factory $AyatCopyWith(Ayat value, $Res Function(Ayat) _then) = _$AyatCopyWithImpl;
@useResult
$Res call({
 int nomorAyat, String teksArab, String teksLatin, String teksIndonesia, Map<String, String> audio
});




}
/// @nodoc
class _$AyatCopyWithImpl<$Res>
    implements $AyatCopyWith<$Res> {
  _$AyatCopyWithImpl(this._self, this._then);

  final Ayat _self;
  final $Res Function(Ayat) _then;

/// Create a copy of Ayat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomorAyat = null,Object? teksArab = null,Object? teksLatin = null,Object? teksIndonesia = null,Object? audio = null,}) {
  return _then(_self.copyWith(
nomorAyat: null == nomorAyat ? _self.nomorAyat : nomorAyat // ignore: cast_nullable_to_non_nullable
as int,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,teksLatin: null == teksLatin ? _self.teksLatin : teksLatin // ignore: cast_nullable_to_non_nullable
as String,teksIndonesia: null == teksIndonesia ? _self.teksIndonesia : teksIndonesia // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Ayat].
extension AyatPatterns on Ayat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ayat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ayat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ayat value)  $default,){
final _that = this;
switch (_that) {
case _Ayat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ayat value)?  $default,){
final _that = this;
switch (_that) {
case _Ayat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomorAyat,  String teksArab,  String teksLatin,  String teksIndonesia,  Map<String, String> audio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ayat() when $default != null:
return $default(_that.nomorAyat,_that.teksArab,_that.teksLatin,_that.teksIndonesia,_that.audio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomorAyat,  String teksArab,  String teksLatin,  String teksIndonesia,  Map<String, String> audio)  $default,) {final _that = this;
switch (_that) {
case _Ayat():
return $default(_that.nomorAyat,_that.teksArab,_that.teksLatin,_that.teksIndonesia,_that.audio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomorAyat,  String teksArab,  String teksLatin,  String teksIndonesia,  Map<String, String> audio)?  $default,) {final _that = this;
switch (_that) {
case _Ayat() when $default != null:
return $default(_that.nomorAyat,_that.teksArab,_that.teksLatin,_that.teksIndonesia,_that.audio);case _:
  return null;

}
}

}

/// @nodoc


class _Ayat implements Ayat {
  const _Ayat({required this.nomorAyat, required this.teksArab, required this.teksLatin, required this.teksIndonesia, required final  Map<String, String> audio}): _audio = audio;
  

@override final  int nomorAyat;
@override final  String teksArab;
@override final  String teksLatin;
@override final  String teksIndonesia;
 final  Map<String, String> _audio;
@override Map<String, String> get audio {
  if (_audio is EqualUnmodifiableMapView) return _audio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_audio);
}


/// Create a copy of Ayat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AyatCopyWith<_Ayat> get copyWith => __$AyatCopyWithImpl<_Ayat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ayat&&(identical(other.nomorAyat, nomorAyat) || other.nomorAyat == nomorAyat)&&(identical(other.teksArab, teksArab) || other.teksArab == teksArab)&&(identical(other.teksLatin, teksLatin) || other.teksLatin == teksLatin)&&(identical(other.teksIndonesia, teksIndonesia) || other.teksIndonesia == teksIndonesia)&&const DeepCollectionEquality().equals(other._audio, _audio));
}


@override
int get hashCode => Object.hash(runtimeType,nomorAyat,teksArab,teksLatin,teksIndonesia,const DeepCollectionEquality().hash(_audio));

@override
String toString() {
  return 'Ayat(nomorAyat: $nomorAyat, teksArab: $teksArab, teksLatin: $teksLatin, teksIndonesia: $teksIndonesia, audio: $audio)';
}


}

/// @nodoc
abstract mixin class _$AyatCopyWith<$Res> implements $AyatCopyWith<$Res> {
  factory _$AyatCopyWith(_Ayat value, $Res Function(_Ayat) _then) = __$AyatCopyWithImpl;
@override @useResult
$Res call({
 int nomorAyat, String teksArab, String teksLatin, String teksIndonesia, Map<String, String> audio
});




}
/// @nodoc
class __$AyatCopyWithImpl<$Res>
    implements _$AyatCopyWith<$Res> {
  __$AyatCopyWithImpl(this._self, this._then);

  final _Ayat _self;
  final $Res Function(_Ayat) _then;

/// Create a copy of Ayat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomorAyat = null,Object? teksArab = null,Object? teksLatin = null,Object? teksIndonesia = null,Object? audio = null,}) {
  return _then(_Ayat(
nomorAyat: null == nomorAyat ? _self.nomorAyat : nomorAyat // ignore: cast_nullable_to_non_nullable
as int,teksArab: null == teksArab ? _self.teksArab : teksArab // ignore: cast_nullable_to_non_nullable
as String,teksLatin: null == teksLatin ? _self.teksLatin : teksLatin // ignore: cast_nullable_to_non_nullable
as String,teksIndonesia: null == teksIndonesia ? _self.teksIndonesia : teksIndonesia // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self._audio : audio // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc
mixin _$SuratNavigation {

 int get nomor; String get namaLatin; int get jumlahAyat;
/// Create a copy of SuratNavigation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratNavigationCopyWith<SuratNavigation> get copyWith => _$SuratNavigationCopyWithImpl<SuratNavigation>(this as SuratNavigation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratNavigation&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat));
}


@override
int get hashCode => Object.hash(runtimeType,nomor,namaLatin,jumlahAyat);

@override
String toString() {
  return 'SuratNavigation(nomor: $nomor, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat)';
}


}

/// @nodoc
abstract mixin class $SuratNavigationCopyWith<$Res>  {
  factory $SuratNavigationCopyWith(SuratNavigation value, $Res Function(SuratNavigation) _then) = _$SuratNavigationCopyWithImpl;
@useResult
$Res call({
 int nomor, String namaLatin, int jumlahAyat
});




}
/// @nodoc
class _$SuratNavigationCopyWithImpl<$Res>
    implements $SuratNavigationCopyWith<$Res> {
  _$SuratNavigationCopyWithImpl(this._self, this._then);

  final SuratNavigation _self;
  final $Res Function(SuratNavigation) _then;

/// Create a copy of SuratNavigation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomor = null,Object? namaLatin = null,Object? jumlahAyat = null,}) {
  return _then(_self.copyWith(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SuratNavigation].
extension SuratNavigationPatterns on SuratNavigation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratNavigation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratNavigation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratNavigation value)  $default,){
final _that = this;
switch (_that) {
case _SuratNavigation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratNavigation value)?  $default,){
final _that = this;
switch (_that) {
case _SuratNavigation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nomor,  String namaLatin,  int jumlahAyat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratNavigation() when $default != null:
return $default(_that.nomor,_that.namaLatin,_that.jumlahAyat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nomor,  String namaLatin,  int jumlahAyat)  $default,) {final _that = this;
switch (_that) {
case _SuratNavigation():
return $default(_that.nomor,_that.namaLatin,_that.jumlahAyat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nomor,  String namaLatin,  int jumlahAyat)?  $default,) {final _that = this;
switch (_that) {
case _SuratNavigation() when $default != null:
return $default(_that.nomor,_that.namaLatin,_that.jumlahAyat);case _:
  return null;

}
}

}

/// @nodoc


class _SuratNavigation implements SuratNavigation {
  const _SuratNavigation({required this.nomor, required this.namaLatin, required this.jumlahAyat});
  

@override final  int nomor;
@override final  String namaLatin;
@override final  int jumlahAyat;

/// Create a copy of SuratNavigation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratNavigationCopyWith<_SuratNavigation> get copyWith => __$SuratNavigationCopyWithImpl<_SuratNavigation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratNavigation&&(identical(other.nomor, nomor) || other.nomor == nomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyat, jumlahAyat) || other.jumlahAyat == jumlahAyat));
}


@override
int get hashCode => Object.hash(runtimeType,nomor,namaLatin,jumlahAyat);

@override
String toString() {
  return 'SuratNavigation(nomor: $nomor, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat)';
}


}

/// @nodoc
abstract mixin class _$SuratNavigationCopyWith<$Res> implements $SuratNavigationCopyWith<$Res> {
  factory _$SuratNavigationCopyWith(_SuratNavigation value, $Res Function(_SuratNavigation) _then) = __$SuratNavigationCopyWithImpl;
@override @useResult
$Res call({
 int nomor, String namaLatin, int jumlahAyat
});




}
/// @nodoc
class __$SuratNavigationCopyWithImpl<$Res>
    implements _$SuratNavigationCopyWith<$Res> {
  __$SuratNavigationCopyWithImpl(this._self, this._then);

  final _SuratNavigation _self;
  final $Res Function(_SuratNavigation) _then;

/// Create a copy of SuratNavigation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomor = null,Object? namaLatin = null,Object? jumlahAyat = null,}) {
  return _then(_SuratNavigation(
nomor: null == nomor ? _self.nomor : nomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyat: null == jumlahAyat ? _self.jumlahAyat : jumlahAyat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
