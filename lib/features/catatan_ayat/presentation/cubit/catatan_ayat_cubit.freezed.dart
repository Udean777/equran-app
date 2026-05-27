// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catatan_ayat_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatatanAyatState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatatanAyatState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CatatanAyatState()';
}


}

/// @nodoc
class $CatatanAyatStateCopyWith<$Res>  {
$CatatanAyatStateCopyWith(CatatanAyatState _, $Res Function(CatatanAyatState) __);
}


/// Adds pattern-matching-related methods to [CatatanAyatState].
extension CatatanAyatStatePatterns on CatatanAyatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CatatanAyatInitial value)?  initial,TResult Function( CatatanAyatLoading value)?  loading,TResult Function( CatatanAyatSuccess value)?  success,TResult Function( CatatanAyatFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CatatanAyatInitial() when initial != null:
return initial(_that);case CatatanAyatLoading() when loading != null:
return loading(_that);case CatatanAyatSuccess() when success != null:
return success(_that);case CatatanAyatFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CatatanAyatInitial value)  initial,required TResult Function( CatatanAyatLoading value)  loading,required TResult Function( CatatanAyatSuccess value)  success,required TResult Function( CatatanAyatFailure value)  failure,}){
final _that = this;
switch (_that) {
case CatatanAyatInitial():
return initial(_that);case CatatanAyatLoading():
return loading(_that);case CatatanAyatSuccess():
return success(_that);case CatatanAyatFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CatatanAyatInitial value)?  initial,TResult? Function( CatatanAyatLoading value)?  loading,TResult? Function( CatatanAyatSuccess value)?  success,TResult? Function( CatatanAyatFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CatatanAyatInitial() when initial != null:
return initial(_that);case CatatanAyatLoading() when loading != null:
return loading(_that);case CatatanAyatSuccess() when success != null:
return success(_that);case CatatanAyatFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CatatanAyat> catatan)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CatatanAyatInitial() when initial != null:
return initial();case CatatanAyatLoading() when loading != null:
return loading();case CatatanAyatSuccess() when success != null:
return success(_that.catatan);case CatatanAyatFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CatatanAyat> catatan)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case CatatanAyatInitial():
return initial();case CatatanAyatLoading():
return loading();case CatatanAyatSuccess():
return success(_that.catatan);case CatatanAyatFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CatatanAyat> catatan)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case CatatanAyatInitial() when initial != null:
return initial();case CatatanAyatLoading() when loading != null:
return loading();case CatatanAyatSuccess() when success != null:
return success(_that.catatan);case CatatanAyatFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class CatatanAyatInitial implements CatatanAyatState {
  const CatatanAyatInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatatanAyatInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CatatanAyatState.initial()';
}


}




/// @nodoc


class CatatanAyatLoading implements CatatanAyatState {
  const CatatanAyatLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatatanAyatLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CatatanAyatState.loading()';
}


}




/// @nodoc


class CatatanAyatSuccess implements CatatanAyatState {
  const CatatanAyatSuccess(final  List<CatatanAyat> catatan): _catatan = catatan;
  

 final  List<CatatanAyat> _catatan;
 List<CatatanAyat> get catatan {
  if (_catatan is EqualUnmodifiableListView) return _catatan;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_catatan);
}


/// Create a copy of CatatanAyatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatatanAyatSuccessCopyWith<CatatanAyatSuccess> get copyWith => _$CatatanAyatSuccessCopyWithImpl<CatatanAyatSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatatanAyatSuccess&&const DeepCollectionEquality().equals(other._catatan, _catatan));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_catatan));

@override
String toString() {
  return 'CatatanAyatState.success(catatan: $catatan)';
}


}

/// @nodoc
abstract mixin class $CatatanAyatSuccessCopyWith<$Res> implements $CatatanAyatStateCopyWith<$Res> {
  factory $CatatanAyatSuccessCopyWith(CatatanAyatSuccess value, $Res Function(CatatanAyatSuccess) _then) = _$CatatanAyatSuccessCopyWithImpl;
@useResult
$Res call({
 List<CatatanAyat> catatan
});




}
/// @nodoc
class _$CatatanAyatSuccessCopyWithImpl<$Res>
    implements $CatatanAyatSuccessCopyWith<$Res> {
  _$CatatanAyatSuccessCopyWithImpl(this._self, this._then);

  final CatatanAyatSuccess _self;
  final $Res Function(CatatanAyatSuccess) _then;

/// Create a copy of CatatanAyatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? catatan = null,}) {
  return _then(CatatanAyatSuccess(
null == catatan ? _self._catatan : catatan // ignore: cast_nullable_to_non_nullable
as List<CatatanAyat>,
  ));
}


}

/// @nodoc


class CatatanAyatFailure implements CatatanAyatState {
  const CatatanAyatFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of CatatanAyatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatatanAyatFailureCopyWith<CatatanAyatFailure> get copyWith => _$CatatanAyatFailureCopyWithImpl<CatatanAyatFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatatanAyatFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CatatanAyatState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CatatanAyatFailureCopyWith<$Res> implements $CatatanAyatStateCopyWith<$Res> {
  factory $CatatanAyatFailureCopyWith(CatatanAyatFailure value, $Res Function(CatatanAyatFailure) _then) = _$CatatanAyatFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$CatatanAyatFailureCopyWithImpl<$Res>
    implements $CatatanAyatFailureCopyWith<$Res> {
  _$CatatanAyatFailureCopyWithImpl(this._self, this._then);

  final CatatanAyatFailure _self;
  final $Res Function(CatatanAyatFailure) _then;

/// Create a copy of CatatanAyatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CatatanAyatFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of CatatanAyatState
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
