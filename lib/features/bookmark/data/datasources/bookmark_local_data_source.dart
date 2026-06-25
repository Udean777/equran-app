import 'dart:convert';

import 'package:equran_app/features/bookmark/data/models/bookmark_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:synchronized/synchronized.dart';

abstract interface class BookmarkLocalDataSource {
  Future<List<BookmarkDto>> getBookmarks();
  Future<void> addBookmark(BookmarkDto bookmark);
  Future<void> removeBookmark({
    required int suratNomor,
    required int ayatNomor,
  });
  Future<bool> isBookmarked({required int suratNomor, required int ayatNomor});
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  BookmarkLocalDataSourceImpl(this._box);

  final Box<String> _box;
  final _lock = Lock();

  static const _bookmarksKey = 'bookmarks';

  @override
  Future<List<BookmarkDto>> getBookmarks() async {
    try {
      final raw = _box.get(_bookmarksKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => BookmarkDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (_) {
      return [];
    }
  }

  @override
  Future<void> addBookmark(BookmarkDto bookmark) async {
    await _lock.synchronized(() async {
      final current = await _getBookmarksRaw();
      final exists = current.any(
        (b) =>
            b.suratNomor == bookmark.suratNomor &&
            b.ayatNomor == bookmark.ayatNomor,
      );
      if (exists) return;
      current.add(bookmark);
      await _box.put(
        _bookmarksKey,
        jsonEncode(current.map((e) => e.toJson()).toList()),
      );
    });
  }

  @override
  Future<void> removeBookmark({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    await _lock.synchronized(() async {
      final current = await _getBookmarksRaw();
      current.removeWhere(
        (b) => b.suratNomor == suratNomor && b.ayatNomor == ayatNomor,
      );
      await _box.put(
        _bookmarksKey,
        jsonEncode(current.map((e) => e.toJson()).toList()),
      );
    });
  }

  Future<List<BookmarkDto>> _getBookmarksRaw() async {
    try {
      final raw = _box.get(_bookmarksKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => BookmarkDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (_) {
      return [];
    }
  }

  @override
  Future<bool> isBookmarked({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    final current = await getBookmarks();
    return current.any(
      (b) => b.suratNomor == suratNomor && b.ayatNomor == ayatNomor,
    );
  }
}
