import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuranStreakRepository extends Mock implements QuranStreakRepository {}

void main() {
  late MockQuranStreakRepository mockRepository;
  late GetStreakCount useCase;

  setUp(() {
    mockRepository = MockQuranStreakRepository();
    useCase = GetStreakCount(mockRepository);
  });

  test('returns streak count dari repository', () async {
    when(() => mockRepository.getStreakCount()).thenAnswer((_) async => 10);

    final result = await useCase();

    expect(result, 10);
    verify(() => mockRepository.getStreakCount()).called(1);
  });
}
