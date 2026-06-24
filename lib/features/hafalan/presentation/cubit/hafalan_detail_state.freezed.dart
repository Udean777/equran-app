// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hafalan_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HafalanDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanDetailState()';
}


}

/// @nodoc
class $HafalanDetailStateCopyWith<$Res>  {
$HafalanDetailStateCopyWith(HafalanDetailState _, $Res Function(HafalanDetailState) __);
}


/// Adds pattern-matching-related methods to [HafalanDetailState].
extension HafalanDetailStatePatterns on HafalanDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HafalanDetailInitial value)?  initial,TResult Function( HafalanDetailLoading value)?  loading,TResult Function( HafalanDetailSuccess value)?  success,TResult Function( HafalanDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HafalanDetailInitial() when initial != null:
return initial(_that);case HafalanDetailLoading() when loading != null:
return loading(_that);case HafalanDetailSuccess() when success != null:
return success(_that);case HafalanDetailFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HafalanDetailInitial value)  initial,required TResult Function( HafalanDetailLoading value)  loading,required TResult Function( HafalanDetailSuccess value)  success,required TResult Function( HafalanDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case HafalanDetailInitial():
return initial(_that);case HafalanDetailLoading():
return loading(_that);case HafalanDetailSuccess():
return success(_that);case HafalanDetailFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HafalanDetailInitial value)?  initial,TResult? Function( HafalanDetailLoading value)?  loading,TResult? Function( HafalanDetailSuccess value)?  success,TResult? Function( HafalanDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case HafalanDetailInitial() when initial != null:
return initial(_that);case HafalanDetailLoading() when loading != null:
return loading(_that);case HafalanDetailSuccess() when success != null:
return success(_that);case HafalanDetailFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( HafalanSurat? hafalan)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HafalanDetailInitial() when initial != null:
return initial();case HafalanDetailLoading() when loading != null:
return loading();case HafalanDetailSuccess() when success != null:
return success(_that.hafalan);case HafalanDetailFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( HafalanSurat? hafalan)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case HafalanDetailInitial():
return initial();case HafalanDetailLoading():
return loading();case HafalanDetailSuccess():
return success(_that.hafalan);case HafalanDetailFailure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( HafalanSurat? hafalan)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case HafalanDetailInitial() when initial != null:
return initial();case HafalanDetailLoading() when loading != null:
return loading();case HafalanDetailSuccess() when success != null:
return success(_that.hafalan);case HafalanDetailFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HafalanDetailInitial implements HafalanDetailState {
  const HafalanDetailInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanDetailState.initial()';
}


}




/// @nodoc


class HafalanDetailLoading implements HafalanDetailState {
  const HafalanDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanDetailState.loading()';
}


}




/// @nodoc


class HafalanDetailSuccess implements HafalanDetailState {
  const HafalanDetailSuccess({this.hafalan});
  

 final  HafalanSurat? hafalan;

/// Create a copy of HafalanDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanDetailSuccessCopyWith<HafalanDetailSuccess> get copyWith => _$HafalanDetailSuccessCopyWithImpl<HafalanDetailSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanDetailSuccess&&(identical(other.hafalan, hafalan) || other.hafalan == hafalan));
}


@override
int get hashCode => Object.hash(runtimeType,hafalan);

@override
String toString() {
  return 'HafalanDetailState.success(hafalan: $hafalan)';
}


}

/// @nodoc
abstract mixin class $HafalanDetailSuccessCopyWith<$Res> implements $HafalanDetailStateCopyWith<$Res> {
  factory $HafalanDetailSuccessCopyWith(HafalanDetailSuccess value, $Res Function(HafalanDetailSuccess) _then) = _$HafalanDetailSuccessCopyWithImpl;
@useResult
$Res call({
 HafalanSurat? hafalan
});


$HafalanSuratCopyWith<$Res>? get hafalan;

}
/// @nodoc
class _$HafalanDetailSuccessCopyWithImpl<$Res>
    implements $HafalanDetailSuccessCopyWith<$Res> {
  _$HafalanDetailSuccessCopyWithImpl(this._self, this._then);

  final HafalanDetailSuccess _self;
  final $Res Function(HafalanDetailSuccess) _then;

/// Create a copy of HafalanDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hafalan = freezed,}) {
  return _then(HafalanDetailSuccess(
hafalan: freezed == hafalan ? _self.hafalan : hafalan // ignore: cast_nullable_to_non_nullable
as HafalanSurat?,
  ));
}

/// Create a copy of HafalanDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HafalanSuratCopyWith<$Res>? get hafalan {
    if (_self.hafalan == null) {
    return null;
  }

  return $HafalanSuratCopyWith<$Res>(_self.hafalan!, (value) {
    return _then(_self.copyWith(hafalan: value));
  });
}
}

/// @nodoc


class HafalanDetailFailure implements HafalanDetailState {
  const HafalanDetailFailure(this.message);
  

 final  String message;

/// Create a copy of HafalanDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanDetailFailureCopyWith<HafalanDetailFailure> get copyWith => _$HafalanDetailFailureCopyWithImpl<HafalanDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanDetailFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HafalanDetailState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $HafalanDetailFailureCopyWith<$Res> implements $HafalanDetailStateCopyWith<$Res> {
  factory $HafalanDetailFailureCopyWith(HafalanDetailFailure value, $Res Function(HafalanDetailFailure) _then) = _$HafalanDetailFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HafalanDetailFailureCopyWithImpl<$Res>
    implements $HafalanDetailFailureCopyWith<$Res> {
  _$HafalanDetailFailureCopyWithImpl(this._self, this._then);

  final HafalanDetailFailure _self;
  final $Res Function(HafalanDetailFailure) _then;

/// Create a copy of HafalanDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HafalanDetailFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
