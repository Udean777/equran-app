// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shalat_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShalatLog {

/// Format: yyyy-MM-dd
 String get date;/// Waktu shalat (subuh/dzuhur/ashar/maghrib/isya).
 WaktuShalat get waktu;/// Status pelaksanaan shalat.
 ShalatStatus get status;/// Catatan opsional.
 String? get catatan;/// Timestamp saat log dibuat/diupdate.
 DateTime? get updatedAt;
/// Create a copy of ShalatLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalatLogCopyWith<ShalatLog> get copyWith => _$ShalatLogCopyWithImpl<ShalatLog>(this as ShalatLog, _$identity);

  /// Serializes this ShalatLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalatLog&&(identical(other.date, date) || other.date == date)&&(identical(other.waktu, waktu) || other.waktu == waktu)&&(identical(other.status, status) || other.status == status)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,waktu,status,catatan,updatedAt);

@override
String toString() {
  return 'ShalatLog(date: $date, waktu: $waktu, status: $status, catatan: $catatan, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShalatLogCopyWith<$Res>  {
  factory $ShalatLogCopyWith(ShalatLog value, $Res Function(ShalatLog) _then) = _$ShalatLogCopyWithImpl;
@useResult
$Res call({
 String date, WaktuShalat waktu, ShalatStatus status, String? catatan, DateTime? updatedAt
});




}
/// @nodoc
class _$ShalatLogCopyWithImpl<$Res>
    implements $ShalatLogCopyWith<$Res> {
  _$ShalatLogCopyWithImpl(this._self, this._then);

  final ShalatLog _self;
  final $Res Function(ShalatLog) _then;

/// Create a copy of ShalatLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? waktu = null,Object? status = null,Object? catatan = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,waktu: null == waktu ? _self.waktu : waktu // ignore: cast_nullable_to_non_nullable
as WaktuShalat,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShalatStatus,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShalatLog].
extension ShalatLogPatterns on ShalatLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShalatLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShalatLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShalatLog value)  $default,){
final _that = this;
switch (_that) {
case _ShalatLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShalatLog value)?  $default,){
final _that = this;
switch (_that) {
case _ShalatLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  WaktuShalat waktu,  ShalatStatus status,  String? catatan,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShalatLog() when $default != null:
return $default(_that.date,_that.waktu,_that.status,_that.catatan,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  WaktuShalat waktu,  ShalatStatus status,  String? catatan,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShalatLog():
return $default(_that.date,_that.waktu,_that.status,_that.catatan,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  WaktuShalat waktu,  ShalatStatus status,  String? catatan,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShalatLog() when $default != null:
return $default(_that.date,_that.waktu,_that.status,_that.catatan,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShalatLog implements ShalatLog {
  const _ShalatLog({required this.date, required this.waktu, this.status = ShalatStatus.belumDicatat, this.catatan, this.updatedAt});
  factory _ShalatLog.fromJson(Map<String, dynamic> json) => _$ShalatLogFromJson(json);

/// Format: yyyy-MM-dd
@override final  String date;
/// Waktu shalat (subuh/dzuhur/ashar/maghrib/isya).
@override final  WaktuShalat waktu;
/// Status pelaksanaan shalat.
@override@JsonKey() final  ShalatStatus status;
/// Catatan opsional.
@override final  String? catatan;
/// Timestamp saat log dibuat/diupdate.
@override final  DateTime? updatedAt;

/// Create a copy of ShalatLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShalatLogCopyWith<_ShalatLog> get copyWith => __$ShalatLogCopyWithImpl<_ShalatLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShalatLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShalatLog&&(identical(other.date, date) || other.date == date)&&(identical(other.waktu, waktu) || other.waktu == waktu)&&(identical(other.status, status) || other.status == status)&&(identical(other.catatan, catatan) || other.catatan == catatan)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,waktu,status,catatan,updatedAt);

@override
String toString() {
  return 'ShalatLog(date: $date, waktu: $waktu, status: $status, catatan: $catatan, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShalatLogCopyWith<$Res> implements $ShalatLogCopyWith<$Res> {
  factory _$ShalatLogCopyWith(_ShalatLog value, $Res Function(_ShalatLog) _then) = __$ShalatLogCopyWithImpl;
@override @useResult
$Res call({
 String date, WaktuShalat waktu, ShalatStatus status, String? catatan, DateTime? updatedAt
});




}
/// @nodoc
class __$ShalatLogCopyWithImpl<$Res>
    implements _$ShalatLogCopyWith<$Res> {
  __$ShalatLogCopyWithImpl(this._self, this._then);

  final _ShalatLog _self;
  final $Res Function(_ShalatLog) _then;

/// Create a copy of ShalatLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? waktu = null,Object? status = null,Object? catatan = freezed,Object? updatedAt = freezed,}) {
  return _then(_ShalatLog(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,waktu: null == waktu ? _self.waktu : waktu // ignore: cast_nullable_to_non_nullable
as WaktuShalat,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShalatStatus,catatan: freezed == catatan ? _self.catatan : catatan // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ShalatDayStats {

/// Format: yyyy-MM-dd
 String get date;/// Map waktu shalat → log.
/// Key: WaktuShalat.key (string)
 Map<String, ShalatLog> get logs;
/// Create a copy of ShalatDayStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalatDayStatsCopyWith<ShalatDayStats> get copyWith => _$ShalatDayStatsCopyWithImpl<ShalatDayStats>(this as ShalatDayStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalatDayStats&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.logs, logs));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(logs));

@override
String toString() {
  return 'ShalatDayStats(date: $date, logs: $logs)';
}


}

/// @nodoc
abstract mixin class $ShalatDayStatsCopyWith<$Res>  {
  factory $ShalatDayStatsCopyWith(ShalatDayStats value, $Res Function(ShalatDayStats) _then) = _$ShalatDayStatsCopyWithImpl;
@useResult
$Res call({
 String date, Map<String, ShalatLog> logs
});




}
/// @nodoc
class _$ShalatDayStatsCopyWithImpl<$Res>
    implements $ShalatDayStatsCopyWith<$Res> {
  _$ShalatDayStatsCopyWithImpl(this._self, this._then);

  final ShalatDayStats _self;
  final $Res Function(ShalatDayStats) _then;

/// Create a copy of ShalatDayStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? logs = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, ShalatLog>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShalatDayStats].
extension ShalatDayStatsPatterns on ShalatDayStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShalatDayStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShalatDayStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShalatDayStats value)  $default,){
final _that = this;
switch (_that) {
case _ShalatDayStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShalatDayStats value)?  $default,){
final _that = this;
switch (_that) {
case _ShalatDayStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  Map<String, ShalatLog> logs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShalatDayStats() when $default != null:
return $default(_that.date,_that.logs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  Map<String, ShalatLog> logs)  $default,) {final _that = this;
switch (_that) {
case _ShalatDayStats():
return $default(_that.date,_that.logs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  Map<String, ShalatLog> logs)?  $default,) {final _that = this;
switch (_that) {
case _ShalatDayStats() when $default != null:
return $default(_that.date,_that.logs);case _:
  return null;

}
}

}

/// @nodoc


class _ShalatDayStats extends ShalatDayStats {
  const _ShalatDayStats({required this.date, final  Map<String, ShalatLog> logs = const {}}): _logs = logs,super._();
  

/// Format: yyyy-MM-dd
@override final  String date;
/// Map waktu shalat → log.
/// Key: WaktuShalat.key (string)
 final  Map<String, ShalatLog> _logs;
/// Map waktu shalat → log.
/// Key: WaktuShalat.key (string)
@override@JsonKey() Map<String, ShalatLog> get logs {
  if (_logs is EqualUnmodifiableMapView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_logs);
}


/// Create a copy of ShalatDayStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShalatDayStatsCopyWith<_ShalatDayStats> get copyWith => __$ShalatDayStatsCopyWithImpl<_ShalatDayStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShalatDayStats&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._logs, _logs));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_logs));

@override
String toString() {
  return 'ShalatDayStats(date: $date, logs: $logs)';
}


}

/// @nodoc
abstract mixin class _$ShalatDayStatsCopyWith<$Res> implements $ShalatDayStatsCopyWith<$Res> {
  factory _$ShalatDayStatsCopyWith(_ShalatDayStats value, $Res Function(_ShalatDayStats) _then) = __$ShalatDayStatsCopyWithImpl;
@override @useResult
$Res call({
 String date, Map<String, ShalatLog> logs
});




}
/// @nodoc
class __$ShalatDayStatsCopyWithImpl<$Res>
    implements _$ShalatDayStatsCopyWith<$Res> {
  __$ShalatDayStatsCopyWithImpl(this._self, this._then);

  final _ShalatDayStats _self;
  final $Res Function(_ShalatDayStats) _then;

/// Create a copy of ShalatDayStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? logs = null,}) {
  return _then(_ShalatDayStats(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as Map<String, ShalatLog>,
  ));
}


}

/// @nodoc
mixin _$ShalatStats {

/// Total hari yang punya data.
 int get totalHariDenganData;/// Total shalat tepat waktu (dari semua hari).
 int get totalTepatWaktu;/// Total shalat qadha.
 int get totalQadha;/// Total shalat tidak shalat.
 int get totalTidakShalat;/// Streak shalat 5 waktu berturut-turut (hari).
 int get streak;/// Persentase shalat tepat waktu (0.0–1.0).
 double get persentaseTepatWaktu;/// Data per hari (7 hari terakhir untuk chart).
 List<ShalatDayStats> get dailyStats;
/// Create a copy of ShalatStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShalatStatsCopyWith<ShalatStats> get copyWith => _$ShalatStatsCopyWithImpl<ShalatStats>(this as ShalatStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShalatStats&&(identical(other.totalHariDenganData, totalHariDenganData) || other.totalHariDenganData == totalHariDenganData)&&(identical(other.totalTepatWaktu, totalTepatWaktu) || other.totalTepatWaktu == totalTepatWaktu)&&(identical(other.totalQadha, totalQadha) || other.totalQadha == totalQadha)&&(identical(other.totalTidakShalat, totalTidakShalat) || other.totalTidakShalat == totalTidakShalat)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.persentaseTepatWaktu, persentaseTepatWaktu) || other.persentaseTepatWaktu == persentaseTepatWaktu)&&const DeepCollectionEquality().equals(other.dailyStats, dailyStats));
}


@override
int get hashCode => Object.hash(runtimeType,totalHariDenganData,totalTepatWaktu,totalQadha,totalTidakShalat,streak,persentaseTepatWaktu,const DeepCollectionEquality().hash(dailyStats));

@override
String toString() {
  return 'ShalatStats(totalHariDenganData: $totalHariDenganData, totalTepatWaktu: $totalTepatWaktu, totalQadha: $totalQadha, totalTidakShalat: $totalTidakShalat, streak: $streak, persentaseTepatWaktu: $persentaseTepatWaktu, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class $ShalatStatsCopyWith<$Res>  {
  factory $ShalatStatsCopyWith(ShalatStats value, $Res Function(ShalatStats) _then) = _$ShalatStatsCopyWithImpl;
@useResult
$Res call({
 int totalHariDenganData, int totalTepatWaktu, int totalQadha, int totalTidakShalat, int streak, double persentaseTepatWaktu, List<ShalatDayStats> dailyStats
});




}
/// @nodoc
class _$ShalatStatsCopyWithImpl<$Res>
    implements $ShalatStatsCopyWith<$Res> {
  _$ShalatStatsCopyWithImpl(this._self, this._then);

  final ShalatStats _self;
  final $Res Function(ShalatStats) _then;

/// Create a copy of ShalatStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalHariDenganData = null,Object? totalTepatWaktu = null,Object? totalQadha = null,Object? totalTidakShalat = null,Object? streak = null,Object? persentaseTepatWaktu = null,Object? dailyStats = null,}) {
  return _then(_self.copyWith(
totalHariDenganData: null == totalHariDenganData ? _self.totalHariDenganData : totalHariDenganData // ignore: cast_nullable_to_non_nullable
as int,totalTepatWaktu: null == totalTepatWaktu ? _self.totalTepatWaktu : totalTepatWaktu // ignore: cast_nullable_to_non_nullable
as int,totalQadha: null == totalQadha ? _self.totalQadha : totalQadha // ignore: cast_nullable_to_non_nullable
as int,totalTidakShalat: null == totalTidakShalat ? _self.totalTidakShalat : totalTidakShalat // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,persentaseTepatWaktu: null == persentaseTepatWaktu ? _self.persentaseTepatWaktu : persentaseTepatWaktu // ignore: cast_nullable_to_non_nullable
as double,dailyStats: null == dailyStats ? _self.dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as List<ShalatDayStats>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShalatStats].
extension ShalatStatsPatterns on ShalatStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShalatStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShalatStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShalatStats value)  $default,){
final _that = this;
switch (_that) {
case _ShalatStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShalatStats value)?  $default,){
final _that = this;
switch (_that) {
case _ShalatStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalHariDenganData,  int totalTepatWaktu,  int totalQadha,  int totalTidakShalat,  int streak,  double persentaseTepatWaktu,  List<ShalatDayStats> dailyStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShalatStats() when $default != null:
return $default(_that.totalHariDenganData,_that.totalTepatWaktu,_that.totalQadha,_that.totalTidakShalat,_that.streak,_that.persentaseTepatWaktu,_that.dailyStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalHariDenganData,  int totalTepatWaktu,  int totalQadha,  int totalTidakShalat,  int streak,  double persentaseTepatWaktu,  List<ShalatDayStats> dailyStats)  $default,) {final _that = this;
switch (_that) {
case _ShalatStats():
return $default(_that.totalHariDenganData,_that.totalTepatWaktu,_that.totalQadha,_that.totalTidakShalat,_that.streak,_that.persentaseTepatWaktu,_that.dailyStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalHariDenganData,  int totalTepatWaktu,  int totalQadha,  int totalTidakShalat,  int streak,  double persentaseTepatWaktu,  List<ShalatDayStats> dailyStats)?  $default,) {final _that = this;
switch (_that) {
case _ShalatStats() when $default != null:
return $default(_that.totalHariDenganData,_that.totalTepatWaktu,_that.totalQadha,_that.totalTidakShalat,_that.streak,_that.persentaseTepatWaktu,_that.dailyStats);case _:
  return null;

}
}

}

/// @nodoc


class _ShalatStats implements ShalatStats {
  const _ShalatStats({this.totalHariDenganData = 0, this.totalTepatWaktu = 0, this.totalQadha = 0, this.totalTidakShalat = 0, this.streak = 0, this.persentaseTepatWaktu = 0.0, final  List<ShalatDayStats> dailyStats = const []}): _dailyStats = dailyStats;
  

/// Total hari yang punya data.
@override@JsonKey() final  int totalHariDenganData;
/// Total shalat tepat waktu (dari semua hari).
@override@JsonKey() final  int totalTepatWaktu;
/// Total shalat qadha.
@override@JsonKey() final  int totalQadha;
/// Total shalat tidak shalat.
@override@JsonKey() final  int totalTidakShalat;
/// Streak shalat 5 waktu berturut-turut (hari).
@override@JsonKey() final  int streak;
/// Persentase shalat tepat waktu (0.0–1.0).
@override@JsonKey() final  double persentaseTepatWaktu;
/// Data per hari (7 hari terakhir untuk chart).
 final  List<ShalatDayStats> _dailyStats;
/// Data per hari (7 hari terakhir untuk chart).
@override@JsonKey() List<ShalatDayStats> get dailyStats {
  if (_dailyStats is EqualUnmodifiableListView) return _dailyStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyStats);
}


/// Create a copy of ShalatStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShalatStatsCopyWith<_ShalatStats> get copyWith => __$ShalatStatsCopyWithImpl<_ShalatStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShalatStats&&(identical(other.totalHariDenganData, totalHariDenganData) || other.totalHariDenganData == totalHariDenganData)&&(identical(other.totalTepatWaktu, totalTepatWaktu) || other.totalTepatWaktu == totalTepatWaktu)&&(identical(other.totalQadha, totalQadha) || other.totalQadha == totalQadha)&&(identical(other.totalTidakShalat, totalTidakShalat) || other.totalTidakShalat == totalTidakShalat)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.persentaseTepatWaktu, persentaseTepatWaktu) || other.persentaseTepatWaktu == persentaseTepatWaktu)&&const DeepCollectionEquality().equals(other._dailyStats, _dailyStats));
}


@override
int get hashCode => Object.hash(runtimeType,totalHariDenganData,totalTepatWaktu,totalQadha,totalTidakShalat,streak,persentaseTepatWaktu,const DeepCollectionEquality().hash(_dailyStats));

@override
String toString() {
  return 'ShalatStats(totalHariDenganData: $totalHariDenganData, totalTepatWaktu: $totalTepatWaktu, totalQadha: $totalQadha, totalTidakShalat: $totalTidakShalat, streak: $streak, persentaseTepatWaktu: $persentaseTepatWaktu, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class _$ShalatStatsCopyWith<$Res> implements $ShalatStatsCopyWith<$Res> {
  factory _$ShalatStatsCopyWith(_ShalatStats value, $Res Function(_ShalatStats) _then) = __$ShalatStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalHariDenganData, int totalTepatWaktu, int totalQadha, int totalTidakShalat, int streak, double persentaseTepatWaktu, List<ShalatDayStats> dailyStats
});




}
/// @nodoc
class __$ShalatStatsCopyWithImpl<$Res>
    implements _$ShalatStatsCopyWith<$Res> {
  __$ShalatStatsCopyWithImpl(this._self, this._then);

  final _ShalatStats _self;
  final $Res Function(_ShalatStats) _then;

/// Create a copy of ShalatStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalHariDenganData = null,Object? totalTepatWaktu = null,Object? totalQadha = null,Object? totalTidakShalat = null,Object? streak = null,Object? persentaseTepatWaktu = null,Object? dailyStats = null,}) {
  return _then(_ShalatStats(
totalHariDenganData: null == totalHariDenganData ? _self.totalHariDenganData : totalHariDenganData // ignore: cast_nullable_to_non_nullable
as int,totalTepatWaktu: null == totalTepatWaktu ? _self.totalTepatWaktu : totalTepatWaktu // ignore: cast_nullable_to_non_nullable
as int,totalQadha: null == totalQadha ? _self.totalQadha : totalQadha // ignore: cast_nullable_to_non_nullable
as int,totalTidakShalat: null == totalTidakShalat ? _self.totalTidakShalat : totalTidakShalat // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,persentaseTepatWaktu: null == persentaseTepatWaktu ? _self.persentaseTepatWaktu : persentaseTepatWaktu // ignore: cast_nullable_to_non_nullable
as double,dailyStats: null == dailyStats ? _self._dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as List<ShalatDayStats>,
  ));
}


}

// dart format on
