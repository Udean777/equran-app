import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveSuratProgress {
  const SaveSuratProgress(this._repository);

  final ReadingProgressRepository _repository;

  Future<Either<Failure, Unit>> call(int suratNomor, double maxProgress) =>
      _repository.saveSuratProgress(suratNomor, maxProgress);
}
