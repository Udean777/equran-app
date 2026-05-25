import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/doa/data/models/doa_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class DoaLocalDataSource {
  Future<List<DoaDto>?> getCachedDoaList();
  Future<void> cacheDoaList(List<DoaDto> doaList);
  Future<DoaDto?> getCachedDoaDetail(int id);
  Future<void> cacheDoaDetail(int id, DoaDto doa);
}

@LazySingleton(as: DoaLocalDataSource)
class DoaLocalDataSourceImpl implements DoaLocalDataSource {
  const DoaLocalDataSourceImpl(@Named('doaBox') this._box);

  final Box<dynamic> _box;

  static const _doaListKey = 'doa_list';
  String _detailKey(int id) => 'doa_detail_$id';

  @override
  Future<List<DoaDto>?> getCachedDoaList() async {
    try {
      final entry = CacheEntry.decode(_box.get(_doaListKey));
      if (entry == null || entry.isExpired) return null;
      final list = jsonDecode(entry.data) as List<dynamic>;
      return list
          .map((e) => DoaDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheDoaList(List<DoaDto> doaList) async {
    final entry = CacheEntry(
      data: jsonEncode(doaList.map((e) => e.toJson()).toList()),
      cachedAt: DateTime.now(),
    );
    await _box.put(_doaListKey, entry.encode());
  }

  @override
  Future<DoaDto?> getCachedDoaDetail(int id) async {
    try {
      final entry = CacheEntry.decode(_box.get(_detailKey(id)));
      if (entry == null || entry.isExpired) return null;
      return DoaDto.fromJson(jsonDecode(entry.data) as Map<String, dynamic>);
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheDoaDetail(int id, DoaDto doa) async {
    final entry = CacheEntry(
      data: jsonEncode(doa.toJson()),
      cachedAt: DateTime.now(),
    );
    await _box.put(_detailKey(id), entry.encode());
  }
}
