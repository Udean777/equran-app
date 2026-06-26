import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:synchronized/synchronized.dart';

abstract interface class DoaBookmarkDataSource {
  Future<Set<int>> getBookmarkedIds();
  Future<void> addBookmark(int id);
  Future<void> removeBookmark(int id);
  Future<bool> isBookmarked(int id);
}

class DoaBookmarkDataSourceImpl implements DoaBookmarkDataSource {
  DoaBookmarkDataSourceImpl(this._box);

  final Box<String> _box;
  final _lock = Lock();

  static const _key = 'doa_bookmark_ids';

  @override
  Future<Set<int>> getBookmarkedIds() async {
    try {
      final raw = _box.get(_key);
      if (raw == null) return {};
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => e as int).toSet();
    } on Object catch (_) {
      return {};
    }
  }

  @override
  Future<void> addBookmark(int id) async {
    await _lock.synchronized(() async {
      final ids = await getBookmarkedIds();
      if (ids.contains(id)) return;
      ids.add(id);
      await _box.put(_key, jsonEncode(ids.toList()));
    });
  }

  @override
  Future<void> removeBookmark(int id) async {
    await _lock.synchronized(() async {
      final ids = await getBookmarkedIds();
      ids.remove(id);
      await _box.put(_key, jsonEncode(ids.toList()));
    });
  }

  @override
  Future<bool> isBookmarked(int id) async {
    final ids = await getBookmarkedIds();
    return ids.contains(id);
  }
}
