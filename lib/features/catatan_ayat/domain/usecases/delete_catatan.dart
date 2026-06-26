import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteCatatanParams extends Equatable {
  const DeleteCatatanParams({
    required this.suratNomor,
    required this.ayatNomor,
  });

  final int suratNomor;
  final int ayatNomor;

  @override
  List<Object?> get props => [suratNomor, ayatNomor];
}

class DeleteCatatan implements UseCase<Unit, DeleteCatatanParams> {
  const DeleteCatatan(this._repository);

  final CatatanAyatRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteCatatanParams params) => _repository
      .delete(suratNomor: params.suratNomor, ayatNomor: params.ayatNomor);
}
