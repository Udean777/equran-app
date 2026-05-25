// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_storage_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioStorageState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AudioStorageState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioStorageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AudioStorageState()';
}


}

/// @nodoc
class $AudioStorageStateCopyWith<$Res>  {
$AudioStorageStateCopyWith(AudioStorageState _, $Res Function(AudioStorageState) __);
}


/// Adds pattern-matching-related methods to [AudioStorageState].
extension AudioStorageStatePatterns on AudioStorageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AudioStorageInitial value)?  initial,TResult Function( AudioStorageLoading value)?  loading,TResult Function( AudioStorageSuccess value)?  success,TResult Function( AudioStorageError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AudioStorageInitial() when initial != null:
return initial(_that);case AudioStorageLoading() when loading != null:
return loading(_that);case AudioStorageSuccess() when success != null:
return success(_that);case AudioStorageError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AudioStorageInitial value)  initial,required TResult Function( AudioStorageLoading value)  loading,required TResult Function( AudioStorageSuccess value)  success,required TResult Function( AudioStorageError value)  error,}){
final _that = this;
switch (_that) {
case AudioStorageInitial():
return initial(_that);case AudioStorageLoading():
return loading(_that);case AudioStorageSuccess():
return success(_that);case AudioStorageError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AudioStorageInitial value)?  initial,TResult? Function( AudioStorageLoading value)?  loading,TResult? Function( AudioStorageSuccess value)?  success,TResult? Function( AudioStorageError value)?  error,}){
final _that = this;
switch (_that) {
case AudioStorageInitial() when initial != null:
return initial(_that);case AudioStorageLoading() when loading != null:
return loading(_that);case AudioStorageSuccess() when success != null:
return success(_that);case AudioStorageError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<DownloadedAyatInfo> files,  int totalBytes)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AudioStorageInitial() when initial != null:
return initial();case AudioStorageLoading() when loading != null:
return loading();case AudioStorageSuccess() when success != null:
return success(_that.files,_that.totalBytes);case AudioStorageError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<DownloadedAyatInfo> files,  int totalBytes)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AudioStorageInitial():
return initial();case AudioStorageLoading():
return loading();case AudioStorageSuccess():
return success(_that.files,_that.totalBytes);case AudioStorageError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<DownloadedAyatInfo> files,  int totalBytes)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AudioStorageInitial() when initial != null:
return initial();case AudioStorageLoading() when loading != null:
return loading();case AudioStorageSuccess() when success != null:
return success(_that.files,_that.totalBytes);case AudioStorageError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AudioStorageInitial with DiagnosticableTreeMixin implements AudioStorageState {
  const AudioStorageInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AudioStorageState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioStorageInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AudioStorageState.initial()';
}


}




/// @nodoc


class AudioStorageLoading with DiagnosticableTreeMixin implements AudioStorageState {
  const AudioStorageLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AudioStorageState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioStorageLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AudioStorageState.loading()';
}


}




/// @nodoc


class AudioStorageSuccess with DiagnosticableTreeMixin implements AudioStorageState {
  const AudioStorageSuccess({required final  List<DownloadedAyatInfo> files, required this.totalBytes}): _files = files;
  

 final  List<DownloadedAyatInfo> _files;
 List<DownloadedAyatInfo> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  int totalBytes;

/// Create a copy of AudioStorageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioStorageSuccessCopyWith<AudioStorageSuccess> get copyWith => _$AudioStorageSuccessCopyWithImpl<AudioStorageSuccess>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AudioStorageState.success'))
    ..add(DiagnosticsProperty('files', files))..add(DiagnosticsProperty('totalBytes', totalBytes));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioStorageSuccess&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),totalBytes);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AudioStorageState.success(files: $files, totalBytes: $totalBytes)';
}


}

/// @nodoc
abstract mixin class $AudioStorageSuccessCopyWith<$Res> implements $AudioStorageStateCopyWith<$Res> {
  factory $AudioStorageSuccessCopyWith(AudioStorageSuccess value, $Res Function(AudioStorageSuccess) _then) = _$AudioStorageSuccessCopyWithImpl;
@useResult
$Res call({
 List<DownloadedAyatInfo> files, int totalBytes
});




}
/// @nodoc
class _$AudioStorageSuccessCopyWithImpl<$Res>
    implements $AudioStorageSuccessCopyWith<$Res> {
  _$AudioStorageSuccessCopyWithImpl(this._self, this._then);

  final AudioStorageSuccess _self;
  final $Res Function(AudioStorageSuccess) _then;

/// Create a copy of AudioStorageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,Object? totalBytes = null,}) {
  return _then(AudioStorageSuccess(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<DownloadedAyatInfo>,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AudioStorageError with DiagnosticableTreeMixin implements AudioStorageState {
  const AudioStorageError({required this.message});
  

 final  String message;

/// Create a copy of AudioStorageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioStorageErrorCopyWith<AudioStorageError> get copyWith => _$AudioStorageErrorCopyWithImpl<AudioStorageError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AudioStorageState.error'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioStorageError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AudioStorageState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AudioStorageErrorCopyWith<$Res> implements $AudioStorageStateCopyWith<$Res> {
  factory $AudioStorageErrorCopyWith(AudioStorageError value, $Res Function(AudioStorageError) _then) = _$AudioStorageErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AudioStorageErrorCopyWithImpl<$Res>
    implements $AudioStorageErrorCopyWith<$Res> {
  _$AudioStorageErrorCopyWithImpl(this._self, this._then);

  final AudioStorageError _self;
  final $Res Function(AudioStorageError) _then;

/// Create a copy of AudioStorageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AudioStorageError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
