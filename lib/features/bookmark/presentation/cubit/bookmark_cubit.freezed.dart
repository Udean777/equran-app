// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookmarkState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkState()';
}


}

/// @nodoc
class $BookmarkStateCopyWith<$Res>  {
$BookmarkStateCopyWith(BookmarkState _, $Res Function(BookmarkState) __);
}


/// Adds pattern-matching-related methods to [BookmarkState].
extension BookmarkStatePatterns on BookmarkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BookmarkInitial value)?  initial,TResult Function( BookmarkLoading value)?  loading,TResult Function( BookmarkSuccess value)?  success,TResult Function( BookmarkFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BookmarkInitial() when initial != null:
return initial(_that);case BookmarkLoading() when loading != null:
return loading(_that);case BookmarkSuccess() when success != null:
return success(_that);case BookmarkFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BookmarkInitial value)  initial,required TResult Function( BookmarkLoading value)  loading,required TResult Function( BookmarkSuccess value)  success,required TResult Function( BookmarkFailure value)  failure,}){
final _that = this;
switch (_that) {
case BookmarkInitial():
return initial(_that);case BookmarkLoading():
return loading(_that);case BookmarkSuccess():
return success(_that);case BookmarkFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BookmarkInitial value)?  initial,TResult? Function( BookmarkLoading value)?  loading,TResult? Function( BookmarkSuccess value)?  success,TResult? Function( BookmarkFailure value)?  failure,}){
final _that = this;
switch (_that) {
case BookmarkInitial() when initial != null:
return initial(_that);case BookmarkLoading() when loading != null:
return loading(_that);case BookmarkSuccess() when success != null:
return success(_that);case BookmarkFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Bookmark> bookmarks,  List<Doa> bookmarkedDoas,  LastRead? lastRead,  Map<int, double> suratProgressMap)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BookmarkInitial() when initial != null:
return initial();case BookmarkLoading() when loading != null:
return loading();case BookmarkSuccess() when success != null:
return success(_that.bookmarks,_that.bookmarkedDoas,_that.lastRead,_that.suratProgressMap);case BookmarkFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Bookmark> bookmarks,  List<Doa> bookmarkedDoas,  LastRead? lastRead,  Map<int, double> suratProgressMap)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case BookmarkInitial():
return initial();case BookmarkLoading():
return loading();case BookmarkSuccess():
return success(_that.bookmarks,_that.bookmarkedDoas,_that.lastRead,_that.suratProgressMap);case BookmarkFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Bookmark> bookmarks,  List<Doa> bookmarkedDoas,  LastRead? lastRead,  Map<int, double> suratProgressMap)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case BookmarkInitial() when initial != null:
return initial();case BookmarkLoading() when loading != null:
return loading();case BookmarkSuccess() when success != null:
return success(_that.bookmarks,_that.bookmarkedDoas,_that.lastRead,_that.suratProgressMap);case BookmarkFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class BookmarkInitial implements BookmarkState {
  const BookmarkInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkState.initial()';
}


}




/// @nodoc


class BookmarkLoading implements BookmarkState {
  const BookmarkLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkState.loading()';
}


}




/// @nodoc


class BookmarkSuccess implements BookmarkState {
  const BookmarkSuccess({required final  List<Bookmark> bookmarks, final  List<Doa> bookmarkedDoas = const [], this.lastRead, final  Map<int, double> suratProgressMap = const <int, double>{}}): _bookmarks = bookmarks,_bookmarkedDoas = bookmarkedDoas,_suratProgressMap = suratProgressMap;
  

 final  List<Bookmark> _bookmarks;
 List<Bookmark> get bookmarks {
  if (_bookmarks is EqualUnmodifiableListView) return _bookmarks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookmarks);
}

 final  List<Doa> _bookmarkedDoas;
@JsonKey() List<Doa> get bookmarkedDoas {
  if (_bookmarkedDoas is EqualUnmodifiableListView) return _bookmarkedDoas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookmarkedDoas);
}

 final  LastRead? lastRead;
/// Progress per surat — key: suratNomor, value: maxScrollPercent (0.0–1.0)
 final  Map<int, double> _suratProgressMap;
/// Progress per surat — key: suratNomor, value: maxScrollPercent (0.0–1.0)
@JsonKey() Map<int, double> get suratProgressMap {
  if (_suratProgressMap is EqualUnmodifiableMapView) return _suratProgressMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_suratProgressMap);
}


/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkSuccessCopyWith<BookmarkSuccess> get copyWith => _$BookmarkSuccessCopyWithImpl<BookmarkSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkSuccess&&const DeepCollectionEquality().equals(other._bookmarks, _bookmarks)&&const DeepCollectionEquality().equals(other._bookmarkedDoas, _bookmarkedDoas)&&(identical(other.lastRead, lastRead) || other.lastRead == lastRead)&&const DeepCollectionEquality().equals(other._suratProgressMap, _suratProgressMap));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookmarks),const DeepCollectionEquality().hash(_bookmarkedDoas),lastRead,const DeepCollectionEquality().hash(_suratProgressMap));

@override
String toString() {
  return 'BookmarkState.success(bookmarks: $bookmarks, bookmarkedDoas: $bookmarkedDoas, lastRead: $lastRead, suratProgressMap: $suratProgressMap)';
}


}

/// @nodoc
abstract mixin class $BookmarkSuccessCopyWith<$Res> implements $BookmarkStateCopyWith<$Res> {
  factory $BookmarkSuccessCopyWith(BookmarkSuccess value, $Res Function(BookmarkSuccess) _then) = _$BookmarkSuccessCopyWithImpl;
@useResult
$Res call({
 List<Bookmark> bookmarks, List<Doa> bookmarkedDoas, LastRead? lastRead, Map<int, double> suratProgressMap
});


$LastReadCopyWith<$Res>? get lastRead;

}
/// @nodoc
class _$BookmarkSuccessCopyWithImpl<$Res>
    implements $BookmarkSuccessCopyWith<$Res> {
  _$BookmarkSuccessCopyWithImpl(this._self, this._then);

  final BookmarkSuccess _self;
  final $Res Function(BookmarkSuccess) _then;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookmarks = null,Object? bookmarkedDoas = null,Object? lastRead = freezed,Object? suratProgressMap = null,}) {
  return _then(BookmarkSuccess(
bookmarks: null == bookmarks ? _self._bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<Bookmark>,bookmarkedDoas: null == bookmarkedDoas ? _self._bookmarkedDoas : bookmarkedDoas // ignore: cast_nullable_to_non_nullable
as List<Doa>,lastRead: freezed == lastRead ? _self.lastRead : lastRead // ignore: cast_nullable_to_non_nullable
as LastRead?,suratProgressMap: null == suratProgressMap ? _self._suratProgressMap : suratProgressMap // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastReadCopyWith<$Res>? get lastRead {
    if (_self.lastRead == null) {
    return null;
  }

  return $LastReadCopyWith<$Res>(_self.lastRead!, (value) {
    return _then(_self.copyWith(lastRead: value));
  });
}
}

/// @nodoc


class BookmarkFailure implements BookmarkState {
  const BookmarkFailure({required this.failure});
  

 final  Failure failure;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkFailureCopyWith<BookmarkFailure> get copyWith => _$BookmarkFailureCopyWithImpl<BookmarkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'BookmarkState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BookmarkFailureCopyWith<$Res> implements $BookmarkStateCopyWith<$Res> {
  factory $BookmarkFailureCopyWith(BookmarkFailure value, $Res Function(BookmarkFailure) _then) = _$BookmarkFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$BookmarkFailureCopyWithImpl<$Res>
    implements $BookmarkFailureCopyWith<$Res> {
  _$BookmarkFailureCopyWithImpl(this._self, this._then);

  final BookmarkFailure _self;
  final $Res Function(BookmarkFailure) _then;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(BookmarkFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of BookmarkState
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
