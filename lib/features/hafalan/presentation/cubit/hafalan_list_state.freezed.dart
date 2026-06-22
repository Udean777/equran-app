// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hafalan_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HafalanListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanListState()';
}


}

/// @nodoc
class $HafalanListStateCopyWith<$Res>  {
$HafalanListStateCopyWith(HafalanListState _, $Res Function(HafalanListState) __);
}


/// Adds pattern-matching-related methods to [HafalanListState].
extension HafalanListStatePatterns on HafalanListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HafalanListInitial value)?  initial,TResult Function( HafalanListLoading value)?  loading,TResult Function( HafalanListSuccess value)?  success,TResult Function( HafalanListFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HafalanListInitial() when initial != null:
return initial(_that);case HafalanListLoading() when loading != null:
return loading(_that);case HafalanListSuccess() when success != null:
return success(_that);case HafalanListFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HafalanListInitial value)  initial,required TResult Function( HafalanListLoading value)  loading,required TResult Function( HafalanListSuccess value)  success,required TResult Function( HafalanListFailure value)  failure,}){
final _that = this;
switch (_that) {
case HafalanListInitial():
return initial(_that);case HafalanListLoading():
return loading(_that);case HafalanListSuccess():
return success(_that);case HafalanListFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HafalanListInitial value)?  initial,TResult? Function( HafalanListLoading value)?  loading,TResult? Function( HafalanListSuccess value)?  success,TResult? Function( HafalanListFailure value)?  failure,}){
final _that = this;
switch (_that) {
case HafalanListInitial() when initial != null:
return initial(_that);case HafalanListLoading() when loading != null:
return loading(_that);case HafalanListSuccess() when success != null:
return success(_that);case HafalanListFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<HafalanSurat> hafalanList,  HafalanStats stats,  List<HafalanSurat> mergedList,  List<HafalanSurat> filteredList,  HafalanFilter filter,  String searchQuery,  int? selectedJuz,  Map<int, List<HafalanSurat>> juzGroups,  List<int> sortedJuz,  String? errorMessage)?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HafalanListInitial() when initial != null:
return initial();case HafalanListLoading() when loading != null:
return loading();case HafalanListSuccess() when success != null:
return success(_that.hafalanList,_that.stats,_that.mergedList,_that.filteredList,_that.filter,_that.searchQuery,_that.selectedJuz,_that.juzGroups,_that.sortedJuz,_that.errorMessage);case HafalanListFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<HafalanSurat> hafalanList,  HafalanStats stats,  List<HafalanSurat> mergedList,  List<HafalanSurat> filteredList,  HafalanFilter filter,  String searchQuery,  int? selectedJuz,  Map<int, List<HafalanSurat>> juzGroups,  List<int> sortedJuz,  String? errorMessage)  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case HafalanListInitial():
return initial();case HafalanListLoading():
return loading();case HafalanListSuccess():
return success(_that.hafalanList,_that.stats,_that.mergedList,_that.filteredList,_that.filter,_that.searchQuery,_that.selectedJuz,_that.juzGroups,_that.sortedJuz,_that.errorMessage);case HafalanListFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<HafalanSurat> hafalanList,  HafalanStats stats,  List<HafalanSurat> mergedList,  List<HafalanSurat> filteredList,  HafalanFilter filter,  String searchQuery,  int? selectedJuz,  Map<int, List<HafalanSurat>> juzGroups,  List<int> sortedJuz,  String? errorMessage)?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case HafalanListInitial() when initial != null:
return initial();case HafalanListLoading() when loading != null:
return loading();case HafalanListSuccess() when success != null:
return success(_that.hafalanList,_that.stats,_that.mergedList,_that.filteredList,_that.filter,_that.searchQuery,_that.selectedJuz,_that.juzGroups,_that.sortedJuz,_that.errorMessage);case HafalanListFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HafalanListInitial implements HafalanListState {
  const HafalanListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanListState.initial()';
}


}




/// @nodoc


class HafalanListLoading implements HafalanListState {
  const HafalanListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HafalanListState.loading()';
}


}




/// @nodoc


class HafalanListSuccess implements HafalanListState {
  const HafalanListSuccess({required final  List<HafalanSurat> hafalanList, required this.stats, final  List<HafalanSurat> mergedList = const [], final  List<HafalanSurat> filteredList = const [], this.filter = HafalanFilter.semua, this.searchQuery = '', this.selectedJuz = null, final  Map<int, List<HafalanSurat>> juzGroups = const {}, final  List<int> sortedJuz = const [], this.errorMessage}): _hafalanList = hafalanList,_mergedList = mergedList,_filteredList = filteredList,_juzGroups = juzGroups,_sortedJuz = sortedJuz;
  

 final  List<HafalanSurat> _hafalanList;
 List<HafalanSurat> get hafalanList {
  if (_hafalanList is EqualUnmodifiableListView) return _hafalanList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hafalanList);
}

 final  HafalanStats stats;
 final  List<HafalanSurat> _mergedList;
@JsonKey() List<HafalanSurat> get mergedList {
  if (_mergedList is EqualUnmodifiableListView) return _mergedList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mergedList);
}

 final  List<HafalanSurat> _filteredList;
@JsonKey() List<HafalanSurat> get filteredList {
  if (_filteredList is EqualUnmodifiableListView) return _filteredList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredList);
}

@JsonKey() final  HafalanFilter filter;
@JsonKey() final  String searchQuery;
@JsonKey() final  int? selectedJuz;
 final  Map<int, List<HafalanSurat>> _juzGroups;
@JsonKey() Map<int, List<HafalanSurat>> get juzGroups {
  if (_juzGroups is EqualUnmodifiableMapView) return _juzGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_juzGroups);
}

 final  List<int> _sortedJuz;
@JsonKey() List<int> get sortedJuz {
  if (_sortedJuz is EqualUnmodifiableListView) return _sortedJuz;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sortedJuz);
}

 final  String? errorMessage;

/// Create a copy of HafalanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanListSuccessCopyWith<HafalanListSuccess> get copyWith => _$HafalanListSuccessCopyWithImpl<HafalanListSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanListSuccess&&const DeepCollectionEquality().equals(other._hafalanList, _hafalanList)&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._mergedList, _mergedList)&&const DeepCollectionEquality().equals(other._filteredList, _filteredList)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedJuz, selectedJuz) || other.selectedJuz == selectedJuz)&&const DeepCollectionEquality().equals(other._juzGroups, _juzGroups)&&const DeepCollectionEquality().equals(other._sortedJuz, _sortedJuz)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_hafalanList),stats,const DeepCollectionEquality().hash(_mergedList),const DeepCollectionEquality().hash(_filteredList),filter,searchQuery,selectedJuz,const DeepCollectionEquality().hash(_juzGroups),const DeepCollectionEquality().hash(_sortedJuz),errorMessage);

@override
String toString() {
  return 'HafalanListState.success(hafalanList: $hafalanList, stats: $stats, mergedList: $mergedList, filteredList: $filteredList, filter: $filter, searchQuery: $searchQuery, selectedJuz: $selectedJuz, juzGroups: $juzGroups, sortedJuz: $sortedJuz, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $HafalanListSuccessCopyWith<$Res> implements $HafalanListStateCopyWith<$Res> {
  factory $HafalanListSuccessCopyWith(HafalanListSuccess value, $Res Function(HafalanListSuccess) _then) = _$HafalanListSuccessCopyWithImpl;
@useResult
$Res call({
 List<HafalanSurat> hafalanList, HafalanStats stats, List<HafalanSurat> mergedList, List<HafalanSurat> filteredList, HafalanFilter filter, String searchQuery, int? selectedJuz, Map<int, List<HafalanSurat>> juzGroups, List<int> sortedJuz, String? errorMessage
});


$HafalanStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$HafalanListSuccessCopyWithImpl<$Res>
    implements $HafalanListSuccessCopyWith<$Res> {
  _$HafalanListSuccessCopyWithImpl(this._self, this._then);

  final HafalanListSuccess _self;
  final $Res Function(HafalanListSuccess) _then;

/// Create a copy of HafalanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hafalanList = null,Object? stats = null,Object? mergedList = null,Object? filteredList = null,Object? filter = null,Object? searchQuery = null,Object? selectedJuz = freezed,Object? juzGroups = null,Object? sortedJuz = null,Object? errorMessage = freezed,}) {
  return _then(HafalanListSuccess(
hafalanList: null == hafalanList ? _self._hafalanList : hafalanList // ignore: cast_nullable_to_non_nullable
as List<HafalanSurat>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as HafalanStats,mergedList: null == mergedList ? _self._mergedList : mergedList // ignore: cast_nullable_to_non_nullable
as List<HafalanSurat>,filteredList: null == filteredList ? _self._filteredList : filteredList // ignore: cast_nullable_to_non_nullable
as List<HafalanSurat>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as HafalanFilter,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedJuz: freezed == selectedJuz ? _self.selectedJuz : selectedJuz // ignore: cast_nullable_to_non_nullable
as int?,juzGroups: null == juzGroups ? _self._juzGroups : juzGroups // ignore: cast_nullable_to_non_nullable
as Map<int, List<HafalanSurat>>,sortedJuz: null == sortedJuz ? _self._sortedJuz : sortedJuz // ignore: cast_nullable_to_non_nullable
as List<int>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HafalanListState
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


class HafalanListFailure implements HafalanListState {
  const HafalanListFailure(this.message);
  

 final  String message;

/// Create a copy of HafalanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanListFailureCopyWith<HafalanListFailure> get copyWith => _$HafalanListFailureCopyWithImpl<HafalanListFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanListFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HafalanListState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $HafalanListFailureCopyWith<$Res> implements $HafalanListStateCopyWith<$Res> {
  factory $HafalanListFailureCopyWith(HafalanListFailure value, $Res Function(HafalanListFailure) _then) = _$HafalanListFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HafalanListFailureCopyWithImpl<$Res>
    implements $HafalanListFailureCopyWith<$Res> {
  _$HafalanListFailureCopyWithImpl(this._self, this._then);

  final HafalanListFailure _self;
  final $Res Function(HafalanListFailure) _then;

/// Create a copy of HafalanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HafalanListFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
