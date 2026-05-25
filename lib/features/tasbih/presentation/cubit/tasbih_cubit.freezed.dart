// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasbih_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TasbihState {

/// Preset dzikir yang sedang aktif.
 TasbihPreset get selectedPreset;/// Target hitungan saat ini (bisa custom atau dari preset).
 int get target;/// Hitungan saat ini.
 int get count;/// Apakah target sudah tercapai.
 bool get isCompleted;/// Toggle haptic feedback.
 bool get hapticEnabled;/// Status loading saat simpan/load riwayat.
 bool get isSaving;/// Riwayat sesi yang sudah tersimpan.
 List<TasbihSession> get sessions;/// Pesan error jika ada.
 String? get errorMessage;
/// Create a copy of TasbihState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasbihStateCopyWith<TasbihState> get copyWith => _$TasbihStateCopyWithImpl<TasbihState>(this as TasbihState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasbihState&&(identical(other.selectedPreset, selectedPreset) || other.selectedPreset == selectedPreset)&&(identical(other.target, target) || other.target == target)&&(identical(other.count, count) || other.count == count)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&const DeepCollectionEquality().equals(other.sessions, sessions)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectedPreset,target,count,isCompleted,hapticEnabled,isSaving,const DeepCollectionEquality().hash(sessions),errorMessage);

@override
String toString() {
  return 'TasbihState(selectedPreset: $selectedPreset, target: $target, count: $count, isCompleted: $isCompleted, hapticEnabled: $hapticEnabled, isSaving: $isSaving, sessions: $sessions, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TasbihStateCopyWith<$Res>  {
  factory $TasbihStateCopyWith(TasbihState value, $Res Function(TasbihState) _then) = _$TasbihStateCopyWithImpl;
@useResult
$Res call({
 TasbihPreset selectedPreset, int target, int count, bool isCompleted, bool hapticEnabled, bool isSaving, List<TasbihSession> sessions, String? errorMessage
});


$TasbihPresetCopyWith<$Res> get selectedPreset;

}
/// @nodoc
class _$TasbihStateCopyWithImpl<$Res>
    implements $TasbihStateCopyWith<$Res> {
  _$TasbihStateCopyWithImpl(this._self, this._then);

  final TasbihState _self;
  final $Res Function(TasbihState) _then;

/// Create a copy of TasbihState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedPreset = null,Object? target = null,Object? count = null,Object? isCompleted = null,Object? hapticEnabled = null,Object? isSaving = null,Object? sessions = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
selectedPreset: null == selectedPreset ? _self.selectedPreset : selectedPreset // ignore: cast_nullable_to_non_nullable
as TasbihPreset,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<TasbihSession>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TasbihState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TasbihPresetCopyWith<$Res> get selectedPreset {
  
  return $TasbihPresetCopyWith<$Res>(_self.selectedPreset, (value) {
    return _then(_self.copyWith(selectedPreset: value));
  });
}
}


/// Adds pattern-matching-related methods to [TasbihState].
extension TasbihStatePatterns on TasbihState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TasbihState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TasbihState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TasbihState value)  $default,){
final _that = this;
switch (_that) {
case _TasbihState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TasbihState value)?  $default,){
final _that = this;
switch (_that) {
case _TasbihState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TasbihPreset selectedPreset,  int target,  int count,  bool isCompleted,  bool hapticEnabled,  bool isSaving,  List<TasbihSession> sessions,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TasbihState() when $default != null:
return $default(_that.selectedPreset,_that.target,_that.count,_that.isCompleted,_that.hapticEnabled,_that.isSaving,_that.sessions,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TasbihPreset selectedPreset,  int target,  int count,  bool isCompleted,  bool hapticEnabled,  bool isSaving,  List<TasbihSession> sessions,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TasbihState():
return $default(_that.selectedPreset,_that.target,_that.count,_that.isCompleted,_that.hapticEnabled,_that.isSaving,_that.sessions,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TasbihPreset selectedPreset,  int target,  int count,  bool isCompleted,  bool hapticEnabled,  bool isSaving,  List<TasbihSession> sessions,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TasbihState() when $default != null:
return $default(_that.selectedPreset,_that.target,_that.count,_that.isCompleted,_that.hapticEnabled,_that.isSaving,_that.sessions,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TasbihState implements TasbihState {
  const _TasbihState({required this.selectedPreset, required this.target, this.count = 0, this.isCompleted = false, this.hapticEnabled = true, this.isSaving = false, final  List<TasbihSession> sessions = const [], this.errorMessage}): _sessions = sessions;
  

/// Preset dzikir yang sedang aktif.
@override final  TasbihPreset selectedPreset;
/// Target hitungan saat ini (bisa custom atau dari preset).
@override final  int target;
/// Hitungan saat ini.
@override@JsonKey() final  int count;
/// Apakah target sudah tercapai.
@override@JsonKey() final  bool isCompleted;
/// Toggle haptic feedback.
@override@JsonKey() final  bool hapticEnabled;
/// Status loading saat simpan/load riwayat.
@override@JsonKey() final  bool isSaving;
/// Riwayat sesi yang sudah tersimpan.
 final  List<TasbihSession> _sessions;
/// Riwayat sesi yang sudah tersimpan.
@override@JsonKey() List<TasbihSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

/// Pesan error jika ada.
@override final  String? errorMessage;

/// Create a copy of TasbihState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TasbihStateCopyWith<_TasbihState> get copyWith => __$TasbihStateCopyWithImpl<_TasbihState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TasbihState&&(identical(other.selectedPreset, selectedPreset) || other.selectedPreset == selectedPreset)&&(identical(other.target, target) || other.target == target)&&(identical(other.count, count) || other.count == count)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.hapticEnabled, hapticEnabled) || other.hapticEnabled == hapticEnabled)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectedPreset,target,count,isCompleted,hapticEnabled,isSaving,const DeepCollectionEquality().hash(_sessions),errorMessage);

@override
String toString() {
  return 'TasbihState(selectedPreset: $selectedPreset, target: $target, count: $count, isCompleted: $isCompleted, hapticEnabled: $hapticEnabled, isSaving: $isSaving, sessions: $sessions, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TasbihStateCopyWith<$Res> implements $TasbihStateCopyWith<$Res> {
  factory _$TasbihStateCopyWith(_TasbihState value, $Res Function(_TasbihState) _then) = __$TasbihStateCopyWithImpl;
@override @useResult
$Res call({
 TasbihPreset selectedPreset, int target, int count, bool isCompleted, bool hapticEnabled, bool isSaving, List<TasbihSession> sessions, String? errorMessage
});


@override $TasbihPresetCopyWith<$Res> get selectedPreset;

}
/// @nodoc
class __$TasbihStateCopyWithImpl<$Res>
    implements _$TasbihStateCopyWith<$Res> {
  __$TasbihStateCopyWithImpl(this._self, this._then);

  final _TasbihState _self;
  final $Res Function(_TasbihState) _then;

/// Create a copy of TasbihState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedPreset = null,Object? target = null,Object? count = null,Object? isCompleted = null,Object? hapticEnabled = null,Object? isSaving = null,Object? sessions = null,Object? errorMessage = freezed,}) {
  return _then(_TasbihState(
selectedPreset: null == selectedPreset ? _self.selectedPreset : selectedPreset // ignore: cast_nullable_to_non_nullable
as TasbihPreset,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,hapticEnabled: null == hapticEnabled ? _self.hapticEnabled : hapticEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<TasbihSession>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TasbihState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TasbihPresetCopyWith<$Res> get selectedPreset {
  
  return $TasbihPresetCopyWith<$Res>(_self.selectedPreset, (value) {
    return _then(_self.copyWith(selectedPreset: value));
  });
}
}

// dart format on
