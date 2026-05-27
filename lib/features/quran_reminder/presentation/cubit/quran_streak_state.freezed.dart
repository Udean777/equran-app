// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quran_streak_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuranStreakState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranStreakState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuranStreakState()';
}


}

/// @nodoc
class $QuranStreakStateCopyWith<$Res>  {
$QuranStreakStateCopyWith(QuranStreakState _, $Res Function(QuranStreakState) __);
}


/// Adds pattern-matching-related methods to [QuranStreakState].
extension QuranStreakStatePatterns on QuranStreakState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuranStreakInitial value)?  initial,TResult Function( QuranStreakLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuranStreakInitial() when initial != null:
return initial(_that);case QuranStreakLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuranStreakInitial value)  initial,required TResult Function( QuranStreakLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case QuranStreakInitial():
return initial(_that);case QuranStreakLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuranStreakInitial value)?  initial,TResult? Function( QuranStreakLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case QuranStreakInitial() when initial != null:
return initial(_that);case QuranStreakLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int streak)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuranStreakInitial() when initial != null:
return initial();case QuranStreakLoaded() when loaded != null:
return loaded(_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int streak)  loaded,}) {final _that = this;
switch (_that) {
case QuranStreakInitial():
return initial();case QuranStreakLoaded():
return loaded(_that.streak);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int streak)?  loaded,}) {final _that = this;
switch (_that) {
case QuranStreakInitial() when initial != null:
return initial();case QuranStreakLoaded() when loaded != null:
return loaded(_that.streak);case _:
  return null;

}
}

}

/// @nodoc


class QuranStreakInitial implements QuranStreakState {
  const QuranStreakInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranStreakInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuranStreakState.initial()';
}


}




/// @nodoc


class QuranStreakLoaded implements QuranStreakState {
  const QuranStreakLoaded(this.streak);
  

 final  int streak;

/// Create a copy of QuranStreakState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuranStreakLoadedCopyWith<QuranStreakLoaded> get copyWith => _$QuranStreakLoadedCopyWithImpl<QuranStreakLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranStreakLoaded&&(identical(other.streak, streak) || other.streak == streak));
}


@override
int get hashCode => Object.hash(runtimeType,streak);

@override
String toString() {
  return 'QuranStreakState.loaded(streak: $streak)';
}


}

/// @nodoc
abstract mixin class $QuranStreakLoadedCopyWith<$Res> implements $QuranStreakStateCopyWith<$Res> {
  factory $QuranStreakLoadedCopyWith(QuranStreakLoaded value, $Res Function(QuranStreakLoaded) _then) = _$QuranStreakLoadedCopyWithImpl;
@useResult
$Res call({
 int streak
});




}
/// @nodoc
class _$QuranStreakLoadedCopyWithImpl<$Res>
    implements $QuranStreakLoadedCopyWith<$Res> {
  _$QuranStreakLoadedCopyWithImpl(this._self, this._then);

  final QuranStreakLoaded _self;
  final $Res Function(QuranStreakLoaded) _then;

/// Create a copy of QuranStreakState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? streak = null,}) {
  return _then(QuranStreakLoaded(
null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
