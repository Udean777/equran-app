// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasbih_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TasbihSessionDto {

 String get id; String get presetId; String get presetName; int get count; int get target; String get createdAt;
/// Create a copy of TasbihSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasbihSessionDtoCopyWith<TasbihSessionDto> get copyWith => _$TasbihSessionDtoCopyWithImpl<TasbihSessionDto>(this as TasbihSessionDto, _$identity);

  /// Serializes this TasbihSessionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasbihSessionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.count, count) || other.count == count)&&(identical(other.target, target) || other.target == target)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,presetId,presetName,count,target,createdAt);

@override
String toString() {
  return 'TasbihSessionDto(id: $id, presetId: $presetId, presetName: $presetName, count: $count, target: $target, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TasbihSessionDtoCopyWith<$Res>  {
  factory $TasbihSessionDtoCopyWith(TasbihSessionDto value, $Res Function(TasbihSessionDto) _then) = _$TasbihSessionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String presetId, String presetName, int count, int target, String createdAt
});




}
/// @nodoc
class _$TasbihSessionDtoCopyWithImpl<$Res>
    implements $TasbihSessionDtoCopyWith<$Res> {
  _$TasbihSessionDtoCopyWithImpl(this._self, this._then);

  final TasbihSessionDto _self;
  final $Res Function(TasbihSessionDto) _then;

/// Create a copy of TasbihSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? presetId = null,Object? presetName = null,Object? count = null,Object? target = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,presetId: null == presetId ? _self.presetId : presetId // ignore: cast_nullable_to_non_nullable
as String,presetName: null == presetName ? _self.presetName : presetName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TasbihSessionDto].
extension TasbihSessionDtoPatterns on TasbihSessionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TasbihSessionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TasbihSessionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TasbihSessionDto value)  $default,){
final _that = this;
switch (_that) {
case _TasbihSessionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TasbihSessionDto value)?  $default,){
final _that = this;
switch (_that) {
case _TasbihSessionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String presetId,  String presetName,  int count,  int target,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TasbihSessionDto() when $default != null:
return $default(_that.id,_that.presetId,_that.presetName,_that.count,_that.target,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String presetId,  String presetName,  int count,  int target,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _TasbihSessionDto():
return $default(_that.id,_that.presetId,_that.presetName,_that.count,_that.target,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String presetId,  String presetName,  int count,  int target,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TasbihSessionDto() when $default != null:
return $default(_that.id,_that.presetId,_that.presetName,_that.count,_that.target,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TasbihSessionDto implements TasbihSessionDto {
  const _TasbihSessionDto({required this.id, required this.presetId, required this.presetName, required this.count, required this.target, required this.createdAt});
  factory _TasbihSessionDto.fromJson(Map<String, dynamic> json) => _$TasbihSessionDtoFromJson(json);

@override final  String id;
@override final  String presetId;
@override final  String presetName;
@override final  int count;
@override final  int target;
@override final  String createdAt;

/// Create a copy of TasbihSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TasbihSessionDtoCopyWith<_TasbihSessionDto> get copyWith => __$TasbihSessionDtoCopyWithImpl<_TasbihSessionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TasbihSessionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TasbihSessionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.presetName, presetName) || other.presetName == presetName)&&(identical(other.count, count) || other.count == count)&&(identical(other.target, target) || other.target == target)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,presetId,presetName,count,target,createdAt);

@override
String toString() {
  return 'TasbihSessionDto(id: $id, presetId: $presetId, presetName: $presetName, count: $count, target: $target, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TasbihSessionDtoCopyWith<$Res> implements $TasbihSessionDtoCopyWith<$Res> {
  factory _$TasbihSessionDtoCopyWith(_TasbihSessionDto value, $Res Function(_TasbihSessionDto) _then) = __$TasbihSessionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String presetId, String presetName, int count, int target, String createdAt
});




}
/// @nodoc
class __$TasbihSessionDtoCopyWithImpl<$Res>
    implements _$TasbihSessionDtoCopyWith<$Res> {
  __$TasbihSessionDtoCopyWithImpl(this._self, this._then);

  final _TasbihSessionDto _self;
  final $Res Function(_TasbihSessionDto) _then;

/// Create a copy of TasbihSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? presetId = null,Object? presetName = null,Object? count = null,Object? target = null,Object? createdAt = null,}) {
  return _then(_TasbihSessionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,presetId: null == presetId ? _self.presetId : presetId // ignore: cast_nullable_to_non_nullable
as String,presetName: null == presetName ? _self.presetName : presetName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
