import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_history.freezed.dart';
part 'reading_history.g.dart';

/// Riwayat ayat yang dibaca pada satu hari.
@freezed
abstract class ReadingHistory with _$ReadingHistory {
  const factory ReadingHistory({
    /// Format: yyyy-MM-dd
    required String date,

    /// Set ayat yang sudah dibaca.
    /// Format setiap item: 'suratNomor:ayatNomor' (contoh: '2:255')
    @Default(<String>{}) Set<String> ayatRead,
  }) = _ReadingHistory;

  const ReadingHistory._();

  factory ReadingHistory.fromJson(Map<String, dynamic> json) =>
      _$ReadingHistoryFromJson(json);

  /// Jumlah ayat yang dibaca hari ini.
  int get jumlahAyat => ayatRead.length;

  /// True jika ada ayat yang dibaca hari ini.
  bool get hasData => ayatRead.isNotEmpty;
}

/// Statistik membaca Al-Quran.
@freezed
abstract class ReadingStats with _$ReadingStats {
  const factory ReadingStats({
    /// Total ayat yang pernah dibaca (all-time dari data yang tersimpan).
    @Default(0) int totalAyatRead,

    /// Total hari yang punya data baca.
    @Default(0) int totalHariDenganData,

    /// Rata-rata ayat dibaca per hari (dari hari yang punya data).
    @Default(0.0) double rataRataPerHari,

    /// Progress per juz: juz → persentase (0.0–1.0).
    /// Dihitung dari ayat yang pernah dibaca vs total ayat per juz.
    @Default(<int, double>{}) Map<int, double> progressPerJuz,

    /// Data 90 hari terakhir untuk heatmap.
    @Default(<ReadingHistory>[]) List<ReadingHistory> last90Days,

    /// Top 5 surat paling sering dibaca.
    @Default(<SuratReadCount>[]) List<SuratReadCount> topSurat,
  }) = _ReadingStats;

  const ReadingStats._();

  /// True jika tidak ada data sama sekali.
  bool get isEmpty => totalAyatRead == 0;
}

/// Jumlah ayat yang dibaca per surat.
@freezed
abstract class SuratReadCount with _$SuratReadCount {
  const factory SuratReadCount({
    required int suratNomor,
    required String namaLatin,
    required int jumlahAyatDibaca,
  }) = _SuratReadCount;

  factory SuratReadCount.fromJson(Map<String, dynamic> json) =>
      _$SuratReadCountFromJson(json);
}
