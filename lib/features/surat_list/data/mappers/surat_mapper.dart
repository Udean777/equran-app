import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';

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
      _ => TempatTurun.mekah,
    };
