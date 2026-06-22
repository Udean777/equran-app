import 'package:equran_app/features/surat_detail/constants/juz_mapping.dart';

/// Helper untuk view-level calculations pada halaman hafalan.
class HafalanViewHelper {
  const HafalanViewHelper._();

  static ({int start, int end, int total}) getAyatRange({
    required int suratNomor,
    required int jumlahAyat,
    int? juzNomor,
  }) {
    if (juzNomor == null) {
      return (start: 1, end: jumlahAyat, total: jumlahAyat);
    }
    final range = kJuzSurahVerseRanges['$juzNomor:$suratNomor'];
    final start = range?.$1 ?? 1;
    final end = range?.$2 ?? jumlahAyat;
    return (start: start, end: end, total: end - start + 1);
  }
}
