import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/shalat_location_repository.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/params/jadwal_shalat_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveLastLocationShalat
    implements UseCase<Unit, SaveLastLocationShalatParams> {
  const SaveLastLocationShalat(this._repository);

  final ShalatLocationRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(
    SaveLastLocationShalatParams params,
  ) async {
    final provinsiResult = await _repository.saveLastProvinsi(params.provinsi);
    return provinsiResult.fold(
      left,
      (_) => _repository.saveLastKabkota(params.kabkota),
    );
  }
}
