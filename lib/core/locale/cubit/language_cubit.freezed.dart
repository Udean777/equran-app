// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LanguageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LanguageState()';
}


}

/// @nodoc
class $LanguageStateCopyWith<$Res>  {
$LanguageStateCopyWith(LanguageState _, $Res Function(LanguageState) __);
}


/// Adds pattern-matching-related methods to [LanguageState].
extension LanguageStatePatterns on LanguageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LanguageId value)?  id,TResult Function( LanguageEn value)?  en,TResult Function( LanguageAr value)?  ar,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LanguageId() when id != null:
return id(_that);case LanguageEn() when en != null:
return en(_that);case LanguageAr() when ar != null:
return ar(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LanguageId value)  id,required TResult Function( LanguageEn value)  en,required TResult Function( LanguageAr value)  ar,}){
final _that = this;
switch (_that) {
case LanguageId():
return id(_that);case LanguageEn():
return en(_that);case LanguageAr():
return ar(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LanguageId value)?  id,TResult? Function( LanguageEn value)?  en,TResult? Function( LanguageAr value)?  ar,}){
final _that = this;
switch (_that) {
case LanguageId() when id != null:
return id(_that);case LanguageEn() when en != null:
return en(_that);case LanguageAr() when ar != null:
return ar(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  id,TResult Function()?  en,TResult Function()?  ar,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LanguageId() when id != null:
return id();case LanguageEn() when en != null:
return en();case LanguageAr() when ar != null:
return ar();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  id,required TResult Function()  en,required TResult Function()  ar,}) {final _that = this;
switch (_that) {
case LanguageId():
return id();case LanguageEn():
return en();case LanguageAr():
return ar();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  id,TResult? Function()?  en,TResult? Function()?  ar,}) {final _that = this;
switch (_that) {
case LanguageId() when id != null:
return id();case LanguageEn() when en != null:
return en();case LanguageAr() when ar != null:
return ar();case _:
  return null;

}
}

}

/// @nodoc


class LanguageId implements LanguageState {
  const LanguageId();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageId);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LanguageState.id()';
}


}




/// @nodoc


class LanguageEn implements LanguageState {
  const LanguageEn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageEn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LanguageState.en()';
}


}




/// @nodoc


class LanguageAr implements LanguageState {
  const LanguageAr();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageAr);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LanguageState.ar()';
}


}




// dart format on
