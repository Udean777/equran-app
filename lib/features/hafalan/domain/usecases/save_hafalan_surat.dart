import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveHafalanSurat {
  const SaveHafalanSurat(this._repository);

  final HafalanRepository _repository;

  Future<Either<Failure, Unit>> call(HafalanSurat hafalan) =>
      _repository.saveHafalanSurat(hafalan);
}
