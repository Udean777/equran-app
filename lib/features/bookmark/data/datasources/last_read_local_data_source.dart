import 'dart:convert';

import 'package:equran_app/features/bookmark/data/models/last_read_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class LastReadLocalDataSource {
  Future<LastReadDto?> getLastRead();
  Future<void> saveLastRead(LastReadDto lastRead);
}

@LazySingleton(as: LastReadLocalDataSource)
class LastReadLocalDataSourceImpl implements LastReadLocalDataSource {
  LastReadLocalDataSourceImpl(@Named('bookmarkBox') this._box);

  final Box<String> _box;

  static const _lastReadKey = 'last_read';
  static const _lastReadMigrationKey = 'last_read_v2_migrated';

  @override
  Future<LastReadDto?> getLastRead() async {
    try {
      // One-time migration: hapus data lama yang tidak punya totalAyat
      if (_box.get(_lastReadMigrationKey) == null) {
        final raw = _box.get(_lastReadKey);
        if (raw != null) {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          final totalAyat = json['totalAyat'] as int? ?? 0;
          if (totalAyat == 0) {
            await _box.delete(_lastReadKey);
          }
        }
        await _box.put(_lastReadMigrationKey, 'true');
      }

      final raw = _box.get(_lastReadKey);
      if (raw == null) return null;
      return LastReadDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastRead(LastReadDto lastRead) async {
    await _box.put(_lastReadKey, jsonEncode(lastRead.toJson()));
  }
}
