import 'package:equran_app/features/reading_progress/domain/constants/reading_progress_constants.dart';
import 'package:equran_app/features/reading_progress/domain/constants/surat_names.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/surat_detail/constants/juz_mapping.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@lazySingleton
class ReadingStatsCalculator {
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Generate list tanggal N hari terakhir (termasuk today), ascending.
  List<String> generateDateRange(String today, int days) {
    final base = DateTime.parse(today);
    return List.generate(
      days,
      (i) => _dateFormat.format(base.subtract(Duration(days: days - 1 - i))),
    );
  }

  /// Hitung progress per juz dari set ayat yang sudah dibaca.
  /// ayatId format: 'suratNomor:ayatNomor'
  Map<int, double> computeProgressPerJuz(Set<String> allAyatRead) {
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
    for (var juz = 1; juz <= ReadingProgressConstants.juzCount; juz++) {
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
        final end =
            range?.$2 ??
            ReadingProgressConstants
                .fallbackEndVerse; // Fallback ke angka besar

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
  List<SuratReadCount> computeTopSurat(Set<String> allAyatRead) {
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

    return sorted.take(ReadingProgressConstants.topSuratCount).map((e) {
      return SuratReadCount(
        suratNomor: e.key,
        namaLatin: suratName(e.key),
        jumlahAyatDibaca: e.value,
      );
    }).toList();
  }

  String suratName(int nomor) {
    return SuratNames.names[nomor] ?? 'Surat $nomor';
  }
}
