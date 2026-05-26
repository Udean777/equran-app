import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetReadingStats {
  const GetReadingStats(this._repository);
  final ReadingProgressRepository _repository;

  Either<Failure, ReadingStats> call({required String today}) =>
      _repository.getStats(today: today);
}
