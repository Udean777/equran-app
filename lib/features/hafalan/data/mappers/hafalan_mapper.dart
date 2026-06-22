import 'package:equran_app/features/hafalan/data/models/hafalan_surat_dto.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';

/// Helper untuk konversi string ↔ HafalanStatus.
extension HafalanStatusStringX on String {
  HafalanStatus toHafalanStatus() {
    switch (this) {
      case 'sedangDihafal':
        return HafalanStatus.sedangDihafal;
      case 'sudahHafal':
        return HafalanStatus.sudahHafal;
      case 'perluMurajaah':
        return HafalanStatus.sudahHafal;
      default:
        return HafalanStatus.belum;
    }
  }
}

extension HafalanStatusEnumX on HafalanStatus {
  String toStringValue() {
    switch (this) {
      case HafalanStatus.sedangDihafal:
        return 'sedangDihafal';
      case HafalanStatus.sudahHafal:
        return 'sudahHafal';
      case HafalanStatus.perluMurajaah:
        return 'sudahHafal';
      case HafalanStatus.belum:
        return 'belum';
    }
  }
}

extension HafalanSuratDtoMapper on HafalanSuratDto {
  HafalanSurat toEntity() => HafalanSurat(
    suratNomor: suratNomor,
    namaLatin: namaLatin,
    nama: nama,
    jumlahAyat: jumlahAyat,
    status: status.toHafalanStatus(),
    ayatHafal: ayatHafal,
    murajaahLevel: murajaahLevel,
    tanggalMulai: tanggalMulai != null ? DateTime.parse(tanggalMulai!) : null,
    tanggalSelesai: tanggalSelesai != null
        ? DateTime.parse(tanggalSelesai!)
        : null,
    tanggalMurajaahBerikutnya: tanggalMurajaahBerikutnya != null
        ? DateTime.parse(tanggalMurajaahBerikutnya!)
        : null,
    catatan: catatan,
  );
}

extension HafalanSuratMapper on HafalanSurat {
  HafalanSuratDto toDto() => HafalanSuratDto(
    suratNomor: suratNomor,
    namaLatin: namaLatin,
    nama: nama,
    jumlahAyat: jumlahAyat,
    status: status.toStringValue(),
    ayatHafal: ayatHafal,
    murajaahLevel: murajaahLevel,
    tanggalMulai: tanggalMulai?.toIso8601String(),
    tanggalSelesai: tanggalSelesai?.toIso8601String(),
    tanggalMurajaahBerikutnya: tanggalMurajaahBerikutnya?.toIso8601String(),
    catatan: catatan,
  );
}
