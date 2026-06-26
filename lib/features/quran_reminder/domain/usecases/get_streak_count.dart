import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetStreakCount implements UseCaseNoParams<int> {
  const GetStreakCount(this._repository);

  final QuranStreakRepository _repository;

  @override
  Future<Either<Failure, int>> call() => _repository.getStreakCount();
}
