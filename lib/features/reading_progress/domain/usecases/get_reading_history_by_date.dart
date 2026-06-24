import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/params/get_reading_history_by_date_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetReadingHistoryByDate
    implements UseCase<ReadingHistory?, GetReadingHistoryByDateParams> {
  const GetReadingHistoryByDate(this._repository);
  final ReadingProgressRepository _repository;

  @override
  Future<Either<Failure, ReadingHistory?>> call(
    GetReadingHistoryByDateParams params,
  ) async => _repository.getByDate(params.date);
}
