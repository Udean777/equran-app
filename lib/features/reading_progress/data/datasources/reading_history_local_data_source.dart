import 'dart:convert';

import 'package:equran_app/features/reading_progress/data/mappers/reading_history_mapper.dart';
import 'package:equran_app/features/reading_progress/data/models/reading_history_dto.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';

abstract interface class ReadingHistoryLocalDataSource {
  /// Ambil riwayat baca untuk tanggal tertentu.
  Future<ReadingHistory?> getByDate(String date);

  /// Ambil riwayat baca untuk range tanggal.
  Future<List<ReadingHistory>> getByDateRange(List<String> dates);

  /// Tambah ayat ke riwayat baca hari ini.
  /// [ayatId] format: 'suratNomor:ayatNomor' (contoh: '2:255')
  Future<void> saveAyat(String date, String ayatId);

  /// Batch save beberapa ayat sekaligus (lebih efisien).
  Future<void> saveAyatBatch(String date, Set<String> ayatIds);

  /// Hapus riwayat baca untuk tanggal tertentu.
  Future<void> deleteByDate(String date);

  /// Hapus data yang lebih lama dari [retentionDays] hari.
  Future<void> cleanupOldData(int retentionDays);

  /// Ambil semua tanggal yang punya data (sorted ascending).
  Future<List<String>> getAllDates();
}

class ReadingHistoryLocalDataSourceImpl
    implements ReadingHistoryLocalDataSource {
  const ReadingHistoryLocalDataSourceImpl(
    this._box,
  );

  final Box<String> _box;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Key format: "reading_YYYY-MM-DD"
  String _key(String date) => 'reading_$date';

  @override
  Future<ReadingHistory?> getByDate(String date) async {
    final raw = _box.get(_key(date));
    if (raw == null) return null;
    final dto = ReadingHistoryDto.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    return dto.toEntity();
  }

  @override
  Future<List<ReadingHistory>> getByDateRange(List<String> dates) async {
    final result = <ReadingHistory>[];
    for (final date in dates) {
      final history = await getByDate(date);
      if (history != null) result.add(history);
    }
    return result;
  }

  @override
  Future<void> saveAyat(String date, String ayatId) async {
    final existing = await getByDate(date);
    final currentAyat = existing?.ayatRead ?? <String>{};
    if (currentAyat.contains(ayatId)) return; // sudah ada, skip

    final updated = ReadingHistory(
      date: date,
      ayatRead: {...currentAyat, ayatId},
    );
    await _persist(updated);
  }

  @override
  Future<void> saveAyatBatch(String date, Set<String> ayatIds) async {
    if (ayatIds.isEmpty) return;
    final existing = await getByDate(date);
    final currentAyat = existing?.ayatRead ?? <String>{};
    final merged = {...currentAyat, ...ayatIds};
    if (merged.length == currentAyat.length) return; // tidak ada yang baru

    final updated = ReadingHistory(date: date, ayatRead: merged);
    await _persist(updated);
  }

  @override
  Future<void> deleteByDate(String date) async {
    await _box.delete(_key(date));
  }

  @override
  Future<void> cleanupOldData(int retentionDays) async {
    final cutoff = DateTime.now().subtract(Duration(days: retentionDays));
    final cutoffStr = _dateFormat.format(cutoff);

    final keysToDelete = _box.keys
        .whereType<String>()
        .where((k) => k.startsWith('reading_'))
        .where((k) {
          final date = k.replaceFirst('reading_', '');
          return date.compareTo(cutoffStr) < 0;
        })
        .toList();

    for (final key in keysToDelete) {
      await _box.delete(key);
    }
  }

  @override
  Future<List<String>> getAllDates() async {
    return _box.keys
        .whereType<String>()
        .where((k) => k.startsWith('reading_'))
        .map((k) => k.replaceFirst('reading_', ''))
        .toList()
      ..sort();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Future<void> _persist(ReadingHistory history) async {
    final dto = history.toDto();
    await _box.put(_key(history.date), jsonEncode(dto.toJson()));
  }
}
