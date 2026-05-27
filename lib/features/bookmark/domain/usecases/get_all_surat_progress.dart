import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllSuratProgress {
  const GetAllSuratProgress(this._repository);

  final ReadingProgressRepository _repository;

  Either<Failure, Map<int, double>> call() => _repository.getAllSuratProgress();
}
