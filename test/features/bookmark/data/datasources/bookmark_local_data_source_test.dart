import 'dart:convert';

import 'package:equran_app/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:equran_app/features/bookmark/data/models/bookmark_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_bookmark_data.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late BookmarkLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = BookmarkLocalDataSourceImpl(mockBox);
  });

  group('getBookmarks()', () {
    test('return list bookmark jika ada data', () async {
      final dtos = [tBookmark, tBookmark2].map(
        (b) => BookmarkDto(
          suratNomor: b.suratNomor,
          ayatNomor: b.ayatNomor,
          namaLatin: b.namaLatin,
          teksArab: b.teksArab,
          teksIndonesia: b.teksIndonesia,
          savedAt: b.savedAt.toIso8601String(),
        ),
      );
      when(
        () => mockBox.get('bookmarks'),
      ).thenReturn(jsonEncode(dtos.map((e) => e.toJson()).toList()));

      final result = await dataSource.getBookmarks();

      expect(result.length, 2);
      expect(result.first.namaLatin, 'Al-Fatihah');
    });

    test('return list kosong jika tidak ada data', () async {
      when(() => mockBox.get('bookmarks')).thenReturn(null);

      final result = await dataSource.getBookmarks();

      expect(result, isEmpty);
    });

    test('return list kosong jika data corrupt', () async {
      when(() => mockBox.get('bookmarks')).thenReturn('corrupt');

      final result = await dataSource.getBookmarks();

      expect(result, isEmpty);
    });
  });

  group('addBookmark()', () {
    test('tambah bookmark baru ke list', () async {
      when(() => mockBox.get('bookmarks')).thenReturn(null);
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      final dto = BookmarkDto(
        suratNomor: tBookmark.suratNomor,
        ayatNomor: tBookmark.ayatNomor,
        namaLatin: tBookmark.namaLatin,
        teksArab: tBookmark.teksArab,
        teksIndonesia: tBookmark.teksIndonesia,
        savedAt: tBookmark.savedAt.toIso8601String(),
      );

      await dataSource.addBookmark(dto);

      verify(() => mockBox.put('bookmarks', any<String>())).called(1);
    });

    test('tidak duplikat jika bookmark sudah ada', () async {
      final dto = BookmarkDto(
        suratNomor: 1,
        ayatNomor: 1,
        namaLatin: 'Al-Fatihah',
        teksArab: 'test',
        teksIndonesia: 'test',
        savedAt: DateTime.now().toIso8601String(),
      );
      when(
        () => mockBox.get('bookmarks'),
      ).thenReturn(jsonEncode([dto.toJson()]));
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await dataSource.addBookmark(dto);

      verifyNever(() => mockBox.put(any<String>(), any<String>()));
    });
  });

  group('removeBookmark()', () {
    test('hapus bookmark dari list', () async {
      final dto = BookmarkDto(
        suratNomor: 1,
        ayatNomor: 1,
        namaLatin: 'Al-Fatihah',
        teksArab: 'test',
        teksIndonesia: 'test',
        savedAt: DateTime.now().toIso8601String(),
      );
      when(
        () => mockBox.get('bookmarks'),
      ).thenReturn(jsonEncode([dto.toJson()]));
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await dataSource.removeBookmark(suratNomor: 1, ayatNomor: 1);

      final captured =
          verify(
                () => mockBox.put('bookmarks', captureAny<String>()),
              ).captured.first
              as String;
      final list = jsonDecode(captured) as List;
      expect(list, isEmpty);
    });
  });

  group('isBookmarked()', () {
    test('return true jika bookmark ada', () async {
      final dto = BookmarkDto(
        suratNomor: 1,
        ayatNomor: 1,
        namaLatin: 'Al-Fatihah',
        teksArab: 'test',
        teksIndonesia: 'test',
        savedAt: DateTime.now().toIso8601String(),
      );
      when(
        () => mockBox.get('bookmarks'),
      ).thenReturn(jsonEncode([dto.toJson()]));

      final result = await dataSource.isBookmarked(suratNomor: 1, ayatNomor: 1);

      expect(result, isTrue);
    });

    test('return false jika bookmark tidak ada', () async {
      when(() => mockBox.get('bookmarks')).thenReturn(null);

      final result = await dataSource.isBookmarked(suratNomor: 1, ayatNomor: 1);

      expect(result, isFalse);
    });
  });

  group('getLastRead()', () {
    test('return LastReadDto jika ada data', () async {
      final dto = LastReadDto(
        suratNomor: tLastRead.suratNomor,
        ayatNomor: tLastRead.ayatNomor,
        namaLatin: tLastRead.namaLatin,
        readAt: tLastRead.readAt.toIso8601String(),
        totalAyat: 7, // totalAyat > 0 agar tidak dihapus migration
      );
      // Migration sudah dijalankan sebelumnya
      when(
        () => mockBox.get('last_read_v2_migrated'),
      ).thenReturn('true');
      when(() => mockBox.get('last_read')).thenReturn(jsonEncode(dto.toJson()));

      final result = await dataSource.getLastRead();

      expect(result, isNotNull);
      expect(result!.suratNomor, 1);
      expect(result.ayatNomor, 3);
    });

    test('return null jika tidak ada data', () async {
      when(
        () => mockBox.get('last_read_v2_migrated'),
      ).thenReturn('true');
      when(() => mockBox.get('last_read')).thenReturn(null);

      final result = await dataSource.getLastRead();

      expect(result, isNull);
    });

    test('migration hapus data lama yang totalAyat == 0', () async {
      final oldDto = LastReadDto(
        suratNomor: 1,
        ayatNomor: 3,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1).toIso8601String(),
        // totalAyat default 0 — data lama
      );
      final encoded = jsonEncode(oldDto.toJson());

      // Belum migrasi
      when(
        () => mockBox.get('last_read_v2_migrated'),
      ).thenReturn(null);
      // Panggilan pertama: cek isi data lama → ada
      // Panggilan kedua: setelah delete → null
      var callCount = 0;
      when(() => mockBox.get('last_read')).thenAnswer((_) {
        callCount++;
        return callCount == 1 ? encoded : null;
      });
      when(
        () => mockBox.delete('last_read'),
      ).thenAnswer((_) async {});
      when(
        () => mockBox.put('last_read_v2_migrated', 'true'),
      ).thenAnswer((_) async {});

      final result = await dataSource.getLastRead();

      expect(result, isNull);
      verify(() => mockBox.delete('last_read')).called(1);
      verify(() => mockBox.put('last_read_v2_migrated', 'true')).called(1);
    });
  });

  group('saveLastRead()', () {
    test('simpan LastReadDto ke Hive', () async {
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      final dto = LastReadDto(
        suratNomor: tLastRead.suratNomor,
        ayatNomor: tLastRead.ayatNomor,
        namaLatin: tLastRead.namaLatin,
        readAt: tLastRead.readAt.toIso8601String(),
      );

      await dataSource.saveLastRead(dto);

      verify(() => mockBox.put('last_read', any<String>())).called(1);
    });
  });
}
