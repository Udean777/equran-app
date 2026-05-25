import 'package:freezed_annotation/freezed_annotation.dart';

part 'doa_dto.freezed.dart';
part 'doa_dto.g.dart';

@freezed
abstract class DoaListResponseDto with _$DoaListResponseDto {
  const factory DoaListResponseDto({
    required String status,
    required int total,
    required List<DoaDto> data,
  }) = _DoaListResponseDto;

  factory DoaListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DoaListResponseDtoFromJson(json);
}

@freezed
abstract class DoaDetailResponseDto with _$DoaDetailResponseDto {
  const factory DoaDetailResponseDto({
    required String status,
    required DoaDto data,
  }) = _DoaDetailResponseDto;

  factory DoaDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DoaDetailResponseDtoFromJson(json);
}

@freezed
abstract class DoaDto with _$DoaDto {
  const factory DoaDto({
    required int id,
    required String grup,
    required String nama,
    required String ar,
    @Default('') String tr,
    @Default('') String idn,
    @Default('') String tentang,
    @Default([]) List<String> tag,
  }) = _DoaDto;

  factory DoaDto.fromJson(Map<String, dynamic> json) => _$DoaDtoFromJson(json);
}
