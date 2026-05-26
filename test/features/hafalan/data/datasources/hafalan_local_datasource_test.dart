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
      test('return list hafalan dari Hive, sorted by suratNomor', () async {
        // getAll() iterasi key surat_1 s/d surat_114
        // Stub: surat_1 dan surat_2 ada, sisanya null
        for (var i = 1; i <= 114; i++) {
          if (i == 1) {
            when(() => mockBox.get('surat_1')).thenReturn(encode(tHafalan));
          } else if (i == 2) {
            when(() => mockBox.get('surat_2')).thenReturn(encode(tHafalan2));
          } else {
            when(() => mockBox.get('surat_$i')).thenReturn(null);
          }
        }

        final result = await datasource.getAll();

        expect(result.length, 2);
        expect(result.first.suratNomor, 1);
        expect(result.last.suratNomor, 2);
      });

      test('return list kosong jika box kosong', () async {
        for (var i = 1; i <= 114; i++) {
          when(() => mockBox.get('surat_$i')).thenReturn(null);
        }

        final result = await datasource.getAll();

        expect(result, isEmpty);
      });

      test('skip entry corrupt dan return sisanya', () async {
        when(() => mockBox.get('surat_1')).thenReturn('invalid_json');
        when(() => mockBox.get('surat_2')).thenReturn(encode(tHafalan2));
        for (var i = 3; i <= 114; i++) {
          when(() => mockBox.get('surat_$i')).thenReturn(null);
        }

        final result = await datasource.getAll();

        expect(result.length, 1);
        expect(result.first.suratNomor, 2);
      });
    });

    group('getBySurat()', () {
      test('return hafalan jika key ada', () async {
        when(() => mockBox.get('surat_1')).thenReturn(encode(tHafalan));

        final result = await datasource.getBySurat(1);

        expect(result, isNotNull);
        expect(result!.suratNomor, 1);
        expect(result.ayatHafal, [1, 2, 3]);
      });

      test('return null jika key tidak ada', () async {
        when(() => mockBox.get('surat_99')).thenReturn(null);

        final result = await datasource.getBySurat(99);

        expect(result, isNull);
      });

      test('return null jika JSON corrupt', () async {
        when(() => mockBox.get('surat_1')).thenReturn('invalid_json');

        final result = await datasource.getBySurat(1);

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
