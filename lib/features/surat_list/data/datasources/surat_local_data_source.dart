import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

abstract interface class SuratLocalDataSource {
  Future<List<SuratDto>?> getCachedSuratList();
  Future<void> cacheSuratList(List<SuratDto> surats);
  Future<SuratDetailLocalDto?> getCachedSuratDetail(int nomor);
  Future<void> cacheSuratDetail(int nomor, SuratDetailLocalDto detail);
}

/// Typedef untuk menghindari import silang — data detail disimpan sebagai
/// raw JSON string dan di-decode di DataSource masing-masing.
typedef SuratDetailLocalDto = Map<String, dynamic>;

class SuratLocalDataSourceImpl implements SuratLocalDataSource {
  const SuratLocalDataSourceImpl(this._box);

  final LazyBox<String> _box;

  static const _suratListKey = 'surat_list';
  String _detailKey(int nomor) => 'surat_detail_$nomor';

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

  @override
  Future<SuratDetailLocalDto?> getCachedSuratDetail(int nomor) async {
    try {
      final entry = CacheEntry.decode(await _box.get(_detailKey(nomor)));
      if (entry == null || entry.isExpired) return null;
      return jsonDecode(entry.data) as Map<String, dynamic>;
    } on Object catch (e) {
      debugPrint('Failed to get cached surat detail $nomor: $e');
      return null;
    }
  }

  @override
  Future<void> cacheSuratDetail(int nomor, SuratDetailLocalDto detail) async {
    final entry = CacheEntry(
      data: jsonEncode(detail),
      cachedAt: DateTime.now(),
    );
    await _box.put(_detailKey(nomor), entry.encode());
  }
}
