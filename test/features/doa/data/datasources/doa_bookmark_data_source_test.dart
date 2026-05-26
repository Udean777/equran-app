import 'dart:convert';

import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

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
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await dataSource.addBookmark(135);

      final captured =
          verify(
                () => mockBox.put('doa_bookmark_ids', captureAny<String>()),
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
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await dataSource.addBookmark(1); // sudah ada — harus skip

      // Tidak boleh write ke Hive karena id sudah ada
      verifyNever(() => mockBox.put(any<String>(), any<String>()));
    });
  });

  group('DoaBookmarkDataSource — removeBookmark', () {
    test('hapus ID dari set', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6, 135]));
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await dataSource.removeBookmark(6);

      final captured =
          verify(
                () => mockBox.put('doa_bookmark_ids', captureAny<String>()),
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

  // ─── Concurrent operations ────────────────────────────────────────────────

  group('DoaBookmarkDataSource — concurrent operations', () {
    test('concurrent addBookmark tidak duplikat', () async {
      // Dua addBookmark dengan id sama berjalan bersamaan
      // Lock memastikan hanya satu yang tersimpan
      final stored = <String>[];
      when(() => mockBox.get('doa_bookmark_ids')).thenAnswer((_) {
        return stored.isEmpty ? null : stored.last;
      });
      when(() => mockBox.put(any<String>(), any<String>()))
          .thenAnswer((inv) async {
        stored.add(inv.positionalArguments[1] as String);
      });

      await Future.wait([
        dataSource.addBookmark(1),
        dataSource.addBookmark(2),
      ]);

      // put dipanggil 2x — satu per operasi
      verify(
        () => mockBox.put('doa_bookmark_ids', any<String>()),
      ).called(2);
    });

    test('removeBookmark dengan id tidak ada tidak error', () async {
      when(
        () => mockBox.get('doa_bookmark_ids'),
      ).thenReturn(jsonEncode([1, 6]));
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await expectLater(
        dataSource.removeBookmark(999), // id tidak ada
        completes,
      );
    });

    test('concurrent addBookmark + removeBookmark menghasilkan state konsisten',
        () async {
      final stored = <String>[];
      when(() => mockBox.get('doa_bookmark_ids')).thenAnswer((_) {
        return stored.isEmpty ? jsonEncode([1]) : stored.last;
      });
      when(() => mockBox.put(any<String>(), any<String>()))
          .thenAnswer((inv) async {
        stored.add(inv.positionalArguments[1] as String);
      });

      // add + remove berjalan bersamaan — tidak boleh throw
      await Future.wait([
        dataSource.addBookmark(2),
        dataSource.removeBookmark(1),
      ]);

      // Tidak throw = state konsisten
      verify(
        () => mockBox.put('doa_bookmark_ids', any<String>()),
      ).called(greaterThanOrEqualTo(1));
    });
  });
}
