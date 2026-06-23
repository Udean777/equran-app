import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ShalatLocationRepository {
  Future<Either<Failure, String?>> getLastProvinsi();
  Future<Either<Failure, Unit>> saveLastProvinsi(String provinsi);
  Future<Either<Failure, String?>> getLastKabkota();
  Future<Either<Failure, Unit>> saveLastKabkota(String kabkota);
}
