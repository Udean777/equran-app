import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/params/imsakiyah_params.dart';
import 'package:fpdart/fpdart.dart';

class GetKabkota implements UseCase<List<String>, GetKabkotaParams> {
  const GetKabkota(this._repository);

  final ImsakiyahRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call(GetKabkotaParams params) =>
      _repository.getKabkota(params.provinsi);
}
