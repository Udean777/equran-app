import 'package:equran_app/features/statistik_shalat/data/models/shalat_log_dto.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';

// ─── ShalatLogDto ↔ ShalatLog ────────────────────────────────────────────────

extension ShalatLogDtoMapper on ShalatLogDto {
  ShalatLog toEntity() => ShalatLog(
    date: date,
    waktu: waktu.toWaktuShalat(),
    status: status.toShalatStatus(),
    catatan: catatan,
    updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
  );
}

extension ShalatLogMapper on ShalatLog {
  ShalatLogDto toDto() => ShalatLogDto(
    date: date,
    waktu: waktu.key,
    status: status.toStringValue(),
    catatan: catatan,
    updatedAt: updatedAt?.toIso8601String(),
  );
}

// ─── ShalatDayDto ↔ ShalatDayStats ──────────────────────────────────────────

extension ShalatDayDtoMapper on ShalatDayDto {
  ShalatDayStats toEntity() => ShalatDayStats(
    date: date,
    logs: logs.map((key, dto) => MapEntry(key, dto.toEntity())),
  );
}

extension ShalatDayStatsMapper on ShalatDayStats {
  ShalatDayDto toDto() => ShalatDayDto(
    date: date,
    logs: logs.map((key, log) => MapEntry(key, log.toDto())),
  );
}
