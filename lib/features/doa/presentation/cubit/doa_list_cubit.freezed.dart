// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doa_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoaListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaListState()';
}


}

/// @nodoc
class $DoaListStateCopyWith<$Res>  {
$DoaListStateCopyWith(DoaListState _, $Res Function(DoaListState) __);
}


/// Adds pattern-matching-related methods to [DoaListState].
extension DoaListStatePatterns on DoaListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DoaListInitial value)?  initial,TResult Function( DoaListLoading value)?  loading,TResult Function( DoaListSuccess value)?  success,TResult Function( DoaListFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DoaListInitial() when initial != null:
return initial(_that);case DoaListLoading() when loading != null:
return loading(_that);case DoaListSuccess() when success != null:
return success(_that);case DoaListFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DoaListInitial value)  initial,required TResult Function( DoaListLoading value)  loading,required TResult Function( DoaListSuccess value)  success,required TResult Function( DoaListFailure value)  failure,}){
final _that = this;
switch (_that) {
case DoaListInitial():
return initial(_that);case DoaListLoading():
return loading(_that);case DoaListSuccess():
return success(_that);case DoaListFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DoaListInitial value)?  initial,TResult? Function( DoaListLoading value)?  loading,TResult? Function( DoaListSuccess value)?  success,TResult? Function( DoaListFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DoaListInitial() when initial != null:
return initial(_that);case DoaListLoading() when loading != null:
return loading(_that);case DoaListSuccess() when success != null:
return success(_that);case DoaListFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Doa> allDoa,  List<String> grupList,  List<String> tagList,  String query,  String? activeGrup,  String? activeTag)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DoaListInitial() when initial != null:
return initial();case DoaListLoading() when loading != null:
return loading();case DoaListSuccess() when success != null:
return success(_that.allDoa,_that.grupList,_that.tagList,_that.query,_that.activeGrup,_that.activeTag);case DoaListFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Doa> allDoa,  List<String> grupList,  List<String> tagList,  String query,  String? activeGrup,  String? activeTag)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DoaListInitial():
return initial();case DoaListLoading():
return loading();case DoaListSuccess():
return success(_that.allDoa,_that.grupList,_that.tagList,_that.query,_that.activeGrup,_that.activeTag);case DoaListFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Doa> allDoa,  List<String> grupList,  List<String> tagList,  String query,  String? activeGrup,  String? activeTag)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DoaListInitial() when initial != null:
return initial();case DoaListLoading() when loading != null:
return loading();case DoaListSuccess() when success != null:
return success(_that.allDoa,_that.grupList,_that.tagList,_that.query,_that.activeGrup,_that.activeTag);case DoaListFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DoaListInitial implements DoaListState {
  const DoaListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaListState.initial()';
}


}




/// @nodoc


class DoaListLoading implements DoaListState {
  const DoaListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoaListState.loading()';
}


}




/// @nodoc


class DoaListSuccess implements DoaListState {
  const DoaListSuccess({required final  List<Doa> allDoa, required final  List<String> grupList, required final  List<String> tagList, this.query = '', this.activeGrup, this.activeTag}): _allDoa = allDoa,_grupList = grupList,_tagList = tagList;
  

 final  List<Doa> _allDoa;
 List<Doa> get allDoa {
  if (_allDoa is EqualUnmodifiableListView) return _allDoa;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allDoa);
}

 final  List<String> _grupList;
 List<String> get grupList {
  if (_grupList is EqualUnmodifiableListView) return _grupList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grupList);
}

 final  List<String> _tagList;
 List<String> get tagList {
  if (_tagList is EqualUnmodifiableListView) return _tagList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagList);
}

@JsonKey() final  String query;
 final  String? activeGrup;
 final  String? activeTag;

/// Create a copy of DoaListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaListSuccessCopyWith<DoaListSuccess> get copyWith => _$DoaListSuccessCopyWithImpl<DoaListSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaListSuccess&&const DeepCollectionEquality().equals(other._allDoa, _allDoa)&&const DeepCollectionEquality().equals(other._grupList, _grupList)&&const DeepCollectionEquality().equals(other._tagList, _tagList)&&(identical(other.query, query) || other.query == query)&&(identical(other.activeGrup, activeGrup) || other.activeGrup == activeGrup)&&(identical(other.activeTag, activeTag) || other.activeTag == activeTag));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allDoa),const DeepCollectionEquality().hash(_grupList),const DeepCollectionEquality().hash(_tagList),query,activeGrup,activeTag);

@override
String toString() {
  return 'DoaListState.success(allDoa: $allDoa, grupList: $grupList, tagList: $tagList, query: $query, activeGrup: $activeGrup, activeTag: $activeTag)';
}


}

/// @nodoc
abstract mixin class $DoaListSuccessCopyWith<$Res> implements $DoaListStateCopyWith<$Res> {
  factory $DoaListSuccessCopyWith(DoaListSuccess value, $Res Function(DoaListSuccess) _then) = _$DoaListSuccessCopyWithImpl;
@useResult
$Res call({
 List<Doa> allDoa, List<String> grupList, List<String> tagList, String query, String? activeGrup, String? activeTag
});




}
/// @nodoc
class _$DoaListSuccessCopyWithImpl<$Res>
    implements $DoaListSuccessCopyWith<$Res> {
  _$DoaListSuccessCopyWithImpl(this._self, this._then);

  final DoaListSuccess _self;
  final $Res Function(DoaListSuccess) _then;

/// Create a copy of DoaListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allDoa = null,Object? grupList = null,Object? tagList = null,Object? query = null,Object? activeGrup = freezed,Object? activeTag = freezed,}) {
  return _then(DoaListSuccess(
allDoa: null == allDoa ? _self._allDoa : allDoa // ignore: cast_nullable_to_non_nullable
as List<Doa>,grupList: null == grupList ? _self._grupList : grupList // ignore: cast_nullable_to_non_nullable
as List<String>,tagList: null == tagList ? _self._tagList : tagList // ignore: cast_nullable_to_non_nullable
as List<String>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,activeGrup: freezed == activeGrup ? _self.activeGrup : activeGrup // ignore: cast_nullable_to_non_nullable
as String?,activeTag: freezed == activeTag ? _self.activeTag : activeTag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DoaListFailure implements DoaListState {
  const DoaListFailure({required this.failure});
  

 final  Failure failure;

/// Create a copy of DoaListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoaListFailureCopyWith<DoaListFailure> get copyWith => _$DoaListFailureCopyWithImpl<DoaListFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoaListFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DoaListState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DoaListFailureCopyWith<$Res> implements $DoaListStateCopyWith<$Res> {
  factory $DoaListFailureCopyWith(DoaListFailure value, $Res Function(DoaListFailure) _then) = _$DoaListFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DoaListFailureCopyWithImpl<$Res>
    implements $DoaListFailureCopyWith<$Res> {
  _$DoaListFailureCopyWithImpl(this._self, this._then);

  final DoaListFailure _self;
  final $Res Function(DoaListFailure) _then;

/// Create a copy of DoaListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DoaListFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DoaListState
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
