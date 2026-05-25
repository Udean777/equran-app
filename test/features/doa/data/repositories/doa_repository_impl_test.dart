import 'package:dio/dio.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/data/datasources/doa_local_data_source.dart';
import 'package:equran_app/features/doa/data/datasources/doa_remote_data_source.dart';
import 'package:equran_app/features/doa/data/repositories/doa_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockDoaRemoteDataSource extends Mock implements DoaRemoteDataSource {}

class MockDoaLocalDataSource extends Mock implements DoaLocalDataSource {}

void main() {
  late MockDoaRemoteDataSource mockRemote;
  late MockDoaLocalDataSource mockLocal;
  late DoaRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(tDoaDto1);
  });

  setUp(() {
    mockRemote = MockDoaRemoteDataSource();
    mockLocal = MockDoaLocalDataSource();
    repository = DoaRepositoryImpl(mockRemote, mockLocal);
  });

  // ── getDoaList ──────────────────────────────────────────────────────────────

  group('getDoaList()', () {
    test('return cached data jika cache tersedia', () async {
      when(
        () => mockLocal.getCachedDoaList(),
      ).thenAnswer((_) async => tDoaDtoList);

      final result = await repository.getDoaList();

      expect(result, isA<Right<Failure, dynamic>>());
      result.fold(
        (_) => fail('Expected Right'),
        (doaList) {
          expect(doaList.length, 2);
          expect(doaList.first.nama, 'Doa Sebelum Tidur 1');
        },
      );
      verifyNever(() => mockRemote.fetchDoaList());
    });

    test('fetch dari network jika cache kosong', () async {
      when(() => mockLocal.getCachedDoaList()).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchDoaList(),
      ).thenAnswer((_) async => tDoaListResponseDto);
      when(() => mockLocal.cacheDoaList(any())).thenAnswer((_) async {});

      final result = await repository.getDoaList();

      expect(result, isA<Right<Failure, dynamic>>());
      verify(() => mockRemote.fetchDoaList()).called(1);
      verify(() => mockLocal.cacheDoaList(any())).called(1);
    });

    test('return NetworkFailure saat DioException connectionError', () async {
      when(() => mockLocal.getCachedDoaList()).thenAnswer((_) async => null);
      when(() => mockRemote.fetchDoaList()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getDoaList();

      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('return ServerFailure saat DioException dengan status code', () async {
      when(() => mockLocal.getCachedDoaList()).thenAnswer((_) async => null);
      when(() => mockRemote.fetchDoaList()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
          ),
        ),
      );

      final result = await repository.getDoaList();

      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).statusCode, 500);
        },
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── getDoaDetail ────────────────────────────────────────────────────────────

  group('getDoaDetail()', () {
    test('return cached detail jika cache tersedia', () async {
      when(
        () => mockLocal.getCachedDoaDetail(1),
      ).thenAnswer((_) async => tDoaDto1);

      final result = await repository.getDoaDetail(1);

      expect(result, isA<Right<Failure, dynamic>>());
      result.fold(
        (_) => fail('Expected Right'),
        (doa) {
          expect(doa.id, 1);
          expect(doa.nama, 'Doa Sebelum Tidur 1');
        },
      );
      verifyNever(() => mockRemote.fetchDoaDetail(any()));
    });

    test('fetch dari network jika cache detail kosong', () async {
      when(() => mockLocal.getCachedDoaDetail(1))
          .thenAnswer((_) async => null);
      when(() => mockRemote.fetchDoaDetail(1))
          .thenAnswer((_) async => tDoaDetailResponseDto);
      when(() => mockLocal.cacheDoaDetail(1, any()))
          .thenAnswer((_) async {});

      final result = await repository.getDoaDetail(1);

      expect(result, isA<Right<Failure, dynamic>>());
      verify(() => mockRemote.fetchDoaDetail(1)).called(1);
      verify(() => mockLocal.cacheDoaDetail(1, any())).called(1);
    });

    test('return NetworkFailure saat network error pada getDoaDetail',
        () async {
      when(() => mockLocal.getCachedDoaDetail(1))
          .thenAnswer((_) async => null);
      when(() => mockRemote.fetchDoaDetail(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await repository.getDoaDetail(1);

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );

    test('handle edge case doa id 42 (tr dan idn kosong)', () async {
      when(
        () => mockLocal.getCachedDoaDetail(42),
      ).thenAnswer((_) async => tDoaDto42);

      final result = await repository.getDoaDetail(42);

      expect(result, isA<Right<Failure, dynamic>>());
      result.fold(
        (_) => fail('Expected Right'),
        (doa) {
          expect(doa.id, 42);
          expect(doa.tr, '');
          expect(doa.idn, '');
        },
      );
    });
  });
}
