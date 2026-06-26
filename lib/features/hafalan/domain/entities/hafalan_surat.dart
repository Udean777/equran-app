import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/features/hafalan/domain/constants/murajaah_intervals.dart';
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

  factory HafalanSurat.fromSurat(Surat surat) => HafalanSurat(
    suratNomor: surat.nomor,
    namaLatin: surat.namaLatin,
    nama: surat.nama,
    jumlahAyat: surat.jumlahAyat,
  );

  /// Progress hafalan: 0.0 – 1.0
  double get progressAyat =>
      jumlahAyat == 0 ? 0 : (ayatHafal.length / jumlahAyat).clamp(0.0, 1.0);

  /// True jika semua ayat sudah ditandai hafal.
  bool get isSelesai => jumlahAyat > 0 && ayatHafal.length >= jumlahAyat;

  /// True jika tanggal muraja'ah sudah lewat.
  bool isMurajaahJatuhTempo([DateTime? now]) {
    final current = now ?? DateTime.now();
    return tanggalMurajaahBerikutnya != null &&
        current.isAfter(tanggalMurajaahBerikutnya!);
  }

  /// True jika sudah mencapai level muraja'ah maksimum.
  bool get isMurajaahSelesai => murajaahLevel >= 5;
}

/// Domain logic untuk [HafalanSurat] — business rules yang tidak bergantung
/// pada layer presentation atau data.
extension HafalanSuratX on HafalanSurat {
  /// Hitung tanggal muraja'ah berikutnya berdasarkan level spaced repetition.
  DateTime nextMurajaahDate(int level, [DateTime? now]) {
    final current = now ?? DateTime.now();
    final days = level < kMurajaahIntervalDays.length
        ? kMurajaahIntervalDays[level]
        : kMurajaahIntervalDays.last;
    return current.add(Duration(days: days));
  }

  /// Buat salinan setelah toggle satu ayat hafal/belum hafal.
  /// Otomatis compute status, tanggalSelesai, dan jadwal muraja'ah.
  HafalanSurat withToggledAyat(int ayatNomor) {
    final newAyatHafal = List<int>.from(ayatHafal);
    if (newAyatHafal.contains(ayatNomor)) {
      newAyatHafal.remove(ayatNomor);
    } else {
      newAyatHafal.add(ayatNomor);
    }
    return withAyatHafalList(newAyatHafal);
  }

  /// Buat salinan dengan list ayat hafal baru.
  /// Otomatis compute status, tanggalSelesai, dan jadwal muraja'ah.
  HafalanSurat withAyatHafalList(List<int> newAyatHafal) {
    final nowSelesai = newAyatHafal.length >= jumlahAyat && jumlahAyat > 0;

    // Baru selesai: set tanggalSelesai + jadwal muraja'ah pertama
    if (nowSelesai && !isSelesai) {
      return copyWith(
        ayatHafal: newAyatHafal,
        status: HafalanStatus.sudahHafal,
        tanggalSelesai: DateTime.now(),
        murajaahLevel: 0,
        tanggalMurajaahBerikutnya: nextMurajaahDate(0),
      );
    }

    // Tidak lagi selesai: batalkan muraja'ah
    if (!nowSelesai && isSelesai) {
      return copyWith(
        ayatHafal: newAyatHafal,
        status: newAyatHafal.isEmpty
            ? HafalanStatus.belum
            : HafalanStatus.sedangDihafal,
        tanggalSelesai: null,
        murajaahLevel: 0,
        tanggalMurajaahBerikutnya: null,
      );
    }

    // Masih dalam proses
    return copyWith(
      ayatHafal: newAyatHafal,
      status: newAyatHafal.isEmpty
          ? HafalanStatus.belum
          : HafalanStatus.sedangDihafal,
    );
  }
}
