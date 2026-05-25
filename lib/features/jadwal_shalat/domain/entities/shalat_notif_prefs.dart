import 'package:freezed_annotation/freezed_annotation.dart';

part 'shalat_notif_prefs.freezed.dart';

@freezed
abstract class ShalatNotifPrefs with _$ShalatNotifPrefs {
  const factory ShalatNotifPrefs({
    @Default(true) bool subuh,
    @Default(true) bool dzuhur,
    @Default(true) bool ashar,
    @Default(true) bool maghrib,
    @Default(true) bool isya,

    /// Menit sebelum waktu shalat untuk notifikasi.
    /// Nilai valid: 0, 5, 10, 15.
    @Default(0) int menitSebelum,
  }) = _ShalatNotifPrefs;
}
