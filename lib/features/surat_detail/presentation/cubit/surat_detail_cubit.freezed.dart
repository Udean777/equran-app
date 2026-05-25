// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surat_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SuratDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SuratDetailState()';
}


}

/// @nodoc
class $SuratDetailStateCopyWith<$Res>  {
$SuratDetailStateCopyWith(SuratDetailState _, $Res Function(SuratDetailState) __);
}


/// Adds pattern-matching-related methods to [SuratDetailState].
extension SuratDetailStatePatterns on SuratDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SuratDetailInitial value)?  initial,TResult Function( SuratDetailLoading value)?  loading,TResult Function( SuratDetailSuccess value)?  success,TResult Function( SuratDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SuratDetailInitial() when initial != null:
return initial(_that);case SuratDetailLoading() when loading != null:
return loading(_that);case SuratDetailSuccess() when success != null:
return success(_that);case SuratDetailFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SuratDetailInitial value)  initial,required TResult Function( SuratDetailLoading value)  loading,required TResult Function( SuratDetailSuccess value)  success,required TResult Function( SuratDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case SuratDetailInitial():
return initial(_that);case SuratDetailLoading():
return loading(_that);case SuratDetailSuccess():
return success(_that);case SuratDetailFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SuratDetailInitial value)?  initial,TResult? Function( SuratDetailLoading value)?  loading,TResult? Function( SuratDetailSuccess value)?  success,TResult? Function( SuratDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SuratDetailInitial() when initial != null:
return initial(_that);case SuratDetailLoading() when loading != null:
return loading(_that);case SuratDetailSuccess() when success != null:
return success(_that);case SuratDetailFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( SuratDetail detail)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SuratDetailInitial() when initial != null:
return initial();case SuratDetailLoading() when loading != null:
return loading();case SuratDetailSuccess() when success != null:
return success(_that.detail);case SuratDetailFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( SuratDetail detail)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case SuratDetailInitial():
return initial();case SuratDetailLoading():
return loading();case SuratDetailSuccess():
return success(_that.detail);case SuratDetailFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( SuratDetail detail)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case SuratDetailInitial() when initial != null:
return initial();case SuratDetailLoading() when loading != null:
return loading();case SuratDetailSuccess() when success != null:
return success(_that.detail);case SuratDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SuratDetailInitial implements SuratDetailState {
  const SuratDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SuratDetailState.initial()';
}


}




/// @nodoc


class SuratDetailLoading implements SuratDetailState {
  const SuratDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SuratDetailState.loading()';
}


}




/// @nodoc


class SuratDetailSuccess implements SuratDetailState {
  const SuratDetailSuccess({required this.detail});
  

 final  SuratDetail detail;

/// Create a copy of SuratDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratDetailSuccessCopyWith<SuratDetailSuccess> get copyWith => _$SuratDetailSuccessCopyWithImpl<SuratDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetailSuccess&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,detail);

@override
String toString() {
  return 'SuratDetailState.success(detail: $detail)';
}


}

/// @nodoc
abstract mixin class $SuratDetailSuccessCopyWith<$Res> implements $SuratDetailStateCopyWith<$Res> {
  factory $SuratDetailSuccessCopyWith(SuratDetailSuccess value, $Res Function(SuratDetailSuccess) _then) = _$SuratDetailSuccessCopyWithImpl;
@useResult
$Res call({
 SuratDetail detail
});


$SuratDetailCopyWith<$Res> get detail;

}
/// @nodoc
class _$SuratDetailSuccessCopyWithImpl<$Res>
    implements $SuratDetailSuccessCopyWith<$Res> {
  _$SuratDetailSuccessCopyWithImpl(this._self, this._then);

  final SuratDetailSuccess _self;
  final $Res Function(SuratDetailSuccess) _then;

/// Create a copy of SuratDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,}) {
  return _then(SuratDetailSuccess(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as SuratDetail,
  ));
}

/// Create a copy of SuratDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuratDetailCopyWith<$Res> get detail {
  
  return $SuratDetailCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

/// @nodoc


class SuratDetailFailure implements SuratDetailState {
  const SuratDetailFailure({required this.failure});
  

 final  Failure failure;

/// Create a copy of SuratDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratDetailFailureCopyWith<SuratDetailFailure> get copyWith => _$SuratDetailFailureCopyWithImpl<SuratDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SuratDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SuratDetailFailureCopyWith<$Res> implements $SuratDetailStateCopyWith<$Res> {
  factory $SuratDetailFailureCopyWith(SuratDetailFailure value, $Res Function(SuratDetailFailure) _then) = _$SuratDetailFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SuratDetailFailureCopyWithImpl<$Res>
    implements $SuratDetailFailureCopyWith<$Res> {
  _$SuratDetailFailureCopyWithImpl(this._self, this._then);

  final SuratDetailFailure _self;
  final $Res Function(SuratDetailFailure) _then;

/// Create a copy of SuratDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SuratDetailFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of SuratDetailState
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
