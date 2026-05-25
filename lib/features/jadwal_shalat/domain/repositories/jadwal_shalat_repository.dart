import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class JadwalShalatRepository {
  Future<Either<Failure, List<String>>> getProvinsi();
  Future<Either<Failure, List<String>>> getKabkota(String provinsi);
  Future<Either<Failure, JadwalShalat>> getJadwalShalat({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
  });
}
