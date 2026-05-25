import 'package:equran_app/core/utils/html_stripper.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/tafsir/data/models/tafsir_dto.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';

extension TafsirDataDtoMapper on TafsirDataDto {
  TafsirSurat toEntity() => TafsirSurat(
        info: Surat(
          nomor: nomor,
          nama: nama,
          namaLatin: namaLatin,
          jumlahAyat: jumlahAyat,
          tempatTurun: _parseTempatTurun(tempatTurun),
          arti: arti,
        ),
        tafsirList: tafsir.map((t) => t.toEntity()).toList(),
      );
}

extension TafsirAyatDtoMapper on TafsirAyatDto {
  TafsirAyat toEntity() => TafsirAyat(
        nomorAyat: ayat,
        teks: teks.stripHtml(),
      );
}

TempatTurun _parseTempatTurun(String raw) => switch (raw.toLowerCase()) {
      'mekah' => TempatTurun.mekah,
      'madinah' => TempatTurun.madinah,
      _ => TempatTurun.mekah,
    };
