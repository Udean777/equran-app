import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_compare_repository.dart';
import 'package:equran_app/features/hafalan/domain/usecases/compare_recitation.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/compare_recitation_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockHafalanCompareRepository extends Mock
    implements HafalanCompareRepository {}

void main() {
  late CompareRecitation usecase;
  late MockHafalanCompareRepository mockRepository;

  setUp(() {
    mockRepository = MockHafalanCompareRepository();
    usecase = CompareRecitation(mockRepository);
  });

  group('CompareRecitation', () {
    const tAudioPath = '/path/to/audio.m4a';
    const tTargetText = 'bismillahirrahmanirrahim';

    const tParams = CompareRecitationParams(
      audioFilePath: tAudioPath,
      targetText: tTargetText,
    );

    const tCompareResult = SetoranCompareResult(
      score: 85.5,
      passed: true,
      threshold: 75,
      transcribed: 'bismillahirrahmanirrahim',
      target: 'bismillahirrahmanirrahim',
      cer: 0,
      durationMs: 1500,
    );

    test('should return SetoranCompareResult from repository', () async {
      // arrange
      when(
        () => mockRepository.compare(
          audioFilePath: any(named: 'audioFilePath'),
          targetText: any(named: 'targetText'),
          threshold: any(named: 'threshold'),
        ),
      ).thenAnswer((_) async => const Right(tCompareResult));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (compareResult) {
          expect(compareResult, tCompareResult);
          expect(compareResult.score, 85.5);
          expect(compareResult.passed, true);
        },
      );
      verify(
        () => mockRepository.compare(
          audioFilePath: tAudioPath,
          targetText: tTargetText,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository call fails', () async {
      // arrange
      const tFailure = Failure.network();
      when(
        () => mockRepository.compare(
          audioFilePath: any(named: 'audioFilePath'),
          targetText: any(named: 'targetText'),
          threshold: any(named: 'threshold'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, tFailure),
        (_) => fail('Should return failure'),
      );
    });

    test('should use default threshold when not provided', () async {
      // arrange
      const tParamsWithoutThreshold = CompareRecitationParams(
        audioFilePath: tAudioPath,
        targetText: tTargetText,
      );

      when(
        () => mockRepository.compare(
          audioFilePath: any(named: 'audioFilePath'),
          targetText: any(named: 'targetText'),
          threshold: any(named: 'threshold'),
        ),
      ).thenAnswer((_) async => const Right(tCompareResult));

      // act
      await usecase(tParamsWithoutThreshold);

      // assert
      verify(
        () => mockRepository.compare(
          audioFilePath: tAudioPath,
          targetText: tTargetText,
        ),
      ).called(1);
    });
  });
}
