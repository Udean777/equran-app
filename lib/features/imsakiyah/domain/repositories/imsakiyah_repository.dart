import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ImsakiyahRepository {
  Future<Either<Failure, List<String>>> getProvinsi();
  Future<Either<Failure, List<String>>> getKabkota(String provinsi);
  Future<Either<Failure, Imsakiyah>> getImsakiyah({
    required String provinsi,
    required String kabkota,
  });

  Future<Either<Failure, String?>> getLastProvinsi();
  Future<Either<Failure, Unit>> saveLastProvinsi(String provinsi);
  Future<Either<Failure, String?>> getLastKabkota();
  Future<Either<Failure, Unit>> saveLastKabkota(String kabkota);
}
