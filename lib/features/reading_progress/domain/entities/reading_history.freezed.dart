// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingHistory {

/// Format: yyyy-MM-dd
 String get date;/// Set ayat yang sudah dibaca.
/// Format setiap item: 'suratNomor:ayatNomor' (contoh: '2:255')
 Set<String> get ayatRead;
/// Create a copy of ReadingHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingHistoryCopyWith<ReadingHistory> get copyWith => _$ReadingHistoryCopyWithImpl<ReadingHistory>(this as ReadingHistory, _$identity);

  /// Serializes this ReadingHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingHistory&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.ayatRead, ayatRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(ayatRead));

@override
String toString() {
  return 'ReadingHistory(date: $date, ayatRead: $ayatRead)';
}


}

/// @nodoc
abstract mixin class $ReadingHistoryCopyWith<$Res>  {
  factory $ReadingHistoryCopyWith(ReadingHistory value, $Res Function(ReadingHistory) _then) = _$ReadingHistoryCopyWithImpl;
@useResult
$Res call({
 String date, Set<String> ayatRead
});




}
/// @nodoc
class _$ReadingHistoryCopyWithImpl<$Res>
    implements $ReadingHistoryCopyWith<$Res> {
  _$ReadingHistoryCopyWithImpl(this._self, this._then);

  final ReadingHistory _self;
  final $Res Function(ReadingHistory) _then;

/// Create a copy of ReadingHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? ayatRead = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,ayatRead: null == ayatRead ? _self.ayatRead : ayatRead // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingHistory].
extension ReadingHistoryPatterns on ReadingHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingHistory value)  $default,){
final _that = this;
switch (_that) {
case _ReadingHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingHistory value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  Set<String> ayatRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingHistory() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  Set<String> ayatRead)  $default,) {final _that = this;
switch (_that) {
case _ReadingHistory():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  Set<String> ayatRead)?  $default,) {final _that = this;
switch (_that) {
case _ReadingHistory() when $default != null:
return $default(_that.date,_that.ayatRead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingHistory extends ReadingHistory {
  const _ReadingHistory({required this.date, final  Set<String> ayatRead = const <String>{}}): _ayatRead = ayatRead,super._();
  factory _ReadingHistory.fromJson(Map<String, dynamic> json) => _$ReadingHistoryFromJson(json);

/// Format: yyyy-MM-dd
@override final  String date;
/// Set ayat yang sudah dibaca.
/// Format setiap item: 'suratNomor:ayatNomor' (contoh: '2:255')
 final  Set<String> _ayatRead;
/// Set ayat yang sudah dibaca.
/// Format setiap item: 'suratNomor:ayatNomor' (contoh: '2:255')
@override@JsonKey() Set<String> get ayatRead {
  if (_ayatRead is EqualUnmodifiableSetView) return _ayatRead;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_ayatRead);
}


/// Create a copy of ReadingHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingHistoryCopyWith<_ReadingHistory> get copyWith => __$ReadingHistoryCopyWithImpl<_ReadingHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingHistory&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._ayatRead, _ayatRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_ayatRead));

@override
String toString() {
  return 'ReadingHistory(date: $date, ayatRead: $ayatRead)';
}


}

/// @nodoc
abstract mixin class _$ReadingHistoryCopyWith<$Res> implements $ReadingHistoryCopyWith<$Res> {
  factory _$ReadingHistoryCopyWith(_ReadingHistory value, $Res Function(_ReadingHistory) _then) = __$ReadingHistoryCopyWithImpl;
@override @useResult
$Res call({
 String date, Set<String> ayatRead
});




}
/// @nodoc
class __$ReadingHistoryCopyWithImpl<$Res>
    implements _$ReadingHistoryCopyWith<$Res> {
  __$ReadingHistoryCopyWithImpl(this._self, this._then);

  final _ReadingHistory _self;
  final $Res Function(_ReadingHistory) _then;

/// Create a copy of ReadingHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? ayatRead = null,}) {
  return _then(_ReadingHistory(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,ayatRead: null == ayatRead ? _self._ayatRead : ayatRead // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

/// @nodoc
mixin _$ReadingStats {

/// Total ayat yang pernah dibaca (all-time dari data yang tersimpan).
 int get totalAyatRead;/// Total hari yang punya data baca.
 int get totalHariDenganData;/// Rata-rata ayat dibaca per hari (dari hari yang punya data).
 double get rataRataPerHari;/// Progress per juz: juz → persentase (0.0–1.0).
/// Dihitung dari ayat yang pernah dibaca vs total ayat per juz.
 Map<int, double> get progressPerJuz;/// Data 90 hari terakhir untuk heatmap.
 List<ReadingHistory> get last90Days;/// Top 5 surat paling sering dibaca.
 List<SuratReadCount> get topSurat;
/// Create a copy of ReadingStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingStatsCopyWith<ReadingStats> get copyWith => _$ReadingStatsCopyWithImpl<ReadingStats>(this as ReadingStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingStats&&(identical(other.totalAyatRead, totalAyatRead) || other.totalAyatRead == totalAyatRead)&&(identical(other.totalHariDenganData, totalHariDenganData) || other.totalHariDenganData == totalHariDenganData)&&(identical(other.rataRataPerHari, rataRataPerHari) || other.rataRataPerHari == rataRataPerHari)&&const DeepCollectionEquality().equals(other.progressPerJuz, progressPerJuz)&&const DeepCollectionEquality().equals(other.last90Days, last90Days)&&const DeepCollectionEquality().equals(other.topSurat, topSurat));
}


@override
int get hashCode => Object.hash(runtimeType,totalAyatRead,totalHariDenganData,rataRataPerHari,const DeepCollectionEquality().hash(progressPerJuz),const DeepCollectionEquality().hash(last90Days),const DeepCollectionEquality().hash(topSurat));

@override
String toString() {
  return 'ReadingStats(totalAyatRead: $totalAyatRead, totalHariDenganData: $totalHariDenganData, rataRataPerHari: $rataRataPerHari, progressPerJuz: $progressPerJuz, last90Days: $last90Days, topSurat: $topSurat)';
}


}

/// @nodoc
abstract mixin class $ReadingStatsCopyWith<$Res>  {
  factory $ReadingStatsCopyWith(ReadingStats value, $Res Function(ReadingStats) _then) = _$ReadingStatsCopyWithImpl;
@useResult
$Res call({
 int totalAyatRead, int totalHariDenganData, double rataRataPerHari, Map<int, double> progressPerJuz, List<ReadingHistory> last90Days, List<SuratReadCount> topSurat
});




}
/// @nodoc
class _$ReadingStatsCopyWithImpl<$Res>
    implements $ReadingStatsCopyWith<$Res> {
  _$ReadingStatsCopyWithImpl(this._self, this._then);

  final ReadingStats _self;
  final $Res Function(ReadingStats) _then;

/// Create a copy of ReadingStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalAyatRead = null,Object? totalHariDenganData = null,Object? rataRataPerHari = null,Object? progressPerJuz = null,Object? last90Days = null,Object? topSurat = null,}) {
  return _then(_self.copyWith(
totalAyatRead: null == totalAyatRead ? _self.totalAyatRead : totalAyatRead // ignore: cast_nullable_to_non_nullable
as int,totalHariDenganData: null == totalHariDenganData ? _self.totalHariDenganData : totalHariDenganData // ignore: cast_nullable_to_non_nullable
as int,rataRataPerHari: null == rataRataPerHari ? _self.rataRataPerHari : rataRataPerHari // ignore: cast_nullable_to_non_nullable
as double,progressPerJuz: null == progressPerJuz ? _self.progressPerJuz : progressPerJuz // ignore: cast_nullable_to_non_nullable
as Map<int, double>,last90Days: null == last90Days ? _self.last90Days : last90Days // ignore: cast_nullable_to_non_nullable
as List<ReadingHistory>,topSurat: null == topSurat ? _self.topSurat : topSurat // ignore: cast_nullable_to_non_nullable
as List<SuratReadCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingStats].
extension ReadingStatsPatterns on ReadingStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingStats value)  $default,){
final _that = this;
switch (_that) {
case _ReadingStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingStats value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalAyatRead,  int totalHariDenganData,  double rataRataPerHari,  Map<int, double> progressPerJuz,  List<ReadingHistory> last90Days,  List<SuratReadCount> topSurat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingStats() when $default != null:
return $default(_that.totalAyatRead,_that.totalHariDenganData,_that.rataRataPerHari,_that.progressPerJuz,_that.last90Days,_that.topSurat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalAyatRead,  int totalHariDenganData,  double rataRataPerHari,  Map<int, double> progressPerJuz,  List<ReadingHistory> last90Days,  List<SuratReadCount> topSurat)  $default,) {final _that = this;
switch (_that) {
case _ReadingStats():
return $default(_that.totalAyatRead,_that.totalHariDenganData,_that.rataRataPerHari,_that.progressPerJuz,_that.last90Days,_that.topSurat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalAyatRead,  int totalHariDenganData,  double rataRataPerHari,  Map<int, double> progressPerJuz,  List<ReadingHistory> last90Days,  List<SuratReadCount> topSurat)?  $default,) {final _that = this;
switch (_that) {
case _ReadingStats() when $default != null:
return $default(_that.totalAyatRead,_that.totalHariDenganData,_that.rataRataPerHari,_that.progressPerJuz,_that.last90Days,_that.topSurat);case _:
  return null;

}
}

}

/// @nodoc


class _ReadingStats extends ReadingStats {
  const _ReadingStats({this.totalAyatRead = 0, this.totalHariDenganData = 0, this.rataRataPerHari = 0.0, final  Map<int, double> progressPerJuz = const <int, double>{}, final  List<ReadingHistory> last90Days = const <ReadingHistory>[], final  List<SuratReadCount> topSurat = const <SuratReadCount>[]}): _progressPerJuz = progressPerJuz,_last90Days = last90Days,_topSurat = topSurat,super._();
  

/// Total ayat yang pernah dibaca (all-time dari data yang tersimpan).
@override@JsonKey() final  int totalAyatRead;
/// Total hari yang punya data baca.
@override@JsonKey() final  int totalHariDenganData;
/// Rata-rata ayat dibaca per hari (dari hari yang punya data).
@override@JsonKey() final  double rataRataPerHari;
/// Progress per juz: juz → persentase (0.0–1.0).
/// Dihitung dari ayat yang pernah dibaca vs total ayat per juz.
 final  Map<int, double> _progressPerJuz;
/// Progress per juz: juz → persentase (0.0–1.0).
/// Dihitung dari ayat yang pernah dibaca vs total ayat per juz.
@override@JsonKey() Map<int, double> get progressPerJuz {
  if (_progressPerJuz is EqualUnmodifiableMapView) return _progressPerJuz;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_progressPerJuz);
}

/// Data 90 hari terakhir untuk heatmap.
 final  List<ReadingHistory> _last90Days;
/// Data 90 hari terakhir untuk heatmap.
@override@JsonKey() List<ReadingHistory> get last90Days {
  if (_last90Days is EqualUnmodifiableListView) return _last90Days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_last90Days);
}

/// Top 5 surat paling sering dibaca.
 final  List<SuratReadCount> _topSurat;
/// Top 5 surat paling sering dibaca.
@override@JsonKey() List<SuratReadCount> get topSurat {
  if (_topSurat is EqualUnmodifiableListView) return _topSurat;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topSurat);
}


/// Create a copy of ReadingStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingStatsCopyWith<_ReadingStats> get copyWith => __$ReadingStatsCopyWithImpl<_ReadingStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingStats&&(identical(other.totalAyatRead, totalAyatRead) || other.totalAyatRead == totalAyatRead)&&(identical(other.totalHariDenganData, totalHariDenganData) || other.totalHariDenganData == totalHariDenganData)&&(identical(other.rataRataPerHari, rataRataPerHari) || other.rataRataPerHari == rataRataPerHari)&&const DeepCollectionEquality().equals(other._progressPerJuz, _progressPerJuz)&&const DeepCollectionEquality().equals(other._last90Days, _last90Days)&&const DeepCollectionEquality().equals(other._topSurat, _topSurat));
}


@override
int get hashCode => Object.hash(runtimeType,totalAyatRead,totalHariDenganData,rataRataPerHari,const DeepCollectionEquality().hash(_progressPerJuz),const DeepCollectionEquality().hash(_last90Days),const DeepCollectionEquality().hash(_topSurat));

@override
String toString() {
  return 'ReadingStats(totalAyatRead: $totalAyatRead, totalHariDenganData: $totalHariDenganData, rataRataPerHari: $rataRataPerHari, progressPerJuz: $progressPerJuz, last90Days: $last90Days, topSurat: $topSurat)';
}


}

/// @nodoc
abstract mixin class _$ReadingStatsCopyWith<$Res> implements $ReadingStatsCopyWith<$Res> {
  factory _$ReadingStatsCopyWith(_ReadingStats value, $Res Function(_ReadingStats) _then) = __$ReadingStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalAyatRead, int totalHariDenganData, double rataRataPerHari, Map<int, double> progressPerJuz, List<ReadingHistory> last90Days, List<SuratReadCount> topSurat
});




}
/// @nodoc
class __$ReadingStatsCopyWithImpl<$Res>
    implements _$ReadingStatsCopyWith<$Res> {
  __$ReadingStatsCopyWithImpl(this._self, this._then);

  final _ReadingStats _self;
  final $Res Function(_ReadingStats) _then;

/// Create a copy of ReadingStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalAyatRead = null,Object? totalHariDenganData = null,Object? rataRataPerHari = null,Object? progressPerJuz = null,Object? last90Days = null,Object? topSurat = null,}) {
  return _then(_ReadingStats(
totalAyatRead: null == totalAyatRead ? _self.totalAyatRead : totalAyatRead // ignore: cast_nullable_to_non_nullable
as int,totalHariDenganData: null == totalHariDenganData ? _self.totalHariDenganData : totalHariDenganData // ignore: cast_nullable_to_non_nullable
as int,rataRataPerHari: null == rataRataPerHari ? _self.rataRataPerHari : rataRataPerHari // ignore: cast_nullable_to_non_nullable
as double,progressPerJuz: null == progressPerJuz ? _self._progressPerJuz : progressPerJuz // ignore: cast_nullable_to_non_nullable
as Map<int, double>,last90Days: null == last90Days ? _self._last90Days : last90Days // ignore: cast_nullable_to_non_nullable
as List<ReadingHistory>,topSurat: null == topSurat ? _self._topSurat : topSurat // ignore: cast_nullable_to_non_nullable
as List<SuratReadCount>,
  ));
}


}


/// @nodoc
mixin _$SuratReadCount {

 int get suratNomor; String get namaLatin; int get jumlahAyatDibaca;
/// Create a copy of SuratReadCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuratReadCountCopyWith<SuratReadCount> get copyWith => _$SuratReadCountCopyWithImpl<SuratReadCount>(this as SuratReadCount, _$identity);

  /// Serializes this SuratReadCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuratReadCount&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyatDibaca, jumlahAyatDibaca) || other.jumlahAyatDibaca == jumlahAyatDibaca));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,namaLatin,jumlahAyatDibaca);

@override
String toString() {
  return 'SuratReadCount(suratNomor: $suratNomor, namaLatin: $namaLatin, jumlahAyatDibaca: $jumlahAyatDibaca)';
}


}

/// @nodoc
abstract mixin class $SuratReadCountCopyWith<$Res>  {
  factory $SuratReadCountCopyWith(SuratReadCount value, $Res Function(SuratReadCount) _then) = _$SuratReadCountCopyWithImpl;
@useResult
$Res call({
 int suratNomor, String namaLatin, int jumlahAyatDibaca
});




}
/// @nodoc
class _$SuratReadCountCopyWithImpl<$Res>
    implements $SuratReadCountCopyWith<$Res> {
  _$SuratReadCountCopyWithImpl(this._self, this._then);

  final SuratReadCount _self;
  final $Res Function(SuratReadCount) _then;

/// Create a copy of SuratReadCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suratNomor = null,Object? namaLatin = null,Object? jumlahAyatDibaca = null,}) {
  return _then(_self.copyWith(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyatDibaca: null == jumlahAyatDibaca ? _self.jumlahAyatDibaca : jumlahAyatDibaca // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SuratReadCount].
extension SuratReadCountPatterns on SuratReadCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuratReadCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuratReadCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuratReadCount value)  $default,){
final _that = this;
switch (_that) {
case _SuratReadCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuratReadCount value)?  $default,){
final _that = this;
switch (_that) {
case _SuratReadCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int suratNomor,  String namaLatin,  int jumlahAyatDibaca)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuratReadCount() when $default != null:
return $default(_that.suratNomor,_that.namaLatin,_that.jumlahAyatDibaca);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int suratNomor,  String namaLatin,  int jumlahAyatDibaca)  $default,) {final _that = this;
switch (_that) {
case _SuratReadCount():
return $default(_that.suratNomor,_that.namaLatin,_that.jumlahAyatDibaca);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int suratNomor,  String namaLatin,  int jumlahAyatDibaca)?  $default,) {final _that = this;
switch (_that) {
case _SuratReadCount() when $default != null:
return $default(_that.suratNomor,_that.namaLatin,_that.jumlahAyatDibaca);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuratReadCount implements SuratReadCount {
  const _SuratReadCount({required this.suratNomor, required this.namaLatin, required this.jumlahAyatDibaca});
  factory _SuratReadCount.fromJson(Map<String, dynamic> json) => _$SuratReadCountFromJson(json);

@override final  int suratNomor;
@override final  String namaLatin;
@override final  int jumlahAyatDibaca;

/// Create a copy of SuratReadCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuratReadCountCopyWith<_SuratReadCount> get copyWith => __$SuratReadCountCopyWithImpl<_SuratReadCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuratReadCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuratReadCount&&(identical(other.suratNomor, suratNomor) || other.suratNomor == suratNomor)&&(identical(other.namaLatin, namaLatin) || other.namaLatin == namaLatin)&&(identical(other.jumlahAyatDibaca, jumlahAyatDibaca) || other.jumlahAyatDibaca == jumlahAyatDibaca));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,suratNomor,namaLatin,jumlahAyatDibaca);

@override
String toString() {
  return 'SuratReadCount(suratNomor: $suratNomor, namaLatin: $namaLatin, jumlahAyatDibaca: $jumlahAyatDibaca)';
}


}

/// @nodoc
abstract mixin class _$SuratReadCountCopyWith<$Res> implements $SuratReadCountCopyWith<$Res> {
  factory _$SuratReadCountCopyWith(_SuratReadCount value, $Res Function(_SuratReadCount) _then) = __$SuratReadCountCopyWithImpl;
@override @useResult
$Res call({
 int suratNomor, String namaLatin, int jumlahAyatDibaca
});




}
/// @nodoc
class __$SuratReadCountCopyWithImpl<$Res>
    implements _$SuratReadCountCopyWith<$Res> {
  __$SuratReadCountCopyWithImpl(this._self, this._then);

  final _SuratReadCount _self;
  final $Res Function(_SuratReadCount) _then;

/// Create a copy of SuratReadCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suratNomor = null,Object? namaLatin = null,Object? jumlahAyatDibaca = null,}) {
  return _then(_SuratReadCount(
suratNomor: null == suratNomor ? _self.suratNomor : suratNomor // ignore: cast_nullable_to_non_nullable
as int,namaLatin: null == namaLatin ? _self.namaLatin : namaLatin // ignore: cast_nullable_to_non_nullable
as String,jumlahAyatDibaca: null == jumlahAyatDibaca ? _self.jumlahAyatDibaca : jumlahAyatDibaca // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
