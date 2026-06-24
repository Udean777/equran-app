import 'package:freezed_annotation/freezed_annotation.dart';

part 'catatan_ayat_dto.freezed.dart';
part 'catatan_ayat_dto.g.dart';

@freezed
abstract class CatatanAyatDto with _$CatatanAyatDto {
  const factory CatatanAyatDto({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required String teksArab,
    required String isi,
    required String savedAt,
  }) = _CatatanAyatDto;

  factory CatatanAyatDto.fromJson(Map<String, dynamic> json) =>
      _$CatatanAyatDtoFromJson(json);
}
