import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:synchronized/synchronized.dart';

abstract interface class ReadingProgressLocalDataSource {
  Map<int, double> getAllSuratProgress();
  Future<void> saveSuratProgress(int suratNomor, double maxProgress);
}

class ReadingProgressLocalDataSourceImpl
    implements ReadingProgressLocalDataSource {
  ReadingProgressLocalDataSourceImpl(this._box);

  final Box<String> _box;
  final _lock = Lock();

  static const _suratProgressKey = 'surat_progress';

  @override
  Map<int, double> getAllSuratProgress() {
    try {
      final raw = _box.get(_suratProgressKey);
      if (raw == null) return {};
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map(
        (k, v) => MapEntry(int.parse(k), (v as num).toDouble()),
      );
    } on Object catch (_) {
      return {};
    }
  }

  @override
  Future<void> saveSuratProgress(int suratNomor, double maxProgress) async {
    await _lock.synchronized(() async {
      final current = getAllSuratProgress();
      final existing = current[suratNomor] ?? 0.0;
      if (maxProgress <= existing) return;
      current[suratNomor] = maxProgress;
      await _box.put(
        _suratProgressKey,
        jsonEncode(current.map((k, v) => MapEntry(k.toString(), v))),
      );
    });
  }
}
