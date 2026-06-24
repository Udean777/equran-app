// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quran_reminder_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuranReminderState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranReminderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuranReminderState()';
}


}

/// @nodoc
class $QuranReminderStateCopyWith<$Res>  {
$QuranReminderStateCopyWith(QuranReminderState _, $Res Function(QuranReminderState) __);
}


/// Adds pattern-matching-related methods to [QuranReminderState].
extension QuranReminderStatePatterns on QuranReminderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuranReminderInitial value)?  initial,TResult Function( QuranReminderLoaded value)?  loaded,TResult Function( QuranReminderError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuranReminderInitial() when initial != null:
return initial(_that);case QuranReminderLoaded() when loaded != null:
return loaded(_that);case QuranReminderError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuranReminderInitial value)  initial,required TResult Function( QuranReminderLoaded value)  loaded,required TResult Function( QuranReminderError value)  error,}){
final _that = this;
switch (_that) {
case QuranReminderInitial():
return initial(_that);case QuranReminderLoaded():
return loaded(_that);case QuranReminderError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuranReminderInitial value)?  initial,TResult? Function( QuranReminderLoaded value)?  loaded,TResult? Function( QuranReminderError value)?  error,}){
final _that = this;
switch (_that) {
case QuranReminderInitial() when initial != null:
return initial(_that);case QuranReminderLoaded() when loaded != null:
return loaded(_that);case QuranReminderError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( QuranReminderPrefs prefs)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuranReminderInitial() when initial != null:
return initial();case QuranReminderLoaded() when loaded != null:
return loaded(_that.prefs);case QuranReminderError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( QuranReminderPrefs prefs)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case QuranReminderInitial():
return initial();case QuranReminderLoaded():
return loaded(_that.prefs);case QuranReminderError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( QuranReminderPrefs prefs)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case QuranReminderInitial() when initial != null:
return initial();case QuranReminderLoaded() when loaded != null:
return loaded(_that.prefs);case QuranReminderError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class QuranReminderInitial implements QuranReminderState {
  const QuranReminderInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranReminderInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuranReminderState.initial()';
}


}




/// @nodoc


class QuranReminderLoaded implements QuranReminderState {
  const QuranReminderLoaded(this.prefs);
  

 final  QuranReminderPrefs prefs;

/// Create a copy of QuranReminderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuranReminderLoadedCopyWith<QuranReminderLoaded> get copyWith => _$QuranReminderLoadedCopyWithImpl<QuranReminderLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranReminderLoaded&&(identical(other.prefs, prefs) || other.prefs == prefs));
}


@override
int get hashCode => Object.hash(runtimeType,prefs);

@override
String toString() {
  return 'QuranReminderState.loaded(prefs: $prefs)';
}


}

/// @nodoc
abstract mixin class $QuranReminderLoadedCopyWith<$Res> implements $QuranReminderStateCopyWith<$Res> {
  factory $QuranReminderLoadedCopyWith(QuranReminderLoaded value, $Res Function(QuranReminderLoaded) _then) = _$QuranReminderLoadedCopyWithImpl;
@useResult
$Res call({
 QuranReminderPrefs prefs
});


$QuranReminderPrefsCopyWith<$Res> get prefs;

}
/// @nodoc
class _$QuranReminderLoadedCopyWithImpl<$Res>
    implements $QuranReminderLoadedCopyWith<$Res> {
  _$QuranReminderLoadedCopyWithImpl(this._self, this._then);

  final QuranReminderLoaded _self;
  final $Res Function(QuranReminderLoaded) _then;

/// Create a copy of QuranReminderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? prefs = null,}) {
  return _then(QuranReminderLoaded(
null == prefs ? _self.prefs : prefs // ignore: cast_nullable_to_non_nullable
as QuranReminderPrefs,
  ));
}

/// Create a copy of QuranReminderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuranReminderPrefsCopyWith<$Res> get prefs {
  
  return $QuranReminderPrefsCopyWith<$Res>(_self.prefs, (value) {
    return _then(_self.copyWith(prefs: value));
  });
}
}

/// @nodoc


class QuranReminderError implements QuranReminderState {
  const QuranReminderError(this.failure);
  

 final  Failure failure;

/// Create a copy of QuranReminderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuranReminderErrorCopyWith<QuranReminderError> get copyWith => _$QuranReminderErrorCopyWithImpl<QuranReminderError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranReminderError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'QuranReminderState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $QuranReminderErrorCopyWith<$Res> implements $QuranReminderStateCopyWith<$Res> {
  factory $QuranReminderErrorCopyWith(QuranReminderError value, $Res Function(QuranReminderError) _then) = _$QuranReminderErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$QuranReminderErrorCopyWithImpl<$Res>
    implements $QuranReminderErrorCopyWith<$Res> {
  _$QuranReminderErrorCopyWithImpl(this._self, this._then);

  final QuranReminderError _self;
  final $Res Function(QuranReminderError) _then;

/// Create a copy of QuranReminderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(QuranReminderError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of QuranReminderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
