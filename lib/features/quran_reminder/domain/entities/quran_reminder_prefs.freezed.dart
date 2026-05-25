// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quran_reminder_prefs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuranReminderPrefs {

/// Apakah reminder aktif.
 bool get enabled;/// Jam reminder (0–23). Default: 20 (pukul 20:00).
 int get hour;/// Menit reminder (0–59). Default: 0.
 int get minute;
/// Create a copy of QuranReminderPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuranReminderPrefsCopyWith<QuranReminderPrefs> get copyWith => _$QuranReminderPrefsCopyWithImpl<QuranReminderPrefs>(this as QuranReminderPrefs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranReminderPrefs&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,hour,minute);

@override
String toString() {
  return 'QuranReminderPrefs(enabled: $enabled, hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class $QuranReminderPrefsCopyWith<$Res>  {
  factory $QuranReminderPrefsCopyWith(QuranReminderPrefs value, $Res Function(QuranReminderPrefs) _then) = _$QuranReminderPrefsCopyWithImpl;
@useResult
$Res call({
 bool enabled, int hour, int minute
});




}
/// @nodoc
class _$QuranReminderPrefsCopyWithImpl<$Res>
    implements $QuranReminderPrefsCopyWith<$Res> {
  _$QuranReminderPrefsCopyWithImpl(this._self, this._then);

  final QuranReminderPrefs _self;
  final $Res Function(QuranReminderPrefs) _then;

/// Create a copy of QuranReminderPrefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? hour = null,Object? minute = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuranReminderPrefs].
extension QuranReminderPrefsPatterns on QuranReminderPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuranReminderPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuranReminderPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuranReminderPrefs value)  $default,){
final _that = this;
switch (_that) {
case _QuranReminderPrefs():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuranReminderPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _QuranReminderPrefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  int hour,  int minute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuranReminderPrefs() when $default != null:
return $default(_that.enabled,_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  int hour,  int minute)  $default,) {final _that = this;
switch (_that) {
case _QuranReminderPrefs():
return $default(_that.enabled,_that.hour,_that.minute);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  int hour,  int minute)?  $default,) {final _that = this;
switch (_that) {
case _QuranReminderPrefs() when $default != null:
return $default(_that.enabled,_that.hour,_that.minute);case _:
  return null;

}
}

}

/// @nodoc


class _QuranReminderPrefs implements QuranReminderPrefs {
  const _QuranReminderPrefs({this.enabled = false, this.hour = 20, this.minute = 0});
  

/// Apakah reminder aktif.
@override@JsonKey() final  bool enabled;
/// Jam reminder (0–23). Default: 20 (pukul 20:00).
@override@JsonKey() final  int hour;
/// Menit reminder (0–59). Default: 0.
@override@JsonKey() final  int minute;

/// Create a copy of QuranReminderPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuranReminderPrefsCopyWith<_QuranReminderPrefs> get copyWith => __$QuranReminderPrefsCopyWithImpl<_QuranReminderPrefs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuranReminderPrefs&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,hour,minute);

@override
String toString() {
  return 'QuranReminderPrefs(enabled: $enabled, hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class _$QuranReminderPrefsCopyWith<$Res> implements $QuranReminderPrefsCopyWith<$Res> {
  factory _$QuranReminderPrefsCopyWith(_QuranReminderPrefs value, $Res Function(_QuranReminderPrefs) _then) = __$QuranReminderPrefsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, int hour, int minute
});




}
/// @nodoc
class __$QuranReminderPrefsCopyWithImpl<$Res>
    implements _$QuranReminderPrefsCopyWith<$Res> {
  __$QuranReminderPrefsCopyWithImpl(this._self, this._then);

  final _QuranReminderPrefs _self;
  final $Res Function(_QuranReminderPrefs) _then;

/// Create a copy of QuranReminderPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? hour = null,Object? minute = null,}) {
  return _then(_QuranReminderPrefs(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
