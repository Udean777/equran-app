import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';

extension SuratDtoMapper on SuratDto {
  Surat toEntity() => Surat(
    nomor: nomor,
    nama: nama,
    namaLatin: namaLatin,
    jumlahAyat: jumlahAyat,
    tempatTurun: _parseTempatTurun(tempatTurun),
    arti: arti,
  );
}

TempatTurun _parseTempatTurun(String raw) => switch (raw.toLowerCase()) {
  'mekah' => TempatTurun.mekah,
  'madinah' => TempatTurun.madinah,
  _ => throw FormatException('Unknown tempatTurun value: $raw'),
};
