import 'package:equran_app/core/constants/juz_constants.dart';
import 'package:equran_app/core/constants/quran_constants.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';

/// Kalkulasi statistik hafalan — domain service, tidak bergantung pada layer lain.
class HafalanStatsCalculator {
  const HafalanStatsCalculator._();

  static const int _totalAyatQuran = QuranConstants.totalAyat;

  /// Compute [HafalanStats] dari list hafalan yang sudah di-resolve statusnya.
  static HafalanStats compute(List<HafalanSurat> list) {
    final totalAyatHafal = list.fold<int>(
      0,
      (sum, h) => sum + h.ayatHafal.length,
    );

    final totalSuratSelesai = list.where((h) => h.isSelesai).length;

    final persentaseQuran = (totalAyatHafal / _totalAyatQuran).clamp(0.0, 1.0);

    final suratSedangDihafal = list
        .where((h) => h.status == HafalanStatus.sedangDihafal)
        .length;

    final suratPerluMurajaah = list
        .where((h) => h.status == HafalanStatus.perluMurajaah)
        .length;

    // Progress per juz: hitung ayat hafal per juz dibagi total ayat juz
    final progressPerJuz = <int, double>{};
    for (var juz = 1; juz <= 30; juz++) {
      final totalAyatJuz = JuzConstants.totalAyatPerJuz[juz] ?? 0;
      if (totalAyatJuz == 0) {
        progressPerJuz[juz] = 0;
        continue;
      }

      final suratList = JuzConstants.surahPerJuz[juz] ?? [];
      var ayatHafalJuz = 0;

      for (final suratNomor in suratList) {
        final matches = list.where((h) => h.suratNomor == suratNomor);
        if (matches.isEmpty) continue;
        final h = matches.first;

        final range = JuzConstants.verseRanges['$juz:$suratNomor'];
        final start = range?.$1 ?? 1;
        final end = range?.$2 ?? h.jumlahAyat;

        for (final a in h.ayatHafal) {
          if (a >= start && a <= end) {
            ayatHafalJuz++;
          }
        }
      }

      progressPerJuz[juz] = (ayatHafalJuz / totalAyatJuz).clamp(0.0, 1.0);
    }

    return HafalanStats(
      totalAyatHafal: totalAyatHafal,
      totalSuratSelesai: totalSuratSelesai,
      persentaseQuran: persentaseQuran,
      progressPerJuz: progressPerJuz,
      suratSedangDihafal: suratSedangDihafal,
      suratPerluMurajaah: suratPerluMurajaah,
    );
  }

  /// Resolve status perluMurajaah dari data yang tersimpan.
  /// Status ini tidak disimpan di Hive — selalu di-derive saat load.
  static HafalanSurat resolveStatus(HafalanSurat hafalan) {
    if (hafalan.status == HafalanStatus.sudahHafal &&
        hafalan.isMurajaahJatuhTempo()) {
      return hafalan.copyWith(status: HafalanStatus.perluMurajaah);
    }
    return hafalan;
  }
}
