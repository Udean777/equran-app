import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/params/save_ayat_read_batch_params.dart';
import 'package:fpdart/fpdart.dart';

class SaveAyatReadBatch implements UseCase<Unit, SaveAyatReadBatchParams> {
  const SaveAyatReadBatch(this._repository);
  final ReadingProgressRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveAyatReadBatchParams params) =>
      _repository.saveAyatBatch(params.date, params.ayatIds);
}
