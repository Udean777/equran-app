import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDoaBookmarkDataSource extends Mock implements DoaBookmarkDataSource {}

void main() {
  late MockDoaBookmarkDataSource mockDataSource;
  late GetDoaBookmarks getDoaBookmarks;
  late ToggleDoaBookmark toggleDoaBookmark;

  setUp(() {
    mockDataSource = MockDoaBookmarkDataSource();
    getDoaBookmarks = GetDoaBookmarks(mockDataSource);
    toggleDoaBookmark = ToggleDoaBookmark(mockDataSource);
  });

  group('GetDoaBookmarks', () {
    test('return Set<int> dari datasource', () async {
      when(
        () => mockDataSource.getBookmarkedIds(),
      ).thenAnswer((_) async => {1, 6, 135});

      final result = await getDoaBookmarks();

      result.fold(
        (_) => fail('should be right'),
        (ids) => expect(ids, equals({1, 6, 135})),
      );
      verify(() => mockDataSource.getBookmarkedIds()).called(1);
    });

    test('return Set kosong jika belum ada bookmark', () async {
      when(() => mockDataSource.getBookmarkedIds()).thenAnswer((_) async => {});

      final result = await getDoaBookmarks();

      result.fold(
        (_) => fail('should be right'),
        (ids) => expect(ids, isEmpty),
      );
    });

    test('return Failure jika datasource throw exception', () async {
      when(
        () => mockDataSource.getBookmarkedIds(),
      ).thenThrow(Exception('hive error'));

      final result = await getDoaBookmarks();

      expect(result.isLeft(), true);
    });
  });

  group('ToggleDoaBookmark', () {
    test(
      'addBookmark dipanggil jika doa belum di-bookmark, return true',
      () async {
        when(
          () => mockDataSource.isBookmarked(1),
        ).thenAnswer((_) async => false);
        when(() => mockDataSource.addBookmark(1)).thenAnswer((_) async {});

        final result = await toggleDoaBookmark(1);

        expect(result, equals(right<Failure, bool>(true)));
        verify(() => mockDataSource.addBookmark(1)).called(1);
        verifyNever(() => mockDataSource.removeBookmark(any()));
      },
    );

    test(
      'removeBookmark dipanggil jika doa sudah di-bookmark, return false',
      () async {
        when(
          () => mockDataSource.isBookmarked(1),
        ).thenAnswer((_) async => true);
        when(() => mockDataSource.removeBookmark(1)).thenAnswer((_) async {});

        final result = await toggleDoaBookmark(1);

        expect(result, equals(right<Failure, bool>(false)));
        verify(() => mockDataSource.removeBookmark(1)).called(1);
        verifyNever(() => mockDataSource.addBookmark(any()));
      },
    );

    test('return Failure jika datasource throw exception', () async {
      when(
        () => mockDataSource.isBookmarked(any()),
      ).thenThrow(Exception('hive error'));

      final result = await toggleDoaBookmark(1);

      expect(result.isLeft(), true);
    });

    test('toggle dua kali mengembalikan ke state awal', () async {
      // Pertama: belum bookmark → add → true
      when(() => mockDataSource.isBookmarked(5)).thenAnswer((_) async => false);
      when(() => mockDataSource.addBookmark(5)).thenAnswer((_) async {});

      final first = await toggleDoaBookmark(5);
      expect(first, equals(right<Failure, bool>(true)));

      // Kedua: sudah bookmark → remove → false
      when(() => mockDataSource.isBookmarked(5)).thenAnswer((_) async => true);
      when(() => mockDataSource.removeBookmark(5)).thenAnswer((_) async {});

      final second = await toggleDoaBookmark(5);
      expect(second, equals(right<Failure, bool>(false)));
    });
  });
}
