import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveSuratProgressParams extends Equatable {
  const SaveSuratProgressParams({
    required this.suratNomor,
    required this.maxProgress,
  });

  final int suratNomor;
  final double maxProgress;

  @override
  List<Object?> get props => [suratNomor, maxProgress];
}

class SaveSuratProgress implements UseCase<Unit, SaveSuratProgressParams> {
  const SaveSuratProgress(this._repository);

  final ReadingProgressRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveSuratProgressParams params) =>
      _repository.saveSuratProgress(params.suratNomor, params.maxProgress);
}
