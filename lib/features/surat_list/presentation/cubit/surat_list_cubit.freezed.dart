// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surat_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SuratListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SuratListState()';
}


}

/// @nodoc
class $SuratListStateCopyWith<$Res>  {
$SuratListStateCopyWith(SuratListState _, $Res Function(SuratListState) __);
}


/// Adds pattern-matching-related methods to [SuratListState].
extension SuratListStatePatterns on SuratListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SuratListInitial value)?  initial,TResult Function( SuratListLoading value)?  loading,TResult Function( SuratListSuccess value)?  success,TResult Function( SuratListFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SuratListInitial() when initial != null:
return initial(_that);case SuratListLoading() when loading != null:
return loading(_that);case SuratListSuccess() when success != null:
return success(_that);case SuratListFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SuratListInitial value)  initial,required TResult Function( SuratListLoading value)  loading,required TResult Function( SuratListSuccess value)  success,required TResult Function( SuratListFailure value)  failure,}){
final _that = this;
switch (_that) {
case SuratListInitial():
return initial(_that);case SuratListLoading():
return loading(_that);case SuratListSuccess():
return success(_that);case SuratListFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SuratListInitial value)?  initial,TResult? Function( SuratListLoading value)?  loading,TResult? Function( SuratListSuccess value)?  success,TResult? Function( SuratListFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SuratListInitial() when initial != null:
return initial(_that);case SuratListLoading() when loading != null:
return loading(_that);case SuratListSuccess() when success != null:
return success(_that);case SuratListFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Surat> surats,  String query)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SuratListInitial() when initial != null:
return initial();case SuratListLoading() when loading != null:
return loading();case SuratListSuccess() when success != null:
return success(_that.surats,_that.query);case SuratListFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Surat> surats,  String query)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case SuratListInitial():
return initial();case SuratListLoading():
return loading();case SuratListSuccess():
return success(_that.surats,_that.query);case SuratListFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Surat> surats,  String query)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case SuratListInitial() when initial != null:
return initial();case SuratListLoading() when loading != null:
return loading();case SuratListSuccess() when success != null:
return success(_that.surats,_that.query);case SuratListFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SuratListInitial implements SuratListState {
  const SuratListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SuratListState.initial()';
}


}




/// @nodoc


class SuratListLoading implements SuratListState {
  const SuratListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SuratListState.loading()';
}


}




/// @nodoc


class SuratListSuccess implements SuratListState {
  const SuratListSuccess({required final  List<Surat> surats, this.query = ''}): _surats = surats;
  

 final  List<Surat> _surats;
 List<Surat> get surats {
  if (_surats is EqualUnmodifiableListView) return _surats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surats);
}

@JsonKey() final  String query;

/// Create a copy of SuratListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratListSuccessCopyWith<SuratListSuccess> get copyWith => _$SuratListSuccessCopyWithImpl<SuratListSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratListSuccess&&const DeepCollectionEquality().equals(other._surats, _surats)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_surats),query);

@override
String toString() {
  return 'SuratListState.success(surats: $surats, query: $query)';
}


}

/// @nodoc
abstract mixin class $SuratListSuccessCopyWith<$Res> implements $SuratListStateCopyWith<$Res> {
  factory $SuratListSuccessCopyWith(SuratListSuccess value, $Res Function(SuratListSuccess) _then) = _$SuratListSuccessCopyWithImpl;
@useResult
$Res call({
 List<Surat> surats, String query
});




}
/// @nodoc
class _$SuratListSuccessCopyWithImpl<$Res>
    implements $SuratListSuccessCopyWith<$Res> {
  _$SuratListSuccessCopyWithImpl(this._self, this._then);

  final SuratListSuccess _self;
  final $Res Function(SuratListSuccess) _then;

/// Create a copy of SuratListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? surats = null,Object? query = null,}) {
  return _then(SuratListSuccess(
surats: null == surats ? _self._surats : surats // ignore: cast_nullable_to_non_nullable
as List<Surat>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SuratListFailure implements SuratListState {
  const SuratListFailure({required this.failure});
  

 final  Failure failure;

/// Create a copy of SuratListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratListFailureCopyWith<SuratListFailure> get copyWith => _$SuratListFailureCopyWithImpl<SuratListFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratListFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SuratListState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SuratListFailureCopyWith<$Res> implements $SuratListStateCopyWith<$Res> {
  factory $SuratListFailureCopyWith(SuratListFailure value, $Res Function(SuratListFailure) _then) = _$SuratListFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SuratListFailureCopyWithImpl<$Res>
    implements $SuratListFailureCopyWith<$Res> {
  _$SuratListFailureCopyWithImpl(this._self, this._then);

  final SuratListFailure _self;
  final $Res Function(SuratListFailure) _then;

/// Create a copy of SuratListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SuratListFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of SuratListState
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
