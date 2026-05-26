// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hafalan_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HafalanState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanState()';
}


}

/// @nodoc
class $HafalanStateCopyWith<$Res>  {
$HafalanStateCopyWith(HafalanState _, $Res Function(HafalanState) __);
}


/// Adds pattern-matching-related methods to [HafalanState].
extension HafalanStatePatterns on HafalanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HafalanInitial value)?  initial,TResult Function( HafalanLoading value)?  loading,TResult Function( HafalanSuccess value)?  success,TResult Function( HafalanFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HafalanInitial() when initial != null:
return initial(_that);case HafalanLoading() when loading != null:
return loading(_that);case HafalanSuccess() when success != null:
return success(_that);case HafalanFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HafalanInitial value)  initial,required TResult Function( HafalanLoading value)  loading,required TResult Function( HafalanSuccess value)  success,required TResult Function( HafalanFailure value)  failure,}){
final _that = this;
switch (_that) {
case HafalanInitial():
return initial(_that);case HafalanLoading():
return loading(_that);case HafalanSuccess():
return success(_that);case HafalanFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HafalanInitial value)?  initial,TResult? Function( HafalanLoading value)?  loading,TResult? Function( HafalanSuccess value)?  success,TResult? Function( HafalanFailure value)?  failure,}){
final _that = this;
switch (_that) {
case HafalanInitial() when initial != null:
return initial(_that);case HafalanLoading() when loading != null:
return loading(_that);case HafalanSuccess() when success != null:
return success(_that);case HafalanFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<HafalanSurat> hafalanList,  HafalanStats stats,  HafalanFilter filter,  String? errorMessage)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HafalanInitial() when initial != null:
return initial();case HafalanLoading() when loading != null:
return loading();case HafalanSuccess() when success != null:
return success(_that.hafalanList,_that.stats,_that.filter,_that.errorMessage);case HafalanFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<HafalanSurat> hafalanList,  HafalanStats stats,  HafalanFilter filter,  String? errorMessage)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case HafalanInitial():
return initial();case HafalanLoading():
return loading();case HafalanSuccess():
return success(_that.hafalanList,_that.stats,_that.filter,_that.errorMessage);case HafalanFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<HafalanSurat> hafalanList,  HafalanStats stats,  HafalanFilter filter,  String? errorMessage)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case HafalanInitial() when initial != null:
return initial();case HafalanLoading() when loading != null:
return loading();case HafalanSuccess() when success != null:
return success(_that.hafalanList,_that.stats,_that.filter,_that.errorMessage);case HafalanFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HafalanInitial implements HafalanState {
  const HafalanInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanState.initial()';
}


}




/// @nodoc


class HafalanLoading implements HafalanState {
  const HafalanLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanState.loading()';
}


}




/// @nodoc


class HafalanSuccess implements HafalanState {
  const HafalanSuccess({required final  List<HafalanSurat> hafalanList, required this.stats, this.filter = HafalanFilter.semua, this.errorMessage}): _hafalanList = hafalanList;
  

 final  List<HafalanSurat> _hafalanList;
 List<HafalanSurat> get hafalanList {
  if (_hafalanList is EqualUnmodifiableListView) return _hafalanList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hafalanList);
}

 final  HafalanStats stats;
@JsonKey() final  HafalanFilter filter;
 final  String? errorMessage;

/// Create a copy of HafalanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanSuccessCopyWith<HafalanSuccess> get copyWith => _$HafalanSuccessCopyWithImpl<HafalanSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanSuccess&&const DeepCollectionEquality().equals(other._hafalanList, _hafalanList)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_hafalanList),stats,filter,errorMessage);

@override
String toString() {
  return 'HafalanState.success(hafalanList: $hafalanList, stats: $stats, filter: $filter, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $HafalanSuccessCopyWith<$Res> implements $HafalanStateCopyWith<$Res> {
  factory $HafalanSuccessCopyWith(HafalanSuccess value, $Res Function(HafalanSuccess) _then) = _$HafalanSuccessCopyWithImpl;
@useResult
$Res call({
 List<HafalanSurat> hafalanList, HafalanStats stats, HafalanFilter filter, String? errorMessage
});


$HafalanStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$HafalanSuccessCopyWithImpl<$Res>
    implements $HafalanSuccessCopyWith<$Res> {
  _$HafalanSuccessCopyWithImpl(this._self, this._then);

  final HafalanSuccess _self;
  final $Res Function(HafalanSuccess) _then;

/// Create a copy of HafalanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hafalanList = null,Object? stats = null,Object? filter = null,Object? errorMessage = freezed,}) {
  return _then(HafalanSuccess(
hafalanList: null == hafalanList ? _self._hafalanList : hafalanList // ignore: cast_nullable_to_non_nullable
as List<HafalanSurat>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as HafalanStats,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as HafalanFilter,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HafalanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HafalanStatsCopyWith<$Res> get stats {
  
  return $HafalanStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

/// @nodoc


class HafalanFailure implements HafalanState {
  const HafalanFailure(this.message);
  

 final  String message;

/// Create a copy of HafalanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanFailureCopyWith<HafalanFailure> get copyWith => _$HafalanFailureCopyWithImpl<HafalanFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HafalanState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $HafalanFailureCopyWith<$Res> implements $HafalanStateCopyWith<$Res> {
  factory $HafalanFailureCopyWith(HafalanFailure value, $Res Function(HafalanFailure) _then) = _$HafalanFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HafalanFailureCopyWithImpl<$Res>
    implements $HafalanFailureCopyWith<$Res> {
  _$HafalanFailureCopyWithImpl(this._self, this._then);

  final HafalanFailure _self;
  final $Res Function(HafalanFailure) _then;

/// Create a copy of HafalanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HafalanFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
