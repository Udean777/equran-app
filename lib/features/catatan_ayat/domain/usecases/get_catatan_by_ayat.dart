import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCatatanByAyatParams extends Equatable {
  const GetCatatanByAyatParams({
    required this.suratNomor,
    required this.ayatNomor,
  });

  final int suratNomor;
  final int ayatNomor;

  @override
  List<Object?> get props => [suratNomor, ayatNomor];
}

class GetCatatanByAyat
    implements UseCase<CatatanAyat?, GetCatatanByAyatParams> {
  const GetCatatanByAyat(this._repository);

  final CatatanAyatRepository _repository;

  @override
  Future<Either<Failure, CatatanAyat?>> call(GetCatatanByAyatParams params) =>
      _repository.getByAyat(
        suratNomor: params.suratNomor,
        ayatNomor: params.ayatNomor,
      );
}
