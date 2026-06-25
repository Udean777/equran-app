import 'package:dio/dio.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/data/datasources/hafalan_compare_datasource.dart';
import 'package:equran_app/features/hafalan/data/repositories/hafalan_compare_repository_impl.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHafalanCompareDataSource extends Mock
    implements HafalanCompareDataSource {}

void main() {
  late HafalanCompareRepositoryImpl repository;
  late MockHafalanCompareDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockHafalanCompareDataSource();
    repository = HafalanCompareRepositoryImpl(mockDataSource);
  });

  group('HafalanCompareRepository', () {
    const tAudioPath = '/path/to/audio.m4a';
    const tTargetText = 'bismillahirrahmanirrahim';

    const tCompareResult = SetoranCompareResult(
      score: 85.5,
      passed: true,
      threshold: 75,
      transcribed: 'bismillahirrahmanirrahim',
      target: 'bismillahirrahmanirrahim',
      cer: 0,
      durationMs: 1500,
    );

    test(
      'should return SetoranCompareResult when datasource call is successful',
      () async {
        // arrange
        when(
          () => mockDataSource.compare(
            audioFilePath: any(named: 'audioFilePath'),
            targetText: any(named: 'targetText'),
            threshold: any(named: 'threshold'),
          ),
        ).thenAnswer((_) async => tCompareResult);

        // act
        final result = await repository.compare(
          audioFilePath: tAudioPath,
          targetText: tTargetText,
        );

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (compareResult) {
            expect(compareResult.score, 85.5);
            expect(compareResult.passed, true);
            expect(compareResult.transcribed, 'bismillahirrahmanirrahim');
          },
        );
        verify(
          () => mockDataSource.compare(
            audioFilePath: tAudioPath,
            targetText: tTargetText,
          ),
        ).called(1);
      },
    );

    test(
      'should return Failure.network when DioException with connection error occurs',
      () async {
        // arrange
        when(
          () => mockDataSource.compare(
            audioFilePath: any(named: 'audioFilePath'),
            targetText: any(named: 'targetText'),
            threshold: any(named: 'threshold'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionError,
          ),
        );

        // act
        final result = await repository.compare(
          audioFilePath: tAudioPath,
          targetText: tTargetText,
        );

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should return Failure.server when DioException with response error occurs',
      () async {
        // arrange
        when(
          () => mockDataSource.compare(
            audioFilePath: any(named: 'audioFilePath'),
            targetText: any(named: 'targetText'),
            threshold: any(named: 'threshold'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        // act
        final result = await repository.compare(
          audioFilePath: tAudioPath,
          targetText: tTargetText,
        );

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect((failure as ServerFailure).statusCode, 500);
          },
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should return Failure.unknown when generic exception occurs',
      () async {
        // arrange
        when(
          () => mockDataSource.compare(
            audioFilePath: any(named: 'audioFilePath'),
            targetText: any(named: 'targetText'),
            threshold: any(named: 'threshold'),
          ),
        ).thenThrow(Exception('Something went wrong'));

        // act
        final result = await repository.compare(
          audioFilePath: tAudioPath,
          targetText: tTargetText,
        );

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(
              (failure as UnknownFailure).message,
              contains('Something went wrong'),
            );
          },
          (_) => fail('Should return failure'),
        );
      },
    );
  });
}
