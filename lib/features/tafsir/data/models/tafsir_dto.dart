import 'package:freezed_annotation/freezed_annotation.dart';

part 'tafsir_dto.freezed.dart';
part 'tafsir_dto.g.dart';

@freezed
abstract class TafsirResponseDto with _$TafsirResponseDto {
  const factory TafsirResponseDto({
    required int code,
    required String message,
    required TafsirDataDto data,
  }) = _TafsirResponseDto;

  factory TafsirResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TafsirResponseDtoFromJson(json);
}

@freezed
abstract class TafsirDataDto with _$TafsirDataDto {
  const factory TafsirDataDto({
    required int nomor,
    required String nama,
    @JsonKey(name: 'namaLatin') required String namaLatin,
    @JsonKey(name: 'jumlahAyat') required int jumlahAyat,
    @JsonKey(name: 'tempatTurun') required String tempatTurun,
    required String arti,
    required List<TafsirAyatDto> tafsir,
  }) = _TafsirDataDto;

  factory TafsirDataDto.fromJson(Map<String, dynamic> json) =>
      _$TafsirDataDtoFromJson(json);
}

@freezed
abstract class TafsirAyatDto with _$TafsirAyatDto {
  const factory TafsirAyatDto({
    required int ayat,
    required String teks,
  }) = _TafsirAyatDto;

  factory TafsirAyatDto.fromJson(Map<String, dynamic> json) =>
      _$TafsirAyatDtoFromJson(json);
}
