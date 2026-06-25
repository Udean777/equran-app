import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllSuratProgress implements UseCaseNoParams<Map<int, double>> {
  const GetAllSuratProgress(this._repository);

  final ReadingProgressRepository _repository;

  @override
  Future<Either<Failure, Map<int, double>>> call() =>
      _repository.getAllSuratProgress();
}
