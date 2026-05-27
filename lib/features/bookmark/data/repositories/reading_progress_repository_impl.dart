import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:equran_app/features/bookmark/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReadingProgressRepository)
class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  const ReadingProgressRepositoryImpl(this._local);

  final BookmarkLocalDataSource _local;

  @override
  Either<Failure, Map<int, double>> getAllSuratProgress() {
    try {
      return right(_local.getAllSuratProgress());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSuratProgress(
    int suratNomor,
    double maxProgress,
  ) async {
    try {
      await _local.saveSuratProgress(suratNomor, maxProgress);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
