// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_state_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioPlayerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioPlayerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AudioPlayerState()';
}


}

/// @nodoc
class $AudioPlayerStateCopyWith<$Res>  {
$AudioPlayerStateCopyWith(AudioPlayerState _, $Res Function(AudioPlayerState) __);
}


/// Adds pattern-matching-related methods to [AudioPlayerState].
extension AudioPlayerStatePatterns on AudioPlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AudioIdle value)?  idle,TResult Function( AudioLoading value)?  loading,TResult Function( AudioPlaying value)?  playing,TResult Function( AudioPaused value)?  paused,TResult Function( AudioError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AudioIdle() when idle != null:
return idle(_that);case AudioLoading() when loading != null:
return loading(_that);case AudioPlaying() when playing != null:
return playing(_that);case AudioPaused() when paused != null:
return paused(_that);case AudioError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AudioIdle value)  idle,required TResult Function( AudioLoading value)  loading,required TResult Function( AudioPlaying value)  playing,required TResult Function( AudioPaused value)  paused,required TResult Function( AudioError value)  error,}){
final _that = this;
switch (_that) {
case AudioIdle():
return idle(_that);case AudioLoading():
return loading(_that);case AudioPlaying():
return playing(_that);case AudioPaused():
return paused(_that);case AudioError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AudioIdle value)?  idle,TResult? Function( AudioLoading value)?  loading,TResult? Function( AudioPlaying value)?  playing,TResult? Function( AudioPaused value)?  paused,TResult? Function( AudioError value)?  error,}){
final _that = this;
switch (_that) {
case AudioIdle() when idle != null:
return idle(_that);case AudioLoading() when loading != null:
return loading(_that);case AudioPlaying() when playing != null:
return playing(_that);case AudioPaused() when paused != null:
return paused(_that);case AudioError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( int ayatNomor,  Qari qari)?  loading,TResult Function( int ayatNomor,  Qari qari,  Duration position,  Duration duration)?  playing,TResult Function( int ayatNomor,  Qari qari,  Duration position,  Duration duration)?  paused,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AudioIdle() when idle != null:
return idle();case AudioLoading() when loading != null:
return loading(_that.ayatNomor,_that.qari);case AudioPlaying() when playing != null:
return playing(_that.ayatNomor,_that.qari,_that.position,_that.duration);case AudioPaused() when paused != null:
return paused(_that.ayatNomor,_that.qari,_that.position,_that.duration);case AudioError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( int ayatNomor,  Qari qari)  loading,required TResult Function( int ayatNomor,  Qari qari,  Duration position,  Duration duration)  playing,required TResult Function( int ayatNomor,  Qari qari,  Duration position,  Duration duration)  paused,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AudioIdle():
return idle();case AudioLoading():
return loading(_that.ayatNomor,_that.qari);case AudioPlaying():
return playing(_that.ayatNomor,_that.qari,_that.position,_that.duration);case AudioPaused():
return paused(_that.ayatNomor,_that.qari,_that.position,_that.duration);case AudioError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( int ayatNomor,  Qari qari)?  loading,TResult? Function( int ayatNomor,  Qari qari,  Duration position,  Duration duration)?  playing,TResult? Function( int ayatNomor,  Qari qari,  Duration position,  Duration duration)?  paused,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AudioIdle() when idle != null:
return idle();case AudioLoading() when loading != null:
return loading(_that.ayatNomor,_that.qari);case AudioPlaying() when playing != null:
return playing(_that.ayatNomor,_that.qari,_that.position,_that.duration);case AudioPaused() when paused != null:
return paused(_that.ayatNomor,_that.qari,_that.position,_that.duration);case AudioError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AudioIdle implements AudioPlayerState {
  const AudioIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AudioPlayerState.idle()';
}


}




/// @nodoc


class AudioLoading implements AudioPlayerState {
  const AudioLoading({required this.ayatNomor, required this.qari});
  

 final  int ayatNomor;
 final  Qari qari;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioLoadingCopyWith<AudioLoading> get copyWith => _$AudioLoadingCopyWithImpl<AudioLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioLoading&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.qari, qari) || other.qari == qari));
}


@override
int get hashCode => Object.hash(runtimeType,ayatNomor,qari);

@override
String toString() {
  return 'AudioPlayerState.loading(ayatNomor: $ayatNomor, qari: $qari)';
}


}

/// @nodoc
abstract mixin class $AudioLoadingCopyWith<$Res> implements $AudioPlayerStateCopyWith<$Res> {
  factory $AudioLoadingCopyWith(AudioLoading value, $Res Function(AudioLoading) _then) = _$AudioLoadingCopyWithImpl;
@useResult
$Res call({
 int ayatNomor, Qari qari
});




}
/// @nodoc
class _$AudioLoadingCopyWithImpl<$Res>
    implements $AudioLoadingCopyWith<$Res> {
  _$AudioLoadingCopyWithImpl(this._self, this._then);

  final AudioLoading _self;
  final $Res Function(AudioLoading) _then;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ayatNomor = null,Object? qari = null,}) {
  return _then(AudioLoading(
ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,qari: null == qari ? _self.qari : qari // ignore: cast_nullable_to_non_nullable
as Qari,
  ));
}


}

/// @nodoc


class AudioPlaying implements AudioPlayerState {
  const AudioPlaying({required this.ayatNomor, required this.qari, required this.position, required this.duration});
  

 final  int ayatNomor;
 final  Qari qari;
 final  Duration position;
 final  Duration duration;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioPlayingCopyWith<AudioPlaying> get copyWith => _$AudioPlayingCopyWithImpl<AudioPlaying>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioPlaying&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.qari, qari) || other.qari == qari)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,ayatNomor,qari,position,duration);

@override
String toString() {
  return 'AudioPlayerState.playing(ayatNomor: $ayatNomor, qari: $qari, position: $position, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $AudioPlayingCopyWith<$Res> implements $AudioPlayerStateCopyWith<$Res> {
  factory $AudioPlayingCopyWith(AudioPlaying value, $Res Function(AudioPlaying) _then) = _$AudioPlayingCopyWithImpl;
@useResult
$Res call({
 int ayatNomor, Qari qari, Duration position, Duration duration
});




}
/// @nodoc
class _$AudioPlayingCopyWithImpl<$Res>
    implements $AudioPlayingCopyWith<$Res> {
  _$AudioPlayingCopyWithImpl(this._self, this._then);

  final AudioPlaying _self;
  final $Res Function(AudioPlaying) _then;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ayatNomor = null,Object? qari = null,Object? position = null,Object? duration = null,}) {
  return _then(AudioPlaying(
ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,qari: null == qari ? _self.qari : qari // ignore: cast_nullable_to_non_nullable
as Qari,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class AudioPaused implements AudioPlayerState {
  const AudioPaused({required this.ayatNomor, required this.qari, required this.position, required this.duration});
  

 final  int ayatNomor;
 final  Qari qari;
 final  Duration position;
 final  Duration duration;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioPausedCopyWith<AudioPaused> get copyWith => _$AudioPausedCopyWithImpl<AudioPaused>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioPaused&&(identical(other.ayatNomor, ayatNomor) || other.ayatNomor == ayatNomor)&&(identical(other.qari, qari) || other.qari == qari)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,ayatNomor,qari,position,duration);

@override
String toString() {
  return 'AudioPlayerState.paused(ayatNomor: $ayatNomor, qari: $qari, position: $position, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $AudioPausedCopyWith<$Res> implements $AudioPlayerStateCopyWith<$Res> {
  factory $AudioPausedCopyWith(AudioPaused value, $Res Function(AudioPaused) _then) = _$AudioPausedCopyWithImpl;
@useResult
$Res call({
 int ayatNomor, Qari qari, Duration position, Duration duration
});




}
/// @nodoc
class _$AudioPausedCopyWithImpl<$Res>
    implements $AudioPausedCopyWith<$Res> {
  _$AudioPausedCopyWithImpl(this._self, this._then);

  final AudioPaused _self;
  final $Res Function(AudioPaused) _then;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ayatNomor = null,Object? qari = null,Object? position = null,Object? duration = null,}) {
  return _then(AudioPaused(
ayatNomor: null == ayatNomor ? _self.ayatNomor : ayatNomor // ignore: cast_nullable_to_non_nullable
as int,qari: null == qari ? _self.qari : qari // ignore: cast_nullable_to_non_nullable
as Qari,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class AudioError implements AudioPlayerState {
  const AudioError({required this.message});
  

 final  String message;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioErrorCopyWith<AudioError> get copyWith => _$AudioErrorCopyWithImpl<AudioError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AudioPlayerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AudioErrorCopyWith<$Res> implements $AudioPlayerStateCopyWith<$Res> {
  factory $AudioErrorCopyWith(AudioError value, $Res Function(AudioError) _then) = _$AudioErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AudioErrorCopyWithImpl<$Res>
    implements $AudioErrorCopyWith<$Res> {
  _$AudioErrorCopyWithImpl(this._self, this._then);

  final AudioError _self;
  final $Res Function(AudioError) _then;

/// Create a copy of AudioPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AudioError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
