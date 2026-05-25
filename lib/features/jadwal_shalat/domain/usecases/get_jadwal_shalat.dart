import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetJadwalShalat {
  const GetJadwalShalat(this._repository);

  final JadwalShalatRepository _repository;

  Future<Either<Failure, JadwalShalat>> call({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
  }) => _repository.getJadwalShalat(
    provinsi: provinsi,
    kabkota: kabkota,
    bulan: bulan,
    tahun: tahun,
  );
}
