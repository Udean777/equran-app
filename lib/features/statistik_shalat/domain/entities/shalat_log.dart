import 'package:freezed_annotation/freezed_annotation.dart';

part 'shalat_log.freezed.dart';
part 'shalat_log.g.dart';

/// Status pelaksanaan shalat.
enum ShalatStatus {
  /// Belum dicatat.
  belumDicatat,

  /// Shalat tepat waktu.
  tepatWaktu,

  /// Shalat qadha (setelah waktu habis).
  qadha,

  /// Tidak shalat.
  tidakShalat,
}

/// Nama-nama waktu shalat fardhu.
enum WaktuShalat {
  subuh,
  dzuhur,
  ashar,
  maghrib,
  isya,
}

extension WaktuShalatX on WaktuShalat {
  String get label {
    switch (this) {
      case WaktuShalat.subuh:
        return 'Subuh';
      case WaktuShalat.dzuhur:
        return 'Dzuhur';
      case WaktuShalat.ashar:
        return 'Ashar';
      case WaktuShalat.maghrib:
        return 'Maghrib';
      case WaktuShalat.isya:
        return 'Isya';
    }
  }

  String get key => name;
}

/// Log shalat untuk satu waktu shalat pada satu hari.
@freezed
abstract class ShalatLog with _$ShalatLog {
  const factory ShalatLog({
    /// Format: yyyy-MM-dd
    required String date,

    /// Waktu shalat (subuh/dzuhur/ashar/maghrib/isya).
    required WaktuShalat waktu,

    /// Status pelaksanaan shalat.
    @Default(ShalatStatus.belumDicatat) ShalatStatus status,

    /// Catatan opsional.
    String? catatan,

    /// Timestamp saat log dibuat/diupdate.
    DateTime? updatedAt,
  }) = _ShalatLog;

  factory ShalatLog.fromJson(Map<String, dynamic> json) =>
      _$ShalatLogFromJson(json);
}

/// Statistik shalat untuk satu hari (5 waktu shalat).
@freezed
abstract class ShalatDayStats with _$ShalatDayStats {
  const factory ShalatDayStats({
    /// Format: yyyy-MM-dd
    required String date,

    /// Map waktu shalat → log.
    /// Key: WaktuShalat.key (string)
    @Default({}) Map<String, ShalatLog> logs,
  }) = _ShalatDayStats;

  const ShalatDayStats._();

  /// Jumlah shalat tepat waktu hari ini.
  int get jumlahTepatWaktu =>
      logs.values.where((l) => l.status == ShalatStatus.tepatWaktu).length;

  /// Jumlah shalat qadha hari ini.
  int get jumlahQadha =>
      logs.values.where((l) => l.status == ShalatStatus.qadha).length;

  /// Jumlah shalat yang sudah dicatat (bukan belumDicatat).
  int get jumlahDicatat =>
      logs.values.where((l) => l.status != ShalatStatus.belumDicatat).length;

  /// Jumlah shalat yang dilaksanakan (tepatWaktu + qadha).
  int get jumlahShalat => logs.values
      .where(
        (l) =>
            l.status == ShalatStatus.tepatWaktu ||
            l.status == ShalatStatus.qadha,
      )
      .length;

  /// True jika semua 5 waktu shalat tepat waktu.
  bool get isSempurna => jumlahTepatWaktu == 5;

  /// True jika ada data hari ini (minimal 1 waktu dicatat).
  bool get hasData => jumlahDicatat > 0;

  /// Ambil log untuk waktu shalat tertentu.
  ShalatLog logFor(WaktuShalat waktu) =>
      logs[waktu.key] ?? ShalatLog(date: date, waktu: waktu);
}

/// Statistik shalat mingguan/bulanan.
@freezed
abstract class ShalatStats with _$ShalatStats {
  const factory ShalatStats({
    /// Total hari yang punya data.
    @Default(0) int totalHariDenganData,

    /// Total shalat tepat waktu (dari semua hari).
    @Default(0) int totalTepatWaktu,

    /// Total shalat qadha.
    @Default(0) int totalQadha,

    /// Total shalat tidak shalat.
    @Default(0) int totalTidakShalat,

    /// Streak shalat 5 waktu berturut-turut (hari).
    @Default(0) int streak,

    /// Persentase shalat tepat waktu (0.0–1.0).
    @Default(0.0) double persentaseTepatWaktu,

    /// Data per hari (7 hari terakhir untuk chart).
    @Default([]) List<ShalatDayStats> dailyStats,
  }) = _ShalatStats;
}
