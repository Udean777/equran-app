// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doa_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoaListResponseDto {

 String get status; int get total; List<DoaDto> get data;
/// Create a copy of DoaListResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaListResponseDtoCopyWith<DoaListResponseDto> get copyWith => _$DoaListResponseDtoCopyWithImpl<DoaListResponseDto>(this as DoaListResponseDto, _$identity);

  /// Serializes this DoaListResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaListResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,total,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'DoaListResponseDto(status: $status, total: $total, data: $data)';
}


}

/// @nodoc
abstract mixin class $DoaListResponseDtoCopyWith<$Res>  {
  factory $DoaListResponseDtoCopyWith(DoaListResponseDto value, $Res Function(DoaListResponseDto) _then) = _$DoaListResponseDtoCopyWithImpl;
@useResult
$Res call({
 String status, int total, List<DoaDto> data
});




}
/// @nodoc
class _$DoaListResponseDtoCopyWithImpl<$Res>
    implements $DoaListResponseDtoCopyWith<$Res> {
  _$DoaListResponseDtoCopyWithImpl(this._self, this._then);

  final DoaListResponseDto _self;
  final $Res Function(DoaListResponseDto) _then;

/// Create a copy of DoaListResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? total = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<DoaDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [DoaListResponseDto].
extension DoaListResponseDtoPatterns on DoaListResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoaListResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoaListResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoaListResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _DoaListResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoaListResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _DoaListResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  int total,  List<DoaDto> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoaListResponseDto() when $default != null:
return $default(_that.status,_that.total,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  int total,  List<DoaDto> data)  $default,) {final _that = this;
switch (_that) {
case _DoaListResponseDto():
return $default(_that.status,_that.total,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  int total,  List<DoaDto> data)?  $default,) {final _that = this;
switch (_that) {
case _DoaListResponseDto() when $default != null:
return $default(_that.status,_that.total,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoaListResponseDto implements DoaListResponseDto {
  const _DoaListResponseDto({required this.status, required this.total, required final  List<DoaDto> data}): _data = data;
  factory _DoaListResponseDto.fromJson(Map<String, dynamic> json) => _$DoaListResponseDtoFromJson(json);

@override final  String status;
@override final  int total;
 final  List<DoaDto> _data;
@override List<DoaDto> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of DoaListResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoaListResponseDtoCopyWith<_DoaListResponseDto> get copyWith => __$DoaListResponseDtoCopyWithImpl<_DoaListResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoaListResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoaListResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,total,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'DoaListResponseDto(status: $status, total: $total, data: $data)';
}


}

/// @nodoc
abstract mixin class _$DoaListResponseDtoCopyWith<$Res> implements $DoaListResponseDtoCopyWith<$Res> {
  factory _$DoaListResponseDtoCopyWith(_DoaListResponseDto value, $Res Function(_DoaListResponseDto) _then) = __$DoaListResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String status, int total, List<DoaDto> data
});




}
/// @nodoc
class __$DoaListResponseDtoCopyWithImpl<$Res>
    implements _$DoaListResponseDtoCopyWith<$Res> {
  __$DoaListResponseDtoCopyWithImpl(this._self, this._then);

  final _DoaListResponseDto _self;
  final $Res Function(_DoaListResponseDto) _then;

/// Create a copy of DoaListResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? total = null,Object? data = null,}) {
  return _then(_DoaListResponseDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<DoaDto>,
  ));
}


}


/// @nodoc
mixin _$DoaDetailResponseDto {

 String get status; DoaDto get data;
/// Create a copy of DoaDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaDetailResponseDtoCopyWith<DoaDetailResponseDto> get copyWith => _$DoaDetailResponseDtoCopyWithImpl<DoaDetailResponseDto>(this as DoaDetailResponseDto, _$identity);

  /// Serializes this DoaDetailResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaDetailResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,data);

@override
String toString() {
  return 'DoaDetailResponseDto(status: $status, data: $data)';
}


}

/// @nodoc
abstract mixin class $DoaDetailResponseDtoCopyWith<$Res>  {
  factory $DoaDetailResponseDtoCopyWith(DoaDetailResponseDto value, $Res Function(DoaDetailResponseDto) _then) = _$DoaDetailResponseDtoCopyWithImpl;
@useResult
$Res call({
 String status, DoaDto data
});


$DoaDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$DoaDetailResponseDtoCopyWithImpl<$Res>
    implements $DoaDetailResponseDtoCopyWith<$Res> {
  _$DoaDetailResponseDtoCopyWithImpl(this._self, this._then);

  final DoaDetailResponseDto _self;
  final $Res Function(DoaDetailResponseDto) _then;

/// Create a copy of DoaDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DoaDto,
  ));
}
/// Create a copy of DoaDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoaDtoCopyWith<$Res> get data {
  
  return $DoaDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [DoaDetailResponseDto].
extension DoaDetailResponseDtoPatterns on DoaDetailResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoaDetailResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoaDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoaDetailResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _DoaDetailResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoaDetailResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _DoaDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  DoaDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoaDetailResponseDto() when $default != null:
return $default(_that.status,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  DoaDto data)  $default,) {final _that = this;
switch (_that) {
case _DoaDetailResponseDto():
return $default(_that.status,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  DoaDto data)?  $default,) {final _that = this;
switch (_that) {
case _DoaDetailResponseDto() when $default != null:
return $default(_that.status,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoaDetailResponseDto implements DoaDetailResponseDto {
  const _DoaDetailResponseDto({required this.status, required this.data});
  factory _DoaDetailResponseDto.fromJson(Map<String, dynamic> json) => _$DoaDetailResponseDtoFromJson(json);

@override final  String status;
@override final  DoaDto data;

/// Create a copy of DoaDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoaDetailResponseDtoCopyWith<_DoaDetailResponseDto> get copyWith => __$DoaDetailResponseDtoCopyWithImpl<_DoaDetailResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoaDetailResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoaDetailResponseDto&&(identical(other.status, status) || other.status == status)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,data);

@override
String toString() {
  return 'DoaDetailResponseDto(status: $status, data: $data)';
}


}

/// @nodoc
abstract mixin class _$DoaDetailResponseDtoCopyWith<$Res> implements $DoaDetailResponseDtoCopyWith<$Res> {
  factory _$DoaDetailResponseDtoCopyWith(_DoaDetailResponseDto value, $Res Function(_DoaDetailResponseDto) _then) = __$DoaDetailResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String status, DoaDto data
});


@override $DoaDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$DoaDetailResponseDtoCopyWithImpl<$Res>
    implements _$DoaDetailResponseDtoCopyWith<$Res> {
  __$DoaDetailResponseDtoCopyWithImpl(this._self, this._then);

  final _DoaDetailResponseDto _self;
  final $Res Function(_DoaDetailResponseDto) _then;

/// Create a copy of DoaDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? data = null,}) {
  return _then(_DoaDetailResponseDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DoaDto,
  ));
}

/// Create a copy of DoaDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoaDtoCopyWith<$Res> get data {
  
  return $DoaDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$DoaDto {

 int get id; String get grup; String get nama; String get ar; String get tr; String get idn; String get tentang; List<String> get tag;
/// Create a copy of DoaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaDtoCopyWith<DoaDto> get copyWith => _$DoaDtoCopyWithImpl<DoaDto>(this as DoaDto, _$identity);

  /// Serializes this DoaDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaDto&&(identical(other.id, id) || other.id == id)&&(identical(other.grup, grup) || other.grup == grup)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.tr, tr) || other.tr == tr)&&(identical(other.idn, idn) || other.idn == idn)&&(identical(other.tentang, tentang) || other.tentang == tentang)&&const DeepCollectionEquality().equals(other.tag, tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,grup,nama,ar,tr,idn,tentang,const DeepCollectionEquality().hash(tag));

@override
String toString() {
  return 'DoaDto(id: $id, grup: $grup, nama: $nama, ar: $ar, tr: $tr, idn: $idn, tentang: $tentang, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $DoaDtoCopyWith<$Res>  {
  factory $DoaDtoCopyWith(DoaDto value, $Res Function(DoaDto) _then) = _$DoaDtoCopyWithImpl;
@useResult
$Res call({
 int id, String grup, String nama, String ar, String tr, String idn, String tentang, List<String> tag
});




}
/// @nodoc
class _$DoaDtoCopyWithImpl<$Res>
    implements $DoaDtoCopyWith<$Res> {
  _$DoaDtoCopyWithImpl(this._self, this._then);

  final DoaDto _self;
  final $Res Function(DoaDto) _then;

/// Create a copy of DoaDto
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


/// Adds pattern-matching-related methods to [DoaDto].
extension DoaDtoPatterns on DoaDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoaDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoaDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoaDto value)  $default,){
final _that = this;
switch (_that) {
case _DoaDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoaDto value)?  $default,){
final _that = this;
switch (_that) {
case _DoaDto() when $default != null:
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
case _DoaDto() when $default != null:
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
case _DoaDto():
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
case _DoaDto() when $default != null:
return $default(_that.id,_that.grup,_that.nama,_that.ar,_that.tr,_that.idn,_that.tentang,_that.tag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoaDto implements DoaDto {
  const _DoaDto({required this.id, required this.grup, required this.nama, required this.ar, this.tr = '', this.idn = '', this.tentang = '', final  List<String> tag = const []}): _tag = tag;
  factory _DoaDto.fromJson(Map<String, dynamic> json) => _$DoaDtoFromJson(json);

@override final  int id;
@override final  String grup;
@override final  String nama;
@override final  String ar;
@override@JsonKey() final  String tr;
@override@JsonKey() final  String idn;
@override@JsonKey() final  String tentang;
 final  List<String> _tag;
@override@JsonKey() List<String> get tag {
  if (_tag is EqualUnmodifiableListView) return _tag;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tag);
}


/// Create a copy of DoaDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoaDtoCopyWith<_DoaDto> get copyWith => __$DoaDtoCopyWithImpl<_DoaDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoaDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoaDto&&(identical(other.id, id) || other.id == id)&&(identical(other.grup, grup) || other.grup == grup)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.tr, tr) || other.tr == tr)&&(identical(other.idn, idn) || other.idn == idn)&&(identical(other.tentang, tentang) || other.tentang == tentang)&&const DeepCollectionEquality().equals(other._tag, _tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,grup,nama,ar,tr,idn,tentang,const DeepCollectionEquality().hash(_tag));

@override
String toString() {
  return 'DoaDto(id: $id, grup: $grup, nama: $nama, ar: $ar, tr: $tr, idn: $idn, tentang: $tentang, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$DoaDtoCopyWith<$Res> implements $DoaDtoCopyWith<$Res> {
  factory _$DoaDtoCopyWith(_DoaDto value, $Res Function(_DoaDto) _then) = __$DoaDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String grup, String nama, String ar, String tr, String idn, String tentang, List<String> tag
});




}
/// @nodoc
class __$DoaDtoCopyWithImpl<$Res>
    implements _$DoaDtoCopyWith<$Res> {
  __$DoaDtoCopyWithImpl(this._self, this._then);

  final _DoaDto _self;
  final $Res Function(_DoaDto) _then;

/// Create a copy of DoaDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? grup = null,Object? nama = null,Object? ar = null,Object? tr = null,Object? idn = null,Object? tentang = null,Object? tag = null,}) {
  return _then(_DoaDto(
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
