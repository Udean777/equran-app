import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:equran_app/features/bookmark/data/datasources/last_read_local_data_source.dart';
import 'package:equran_app/features/bookmark/data/datasources/reading_progress_local_data_source.dart';
import 'package:equran_app/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:equran_app/features/bookmark/data/repositories/last_read_repository_impl.dart';
import 'package:equran_app/features/bookmark/data/repositories/reading_progress_repository_impl.dart';
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:equran_app/features/bookmark/domain/repositories/last_read_repository.dart';
import 'package:equran_app/features/bookmark/domain/repositories/reading_progress_repository.dart';
import 'package:equran_app/features/bookmark/domain/usecases/add_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_all_surat_progress.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_bookmarks.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/remove_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/save_last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/save_surat_progress.dart';
import 'package:equran_app/features/bookmark/presentation/viewmodels/bookmark_state.dart';
import 'package:equran_app/features/bookmark/presentation/viewmodels/bookmark_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/bookmark_state.dart';

// --- Data Sources ---

final bookmarkLocalDataSourceProvider = Provider<BookmarkLocalDataSource>((
  ref,
) {
  return BookmarkLocalDataSourceImpl(ref.watch(bookmarkBoxProvider));
});

final lastReadLocalDataSourceProvider = Provider<LastReadLocalDataSource>((
  ref,
) {
  return LastReadLocalDataSourceImpl(ref.watch(bookmarkBoxProvider));
});

final readingProgressLocalDataSourceProvider =
    Provider<ReadingProgressLocalDataSource>((ref) {
      return ReadingProgressLocalDataSourceImpl(ref.watch(bookmarkBoxProvider));
    });

// --- Repositories ---

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(ref.read(bookmarkLocalDataSourceProvider));
});

final lastReadRepositoryProvider = Provider<LastReadRepository>((ref) {
  return LastReadRepositoryImpl(ref.read(lastReadLocalDataSourceProvider));
});

final readingProgressRepositoryProvider = Provider<ReadingProgressRepository>((
  ref,
) {
  return ReadingProgressRepositoryImpl(
    ref.read(readingProgressLocalDataSourceProvider),
  );
});

// --- Use Cases ---

final getBookmarksProvider = Provider<GetBookmarks>((ref) {
  return GetBookmarks(ref.read(bookmarkRepositoryProvider));
});

final addBookmarkProvider = Provider<AddBookmark>((ref) {
  return AddBookmark(ref.read(bookmarkRepositoryProvider));
});

final removeBookmarkProvider = Provider<RemoveBookmark>((ref) {
  return RemoveBookmark(ref.read(bookmarkRepositoryProvider));
});

final getLastReadProvider = Provider<GetLastRead>((ref) {
  return GetLastRead(ref.read(lastReadRepositoryProvider));
});

final saveLastReadProvider = Provider<SaveLastRead>((ref) {
  return SaveLastRead(ref.read(lastReadRepositoryProvider));
});

final getAllSuratProgressProvider = Provider<GetAllSuratProgress>((ref) {
  return GetAllSuratProgress(ref.read(readingProgressRepositoryProvider));
});

final saveSuratProgressProvider = Provider<SaveSuratProgress>((ref) {
  return SaveSuratProgress(ref.read(readingProgressRepositoryProvider));
});

// --- ViewModel ---

final bookmarkViewModelProvider =
    NotifierProvider<BookmarkViewModel, BookmarkState>(
      BookmarkViewModel.new,
    );
