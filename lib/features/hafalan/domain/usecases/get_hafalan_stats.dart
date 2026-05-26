import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHafalanStats {
  const GetHafalanStats(this._repository);

  final HafalanRepository _repository;

  Either<Failure, HafalanStats> call() => _repository.getHafalanStats();
}
