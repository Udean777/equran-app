import 'package:equran_app/features/hafalan/data/models/hafalan_surat_dto.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';

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
