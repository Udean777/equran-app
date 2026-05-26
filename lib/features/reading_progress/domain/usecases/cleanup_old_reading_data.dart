import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CleanupOldReadingData {
  const CleanupOldReadingData(this._repository);
  final ReadingProgressRepository _repository;

  Future<Either<Failure, Unit>> call({int retentionDays = 90}) =>
      _repository.cleanupOldData(retentionDays);
}
