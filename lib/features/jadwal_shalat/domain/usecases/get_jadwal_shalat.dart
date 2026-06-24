import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/params/jadwal_shalat_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetJadwalShalat implements UseCase<JadwalShalat, GetJadwalShalatParams> {
  const GetJadwalShalat(this._repository);

  final JadwalShalatRepository _repository;

  @override
  Future<Either<Failure, JadwalShalat>> call(GetJadwalShalatParams params) =>
      _repository.getJadwalShalat(
        provinsi: params.provinsi,
        kabkota: params.kabkota,
        bulan: params.bulan,
        tahun: params.tahun,
      );
}
