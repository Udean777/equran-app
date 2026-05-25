import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveLastLocationShalat {
  const SaveLastLocationShalat(this._repository);

  final JadwalShalatRepository _repository;

  Future<Either<Failure, Unit>> call({
    required String provinsi,
    required String kabkota,
  }) async {
    final provinsiResult = await _repository.saveLastProvinsi(provinsi);
    return provinsiResult.fold(
      left,
      (_) => _repository.saveLastKabkota(kabkota),
    );
  }
}
