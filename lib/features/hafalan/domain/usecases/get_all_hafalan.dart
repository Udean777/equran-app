import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllHafalan implements UseCaseNoParams<List<HafalanSurat>> {
  const GetAllHafalan(this._repository);

  final HafalanRepository _repository;

  @override
  Future<Either<Failure, List<HafalanSurat>>> call() =>
      _repository.getAllHafalan();
}
