// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doa.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Doa {

 int get id; String get grup; String get nama; String get ar; String get tr; String get idn; String get tentang; List<String> get tag;
/// Create a copy of Doa
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaCopyWith<Doa> get copyWith => _$DoaCopyWithImpl<Doa>(this as Doa, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Doa&&(identical(other.id, id) || other.id == id)&&(identical(other.grup, grup) || other.grup == grup)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.tr, tr) || other.tr == tr)&&(identical(other.idn, idn) || other.idn == idn)&&(identical(other.tentang, tentang) || other.tentang == tentang)&&const DeepCollectionEquality().equals(other.tag, tag));
}


@override
int get hashCode => Object.hash(runtimeType,id,grup,nama,ar,tr,idn,tentang,const DeepCollectionEquality().hash(tag));

@override
String toString() {
  return 'Doa(id: $id, grup: $grup, nama: $nama, ar: $ar, tr: $tr, idn: $idn, tentang: $tentang, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $DoaCopyWith<$Res>  {
  factory $DoaCopyWith(Doa value, $Res Function(Doa) _then) = _$DoaCopyWithImpl;
@useResult
$Res call({
 int id, String grup, String nama, String ar, String tr, String idn, String tentang, List<String> tag
});




}
/// @nodoc
class _$DoaCopyWithImpl<$Res>
    implements $DoaCopyWith<$Res> {
  _$DoaCopyWithImpl(this._self, this._then);

  final Doa _self;
  final $Res Function(Doa) _then;

/// Create a copy of Doa
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? grup = null,Object? nama = null,Object? ar = null,Object? tr = null,Object? idn = null,Object? tentang = null,Object? tag = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,grup: null == grup ? _self.grup : grup // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as String,tr: null == tr ? _self.tr : tr // ignore: cast_nullable_to_non_nullable
as String,idn: null == idn ? _self.idn : idn // ignore: cast_nullable_to_non_nullable
as String,tentang: null == tentang ? _self.tentang : tentang // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Doa].
extension DoaPatterns on Doa {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Doa value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Doa() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Doa value)  $default,){
final _that = this;
switch (_that) {
case _Doa():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Doa value)?  $default,){
final _that = this;
switch (_that) {
case _Doa() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String grup,  String nama,  String ar,  String tr,  String idn,  String tentang,  List<String> tag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Doa() when $default != null:
return $default(_that.id,_that.grup,_that.nama,_that.ar,_that.tr,_that.idn,_that.tentang,_that.tag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String grup,  String nama,  String ar,  String tr,  String idn,  String tentang,  List<String> tag)  $default,) {final _that = this;
switch (_that) {
case _Doa():
return $default(_that.id,_that.grup,_that.nama,_that.ar,_that.tr,_that.idn,_that.tentang,_that.tag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String grup,  String nama,  String ar,  String tr,  String idn,  String tentang,  List<String> tag)?  $default,) {final _that = this;
switch (_that) {
case _Doa() when $default != null:
return $default(_that.id,_that.grup,_that.nama,_that.ar,_that.tr,_that.idn,_that.tentang,_that.tag);case _:
  return null;

}
}

}

/// @nodoc


class _Doa implements Doa {
  const _Doa({required this.id, required this.grup, required this.nama, required this.ar, required this.tr, required this.idn, required this.tentang, required final  List<String> tag}): _tag = tag;
  

@override final  int id;
@override final  String grup;
@override final  String nama;
@override final  String ar;
@override final  String tr;
@override final  String idn;
@override final  String tentang;
 final  List<String> _tag;
@override List<String> get tag {
  if (_tag is EqualUnmodifiableListView) return _tag;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tag);
}


/// Create a copy of Doa
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoaCopyWith<_Doa> get copyWith => __$DoaCopyWithImpl<_Doa>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Doa&&(identical(other.id, id) || other.id == id)&&(identical(other.grup, grup) || other.grup == grup)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.tr, tr) || other.tr == tr)&&(identical(other.idn, idn) || other.idn == idn)&&(identical(other.tentang, tentang) || other.tentang == tentang)&&const DeepCollectionEquality().equals(other._tag, _tag));
}


@override
int get hashCode => Object.hash(runtimeType,id,grup,nama,ar,tr,idn,tentang,const DeepCollectionEquality().hash(_tag));

@override
String toString() {
  return 'Doa(id: $id, grup: $grup, nama: $nama, ar: $ar, tr: $tr, idn: $idn, tentang: $tentang, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$DoaCopyWith<$Res> implements $DoaCopyWith<$Res> {
  factory _$DoaCopyWith(_Doa value, $Res Function(_Doa) _then) = __$DoaCopyWithImpl;
@override @useResult
$Res call({
 int id, String grup, String nama, String ar, String tr, String idn, String tentang, List<String> tag
});




}
/// @nodoc
class __$DoaCopyWithImpl<$Res>
    implements _$DoaCopyWith<$Res> {
  __$DoaCopyWithImpl(this._self, this._then);

  final _Doa _self;
  final $Res Function(_Doa) _then;

/// Create a copy of Doa
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? grup = null,Object? nama = null,Object? ar = null,Object? tr = null,Object? idn = null,Object? tentang = null,Object? tag = null,}) {
  return _then(_Doa(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,grup: null == grup ? _self.grup : grup // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as String,tr: null == tr ? _self.tr : tr // ignore: cast_nullable_to_non_nullable
as String,idn: null == idn ? _self.idn : idn // ignore: cast_nullable_to_non_nullable
as String,tentang: null == tentang ? _self.tentang : tentang // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self._tag : tag // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
