import 'dart:convert';

import 'package:equran_app/features/hafalan/data/datasources/hafalan_local_datasource.dart';
import 'package:equran_app/features/hafalan/data/mappers/hafalan_mapper.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late HafalanLocalDatasourceImpl datasource;

  final tHafalan = HafalanSurat(
    suratNomor: 1,
    namaLatin: 'Al-Fatihah',
    nama: 'الْفَاتِحَةُ',
    jumlahAyat: 7,
    status: HafalanStatus.sedangDihafal,
    ayatHafal: const [1, 2, 3],
    tanggalMulai: DateTime(2024),
  );

  const tHafalan2 = HafalanSurat(
    suratNomor: 2,
    namaLatin: 'Al-Baqarah',
    nama: 'الْبَقَرَةُ',
    jumlahAyat: 286,
    ayatHafal: [1],
  );

  String encode(HafalanSurat h) => jsonEncode(h.toDto().toJson());

  setUp(() {
    mockBox = MockBox();
    datasource = HafalanLocalDatasourceImpl(mockBox);
  });

  group('HafalanLocalDatasource', () {
    group('getAll()', () {
      test('return list hafalan dari Hive, sorted by suratNomor', () {
        when(() => mockBox.values).thenReturn([
          encode(tHafalan2),
          encode(tHafalan),
        ]);

        final result = datasource.getAll();

        expect(result.length, 2);
        expect(result.first.suratNomor, 1);
        expect(result.last.suratNomor, 2);
      });

      test('return list kosong jika box kosong', () {
        when(() => mockBox.values).thenReturn([]);

        final result = datasource.getAll();

        expect(result, isEmpty);
      });

      test('skip entry corrupt dan return sisanya', () {
        when(() => mockBox.values).thenReturn([
          'invalid_json',
          encode(tHafalan),
        ]);

        final result = datasource.getAll();

        expect(result.length, 1);
        expect(result.first.suratNomor, 1);
      });
    });

    group('getBySurat()', () {
      test('return hafalan jika key ada', () {
        when(() => mockBox.get('surat_1')).thenReturn(encode(tHafalan));

        final result = datasource.getBySurat(1);

        expect(result, isNotNull);
        expect(result!.suratNomor, 1);
        expect(result.ayatHafal, [1, 2, 3]);
      });

      test('return null jika key tidak ada', () {
        when(() => mockBox.get('surat_99')).thenReturn(null);

        final result = datasource.getBySurat(99);

        expect(result, isNull);
      });

      test('return null jika JSON corrupt', () {
        when(() => mockBox.get('surat_1')).thenReturn('invalid_json');

        final result = datasource.getBySurat(1);

        expect(result, isNull);
      });
    });

    group('save()', () {
      test('simpan hafalan ke Hive dengan key yang benar', () async {
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        await datasource.save(tHafalan);

        verify(() => mockBox.put('surat_1', any<String>())).called(1);
      });
    });

    group('delete()', () {
      test('hapus hafalan dari Hive', () async {
        when(
          () => mockBox.delete(any<String>()),
        ).thenAnswer((_) async {});

        await datasource.delete(1);

        verify(() => mockBox.delete('surat_1')).called(1);
      });
    });
  });
}
