import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllHafalan {
  const GetAllHafalan(this._repository);

  final HafalanRepository _repository;

  Either<Failure, List<HafalanSurat>> call() => _repository.getAllHafalan();
}
