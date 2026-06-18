import 'dart:convert';

import 'package:equran_app/features/bookmark/data/models/bookmark_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

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

  /// Ambil progress per surat — key: suratNomor, value: maxScrollPercent (0.0–1.0)
  Map<int, double> getAllSuratProgress();

  /// Simpan progress satu surat
  Future<void> saveSuratProgress(int suratNomor, double maxProgress);
}

@LazySingleton(as: BookmarkLocalDataSource)
class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  BookmarkLocalDataSourceImpl(@Named('bookmarkBox') this._box);

  final Box<String> _box;
  final _lock = Lock();

  static const _bookmarksKey = 'bookmarks';
  static const _lastReadKey = 'last_read';
  static const _suratProgressKey = 'surat_progress';
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
    await _lock.synchronized(() async {
      final current = await _getBookmarksRaw();
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

  // Private helper — dipanggil hanya dari dalam lock
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
      // Hanya update jika progress baru lebih tinggi
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
