import 'package:equran_app/core/utils/html_stripper.dart';
import 'package:equran_app/features/surat_detail/data/models/surat_detail_dto.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';

extension SuratDetailDtoMapper on SuratDetailDto {
  SuratDetail toEntity() => SuratDetail(
    nomor: nomor,
    nama: nama,
    namaLatin: namaLatin,
    jumlahAyat: jumlahAyat,
    tempatTurun: _parseTempatTurun(tempatTurun),
    arti: arti,
    deskripsi: deskripsi.stripHtml(),
    audioFull: audioFull,
    ayatList: ayat.map((a) => a.toEntity()).toList(),
    suratSelanjutnya: suratSelanjutnya?.toEntity(),
    suratSebelumnya: suratSebelumnya?.toEntity(),
  );
}

extension AyatDtoMapper on AyatDto {
  Ayat toEntity() => Ayat(
    nomorAyat: nomorAyat,
    teksArab: teksArab,
    teksLatin: teksLatin,
    teksIndonesia: teksIndonesia,
    audio: audio,
  );
}

extension SuratNavDtoMapper on SuratNavDto {
  SuratNavigation toEntity() => SuratNavigation(
    nomor: nomor,
    namaLatin: namaLatin,
    jumlahAyat: jumlahAyat,
  );
}

TempatTurun _parseTempatTurun(String raw) => switch (raw.toLowerCase()) {
  'mekah' => TempatTurun.mekah,
  'madinah' => TempatTurun.madinah,
  _ => TempatTurun.mekah,
};
