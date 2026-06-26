import 'dart:convert';

import 'package:equran_app/features/statistik_shalat/data/mappers/shalat_log_mapper.dart';
import 'package:equran_app/features/statistik_shalat/data/models/shalat_log_dto.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:hive_ce/hive.dart';

abstract interface class ShalatLogLocalDataSource {
  /// Ambil data shalat untuk tanggal tertentu.
  /// [date] format: yyyy-MM-dd
  Future<ShalatDayStats?> getByDate(String date);

  /// Ambil data shalat untuk range tanggal.
  /// [dates] list format: yyyy-MM-dd
  Future<List<ShalatDayStats>> getByDateRange(List<String> dates);

  /// Simpan/update log shalat untuk satu waktu.
  Future<void> saveLog(ShalatLog log);

  /// Hapus data shalat untuk tanggal tertentu.
  Future<void> deleteByDate(String date);

  /// Ambil semua tanggal yang punya data (sorted ascending).
  List<String> getAllDates();
}

class ShalatLogLocalDataSourceImpl implements ShalatLogLocalDataSource {
  const ShalatLogLocalDataSourceImpl(this._box);

  final Box<String> _box;

  /// Key format: "shalat_YYYY-MM-DD"
  String _key(String date) => 'shalat_$date';

  @override
  Future<ShalatDayStats?> getByDate(String date) async {
    try {
      final raw = _box.get(_key(date));
      if (raw == null) return null;
      final dto = ShalatDayDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      return dto.toEntity();
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<List<ShalatDayStats>> getByDateRange(List<String> dates) async {
    final result = <ShalatDayStats>[];
    for (final date in dates) {
      final stats = await getByDate(date);
      if (stats != null) result.add(stats);
    }
    return result;
  }

  @override
  Future<void> saveLog(ShalatLog log) async {
    final existing = await getByDate(log.date);
    final currentLogs = existing?.logs ?? {};

    // Update log untuk waktu shalat ini
    final updatedLogs = Map<String, ShalatLog>.from(currentLogs)
      ..[log.waktu.key] = log;

    final dayStats = ShalatDayStats(date: log.date, logs: updatedLogs);
    final dto = dayStats.toDto();
    await _box.put(_key(log.date), jsonEncode(dto.toJson()));
  }

  @override
  Future<void> deleteByDate(String date) async {
    await _box.delete(_key(date));
  }

  @override
  List<String> getAllDates() {
    return _box.keys
        .whereType<String>()
        .where((k) => k.startsWith('shalat_'))
        .map((k) => k.replaceFirst('shalat_', ''))
        .toList()
      ..sort();
  }
}
