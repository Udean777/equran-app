import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

abstract interface class SuratLocalDataSource {
  Future<List<SuratDto>?> getCachedSuratList();
  Future<void> cacheSuratList(List<SuratDto> surats);
}

class SuratLocalDataSourceImpl implements SuratLocalDataSource {
  const SuratLocalDataSourceImpl(this._box);

  final LazyBox<String> _box;

  static const _suratListKey = 'surat_list';

  @override
  Future<List<SuratDto>?> getCachedSuratList() async {
    try {
      final entry = CacheEntry.decode(await _box.get(_suratListKey));
      if (entry == null || entry.isExpired) return null;
      final list = jsonDecode(entry.data) as List<dynamic>;
      return list
          .map((e) => SuratDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (e) {
      debugPrint('Failed to get cached surat list: $e');
      return null;
    }
  }

  @override
  Future<void> cacheSuratList(List<SuratDto> surats) async {
    final entry = CacheEntry(
      data: jsonEncode(surats.map((e) => e.toJson()).toList()),
      cachedAt: DateTime.now(),
    );
    await _box.put(_suratListKey, entry.encode());
  }
}
