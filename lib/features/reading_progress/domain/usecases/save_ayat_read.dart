import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/params/save_ayat_read_params.dart';
import 'package:fpdart/fpdart.dart';

class SaveAyatRead implements UseCase<Unit, SaveAyatReadParams> {
  const SaveAyatRead(this._repository);
  final ReadingProgressRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveAyatReadParams params) =>
      _repository.saveAyat(params.date, params.ayatId);
}
