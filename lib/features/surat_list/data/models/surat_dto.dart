import 'package:freezed_annotation/freezed_annotation.dart';

part 'surat_dto.freezed.dart';
part 'surat_dto.g.dart';

@freezed
abstract class SuratListResponseDto with _$SuratListResponseDto {
  const factory SuratListResponseDto({
    required int code,
    required String message,
    required List<SuratDto> data,
  }) = _SuratListResponseDto;

  factory SuratListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SuratListResponseDtoFromJson(json);
}

@freezed
abstract class SuratDto with _$SuratDto {
  const factory SuratDto({
    required int nomor,
    required String nama,
    @JsonKey(name: 'namaLatin') required String namaLatin,
    @JsonKey(name: 'jumlahAyat') required int jumlahAyat,
    @JsonKey(name: 'tempatTurun') required String tempatTurun,
    required String arti,
  }) = _SuratDto;

  factory SuratDto.fromJson(Map<String, dynamic> json) =>
      _$SuratDtoFromJson(json);
}
