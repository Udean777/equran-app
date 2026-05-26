import 'package:equran_app/core/constants/juz_mapping.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/data/datasources/hafalan_local_datasource.dart';
import 'package:equran_app/features/hafalan/data/repositories/hafalan_repository_impl.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockHafalanLocalDatasource extends Mock
    implements HafalanLocalDatasource {}

void main() {
  late MockHafalanLocalDatasource mockDatasource;
  late HafalanRepositoryImpl repository;

  final tHafalanSelesai = HafalanSurat(
    suratNomor: 1,
    namaLatin: 'Al-Fatihah',
    nama: 'الْفَاتِحَةُ',
    jumlahAyat: 7,
    status: HafalanStatus.sudahHafal,
    ayatHafal: const [1, 2, 3, 4, 5, 6, 7],
    tanggalMurajaahBerikutnya: DateTime(2099), // masa depan
  );

  final tHafalanJatuhTempo = tHafalanSelesai.copyWith(
    tanggalMurajaahBerikutnya: DateTime(2020), // sudah lewat
  );

  setUp(() {
    mockDatasource = MockHafalanLocalDatasource();
    repository = HafalanRepositoryImpl(mockDatasource);
    registerFallbackValue(tHafalanSelesai);
  });

  group('HafalanRepositoryImpl', () {
    group('getAllHafalan()', () {
      test('return list hafalan dari datasource', () async {
        when(
          () => mockDatasource.getAll(),
        ).thenAnswer((_) async => [tHafalanSelesai]);

        final result = await repository.getAllHafalan();

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should be right'),
          (list) => expect(list.length, 1),
        );
      });

      test('resolve status perluMurajaah jika jatuh tempo', () async {
        when(
          () => mockDatasource.getAll(),
        ).thenAnswer((_) async => [tHafalanJatuhTempo]);

        final result = await repository.getAllHafalan();

        result.fold(
          (_) => fail('should be right'),
          (list) => expect(list.first.status, HafalanStatus.perluMurajaah),
        );
      });

      test('return failure jika datasource throw', () async {
        when(
          () => mockDatasource.getAll(),
        ).thenThrow(Exception('error'));

        final result = await repository.getAllHafalan();

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<UnknownFailure>()),
          (_) => fail('should be left'),
        );
      });
    });

    group('getHafalanBySurat()', () {
      test('return hafalan jika ada', () async {
        when(
          () => mockDatasource.getBySurat(1),
        ).thenAnswer((_) async => tHafalanSelesai);

        final result = await repository.getHafalanBySurat(1);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should be right'),
          (h) => expect(h?.suratNomor, 1),
        );
      });

      test('return Right(null) jika tidak ada', () async {
        when(
          () => mockDatasource.getBySurat(99),
        ).thenAnswer((_) async => null);

        final result = await repository.getHafalanBySurat(99);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should be right'),
          (h) => expect(h, isNull),
        );
      });
    });

    group('saveHafalanSurat()', () {
      test('return Right(unit) setelah save berhasil', () async {
        when(
          () => mockDatasource.save(any()),
        ).thenAnswer((_) async {});

        final result = await repository.saveHafalanSurat(tHafalanSelesai);

        expect(result, const Right<Failure, Unit>(unit));
      });
    });

    group('deleteHafalanSurat()', () {
      test('return Right(unit) setelah delete berhasil', () async {
        when(
          () => mockDatasource.delete(any()),
        ).thenAnswer((_) async {});

        final result = await repository.deleteHafalanSurat(1);

        expect(result, const Right<Failure, Unit>(unit));
      });
    });

    group('getHafalanStats()', () {
      test('hitung stats dengan benar dari list hafalan', () async {
        when(
          () => mockDatasource.getAll(),
        ).thenAnswer((_) async => [tHafalanSelesai]);

        final result = await repository.getHafalanStats();

        result.fold(
          (_) => fail('should be right'),
          (stats) {
            expect(stats.totalAyatHafal, 7);
            expect(stats.totalSuratSelesai, 1);
            expect(stats.persentaseQuran, greaterThan(0));
            expect(stats.suratSedangDihafal, 0);
            expect(stats.suratPerluMurajaah, 0);
          },
        );
      });

      test('hitung progressPerJuz dengan benar', () async {
        when(
          () => mockDatasource.getAll(),
        ).thenAnswer((_) async => [tHafalanSelesai]);

        final result = await repository.getHafalanStats();

        result.fold(
          (_) => fail('should be right'),
          (stats) {
            final juz = kJuzMapping[1]!;
            expect(stats.progressPerJuz[juz], greaterThan(0));
          },
        );
      });

      test('return stats kosong jika tidak ada hafalan', () async {
        when(
          () => mockDatasource.getAll(),
        ).thenAnswer((_) async => []);

        final result = await repository.getHafalanStats();

        result.fold(
          (_) => fail('should be right'),
          (stats) {
            expect(stats.totalAyatHafal, 0);
            expect(stats.persentaseQuran, 0);
          },
        );
      });
    });
  });
}
