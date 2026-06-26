import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProvinsiShalat implements UseCaseNoParams<List<String>> {
  const GetProvinsiShalat(this._repository);

  final JadwalShalatRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call() => _repository.getProvinsi();
}
