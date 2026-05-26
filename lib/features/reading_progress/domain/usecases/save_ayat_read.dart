import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveAyatRead {
  const SaveAyatRead(this._repository);
  final ReadingProgressRepository _repository;

  Future<Either<Failure, Unit>> call(String date, String ayatId) =>
      _repository.saveAyat(date, ayatId);
}

@lazySingleton
class SaveAyatReadBatch {
  const SaveAyatReadBatch(this._repository);
  final ReadingProgressRepository _repository;

  Future<Either<Failure, Unit>> call(String date, Set<String> ayatIds) =>
      _repository.saveAyatBatch(date, ayatIds);
}
