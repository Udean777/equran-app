import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetShalatStats {
  const GetShalatStats(this._repository);
  final StatistikShalatRepository _repository;

  Either<Failure, ShalatStats> call({
    required List<String> dates,
    required String today,
  }) =>
      _repository.getStats(dates: dates, today: today);
}
