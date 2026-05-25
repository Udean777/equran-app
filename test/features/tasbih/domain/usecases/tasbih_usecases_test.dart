import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tasbih/domain/repositories/tasbih_repository.dart';
import 'package:equran_app/features/tasbih/domain/usecases/clear_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/delete_tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/usecases/get_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/save_tasbih_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_tasbih_data.dart';

class MockTasbihRepository extends Mock implements TasbihRepository {}

void main() {
  late MockTasbihRepository mockRepo;

  setUp(() {
    mockRepo = MockTasbihRepository();
    registerFallbackValue(tSession);
  });

  group('SaveTasbihSession', () {
    test('memanggil repository.saveSession dengan params yang benar', () async {
      when(() => mockRepo.saveSession(any()))
          .thenAnswer((_) async => right(unit));

      final usecase = SaveTasbihSession(mockRepo);
      final result = await usecase(tSession);

      expect(result, right<Failure, Unit>(unit));
      verify(() => mockRepo.saveSession(tSession)).called(1);
    });

    test('mengembalikan Failure jika repository gagal', () async {
      when(() => mockRepo.saveSession(any())).thenAnswer(
        (_) async => left(const Failure.unknown(message: 'error')),
      );

      final usecase = SaveTasbihSession(mockRepo);
      final result = await usecase(tSession);

      expect(result.isLeft(), true);
    });
  });

  group('GetTasbihSessions', () {
    test('mengembalikan list sesi dari repository', () async {
      when(() => mockRepo.getSessions())
          .thenAnswer((_) async => right([tSession, tSession2]));

      final usecase = GetTasbihSessions(mockRepo);
      final result = await usecase();

      result.fold(
        (l) => fail('Expected right but got left: $l'),
        (sessions) => expect(sessions, [tSession, tSession2]),
      );
      verify(() => mockRepo.getSessions()).called(1);
    });

    test('mengembalikan list kosong jika belum ada sesi', () async {
      when(() => mockRepo.getSessions())
          .thenAnswer((_) async => right([]));

      final usecase = GetTasbihSessions(mockRepo);
      final result = await usecase();

      result.fold(
        (l) => fail('Expected right but got left: $l'),
        (sessions) => expect(sessions, isEmpty),
      );
    });
  });

  group('DeleteTasbihSession', () {
    test('memanggil repository.deleteSession dengan id yang benar', () async {
      when(() => mockRepo.deleteSession(any()))
          .thenAnswer((_) async => right(unit));

      final usecase = DeleteTasbihSession(mockRepo);
      final result = await usecase(tSession.id);

      expect(result, right<Failure, Unit>(unit));
      verify(() => mockRepo.deleteSession(tSession.id)).called(1);
    });
  });

  group('ClearTasbihSessions', () {
    test('memanggil repository.clearSessions', () async {
      when(() => mockRepo.clearSessions())
          .thenAnswer((_) async => right(unit));

      final usecase = ClearTasbihSessions(mockRepo);
      final result = await usecase();

      expect(result, right<Failure, Unit>(unit));
      verify(() => mockRepo.clearSessions()).called(1);
    });
  });
}
