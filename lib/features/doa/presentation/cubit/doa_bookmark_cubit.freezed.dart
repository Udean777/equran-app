// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doa_bookmark_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoaBookmarkState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaBookmarkState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaBookmarkState()';
}


}

/// @nodoc
class $DoaBookmarkStateCopyWith<$Res>  {
$DoaBookmarkStateCopyWith(DoaBookmarkState _, $Res Function(DoaBookmarkState) __);
}


/// Adds pattern-matching-related methods to [DoaBookmarkState].
extension DoaBookmarkStatePatterns on DoaBookmarkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DoaBookmarkInitial value)?  initial,TResult Function( DoaBookmarkLoading value)?  loading,TResult Function( DoaBookmarkSuccess value)?  success,TResult Function( DoaBookmarkFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DoaBookmarkInitial() when initial != null:
return initial(_that);case DoaBookmarkLoading() when loading != null:
return loading(_that);case DoaBookmarkSuccess() when success != null:
return success(_that);case DoaBookmarkFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DoaBookmarkInitial value)  initial,required TResult Function( DoaBookmarkLoading value)  loading,required TResult Function( DoaBookmarkSuccess value)  success,required TResult Function( DoaBookmarkFailure value)  failure,}){
final _that = this;
switch (_that) {
case DoaBookmarkInitial():
return initial(_that);case DoaBookmarkLoading():
return loading(_that);case DoaBookmarkSuccess():
return success(_that);case DoaBookmarkFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DoaBookmarkInitial value)?  initial,TResult? Function( DoaBookmarkLoading value)?  loading,TResult? Function( DoaBookmarkSuccess value)?  success,TResult? Function( DoaBookmarkFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DoaBookmarkInitial() when initial != null:
return initial(_that);case DoaBookmarkLoading() when loading != null:
return loading(_that);case DoaBookmarkSuccess() when success != null:
return success(_that);case DoaBookmarkFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Doa> bookmarkedDoas)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DoaBookmarkInitial() when initial != null:
return initial();case DoaBookmarkLoading() when loading != null:
return loading();case DoaBookmarkSuccess() when success != null:
return success(_that.bookmarkedDoas);case DoaBookmarkFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Doa> bookmarkedDoas)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DoaBookmarkInitial():
return initial();case DoaBookmarkLoading():
return loading();case DoaBookmarkSuccess():
return success(_that.bookmarkedDoas);case DoaBookmarkFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Doa> bookmarkedDoas)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DoaBookmarkInitial() when initial != null:
return initial();case DoaBookmarkLoading() when loading != null:
return loading();case DoaBookmarkSuccess() when success != null:
return success(_that.bookmarkedDoas);case DoaBookmarkFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DoaBookmarkInitial implements DoaBookmarkState {
  const DoaBookmarkInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaBookmarkInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaBookmarkState.initial()';
}


}




/// @nodoc


class DoaBookmarkLoading implements DoaBookmarkState {
  const DoaBookmarkLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaBookmarkLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaBookmarkState.loading()';
}


}




/// @nodoc


class DoaBookmarkSuccess implements DoaBookmarkState {
  const DoaBookmarkSuccess({required final  List<Doa> bookmarkedDoas}): _bookmarkedDoas = bookmarkedDoas;
  

 final  List<Doa> _bookmarkedDoas;
 List<Doa> get bookmarkedDoas {
  if (_bookmarkedDoas is EqualUnmodifiableListView) return _bookmarkedDoas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookmarkedDoas);
}


/// Create a copy of DoaBookmarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaBookmarkSuccessCopyWith<DoaBookmarkSuccess> get copyWith => _$DoaBookmarkSuccessCopyWithImpl<DoaBookmarkSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaBookmarkSuccess&&const DeepCollectionEquality().equals(other._bookmarkedDoas, _bookmarkedDoas));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookmarkedDoas));

@override
String toString() {
  return 'DoaBookmarkState.success(bookmarkedDoas: $bookmarkedDoas)';
}


}

/// @nodoc
abstract mixin class $DoaBookmarkSuccessCopyWith<$Res> implements $DoaBookmarkStateCopyWith<$Res> {
  factory $DoaBookmarkSuccessCopyWith(DoaBookmarkSuccess value, $Res Function(DoaBookmarkSuccess) _then) = _$DoaBookmarkSuccessCopyWithImpl;
@useResult
$Res call({
 List<Doa> bookmarkedDoas
});




}
/// @nodoc
class _$DoaBookmarkSuccessCopyWithImpl<$Res>
    implements $DoaBookmarkSuccessCopyWith<$Res> {
  _$DoaBookmarkSuccessCopyWithImpl(this._self, this._then);

  final DoaBookmarkSuccess _self;
  final $Res Function(DoaBookmarkSuccess) _then;

/// Create a copy of DoaBookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookmarkedDoas = null,}) {
  return _then(DoaBookmarkSuccess(
bookmarkedDoas: null == bookmarkedDoas ? _self._bookmarkedDoas : bookmarkedDoas // ignore: cast_nullable_to_non_nullable
as List<Doa>,
  ));
}


}

/// @nodoc


class DoaBookmarkFailure implements DoaBookmarkState {
  const DoaBookmarkFailure({required this.failure});
  

 final  Failure failure;

/// Create a copy of DoaBookmarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaBookmarkFailureCopyWith<DoaBookmarkFailure> get copyWith => _$DoaBookmarkFailureCopyWithImpl<DoaBookmarkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaBookmarkFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DoaBookmarkState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DoaBookmarkFailureCopyWith<$Res> implements $DoaBookmarkStateCopyWith<$Res> {
  factory $DoaBookmarkFailureCopyWith(DoaBookmarkFailure value, $Res Function(DoaBookmarkFailure) _then) = _$DoaBookmarkFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DoaBookmarkFailureCopyWithImpl<$Res>
    implements $DoaBookmarkFailureCopyWith<$Res> {
  _$DoaBookmarkFailureCopyWithImpl(this._self, this._then);

  final DoaBookmarkFailure _self;
  final $Res Function(DoaBookmarkFailure) _then;

/// Create a copy of DoaBookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DoaBookmarkFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DoaBookmarkState
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
