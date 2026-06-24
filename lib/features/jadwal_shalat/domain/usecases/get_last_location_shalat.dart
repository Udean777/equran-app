import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/shalat_location_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetLastLocationShalat
    implements UseCaseNoParams<({String? provinsi, String? kabkota})> {
  const GetLastLocationShalat(this._repository);

  final ShalatLocationRepository _repository;

  @override
  Future<Either<Failure, ({String? provinsi, String? kabkota})>> call() async {
    final provinsiResult = await _repository.getLastProvinsi();
    final kabkotaResult = await _repository.getLastKabkota();

    return provinsiResult.fold(
      left,
      (provinsi) => kabkotaResult.fold(
        left,
        (kabkota) => right((provinsi: provinsi, kabkota: kabkota)),
      ),
    );
  }
}
