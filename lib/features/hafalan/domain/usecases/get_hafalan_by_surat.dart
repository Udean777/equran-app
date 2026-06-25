import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/hafalan_params.dart';
import 'package:fpdart/fpdart.dart';

class GetHafalanBySurat implements UseCase<HafalanSurat?, HafalanSuratParams> {
  const GetHafalanBySurat(this._repository);

  final HafalanRepository _repository;

  @override
  Future<Either<Failure, HafalanSurat?>> call(HafalanSuratParams params) =>
      _repository.getHafalanBySurat(params.suratNomor);
}
