import 'dart:convert';

import 'package:equran_app/features/catatan_ayat/data/datasources/catatan_ayat_local_datasource.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late CatatanAyatLocalDatasourceImpl datasource;

  final tCatatan = CatatanAyat(
    suratNomor: 1,
    ayatNomor: 1,
    namaLatin: 'Al-Fatihah',
    teksArab: 'بِسْمِ اللّٰهِ',
    isi: 'Catatan test',
    savedAt: DateTime(2024),
  );

  setUp(() {
    mockBox = MockBox();
    datasource = CatatanAyatLocalDatasourceImpl(mockBox);
  });

  group('CatatanAyatLocalDatasource', () {
    group('getAll()', () {
      test('return list catatan dari Hive', () async {
        // getAll() sekarang iterasi keys dengan pattern 'suratNomor:ayatNomor'
        when(() => mockBox.keys).thenReturn(['1:1']);
        when(() => mockBox.get('1:1')).thenReturn(
          jsonEncode(tCatatan.toJson()),
        );

        final result = await datasource.getAll();

        expect(result.length, 1);
        expect(result.first.suratNomor, 1);
        expect(result.first.isi, 'Catatan test');
      });

      test('return list kosong jika box kosong', () async {
        when(() => mockBox.keys).thenReturn([]);

        final result = await datasource.getAll();

        expect(result, isEmpty);
      });

      test('skip entry corrupt dan return sisanya', () async {
        when(() => mockBox.keys).thenReturn(['1:1', '2:1']);
        when(() => mockBox.get('1:1')).thenReturn('invalid_json');
        when(() => mockBox.get('2:1')).thenReturn(
          jsonEncode(
            tCatatan.copyWith(suratNomor: 2, ayatNomor: 1).toJson(),
          ),
        );

        final result = await datasource.getAll();

        expect(result.length, 1);
      });
    });

    group('getByAyat()', () {
      test('return catatan jika key ada di Hive', () async {
        when(() => mockBox.get('1:1')).thenReturn(
          jsonEncode(tCatatan.toJson()),
        );

        final result = await datasource.getByAyat(
          suratNomor: 1,
          ayatNomor: 1,
        );

        expect(result, isNotNull);
        expect(result!.isi, 'Catatan test');
      });

      test('return null jika key tidak ada', () async {
        when(() => mockBox.get('1:1')).thenReturn(null);

        final result = await datasource.getByAyat(
          suratNomor: 1,
          ayatNomor: 1,
        );

        expect(result, isNull);
      });

      test('return null jika data corrupt', () async {
        when(() => mockBox.get('1:1')).thenReturn('invalid_json');

        final result = await datasource.getByAyat(
          suratNomor: 1,
          ayatNomor: 1,
        );

        expect(result, isNull);
      });
    });

    group('save()', () {
      test('simpan catatan ke Hive dengan key yang benar', () async {
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        await datasource.save(tCatatan);

        verify(
          () => mockBox.put('1:1', any<String>()),
        ).called(1);
      });
    });

    group('delete()', () {
      test('hapus catatan dari Hive dengan key yang benar', () async {
        when(
          () => mockBox.delete(any<String>()),
        ).thenAnswer((_) async {});

        await datasource.delete(suratNomor: 1, ayatNomor: 1);

        verify(() => mockBox.delete('1:1')).called(1);
      });
    });
  });
}
