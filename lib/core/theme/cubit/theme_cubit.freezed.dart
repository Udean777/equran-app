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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ThemeLight value)?  light,TResult Function( ThemeDark value)?  dark,TResult Function( ThemeSepia value)?  sepia,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light(_that);case ThemeDark() when dark != null:
return dark(_that);case ThemeSepia() when sepia != null:
return sepia(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ThemeLight value)  light,required TResult Function( ThemeDark value)  dark,required TResult Function( ThemeSepia value)  sepia,}){
final _that = this;
switch (_that) {
case ThemeLight():
return light(_that);case ThemeDark():
return dark(_that);case ThemeSepia():
return sepia(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ThemeLight value)?  light,TResult? Function( ThemeDark value)?  dark,TResult? Function( ThemeSepia value)?  sepia,}){
final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light(_that);case ThemeDark() when dark != null:
return dark(_that);case ThemeSepia() when sepia != null:
return sepia(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  light,TResult Function()?  dark,TResult Function()?  sepia,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light();case ThemeDark() when dark != null:
return dark();case ThemeSepia() when sepia != null:
return sepia();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  light,required TResult Function()  dark,required TResult Function()  sepia,}) {final _that = this;
switch (_that) {
case ThemeLight():
return light();case ThemeDark():
return dark();case ThemeSepia():
return sepia();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  light,TResult? Function()?  dark,TResult? Function()?  sepia,}) {final _that = this;
switch (_that) {
case ThemeLight() when light != null:
return light();case ThemeDark() when dark != null:
return dark();case ThemeSepia() when sepia != null:
return sepia();case _:
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


class ThemeSepia implements ThemeState {
  const ThemeSepia();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeSepia);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState.sepia()';
}


}




// dart format on
