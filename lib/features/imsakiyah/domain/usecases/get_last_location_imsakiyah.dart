import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_location_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLastLocationImsakiyah
    implements UseCaseNoParams<({String? provinsi, String? kabkota})> {
  const GetLastLocationImsakiyah(this._repository);

  final ImsakiyahLocationRepository _repository;

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
