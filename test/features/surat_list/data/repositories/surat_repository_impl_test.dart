import 'package:dio/dio.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_list/data/datasources/surat_local_data_source.dart';
import 'package:equran_app/features/surat_list/data/datasources/surat_remote_data_source.dart';
import 'package:equran_app/features/surat_list/data/repositories/surat_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockSuratRemoteDataSource extends Mock implements SuratRemoteDataSource {}

class MockSuratLocalDataSource extends Mock implements SuratLocalDataSource {}

void main() {
  late MockSuratRemoteDataSource mockRemote;
  late MockSuratLocalDataSource mockLocal;
  late SuratRepositoryImpl repository;

  setUp(() {
    mockRemote = MockSuratRemoteDataSource();
    mockLocal = MockSuratLocalDataSource();
    repository = SuratRepositoryImpl(mockRemote, mockLocal);
  });

  group('getAllSurat()', () {
    test('return cached data jika cache tersedia', () async {
      when(
        () => mockLocal.getCachedSuratList(),
      ).thenAnswer((_) async => tSuratDtoList);

      final result = await repository.getAllSurat();

      expect(result, isA<Right<Failure, dynamic>>());
      result.fold(
        (_) => fail('Expected Right'),
        (surats) {
          expect(surats.length, 2);
          expect(surats.first.namaLatin, 'Al-Fatihah');
        },
      );
      verifyNever(() => mockRemote.fetchSuratList());
    });

    test('fetch dari network jika cache kosong', () async {
      when(() => mockLocal.getCachedSuratList()).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchSuratList(),
      ).thenAnswer((_) async => tSuratListResponseDto);
      when(() => mockLocal.cacheSuratList(any())).thenAnswer((_) async {});

      final result = await repository.getAllSurat();

      expect(result, isA<Right<Failure, dynamic>>());
      verify(() => mockRemote.fetchSuratList()).called(1);
      verify(() => mockLocal.cacheSuratList(any())).called(1);
    });

    test('return NetworkFailure saat DioException connectionError', () async {
      when(() => mockLocal.getCachedSuratList()).thenAnswer((_) async => null);
      when(() => mockRemote.fetchSuratList()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getAllSurat();

      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('return ServerFailure saat DioException dengan status code', () async {
      when(() => mockLocal.getCachedSuratList()).thenAnswer((_) async => null);
      when(() => mockRemote.fetchSuratList()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
          ),
        ),
      );

      final result = await repository.getAllSurat();

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
}
