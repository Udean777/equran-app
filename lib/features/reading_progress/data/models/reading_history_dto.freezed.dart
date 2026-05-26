// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_history_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingHistoryDto {

 String get date;/// Disimpan sebagai List di JSON (Set tidak support JSON langsung).
 List<String> get ayatRead;
/// Create a copy of ReadingHistoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingHistoryDtoCopyWith<ReadingHistoryDto> get copyWith => _$ReadingHistoryDtoCopyWithImpl<ReadingHistoryDto>(this as ReadingHistoryDto, _$identity);

  /// Serializes this ReadingHistoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingHistoryDto&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.ayatRead, ayatRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(ayatRead));

@override
String toString() {
  return 'ReadingHistoryDto(date: $date, ayatRead: $ayatRead)';
}


}

/// @nodoc
abstract mixin class $ReadingHistoryDtoCopyWith<$Res>  {
  factory $ReadingHistoryDtoCopyWith(ReadingHistoryDto value, $Res Function(ReadingHistoryDto) _then) = _$ReadingHistoryDtoCopyWithImpl;
@useResult
$Res call({
 String date, List<String> ayatRead
});




}
/// @nodoc
class _$ReadingHistoryDtoCopyWithImpl<$Res>
    implements $ReadingHistoryDtoCopyWith<$Res> {
  _$ReadingHistoryDtoCopyWithImpl(this._self, this._then);

  final ReadingHistoryDto _self;
  final $Res Function(ReadingHistoryDto) _then;

/// Create a copy of ReadingHistoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? ayatRead = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,ayatRead: null == ayatRead ? _self.ayatRead : ayatRead // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingHistoryDto].
extension ReadingHistoryDtoPatterns on ReadingHistoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingHistoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingHistoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingHistoryDto value)  $default,){
final _that = this;
switch (_that) {
case _ReadingHistoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingHistoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingHistoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  List<String> ayatRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingHistoryDto() when $default != null:
return $default(_that.date,_that.ayatRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  List<String> ayatRead)  $default,) {final _that = this;
switch (_that) {
case _ReadingHistoryDto():
return $default(_that.date,_that.ayatRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  List<String> ayatRead)?  $default,) {final _that = this;
switch (_that) {
case _ReadingHistoryDto() when $default != null:
return $default(_that.date,_that.ayatRead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingHistoryDto implements ReadingHistoryDto {
  const _ReadingHistoryDto({required this.date, final  List<String> ayatRead = const <String>[]}): _ayatRead = ayatRead;
  factory _ReadingHistoryDto.fromJson(Map<String, dynamic> json) => _$ReadingHistoryDtoFromJson(json);

@override final  String date;
/// Disimpan sebagai List di JSON (Set tidak support JSON langsung).
 final  List<String> _ayatRead;
/// Disimpan sebagai List di JSON (Set tidak support JSON langsung).
@override@JsonKey() List<String> get ayatRead {
  if (_ayatRead is EqualUnmodifiableListView) return _ayatRead;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ayatRead);
}


/// Create a copy of ReadingHistoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingHistoryDtoCopyWith<_ReadingHistoryDto> get copyWith => __$ReadingHistoryDtoCopyWithImpl<_ReadingHistoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingHistoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingHistoryDto&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._ayatRead, _ayatRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_ayatRead));

@override
String toString() {
  return 'ReadingHistoryDto(date: $date, ayatRead: $ayatRead)';
}


}

/// @nodoc
abstract mixin class _$ReadingHistoryDtoCopyWith<$Res> implements $ReadingHistoryDtoCopyWith<$Res> {
  factory _$ReadingHistoryDtoCopyWith(_ReadingHistoryDto value, $Res Function(_ReadingHistoryDto) _then) = __$ReadingHistoryDtoCopyWithImpl;
@override @useResult
$Res call({
 String date, List<String> ayatRead
});




}
/// @nodoc
class __$ReadingHistoryDtoCopyWithImpl<$Res>
    implements _$ReadingHistoryDtoCopyWith<$Res> {
  __$ReadingHistoryDtoCopyWithImpl(this._self, this._then);

  final _ReadingHistoryDto _self;
  final $Res Function(_ReadingHistoryDto) _then;

/// Create a copy of ReadingHistoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? ayatRead = null,}) {
  return _then(_ReadingHistoryDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,ayatRead: null == ayatRead ? _self._ayatRead : ayatRead // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
