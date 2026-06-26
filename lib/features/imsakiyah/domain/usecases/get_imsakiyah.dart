import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/params/imsakiyah_params.dart';
import 'package:fpdart/fpdart.dart';

class GetImsakiyah implements UseCase<Imsakiyah, GetImsakiyahParams> {
  const GetImsakiyah(this._repository);

  final ImsakiyahRepository _repository;

  @override
  Future<Either<Failure, Imsakiyah>> call(GetImsakiyahParams params) =>
      _repository.getImsakiyah(
        provinsi: params.provinsi,
        kabkota: params.kabkota,
      );
}
