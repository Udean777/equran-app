import 'package:equran_app/features/catatan_ayat/data/models/catatan_ayat_dto.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';

extension CatatanAyatDtoMapper on CatatanAyatDto {
  CatatanAyat toEntity() => CatatanAyat(
    suratNomor: suratNomor,
    ayatNomor: ayatNomor,
    namaLatin: namaLatin,
    teksArab: teksArab,
    isi: isi,
    savedAt: DateTime.parse(savedAt),
  );
}

extension CatatanAyatMapper on CatatanAyat {
  CatatanAyatDto toDto() => CatatanAyatDto(
    suratNomor: suratNomor,
    ayatNomor: ayatNomor,
    namaLatin: namaLatin,
    teksArab: teksArab,
    isi: isi,
    savedAt: savedAt.toIso8601String(),
  );
}
