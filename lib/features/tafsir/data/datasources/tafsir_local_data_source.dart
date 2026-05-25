import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/tafsir/data/models/tafsir_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class TafsirLocalDataSource {
  Future<TafsirDataDto?> getCachedTafsir(int nomor);
  Future<void> cacheTafsir(int nomor, TafsirDataDto tafsir);
}

@LazySingleton(as: TafsirLocalDataSource)
class TafsirLocalDataSourceImpl implements TafsirLocalDataSource {
  const TafsirLocalDataSourceImpl(@Named('tafsirBox') this._box);

  final Box<String> _box;

  String _key(int nomor) => 'tafsir_$nomor';

  @override
  Future<TafsirDataDto?> getCachedTafsir(int nomor) async {
    try {
      final entry = CacheEntry.decode(_box.get(_key(nomor)));
      if (entry == null || entry.isExpired) return null;
      return TafsirDataDto.fromJson(
        jsonDecode(entry.data) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheTafsir(int nomor, TafsirDataDto tafsir) async {
    final entry = CacheEntry(
      data: jsonEncode(tafsir.toJson()),
      cachedAt: DateTime.now(),
    );
    await _box.put(_key(nomor), entry.encode());
  }
}
