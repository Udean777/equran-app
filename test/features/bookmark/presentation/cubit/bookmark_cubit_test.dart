import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/usecases/add_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_all_surat_progress.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_bookmarks.dart';
import 'package:equran_app/features/bookmark/domain/usecases/get_last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/remove_bookmark.dart';
import 'package:equran_app/features/bookmark/domain/usecases/save_last_read.dart';
import 'package:equran_app/features/bookmark/domain/usecases/save_surat_progress.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_bookmark_data.dart';

class MockGetBookmarks extends Mock implements GetBookmarks {}

class MockAddBookmark extends Mock implements AddBookmark {}

class MockRemoveBookmark extends Mock implements RemoveBookmark {}

class MockGetLastRead extends Mock implements GetLastRead {}

class MockSaveLastRead extends Mock implements SaveLastRead {}

class MockGetAllSuratProgress extends Mock implements GetAllSuratProgress {}

class MockSaveSuratProgress extends Mock implements SaveSuratProgress {}

void main() {
  late MockGetBookmarks mockGetBookmarks;
  late MockAddBookmark mockAddBookmark;
  late MockRemoveBookmark mockRemoveBookmark;
  late MockGetLastRead mockGetLastRead;
  late MockSaveLastRead mockSaveLastRead;
  late MockGetAllSuratProgress mockGetAllSuratProgress;
  late MockSaveSuratProgress mockSaveSuratProgress;

  setUp(() {
    mockGetBookmarks = MockGetBookmarks();
    mockAddBookmark = MockAddBookmark();
    mockRemoveBookmark = MockRemoveBookmark();
    mockGetLastRead = MockGetLastRead();
    mockSaveLastRead = MockSaveLastRead();
    mockGetAllSuratProgress = MockGetAllSuratProgress();
    mockSaveSuratProgress = MockSaveSuratProgress();

    registerFallbackValue(tBookmark);
    registerFallbackValue(tLastRead);
    registerFallbackValue(
      const RemoveBookmarkParams(suratNomor: 1, ayatNomor: 1),
    );

    // Stubs default
    when(
      () => mockGetAllSuratProgress(),
    ).thenReturn(right(<int, double>{}));
    when(
      () => mockSaveSuratProgress(any(), any()),
    ).thenAnswer((_) async => right(unit));
  });

  BookmarkCubit buildCubit() => BookmarkCubit(
    mockGetBookmarks,
    mockAddBookmark,
    mockRemoveBookmark,
    mockGetLastRead,
    mockSaveLastRead,
    mockGetAllSuratProgress,
    mockSaveSuratProgress,
  );

  group('BookmarkCubit', () {
    blocTest<BookmarkCubit, BookmarkState>(
      'emits [loading, success] saat load() berhasil',
      build: () {
        when(
          () => mockGetBookmarks(),
        ).thenAnswer((_) async => right([tBookmark]));
        when(() => mockGetLastRead()).thenAnswer((_) async => right(tLastRead));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const BookmarkState.loading(),
        BookmarkState.success(
          bookmarks: [tBookmark],
          lastRead: tLastRead,
        ),
      ],
    );

    blocTest<BookmarkCubit, BookmarkState>(
      'emits [loading, success] dengan lastRead null jika belum ada',
      build: () {
        when(() => mockGetBookmarks()).thenAnswer((_) async => right([]));
        when(() => mockGetLastRead()).thenAnswer((_) async => right(null));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const BookmarkState.loading(),
        const BookmarkState.success(bookmarks: []),
      ],
    );

    blocTest<BookmarkCubit, BookmarkState>(
      'emits [loading, failure] saat load() gagal',
      build: () {
        when(
          () => mockGetBookmarks(),
        ).thenAnswer((_) async => left(const Failure.network()));
        when(() => mockGetLastRead()).thenAnswer((_) async => right(null));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const BookmarkState.loading(),
        const BookmarkState.failure(failure: Failure.network()),
      ],
    );

    blocTest<BookmarkCubit, BookmarkState>(
      'addBookmark() memanggil usecase dan reload',
      build: () {
        when(() => mockAddBookmark(any())).thenAnswer((_) async => right(unit));
        when(
          () => mockGetBookmarks(),
        ).thenAnswer((_) async => right([tBookmark]));
        when(() => mockGetLastRead()).thenAnswer((_) async => right(null));
        return buildCubit();
      },
      act: (cubit) => cubit.addBookmark(tBookmark),
      expect: () => [
        const BookmarkState.loading(),
        BookmarkState.success(bookmarks: [tBookmark]),
      ],
      verify: (_) {
        verify(() => mockAddBookmark(tBookmark)).called(1);
      },
    );

    blocTest<BookmarkCubit, BookmarkState>(
      'removeBookmark() memanggil usecase dan reload',
      build: () {
        when(
          () => mockRemoveBookmark(any()),
        ).thenAnswer((_) async => right(unit));
        when(() => mockGetBookmarks()).thenAnswer((_) async => right([]));
        when(() => mockGetLastRead()).thenAnswer((_) async => right(null));
        return buildCubit();
      },
      act: (cubit) => cubit.removeBookmark(suratNomor: 1, ayatNomor: 1),
      expect: () => [
        const BookmarkState.loading(),
        const BookmarkState.success(bookmarks: []),
      ],
      verify: (_) {
        verify(
          () => mockRemoveBookmark(
            const RemoveBookmarkParams(suratNomor: 1, ayatNomor: 1),
          ),
        ).called(1);
      },
    );

    blocTest<BookmarkCubit, BookmarkState>(
      'saveLastRead() memanggil usecase tanpa emit state',
      build: () {
        when(
          () => mockSaveLastRead(any()),
        ).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.saveLastRead(tLastRead),
      expect: () => <BookmarkState>[],
      verify: (_) {
        verify(() => mockSaveLastRead(tLastRead)).called(1);
      },
    );
  });
}
