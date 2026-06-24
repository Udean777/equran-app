import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'surat_detail.freezed.dart';

@freezed
abstract class SuratDetail with _$SuratDetail {
  const factory SuratDetail({
    required int nomor,
    required String nama,
    required String namaLatin,
    required int jumlahAyat,
    required TempatTurun tempatTurun,
    required String arti,
    required String deskripsi,
    required Map<String, String> audioFull,
    required List<Ayat> ayatList,
    SuratNavigation? suratSelanjutnya,
    SuratNavigation? suratSebelumnya,
  }) = _SuratDetail;
}

@freezed
abstract class Ayat with _$Ayat {
  const factory Ayat({
    required int nomorAyat,
    required String teksArab,
    required String teksLatin,
    required String teksIndonesia,
    required Map<String, String> audio,
  }) = _Ayat;
}

@freezed
abstract class SuratNavigation with _$SuratNavigation {
  const factory SuratNavigation({
    required int nomor,
    required String namaLatin,
    required int jumlahAyat,
  }) = _SuratNavigation;
}
