// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tafsir_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TafsirState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TafsirState()';
}


}

/// @nodoc
class $TafsirStateCopyWith<$Res>  {
$TafsirStateCopyWith(TafsirState _, $Res Function(TafsirState) __);
}


/// Adds pattern-matching-related methods to [TafsirState].
extension TafsirStatePatterns on TafsirState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TafsirInitial value)?  initial,TResult Function( TafsirLoading value)?  loading,TResult Function( TafsirSuccess value)?  success,TResult Function( TafsirFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TafsirInitial() when initial != null:
return initial(_that);case TafsirLoading() when loading != null:
return loading(_that);case TafsirSuccess() when success != null:
return success(_that);case TafsirFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TafsirInitial value)  initial,required TResult Function( TafsirLoading value)  loading,required TResult Function( TafsirSuccess value)  success,required TResult Function( TafsirFailure value)  failure,}){
final _that = this;
switch (_that) {
case TafsirInitial():
return initial(_that);case TafsirLoading():
return loading(_that);case TafsirSuccess():
return success(_that);case TafsirFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TafsirInitial value)?  initial,TResult? Function( TafsirLoading value)?  loading,TResult? Function( TafsirSuccess value)?  success,TResult? Function( TafsirFailure value)?  failure,}){
final _that = this;
switch (_that) {
case TafsirInitial() when initial != null:
return initial(_that);case TafsirLoading() when loading != null:
return loading(_that);case TafsirSuccess() when success != null:
return success(_that);case TafsirFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TafsirSurat tafsir)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TafsirInitial() when initial != null:
return initial();case TafsirLoading() when loading != null:
return loading();case TafsirSuccess() when success != null:
return success(_that.tafsir);case TafsirFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TafsirSurat tafsir)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case TafsirInitial():
return initial();case TafsirLoading():
return loading();case TafsirSuccess():
return success(_that.tafsir);case TafsirFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TafsirSurat tafsir)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case TafsirInitial() when initial != null:
return initial();case TafsirLoading() when loading != null:
return loading();case TafsirSuccess() when success != null:
return success(_that.tafsir);case TafsirFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class TafsirInitial implements TafsirState {
  const TafsirInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TafsirState.initial()';
}


}




/// @nodoc


class TafsirLoading implements TafsirState {
  const TafsirLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TafsirState.loading()';
}


}




/// @nodoc


class TafsirSuccess implements TafsirState {
  const TafsirSuccess({required this.tafsir});
  

 final  TafsirSurat tafsir;

/// Create a copy of TafsirState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafsirSuccessCopyWith<TafsirSuccess> get copyWith => _$TafsirSuccessCopyWithImpl<TafsirSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirSuccess&&(identical(other.tafsir, tafsir) || other.tafsir == tafsir));
}


@override
int get hashCode => Object.hash(runtimeType,tafsir);

@override
String toString() {
  return 'TafsirState.success(tafsir: $tafsir)';
}


}

/// @nodoc
abstract mixin class $TafsirSuccessCopyWith<$Res> implements $TafsirStateCopyWith<$Res> {
  factory $TafsirSuccessCopyWith(TafsirSuccess value, $Res Function(TafsirSuccess) _then) = _$TafsirSuccessCopyWithImpl;
@useResult
$Res call({
 TafsirSurat tafsir
});


$TafsirSuratCopyWith<$Res> get tafsir;

}
/// @nodoc
class _$TafsirSuccessCopyWithImpl<$Res>
    implements $TafsirSuccessCopyWith<$Res> {
  _$TafsirSuccessCopyWithImpl(this._self, this._then);

  final TafsirSuccess _self;
  final $Res Function(TafsirSuccess) _then;

/// Create a copy of TafsirState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tafsir = null,}) {
  return _then(TafsirSuccess(
tafsir: null == tafsir ? _self.tafsir : tafsir // ignore: cast_nullable_to_non_nullable
as TafsirSurat,
  ));
}

/// Create a copy of TafsirState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TafsirSuratCopyWith<$Res> get tafsir {
  
  return $TafsirSuratCopyWith<$Res>(_self.tafsir, (value) {
    return _then(_self.copyWith(tafsir: value));
  });
}
}

/// @nodoc


class TafsirFailure implements TafsirState {
  const TafsirFailure({required this.failure});
  

 final  Failure failure;

/// Create a copy of TafsirState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafsirFailureCopyWith<TafsirFailure> get copyWith => _$TafsirFailureCopyWithImpl<TafsirFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafsirFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'TafsirState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TafsirFailureCopyWith<$Res> implements $TafsirStateCopyWith<$Res> {
  factory $TafsirFailureCopyWith(TafsirFailure value, $Res Function(TafsirFailure) _then) = _$TafsirFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$TafsirFailureCopyWithImpl<$Res>
    implements $TafsirFailureCopyWith<$Res> {
  _$TafsirFailureCopyWithImpl(this._self, this._then);

  final TafsirFailure _self;
  final $Res Function(TafsirFailure) _then;

/// Create a copy of TafsirState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(TafsirFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of TafsirState
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
