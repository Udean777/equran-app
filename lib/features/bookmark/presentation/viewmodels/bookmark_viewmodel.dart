import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/add_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_all_surat_progress.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_bookmarks.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/remove_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/save_last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/save_surat_progress.dart';
import 'package:equran_app/features/bookmark/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkViewModel extends Notifier<BookmarkState> {
  GetBookmarks get _getBookmarks => ref.read(getBookmarksProvider);
  AddBookmark get _addBookmark => ref.read(addBookmarkProvider);
  RemoveBookmark get _removeBookmark => ref.read(removeBookmarkProvider);
  GetLastRead get _getLastRead => ref.read(getLastReadProvider);
  SaveLastRead get _saveLastRead => ref.read(saveLastReadProvider);
  GetAllSuratProgress get _getAllSuratProgress =>
      ref.read(getAllSuratProgressProvider);
  SaveSuratProgress get _saveSuratProgress =>
      ref.read(saveSuratProgressProvider);

  @override
  BookmarkState build() => const BookmarkState.initial();

  Future<void> load() async {
    state = const BookmarkState.loading();

    final bookmarksResult = await _getBookmarks();
    final lastReadResult = await _getLastRead();
    final suratProgressResult = await _getAllSuratProgress();

    Failure? firstFailure;
    List<Bookmark>? bookmarks;
    LastRead? lastRead;
    var suratProgressMap = <int, double>{};

    bookmarksResult.fold((f) => firstFailure ??= f, (r) => bookmarks = r);
    lastReadResult.fold((f) => firstFailure ??= f, (r) => lastRead = r);
    suratProgressResult.fold((_) {}, (r) => suratProgressMap = r);

    if (firstFailure != null) {
      state = BookmarkState.failure(failure: firstFailure!);
      return;
    }

    state = BookmarkState.success(
      bookmarks: bookmarks!,
      lastRead: lastRead,
      suratProgressMap: suratProgressMap,
    );
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    final result = await _addBookmark(bookmark);
    result.fold(
      (failure) => state = BookmarkState.failure(failure: failure),
      (_) => load(),
    );
  }

  Future<void> removeBookmark({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    final result = await _removeBookmark(
      RemoveBookmarkParams(suratNomor: suratNomor, ayatNomor: ayatNomor),
    );
    result.fold(
      (failure) => state = BookmarkState.failure(failure: failure),
      (_) => load(),
    );
  }

  Future<void> saveLastRead(LastRead lastRead) async {
    await _saveLastRead(lastRead);
    // Simpan progress per surat sekaligus (fire and forget)
    unawaited(
      _saveSuratProgress(
        SaveSuratProgressParams(
          suratNomor: lastRead.suratNomor,
          maxProgress: lastRead.maxScrollPercent,
        ),
      ),
    );
    // Emit state baru agar LastReadCard di home update realtime.
    final currentState = state;
    if (currentState is BookmarkSuccess) {
      // Update lastRead + suratProgressMap sekaligus
      final updatedMap = Map<int, double>.from(currentState.suratProgressMap);
      final existing = updatedMap[lastRead.suratNomor] ?? 0.0;
      if (lastRead.maxScrollPercent > existing) {
        updatedMap[lastRead.suratNomor] = lastRead.maxScrollPercent;
      }
      state = currentState.copyWith(
        lastRead: lastRead,
        suratProgressMap: updatedMap,
      );
    }
  }

  /// Update lastRead realtime saat audio advance ke ayat baru di playlist mode.
  /// Hanya update state in-memory — tidak persist ke Hive.
  /// Persist terjadi saat user kembali ke detail page (dispose → _saveLastRead).
  void updateLastReadFromAudio({
    required int suratNomor,
    required String namaLatin,
    required int ayatNomor,
    required int totalAyat,
  }) {
    final currentState = state;
    if (currentState is BookmarkSuccess) {
      final scrollPercent = totalAyat > 0
          ? (ayatNomor / totalAyat).clamp(0.0, 1.0)
          : 0.0;
      final current = currentState.lastRead;
      // maxScrollPercent hanya dipertahankan jika suratnya sama
      // jika ganti surat, reset ke scrollPercent saat ini
      final maxScrollPercent = current?.suratNomor == suratNomor
          ? scrollPercent > (current?.maxScrollPercent ?? 0.0)
                ? scrollPercent
                : current!.maxScrollPercent
          : scrollPercent;

      state = currentState.copyWith(
        lastRead: LastRead(
          suratNomor: suratNomor,
          ayatNomor: ayatNomor,
          namaLatin: namaLatin,
          readAt: current?.readAt ?? DateTime.now(),
          scrollPercent: scrollPercent,
          maxScrollPercent: maxScrollPercent,
          totalAyat: totalAyat,
        ),
      );
    }
  }
}
