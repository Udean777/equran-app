import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetShalatByDateRange {
  const GetShalatByDateRange(this._repository);
  final StatistikShalatRepository _repository;

  Either<Failure, List<ShalatDayStats>> call(List<String> dates) =>
      _repository.getByDateRange(dates);
}
