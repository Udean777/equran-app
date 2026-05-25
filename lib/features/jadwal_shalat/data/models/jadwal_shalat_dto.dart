import 'package:freezed_annotation/freezed_annotation.dart';

part 'jadwal_shalat_dto.freezed.dart';
part 'jadwal_shalat_dto.g.dart';

@freezed
abstract class ProvinsiShalatResponseDto with _$ProvinsiShalatResponseDto {
  const factory ProvinsiShalatResponseDto({
    required int code,
    required String message,
    required List<String> data,
  }) = _ProvinsiShalatResponseDto;

  factory ProvinsiShalatResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProvinsiShalatResponseDtoFromJson(json);
}

@freezed
abstract class KabkotaShalatResponseDto with _$KabkotaShalatResponseDto {
  const factory KabkotaShalatResponseDto({
    required int code,
    required String message,
    required List<String> data,
  }) = _KabkotaShalatResponseDto;

  factory KabkotaShalatResponseDto.fromJson(Map<String, dynamic> json) =>
      _$KabkotaShalatResponseDtoFromJson(json);
}

@freezed
abstract class JadwalShalatResponseDto with _$JadwalShalatResponseDto {
  const factory JadwalShalatResponseDto({
    required int code,
    required String message,
    required JadwalShalatDto data,
  }) = _JadwalShalatResponseDto;

  factory JadwalShalatResponseDto.fromJson(Map<String, dynamic> json) =>
      _$JadwalShalatResponseDtoFromJson(json);
}

@freezed
abstract class JadwalShalatDto with _$JadwalShalatDto {
  const factory JadwalShalatDto({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
    @JsonKey(name: 'bulan_nama') required String bulanNama,
    required List<JadwalShalatEntryDto> jadwal,
  }) = _JadwalShalatDto;

  factory JadwalShalatDto.fromJson(Map<String, dynamic> json) =>
      _$JadwalShalatDtoFromJson(json);
}

@freezed
abstract class JadwalShalatEntryDto with _$JadwalShalatEntryDto {
  const factory JadwalShalatEntryDto({
    required int tanggal,
    @JsonKey(name: 'tanggal_lengkap') required String tanggalLengkap,
    required String hari,
    required String imsak,
    required String subuh,
    required String terbit,
    required String dhuha,
    required String dzuhur,
    required String ashar,
    required String maghrib,
    required String isya,
  }) = _JadwalShalatEntryDto;

  factory JadwalShalatEntryDto.fromJson(Map<String, dynamic> json) =>
      _$JadwalShalatEntryDtoFromJson(json);
}
