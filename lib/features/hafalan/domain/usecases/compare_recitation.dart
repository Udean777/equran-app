import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_compare_repository.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/compare_recitation_params.dart';
import 'package:fpdart/fpdart.dart';

class CompareRecitation
    implements UseCase<SetoranCompareResult, CompareRecitationParams> {
  const CompareRecitation(this._repository);

  final HafalanCompareRepository _repository;

  @override
  Future<Either<Failure, SetoranCompareResult>> call(
    CompareRecitationParams params,
  ) => _repository.compare(
    audioFilePath: params.audioFilePath,
    targetText: params.targetText,
    threshold: params.threshold,
  );
}
