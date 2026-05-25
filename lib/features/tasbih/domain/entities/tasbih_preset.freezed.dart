// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasbih_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TasbihPreset {

 String get id; String get name; String get arabic; int get defaultTarget;
/// Create a copy of TasbihPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasbihPresetCopyWith<TasbihPreset> get copyWith => _$TasbihPresetCopyWithImpl<TasbihPreset>(this as TasbihPreset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasbihPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.defaultTarget, defaultTarget) || other.defaultTarget == defaultTarget));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,arabic,defaultTarget);

@override
String toString() {
  return 'TasbihPreset(id: $id, name: $name, arabic: $arabic, defaultTarget: $defaultTarget)';
}


}

/// @nodoc
abstract mixin class $TasbihPresetCopyWith<$Res>  {
  factory $TasbihPresetCopyWith(TasbihPreset value, $Res Function(TasbihPreset) _then) = _$TasbihPresetCopyWithImpl;
@useResult
$Res call({
 String id, String name, String arabic, int defaultTarget
});




}
/// @nodoc
class _$TasbihPresetCopyWithImpl<$Res>
    implements $TasbihPresetCopyWith<$Res> {
  _$TasbihPresetCopyWithImpl(this._self, this._then);

  final TasbihPreset _self;
  final $Res Function(TasbihPreset) _then;

/// Create a copy of TasbihPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? arabic = null,Object? defaultTarget = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,defaultTarget: null == defaultTarget ? _self.defaultTarget : defaultTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TasbihPreset].
extension TasbihPresetPatterns on TasbihPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TasbihPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TasbihPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TasbihPreset value)  $default,){
final _that = this;
switch (_that) {
case _TasbihPreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TasbihPreset value)?  $default,){
final _that = this;
switch (_that) {
case _TasbihPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String arabic,  int defaultTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TasbihPreset() when $default != null:
return $default(_that.id,_that.name,_that.arabic,_that.defaultTarget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String arabic,  int defaultTarget)  $default,) {final _that = this;
switch (_that) {
case _TasbihPreset():
return $default(_that.id,_that.name,_that.arabic,_that.defaultTarget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String arabic,  int defaultTarget)?  $default,) {final _that = this;
switch (_that) {
case _TasbihPreset() when $default != null:
return $default(_that.id,_that.name,_that.arabic,_that.defaultTarget);case _:
  return null;

}
}

}

/// @nodoc


class _TasbihPreset implements TasbihPreset {
  const _TasbihPreset({required this.id, required this.name, required this.arabic, required this.defaultTarget});
  

@override final  String id;
@override final  String name;
@override final  String arabic;
@override final  int defaultTarget;

/// Create a copy of TasbihPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TasbihPresetCopyWith<_TasbihPreset> get copyWith => __$TasbihPresetCopyWithImpl<_TasbihPreset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TasbihPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.defaultTarget, defaultTarget) || other.defaultTarget == defaultTarget));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,arabic,defaultTarget);

@override
String toString() {
  return 'TasbihPreset(id: $id, name: $name, arabic: $arabic, defaultTarget: $defaultTarget)';
}


}

/// @nodoc
abstract mixin class _$TasbihPresetCopyWith<$Res> implements $TasbihPresetCopyWith<$Res> {
  factory _$TasbihPresetCopyWith(_TasbihPreset value, $Res Function(_TasbihPreset) _then) = __$TasbihPresetCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String arabic, int defaultTarget
});




}
/// @nodoc
class __$TasbihPresetCopyWithImpl<$Res>
    implements _$TasbihPresetCopyWith<$Res> {
  __$TasbihPresetCopyWithImpl(this._self, this._then);

  final _TasbihPreset _self;
  final $Res Function(_TasbihPreset) _then;

/// Create a copy of TasbihPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? arabic = null,Object? defaultTarget = null,}) {
  return _then(_TasbihPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,defaultTarget: null == defaultTarget ? _self.defaultTarget : defaultTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
