// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imsak_alarm_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImsakAlarmState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImsakAlarmState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImsakAlarmState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImsakAlarmState()';
}


}

/// @nodoc
class $ImsakAlarmStateCopyWith<$Res>  {
$ImsakAlarmStateCopyWith(ImsakAlarmState _, $Res Function(ImsakAlarmState) __);
}


/// Adds pattern-matching-related methods to [ImsakAlarmState].
extension ImsakAlarmStatePatterns on ImsakAlarmState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ImsakAlarmInitial value)?  initial,TResult Function( ImsakAlarmLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ImsakAlarmInitial() when initial != null:
return initial(_that);case ImsakAlarmLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ImsakAlarmInitial value)  initial,required TResult Function( ImsakAlarmLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case ImsakAlarmInitial():
return initial(_that);case ImsakAlarmLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ImsakAlarmInitial value)?  initial,TResult? Function( ImsakAlarmLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case ImsakAlarmInitial() when initial != null:
return initial(_that);case ImsakAlarmLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( ImsakAlarmPrefs prefs)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ImsakAlarmInitial() when initial != null:
return initial();case ImsakAlarmLoaded() when loaded != null:
return loaded(_that.prefs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( ImsakAlarmPrefs prefs)  loaded,}) {final _that = this;
switch (_that) {
case ImsakAlarmInitial():
return initial();case ImsakAlarmLoaded():
return loaded(_that.prefs);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( ImsakAlarmPrefs prefs)?  loaded,}) {final _that = this;
switch (_that) {
case ImsakAlarmInitial() when initial != null:
return initial();case ImsakAlarmLoaded() when loaded != null:
return loaded(_that.prefs);case _:
  return null;

}
}

}

/// @nodoc


class ImsakAlarmInitial with DiagnosticableTreeMixin implements ImsakAlarmState {
  const ImsakAlarmInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImsakAlarmState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImsakAlarmInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImsakAlarmState.initial()';
}


}




/// @nodoc


class ImsakAlarmLoaded with DiagnosticableTreeMixin implements ImsakAlarmState {
  const ImsakAlarmLoaded({required this.prefs});
  

 final  ImsakAlarmPrefs prefs;

/// Create a copy of ImsakAlarmState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImsakAlarmLoadedCopyWith<ImsakAlarmLoaded> get copyWith => _$ImsakAlarmLoadedCopyWithImpl<ImsakAlarmLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImsakAlarmState.loaded'))
    ..add(DiagnosticsProperty('prefs', prefs));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImsakAlarmLoaded&&(identical(other.prefs, prefs) || other.prefs == prefs));
}


@override
int get hashCode => Object.hash(runtimeType,prefs);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImsakAlarmState.loaded(prefs: $prefs)';
}


}

/// @nodoc
abstract mixin class $ImsakAlarmLoadedCopyWith<$Res> implements $ImsakAlarmStateCopyWith<$Res> {
  factory $ImsakAlarmLoadedCopyWith(ImsakAlarmLoaded value, $Res Function(ImsakAlarmLoaded) _then) = _$ImsakAlarmLoadedCopyWithImpl;
@useResult
$Res call({
 ImsakAlarmPrefs prefs
});


$ImsakAlarmPrefsCopyWith<$Res> get prefs;

}
/// @nodoc
class _$ImsakAlarmLoadedCopyWithImpl<$Res>
    implements $ImsakAlarmLoadedCopyWith<$Res> {
  _$ImsakAlarmLoadedCopyWithImpl(this._self, this._then);

  final ImsakAlarmLoaded _self;
  final $Res Function(ImsakAlarmLoaded) _then;

/// Create a copy of ImsakAlarmState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? prefs = null,}) {
  return _then(ImsakAlarmLoaded(
prefs: null == prefs ? _self.prefs : prefs // ignore: cast_nullable_to_non_nullable
as ImsakAlarmPrefs,
  ));
}

/// Create a copy of ImsakAlarmState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImsakAlarmPrefsCopyWith<$Res> get prefs {
  
  return $ImsakAlarmPrefsCopyWith<$Res>(_self.prefs, (value) {
    return _then(_self.copyWith(prefs: value));
  });
}
}

// dart format on
