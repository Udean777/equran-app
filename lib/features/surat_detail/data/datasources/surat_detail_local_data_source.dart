import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/surat_detail/data/models/surat_detail_dto.dart';
import 'package:hive_ce/hive.dart';

abstract interface class SuratDetailLocalDataSource {
  Future<SuratDetailDto?> getCachedSuratDetail(int nomor);
  Future<void> cacheSuratDetail(int nomor, SuratDetailDto detail);
}

class SuratDetailLocalDataSourceImpl implements SuratDetailLocalDataSource {
  const SuratDetailLocalDataSourceImpl(this._box);

  final LazyBox<String> _box;

  String _key(int nomor) => 'surat_detail_$nomor';

  @override
  Future<SuratDetailDto?> getCachedSuratDetail(int nomor) async {
    try {
      final entry = CacheEntry.decode(await _box.get(_key(nomor)));
      if (entry == null || entry.isExpired) return null;
      return SuratDetailDto.fromJson(
        jsonDecode(entry.data) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheSuratDetail(int nomor, SuratDetailDto detail) async {
    final entry = CacheEntry(
      data: jsonEncode(detail.toJson()),
      cachedAt: DateTime.now(),
    );
    await _box.put(_key(nomor), entry.encode());
  }
}
