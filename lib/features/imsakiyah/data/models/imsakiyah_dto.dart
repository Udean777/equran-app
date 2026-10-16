import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsakiyah_dto.freezed.dart';
part 'imsakiyah_dto.g.dart';

@freezed
abstract class ProvinsiResponseDto with _$ProvinsiResponseDto {
  const factory ProvinsiResponseDto({
    required int code,
    required String message,
    required List<String> data,
  }) = _ProvinsiResponseDto;

  factory ProvinsiResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProvinsiResponseDtoFromJson(json);
}

@freezed
abstract class KabkotaResponseDto with _$KabkotaResponseDto {
  const factory KabkotaResponseDto({
    required int code,
    required String message,
    required List<String> data,
  }) = _KabkotaResponseDto;

  factory KabkotaResponseDto.fromJson(Map<String, dynamic> json) =>
      _$KabkotaResponseDtoFromJson(json);
}

@freezed
abstract class ImsakiyahResponseDto with _$ImsakiyahResponseDto {
  const factory ImsakiyahResponseDto({
    required int code,
    required String message,
    required ImsakiyahDto data,
  }) = _ImsakiyahResponseDto;

  /// The Imsakiyah API has returned both `data: {...}` and
  /// `data: [{...}]` over time. Normalize both shapes at the boundary so the
  /// rest of the feature can work with one stable DTO.
  factory ImsakiyahResponseDto.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final Map<String, dynamic> data;
    if (rawData is Map<String, dynamic>) {
      data = rawData;
    } else if (rawData is List<dynamic> && rawData.isNotEmpty) {
      final first = rawData.first;
      if (first is! Map) {
        throw const FormatException(
          'Response Imsakiyah tidak memiliki data yang valid.',
        );
      }
      data = first.map((key, value) => MapEntry(key.toString(), value));
    } else {
      throw const FormatException(
        'Response Imsakiyah tidak memiliki data yang valid.',
      );
    }

    return ImsakiyahResponseDto(
      code: (json['code'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      data: ImsakiyahDto.fromJson(data),
    );
  }
}

@freezed
abstract class ImsakiyahDto with _$ImsakiyahDto {
  const factory ImsakiyahDto({
    required String provinsi,
    required String kabkota,
    required String hijriah,
    required String masehi,
    required List<ImsakiyahEntryDto> imsakiyah,
  }) = _ImsakiyahDto;

  factory ImsakiyahDto.fromJson(Map<String, dynamic> json) =>
      _$ImsakiyahDtoFromJson(json);
}

@freezed
abstract class ImsakiyahEntryDto with _$ImsakiyahEntryDto {
  const factory ImsakiyahEntryDto({
    required int tanggal,
    required String imsak,
    required String subuh,
    required String terbit,
    required String dhuha,
    required String dzuhur,
    required String ashar,
    required String maghrib,
    required String isya,
  }) = _ImsakiyahEntryDto;

  factory ImsakiyahEntryDto.fromJson(Map<String, dynamic> json) =>
      _$ImsakiyahEntryDtoFromJson(json);
}
