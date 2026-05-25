import 'dart:convert';

import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox mockBox;
  late DoaBookmarkDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = DoaBookmarkDataSourceImpl(mockBox);
  });

  group('DoaBookmarkDataSource — getBookmarkedIds', () {
    test('return Set kosong jika box kosong', () async {
      when(() => mockBox.get('doa_bookmark_ids')).thenReturn(null);

      final result = await dataSource.getBookmarkedIds();

      expect(result, isEmpty);
    });

    test('return Set<int> dari JSON yang tersimpan', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6, 135]));

      final result = await dataSource.getBookmarkedIds();

      expect(result, equals({1, 6, 135}));
    });

    test('return Set kosong jika JSON corrupt', () async {
      when(() => mockBox.get('doa_bookmark_ids')).thenReturn('invalid_json');

      final result = await dataSource.getBookmarkedIds();

      expect(result, isEmpty);
    });
  });

  group('DoaBookmarkDataSource — addBookmark', () {
    test('tambah ID baru ke set yang sudah ada', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6]));
      when(
        () => mockBox.put(any<dynamic>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      await dataSource.addBookmark(135);

      final captured =
          verify(
                () => mockBox.put('doa_bookmark_ids', captureAny<dynamic>()),
              ).captured.first
              as String;

      final saved = (jsonDecode(captured) as List).cast<int>().toSet();
      expect(saved, containsAll([1, 6, 135]));
    });

    test('tidak duplikasi jika ID sudah ada', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6]));
      when(
        () => mockBox.put(any<dynamic>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      await dataSource.addBookmark(1); // sudah ada

      final captured =
          verify(
                () => mockBox.put('doa_bookmark_ids', captureAny<dynamic>()),
              ).captured.first
              as String;

      final saved = (jsonDecode(captured) as List).cast<int>().toSet();
      expect(saved.where((id) => id == 1).length, equals(1));
    });
  });

  group('DoaBookmarkDataSource — removeBookmark', () {
    test('hapus ID dari set', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6, 135]));
      when(
        () => mockBox.put(any<dynamic>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      await dataSource.removeBookmark(6);

      final captured =
          verify(
                () => mockBox.put('doa_bookmark_ids', captureAny<dynamic>()),
              ).captured.first
              as String;

      final saved = (jsonDecode(captured) as List).cast<int>().toSet();
      expect(saved, equals({1, 135}));
      expect(saved, isNot(contains(6)));
    });
  });

  group('DoaBookmarkDataSource — isBookmarked', () {
    test('return true jika ID ada di set', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6, 135]));

      final result = await dataSource.isBookmarked(6);

      expect(result, isTrue);
    });

    test('return false jika ID tidak ada di set', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6, 135]));

      final result = await dataSource.isBookmarked(999);

      expect(result, isFalse);
    });

    test('return false jika box kosong', () async {
      when(() => mockBox.get('doa_bookmark_ids')).thenReturn(null);

      final result = await dataSource.isBookmarked(1);

      expect(result, isFalse);
    });
  });
}
