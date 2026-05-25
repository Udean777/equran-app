import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetProvinsiShalat {
  const GetProvinsiShalat(this._repository);

  final JadwalShalatRepository _repository;

  Future<Either<Failure, List<String>>> call() => _repository.getProvinsi();
}
