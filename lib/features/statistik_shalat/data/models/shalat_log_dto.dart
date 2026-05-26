import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shalat_log_dto.freezed.dart';
part 'shalat_log_dto.g.dart';

@freezed
abstract class ShalatLogDto with _$ShalatLogDto {
  const factory ShalatLogDto({
    required String date,
    required String waktu,
    @Default('belumDicatat') String status,
    String? catatan,
    String? updatedAt,
  }) = _ShalatLogDto;

  factory ShalatLogDto.fromJson(Map<String, dynamic> json) =>
      _$ShalatLogDtoFromJson(json);
}

/// Satu hari = map waktu → ShalatLogDto, disimpan sebagai JSON object.
@freezed
abstract class ShalatDayDto with _$ShalatDayDto {
  const factory ShalatDayDto({
    required String date,
    @Default({}) Map<String, ShalatLogDto> logs,
  }) = _ShalatDayDto;

  factory ShalatDayDto.fromJson(Map<String, dynamic> json) =>
      _$ShalatDayDtoFromJson(json);
}

// ─── String ↔ Enum helpers ───────────────────────────────────────────────────

extension ShalatStatusStringX on String {
  ShalatStatus toShalatStatus() {
    switch (this) {
      case 'tepatWaktu':
        return ShalatStatus.tepatWaktu;
      case 'qadha':
        return ShalatStatus.qadha;
      case 'tidakShalat':
        return ShalatStatus.tidakShalat;
      default:
        return ShalatStatus.belumDicatat;
    }
  }
}

extension ShalatStatusEnumX on ShalatStatus {
  String toStringValue() {
    switch (this) {
      case ShalatStatus.tepatWaktu:
        return 'tepatWaktu';
      case ShalatStatus.qadha:
        return 'qadha';
      case ShalatStatus.tidakShalat:
        return 'tidakShalat';
      case ShalatStatus.belumDicatat:
        return 'belumDicatat';
    }
  }
}

extension WaktuShalatStringX on String {
  WaktuShalat toWaktuShalat() {
    switch (this) {
      case 'subuh':
        return WaktuShalat.subuh;
      case 'dzuhur':
        return WaktuShalat.dzuhur;
      case 'ashar':
        return WaktuShalat.ashar;
      case 'maghrib':
        return WaktuShalat.maghrib;
      case 'isya':
        return WaktuShalat.isya;
      default:
        return WaktuShalat.subuh;
    }
  }
}
