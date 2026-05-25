import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/repositories/doa_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDoaDetail implements UseCase<Doa, int> {
  const GetDoaDetail(this._repository);

  final DoaRepository _repository;

  @override
  Future<Either<Failure, Doa>> call(int params) =>
      _repository.getDoaDetail(params);
}
