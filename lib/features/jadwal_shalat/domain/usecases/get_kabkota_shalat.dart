import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetKabkotaShalat {
  const GetKabkotaShalat(this._repository);

  final JadwalShalatRepository _repository;

  Future<Either<Failure, List<String>>> call(String provinsi) =>
      _repository.getKabkota(provinsi);
}
