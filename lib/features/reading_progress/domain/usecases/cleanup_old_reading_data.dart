import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CleanupOldReadingData implements UseCase<Unit, int> {
  const CleanupOldReadingData(this._repository);
  final ReadingProgressRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int retentionDays) =>
      _repository.cleanupOldData(retentionDays);
}
