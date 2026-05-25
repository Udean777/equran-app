import 'package:freezed_annotation/freezed_annotation.dart';

part 'surat_detail_dto.freezed.dart';
part 'surat_detail_dto.g.dart';

// Edge case: suratSebelumnya & suratSelanjutnya bisa `false` (bool) atau object
class SuratNavOrFalseConverter
    implements JsonConverter<SuratNavDto?, Object?> {
  const SuratNavOrFalseConverter();

  @override
  SuratNavDto? fromJson(Object? json) {
    if (json == null || json == false) return null;
    if (json is Map<String, dynamic>) return SuratNavDto.fromJson(json);
    return null;
  }

  @override
  Object? toJson(SuratNavDto? nav) => nav?.toJson();
}

@freezed
abstract class SuratDetailResponseDto with _$SuratDetailResponseDto {
  const factory SuratDetailResponseDto({
    required int code,
    required String message,
    required SuratDetailDto data,
  }) = _SuratDetailResponseDto;

  factory SuratDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SuratDetailResponseDtoFromJson(json);
}

@freezed
abstract class SuratDetailDto with _$SuratDetailDto {
  const factory SuratDetailDto({
    required int nomor,
    required String nama,
    @JsonKey(name: 'namaLatin') required String namaLatin,
    @JsonKey(name: 'jumlahAyat') required int jumlahAyat,
    @JsonKey(name: 'tempatTurun') required String tempatTurun,
    required String arti,
    required String deskripsi,
    @JsonKey(name: 'audioFull') @Default({}) Map<String, String> audioFull,
    @JsonKey(name: 'ayat') @Default([]) List<AyatDto> ayat,
    @JsonKey(name: 'suratSelanjutnya')
    @SuratNavOrFalseConverter()
    SuratNavDto? suratSelanjutnya,
    @JsonKey(name: 'suratSebelumnya')
    @SuratNavOrFalseConverter()
    SuratNavDto? suratSebelumnya,
  }) = _SuratDetailDto;

  factory SuratDetailDto.fromJson(Map<String, dynamic> json) =>
      _$SuratDetailDtoFromJson(json);
}

@freezed
abstract class AyatDto with _$AyatDto {
  const factory AyatDto({
    @JsonKey(name: 'nomorAyat') required int nomorAyat,
    @JsonKey(name: 'teksArab') required String teksArab,
    @JsonKey(name: 'teksLatin') required String teksLatin,
    @JsonKey(name: 'teksIndonesia') required String teksIndonesia,
    @Default({}) Map<String, String> audio,
  }) = _AyatDto;

  factory AyatDto.fromJson(Map<String, dynamic> json) =>
      _$AyatDtoFromJson(json);
}

@freezed
abstract class SuratNavDto with _$SuratNavDto {
  const factory SuratNavDto({
    required int nomor,
    @JsonKey(name: 'namaLatin') required String namaLatin,
    @JsonKey(name: 'jumlahAyat') required int jumlahAyat,
  }) = _SuratNavDto;

  factory SuratNavDto.fromJson(Map<String, dynamic> json) =>
      _$SuratNavDtoFromJson(json);
}
