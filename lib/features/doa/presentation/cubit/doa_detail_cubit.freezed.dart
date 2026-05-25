// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doa_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoaDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaDetailState()';
}


}

/// @nodoc
class $DoaDetailStateCopyWith<$Res>  {
$DoaDetailStateCopyWith(DoaDetailState _, $Res Function(DoaDetailState) __);
}


/// Adds pattern-matching-related methods to [DoaDetailState].
extension DoaDetailStatePatterns on DoaDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DoaDetailInitial value)?  initial,TResult Function( DoaDetailLoading value)?  loading,TResult Function( DoaDetailSuccess value)?  success,TResult Function( DoaDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DoaDetailInitial() when initial != null:
return initial(_that);case DoaDetailLoading() when loading != null:
return loading(_that);case DoaDetailSuccess() when success != null:
return success(_that);case DoaDetailFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DoaDetailInitial value)  initial,required TResult Function( DoaDetailLoading value)  loading,required TResult Function( DoaDetailSuccess value)  success,required TResult Function( DoaDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case DoaDetailInitial():
return initial(_that);case DoaDetailLoading():
return loading(_that);case DoaDetailSuccess():
return success(_that);case DoaDetailFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DoaDetailInitial value)?  initial,TResult? Function( DoaDetailLoading value)?  loading,TResult? Function( DoaDetailSuccess value)?  success,TResult? Function( DoaDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DoaDetailInitial() when initial != null:
return initial(_that);case DoaDetailLoading() when loading != null:
return loading(_that);case DoaDetailSuccess() when success != null:
return success(_that);case DoaDetailFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Doa doa)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DoaDetailInitial() when initial != null:
return initial();case DoaDetailLoading() when loading != null:
return loading();case DoaDetailSuccess() when success != null:
return success(_that.doa);case DoaDetailFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Doa doa)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DoaDetailInitial():
return initial();case DoaDetailLoading():
return loading();case DoaDetailSuccess():
return success(_that.doa);case DoaDetailFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Doa doa)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DoaDetailInitial() when initial != null:
return initial();case DoaDetailLoading() when loading != null:
return loading();case DoaDetailSuccess() when success != null:
return success(_that.doa);case DoaDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DoaDetailInitial implements DoaDetailState {
  const DoaDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaDetailState.initial()';
}


}




/// @nodoc


class DoaDetailLoading implements DoaDetailState {
  const DoaDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaDetailState.loading()';
}


}




/// @nodoc


class DoaDetailSuccess implements DoaDetailState {
  const DoaDetailSuccess({required this.doa});
  

 final  Doa doa;

/// Create a copy of DoaDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaDetailSuccessCopyWith<DoaDetailSuccess> get copyWith => _$DoaDetailSuccessCopyWithImpl<DoaDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaDetailSuccess&&(identical(other.doa, doa) || other.doa == doa));
}


@override
int get hashCode => Object.hash(runtimeType,doa);

@override
String toString() {
  return 'DoaDetailState.success(doa: $doa)';
}


}

/// @nodoc
abstract mixin class $DoaDetailSuccessCopyWith<$Res> implements $DoaDetailStateCopyWith<$Res> {
  factory $DoaDetailSuccessCopyWith(DoaDetailSuccess value, $Res Function(DoaDetailSuccess) _then) = _$DoaDetailSuccessCopyWithImpl;
@useResult
$Res call({
 Doa doa
});


$DoaCopyWith<$Res> get doa;

}
/// @nodoc
class _$DoaDetailSuccessCopyWithImpl<$Res>
    implements $DoaDetailSuccessCopyWith<$Res> {
  _$DoaDetailSuccessCopyWithImpl(this._self, this._then);

  final DoaDetailSuccess _self;
  final $Res Function(DoaDetailSuccess) _then;

/// Create a copy of DoaDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? doa = null,}) {
  return _then(DoaDetailSuccess(
doa: null == doa ? _self.doa : doa // ignore: cast_nullable_to_non_nullable
as Doa,
  ));
}

/// Create a copy of DoaDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoaCopyWith<$Res> get doa {
  
  return $DoaCopyWith<$Res>(_self.doa, (value) {
    return _then(_self.copyWith(doa: value));
  });
}
}

/// @nodoc


class DoaDetailFailure implements DoaDetailState {
  const DoaDetailFailure({required this.failure});
  

 final  Failure failure;

/// Create a copy of DoaDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaDetailFailureCopyWith<DoaDetailFailure> get copyWith => _$DoaDetailFailureCopyWithImpl<DoaDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DoaDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DoaDetailFailureCopyWith<$Res> implements $DoaDetailStateCopyWith<$Res> {
  factory $DoaDetailFailureCopyWith(DoaDetailFailure value, $Res Function(DoaDetailFailure) _then) = _$DoaDetailFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DoaDetailFailureCopyWithImpl<$Res>
    implements $DoaDetailFailureCopyWith<$Res> {
  _$DoaDetailFailureCopyWithImpl(this._self, this._then);

  final DoaDetailFailure _self;
  final $Res Function(DoaDetailFailure) _then;

/// Create a copy of DoaDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DoaDetailFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DoaDetailState
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
