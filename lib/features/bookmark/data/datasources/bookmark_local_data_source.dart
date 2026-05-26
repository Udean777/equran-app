import 'dart:convert';

import 'package:equran_app/features/bookmark/data/models/bookmark_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class BookmarkLocalDataSource {
  Future<List<BookmarkDto>> getBookmarks();
  Future<void> addBookmark(BookmarkDto bookmark);
  Future<void> removeBookmark({
    required int suratNomor,
    required int ayatNomor,
  });
  Future<bool> isBookmarked({required int suratNomor, required int ayatNomor});
  Future<LastReadDto?> getLastRead();
  Future<void> saveLastRead(LastReadDto lastRead);
}

@LazySingleton(as: BookmarkLocalDataSource)
class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  const BookmarkLocalDataSourceImpl(@Named('bookmarkBox') this._box);

  final Box<String> _box;

  static const _bookmarksKey = 'bookmarks';
  static const _lastReadKey = 'last_read';
  // Migration key — data lama tidak punya totalAyat, perlu di-reset sekali
  static const _lastReadMigrationKey = 'last_read_v2_migrated';

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
    final current = await getBookmarks();
    // Hindari duplikat
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
  }

  @override
  Future<void> removeBookmark({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    final current = await getBookmarks();
    current.removeWhere(
      (b) => b.suratNomor == suratNomor && b.ayatNomor == ayatNomor,
    );
    await _box.put(
      _bookmarksKey,
      jsonEncode(current.map((e) => e.toJson()).toList()),
    );
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

  @override
  Future<LastReadDto?> getLastRead() async {
    try {
      // One-time migration: hapus data lama yang tidak punya totalAyat
      if (_box.get(_lastReadMigrationKey) == null) {
        final raw = _box.get(_lastReadKey);
        if (raw != null) {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          // Data lama tidak punya 'totalAyat' atau nilainya 0
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
