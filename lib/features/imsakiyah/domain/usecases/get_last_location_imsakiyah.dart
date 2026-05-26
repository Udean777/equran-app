import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetLastLocationImsakiyah {
  const GetLastLocationImsakiyah(this._repository);

  final ImsakiyahRepository _repository;

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
