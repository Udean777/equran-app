import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:equran_app/features/surat_detail/constants/juz_mapping.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@LazySingleton(as: ReadingProgressRepository)
class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  const ReadingProgressRepositoryImpl(this._dataSource);

  final ReadingHistoryLocalDataSource _dataSource;

  static final _dateFormat = DateFormat('yyyy-MM-dd');
  static const _retentionDays = 90;

  @override
  Either<Failure, ReadingHistory?> getByDate(String date) {
    try {
      return Right(_dataSource.getByDate(date));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Either<Failure, List<ReadingHistory>> getByDateRange(List<String> dates) {
    try {
      return Right(_dataSource.getByDateRange(dates));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAyat(String date, String ayatId) async {
    try {
      await _dataSource.saveAyat(date, ayatId);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAyatBatch(
    String date,
    Set<String> ayatIds,
  ) async {
    try {
      await _dataSource.saveAyatBatch(date, ayatIds);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cleanupOldData(int retentionDays) async {
    try {
      await _dataSource.cleanupOldData(retentionDays);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Either<Failure, ReadingStats> getStats({required String today}) {
    try {
      // Ambil 90 hari terakhir
      final last90Dates = _generateDateRange(today, _retentionDays);
      final allHistory = _dataSource.getByDateRange(last90Dates);
      final historyMap = {for (final h in allHistory) h.date: h};

      // Total ayat dibaca (unique per surat:ayat, all-time dari 90 hari)
      final allAyatRead = <String>{};
      for (final h in allHistory) {
        allAyatRead.addAll(h.ayatRead);
      }
      final totalAyatRead = allAyatRead.length;

      // Total hari dengan data
      final totalHariDenganData = allHistory.where((h) => h.hasData).length;

      // Rata-rata per hari
      final rataRata = totalHariDenganData == 0
          ? 0.0
          : totalAyatRead / totalHariDenganData;

      // Progress per juz
      final progressPerJuz = _computeProgressPerJuz(allAyatRead);

      // Top 5 surat
      final topSurat = _computeTopSurat(allAyatRead);

      // 90 hari untuk heatmap (termasuk hari tanpa data)
      final last90 = last90Dates
          .map((d) => historyMap[d] ?? ReadingHistory(date: d))
          .toList();

      return Right(
        ReadingStats(
          totalAyatRead: totalAyatRead,
          totalHariDenganData: totalHariDenganData,
          rataRataPerHari: rataRata,
          progressPerJuz: progressPerJuz,
          last90Days: last90,
          topSurat: topSurat,
        ),
      );
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Generate list tanggal N hari terakhir (termasuk today), ascending.
  List<String> _generateDateRange(String today, int days) {
    final base = DateTime.parse(today);
    return List.generate(
      days,
      (i) => _dateFormat.format(base.subtract(Duration(days: days - 1 - i))),
    );
  }

  /// Hitung progress per juz dari set ayat yang sudah dibaca.
  /// ayatId format: 'suratNomor:ayatNomor'
  Map<int, double> _computeProgressPerJuz(Set<String> allAyatRead) {
    // Kelompokkan ayat per surat
    final ayatPerSurat = <int, Set<int>>{};
    for (final ayatId in allAyatRead) {
      final parts = ayatId.split(':');
      if (parts.length != 2) continue;
      final suratNomor = int.tryParse(parts[0]);
      final ayatNomor = int.tryParse(parts[1]);
      if (suratNomor == null || ayatNomor == null) continue;
      ayatPerSurat.putIfAbsent(suratNomor, () => <int>{}).add(ayatNomor);
    }

    final progressPerJuz = <int, double>{};
    for (var juz = 1; juz <= 30; juz++) {
      final totalAyatJuz = kTotalAyatPerJuz[juz] ?? 0;
      if (totalAyatJuz == 0) {
        progressPerJuz[juz] = 0;
        continue;
      }

      // Cari semua surat yang berada di juz ini
      final suratList = kJuzToSurahMapping[juz] ?? [];
      var ayatDibacaJuz = 0;

      for (final suratNomor in suratList) {
        final readSet = ayatPerSurat[suratNomor];
        if (readSet == null || readSet.isEmpty) continue;

        // Cari range untuk surat ini di juz ini
        final range = kJuzSurahVerseRanges['$juz:$suratNomor'];
        final start = range?.$1 ?? 1;
        final end = range?.$2 ?? 9999; // Fallback ke angka besar

        // Hitung berapa ayat yang dibaca di range tersebut
        for (final a in readSet) {
          if (a >= start && a <= end) {
            ayatDibacaJuz++;
          }
        }
      }

      progressPerJuz[juz] = (ayatDibacaJuz / totalAyatJuz).clamp(0.0, 1.0);
    }

    return progressPerJuz;
  }

  /// Hitung top 5 surat paling sering dibaca.
  List<SuratReadCount> _computeTopSurat(Set<String> allAyatRead) {
    final ayatPerSurat = <int, int>{};
    for (final ayatId in allAyatRead) {
      final parts = ayatId.split(':');
      if (parts.length != 2) continue;
      final suratNomor = int.tryParse(parts[0]);
      if (suratNomor == null) continue;
      ayatPerSurat[suratNomor] = (ayatPerSurat[suratNomor] ?? 0) + 1;
    }

    final sorted = ayatPerSurat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).map((e) {
      return SuratReadCount(
        suratNomor: e.key,
        namaLatin: _suratName(e.key),
        jumlahAyatDibaca: e.value,
      );
    }).toList();
  }

  /// Nama latin surat berdasarkan nomor (hardcode untuk top 30 surat populer).
  /// Fallback ke 'Surat $nomor' jika tidak ada.
  String _suratName(int nomor) {
    const names = <int, String>{
      1: 'Al-Fatihah',
      2: 'Al-Baqarah',
      3: "Ali 'Imran",
      4: "An-Nisa'",
      5: "Al-Ma'idah",
      18: 'Al-Kahf',
      36: 'Yasin',
      55: 'Ar-Rahman',
      56: "Al-Waqi'ah",
      67: 'Al-Mulk',
      78: "An-Naba'",
      112: 'Al-Ikhlas',
      113: 'Al-Falaq',
      114: 'An-Nas',
    };
    return names[nomor] ?? 'Surat $nomor';
  }
}
