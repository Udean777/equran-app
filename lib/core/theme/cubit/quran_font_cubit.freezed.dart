// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quran_font_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuranFontState {

/// Ukuran font teks Arab. Range: 18–40.
 double get arabicFontSize;/// Ukuran font teks terjemahan & latin. Range: 12–22.
 double get translationFontSize;/// Nama font Arab yang aktif. Salah satu dari [kFontAmiri] atau [kFontKFGQPC].
 String get arabicFontFamily;/// Error message jika operasi pada Hive gagal. Null = no error.
 String? get errorMessage;
/// Create a copy of QuranFontState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuranFontStateCopyWith<QuranFontState> get copyWith => _$QuranFontStateCopyWithImpl<QuranFontState>(this as QuranFontState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranFontState&&(identical(other.arabicFontSize, arabicFontSize) || other.arabicFontSize == arabicFontSize)&&(identical(other.translationFontSize, translationFontSize) || other.translationFontSize == translationFontSize)&&(identical(other.arabicFontFamily, arabicFontFamily) || other.arabicFontFamily == arabicFontFamily)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,arabicFontSize,translationFontSize,arabicFontFamily,errorMessage);

@override
String toString() {
  return 'QuranFontState(arabicFontSize: $arabicFontSize, translationFontSize: $translationFontSize, arabicFontFamily: $arabicFontFamily, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $QuranFontStateCopyWith<$Res>  {
  factory $QuranFontStateCopyWith(QuranFontState value, $Res Function(QuranFontState) _then) = _$QuranFontStateCopyWithImpl;
@useResult
$Res call({
 double arabicFontSize, double translationFontSize, String arabicFontFamily, String? errorMessage
});




}
/// @nodoc
class _$QuranFontStateCopyWithImpl<$Res>
    implements $QuranFontStateCopyWith<$Res> {
  _$QuranFontStateCopyWithImpl(this._self, this._then);

  final QuranFontState _self;
  final $Res Function(QuranFontState) _then;

/// Create a copy of QuranFontState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? arabicFontSize = null,Object? translationFontSize = null,Object? arabicFontFamily = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
arabicFontSize: null == arabicFontSize ? _self.arabicFontSize : arabicFontSize // ignore: cast_nullable_to_non_nullable
as double,translationFontSize: null == translationFontSize ? _self.translationFontSize : translationFontSize // ignore: cast_nullable_to_non_nullable
as double,arabicFontFamily: null == arabicFontFamily ? _self.arabicFontFamily : arabicFontFamily // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuranFontState].
extension QuranFontStatePatterns on QuranFontState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuranFontState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuranFontState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuranFontState value)  $default,){
final _that = this;
switch (_that) {
case _QuranFontState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuranFontState value)?  $default,){
final _that = this;
switch (_that) {
case _QuranFontState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double arabicFontSize,  double translationFontSize,  String arabicFontFamily,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuranFontState() when $default != null:
return $default(_that.arabicFontSize,_that.translationFontSize,_that.arabicFontFamily,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double arabicFontSize,  double translationFontSize,  String arabicFontFamily,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _QuranFontState():
return $default(_that.arabicFontSize,_that.translationFontSize,_that.arabicFontFamily,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double arabicFontSize,  double translationFontSize,  String arabicFontFamily,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _QuranFontState() when $default != null:
return $default(_that.arabicFontSize,_that.translationFontSize,_that.arabicFontFamily,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _QuranFontState implements QuranFontState {
  const _QuranFontState({this.arabicFontSize = 28.0, this.translationFontSize = 14.0, this.arabicFontFamily = kFontAmiri, this.errorMessage});
  

/// Ukuran font teks Arab. Range: 18–40.
@override@JsonKey() final  double arabicFontSize;
/// Ukuran font teks terjemahan & latin. Range: 12–22.
@override@JsonKey() final  double translationFontSize;
/// Nama font Arab yang aktif. Salah satu dari [kFontAmiri] atau [kFontKFGQPC].
@override@JsonKey() final  String arabicFontFamily;
/// Error message jika operasi pada Hive gagal. Null = no error.
@override final  String? errorMessage;

/// Create a copy of QuranFontState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuranFontStateCopyWith<_QuranFontState> get copyWith => __$QuranFontStateCopyWithImpl<_QuranFontState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuranFontState&&(identical(other.arabicFontSize, arabicFontSize) || other.arabicFontSize == arabicFontSize)&&(identical(other.translationFontSize, translationFontSize) || other.translationFontSize == translationFontSize)&&(identical(other.arabicFontFamily, arabicFontFamily) || other.arabicFontFamily == arabicFontFamily)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,arabicFontSize,translationFontSize,arabicFontFamily,errorMessage);

@override
String toString() {
  return 'QuranFontState(arabicFontSize: $arabicFontSize, translationFontSize: $translationFontSize, arabicFontFamily: $arabicFontFamily, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$QuranFontStateCopyWith<$Res> implements $QuranFontStateCopyWith<$Res> {
  factory _$QuranFontStateCopyWith(_QuranFontState value, $Res Function(_QuranFontState) _then) = __$QuranFontStateCopyWithImpl;
@override @useResult
$Res call({
 double arabicFontSize, double translationFontSize, String arabicFontFamily, String? errorMessage
});




}
/// @nodoc
class __$QuranFontStateCopyWithImpl<$Res>
    implements _$QuranFontStateCopyWith<$Res> {
  __$QuranFontStateCopyWithImpl(this._self, this._then);

  final _QuranFontState _self;
  final $Res Function(_QuranFontState) _then;

/// Create a copy of QuranFontState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? arabicFontSize = null,Object? translationFontSize = null,Object? arabicFontFamily = null,Object? errorMessage = freezed,}) {
  return _then(_QuranFontState(
arabicFontSize: null == arabicFontSize ? _self.arabicFontSize : arabicFontSize // ignore: cast_nullable_to_non_nullable
as double,translationFontSize: null == translationFontSize ? _self.translationFontSize : translationFontSize // ignore: cast_nullable_to_non_nullable
as double,arabicFontFamily: null == arabicFontFamily ? _self.arabicFontFamily : arabicFontFamily // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
