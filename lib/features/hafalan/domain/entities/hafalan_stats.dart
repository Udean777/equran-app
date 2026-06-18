import 'package:freezed_annotation/freezed_annotation.dart';

part 'hafalan_stats.freezed.dart';

@freezed
abstract class HafalanStats with _$HafalanStats {
  const factory HafalanStats({
    /// Total ayat yang sudah ditandai hafal dari semua surat.
    required int totalAyatHafal,

    /// Jumlah surat yang semua ayatnya sudah hafal.
    required int totalSuratSelesai,

    /// Persentase Al-Quran yang sudah dihafal (totalAyatHafal / 6236).
    required double persentaseQuran,

    /// Progress hafalan per juz: juzNomor → 0.0–1.0
    required Map<int, double> progressPerJuz,

    /// Jumlah surat yang sedang dalam proses hafalan.
    required int suratSedangDihafal,

    /// Jumlah surat yang jatuh tempo muraja'ah.
    required int suratPerluMurajaah,
  }) = _HafalanStats;

  const HafalanStats._();

  /// Stats kosong — digunakan sebagai initial state.
  factory HafalanStats.empty() => const HafalanStats(
    totalAyatHafal: 0,
    totalSuratSelesai: 0,
    persentaseQuran: 0,
    progressPerJuz: {},
    suratSedangDihafal: 0,
    suratPerluMurajaah: 0,
  );
}
