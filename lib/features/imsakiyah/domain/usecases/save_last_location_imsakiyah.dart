import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_location_repository.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/params/imsakiyah_params.dart';
import 'package:fpdart/fpdart.dart';

class SaveLastLocationImsakiyah
    implements UseCase<Unit, SaveLastLocationParams> {
  const SaveLastLocationImsakiyah(this._repository);

  final ImsakiyahLocationRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveLastLocationParams params) async {
    final provinsiResult = await _repository.saveLastProvinsi(params.provinsi);
    return provinsiResult.fold(
      left,
      (_) => _repository.saveLastKabkota(params.kabkota),
    );
  }
}
