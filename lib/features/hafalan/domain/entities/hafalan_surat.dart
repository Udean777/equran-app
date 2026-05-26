import 'package:freezed_annotation/freezed_annotation.dart';

part 'hafalan_surat.freezed.dart';

/// Status hafalan per surat.
enum HafalanStatus {
  /// Belum pernah ditandai.
  belum,

  /// Sebagian ayat sudah ditandai hafal.
  sedangDihafal,

  /// Semua ayat sudah ditandai hafal.
  sudahHafal,

  /// Jatuh tempo muraja'ah sudah lewat (computed, tidak disimpan di Hive).
  perluMurajaah,
}

@freezed
abstract class HafalanSurat with _$HafalanSurat {
  const factory HafalanSurat({
    required int suratNomor,
    required String namaLatin,
    required String nama,
    required int jumlahAyat,
    @Default(HafalanStatus.belum) HafalanStatus status,

    /// Nomor ayat yang sudah ditandai hafal.
    @Default([]) List<int> ayatHafal,

    /// Level spaced repetition muraja'ah (0–5).
    /// 5 = hafalan dianggap kuat, tidak ada reminder lagi.
    @Default(0) int murajaahLevel,

    /// Tanggal pertama kali mulai menghafal surat ini.
    DateTime? tanggalMulai,

    /// Tanggal semua ayat selesai ditandai hafal.
    DateTime? tanggalSelesai,

    /// Tanggal muraja'ah berikutnya (dari spaced repetition).
    DateTime? tanggalMurajaahBerikutnya,

    /// Catatan pribadi opsional untuk surat ini.
    String? catatan,
  }) = _HafalanSurat;

  const HafalanSurat._();

  /// Progress hafalan: 0.0 – 1.0
  double get progressAyat =>
      jumlahAyat == 0 ? 0 : (ayatHafal.length / jumlahAyat).clamp(0.0, 1.0);

  /// True jika semua ayat sudah ditandai hafal.
  bool get isSelesai => jumlahAyat > 0 && ayatHafal.length >= jumlahAyat;

  /// True jika tanggal muraja'ah sudah lewat.
  bool get isMurajaahJatuhTempo =>
      tanggalMurajaahBerikutnya != null &&
      DateTime.now().isAfter(tanggalMurajaahBerikutnya!);

  /// True jika sudah mencapai level muraja'ah maksimum.
  bool get isMurajaahSelesai => murajaahLevel >= 5;
}
