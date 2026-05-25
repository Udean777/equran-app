import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/add_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_bookmarks.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/remove_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/save_last_read.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'bookmark_cubit.freezed.dart';
part 'bookmark_state.dart';

@injectable
class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit(
    this._getBookmarks,
    this._addBookmark,
    this._removeBookmark,
    this._getLastRead,
    this._saveLastRead,
    this._getDoaBookmarks,
    this._getDoaList,
    this._toggleDoaBookmark,
  ) : super(const BookmarkState.initial());

  final GetBookmarks _getBookmarks;
  final AddBookmark _addBookmark;
  final RemoveBookmark _removeBookmark;
  final GetLastRead _getLastRead;
  final SaveLastRead _saveLastRead;
  final GetDoaBookmarks _getDoaBookmarks;
  final GetDoaList _getDoaList;
  final ToggleDoaBookmark _toggleDoaBookmark;

  Future<void> load() async {
    emit(const BookmarkState.loading());

    final bookmarksResult = await _getBookmarks();
    final lastReadResult = await _getLastRead();
    final doaBookmarksResult = await _getDoaBookmarks();
    final doaListResult = await _getDoaList();

    Failure? firstFailure;
    List<Bookmark>? bookmarks;
    LastRead? lastRead;
    Set<int>? bookmarkedDoaIds;
    List<Doa>? allDoas;

    bookmarksResult.fold((f) => firstFailure ??= f, (r) => bookmarks = r);
    lastReadResult.fold((f) => firstFailure ??= f, (r) => lastRead = r);
    doaBookmarksResult.fold(
      (f) => firstFailure ??= f,
      (r) => bookmarkedDoaIds = r,
    );
    doaListResult.fold((f) => firstFailure ??= f, (r) => allDoas = r);

    if (firstFailure != null) {
      emit(BookmarkState.failure(failure: firstFailure!));
      return;
    }

    final bookmarkedDoas = allDoas!
        .where((doa) => bookmarkedDoaIds!.contains(doa.id))
        .toList();

    emit(
      BookmarkState.success(
        bookmarks: bookmarks!,
        bookmarkedDoas: bookmarkedDoas,
        lastRead: lastRead,
      ),
    );
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    final result = await _addBookmark(bookmark);
    result.fold(
      (failure) => emit(BookmarkState.failure(failure: failure)),
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
      (failure) => emit(BookmarkState.failure(failure: failure)),
      (_) => load(),
    );
  }

  Future<void> removeDoaBookmark(int id) async {
    final result = await _toggleDoaBookmark(id);
    result.fold(
      (failure) => emit(BookmarkState.failure(failure: failure)),
      (_) => load(),
    );
  }

  Future<void> saveLastRead(LastRead lastRead) async {
    await _saveLastRead(lastRead);
    // Tidak perlu emit ulang — last read update silent di background
  }
}
