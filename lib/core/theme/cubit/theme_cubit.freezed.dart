// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState()';
}


}

/// @nodoc
class $ThemeStateCopyWith<$Res>  {
$ThemeStateCopyWith(ThemeState _, $Res Function(ThemeState) __);
}


/// Adds pattern-matching-related methods to [ThemeState].
extension ThemeStatePatterns on ThemeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ThemeLight value)?  light,TResult Function( ThemeDark value)?  dark,TResult Function( ThemeError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light(_that);case ThemeDark() when dark != null:
return dark(_that);case ThemeError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ThemeLight value)  light,required TResult Function( ThemeDark value)  dark,required TResult Function( ThemeError value)  error,}){
final _that = this;
switch (_that) {
case ThemeLight():
return light(_that);case ThemeDark():
return dark(_that);case ThemeError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ThemeLight value)?  light,TResult? Function( ThemeDark value)?  dark,TResult? Function( ThemeError value)?  error,}){
final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light(_that);case ThemeDark() when dark != null:
return dark(_that);case ThemeError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  light,TResult Function()?  dark,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light();case ThemeDark() when dark != null:
return dark();case ThemeError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  light,required TResult Function()  dark,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ThemeLight():
return light();case ThemeDark():
return dark();case ThemeError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  light,TResult? Function()?  dark,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light();case ThemeDark() when dark != null:
return dark();case ThemeError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ThemeLight implements ThemeState {
  const ThemeLight();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeLight);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState.light()';
}


}




/// @nodoc


class ThemeDark implements ThemeState {
  const ThemeDark();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeDark);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState.dark()';
}


}




/// @nodoc


class ThemeError implements ThemeState {
  const ThemeError(this.message);
  

 final  String message;

/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeErrorCopyWith<ThemeError> get copyWith => _$ThemeErrorCopyWithImpl<ThemeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ThemeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ThemeErrorCopyWith<$Res> implements $ThemeStateCopyWith<$Res> {
  factory $ThemeErrorCopyWith(ThemeError value, $Res Function(ThemeError) _then) = _$ThemeErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ThemeErrorCopyWithImpl<$Res>
    implements $ThemeErrorCopyWith<$Res> {
  _$ThemeErrorCopyWithImpl(this._self, this._then);

  final ThemeError _self;
  final $Res Function(ThemeError) _then;

/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ThemeError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
