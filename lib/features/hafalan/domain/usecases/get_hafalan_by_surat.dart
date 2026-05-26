import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHafalanBySurat {
  const GetHafalanBySurat(this._repository);

  final HafalanRepository _repository;

  Either<Failure, HafalanSurat?> call(int suratNomor) =>
      _repository.getHafalanBySurat(suratNomor);
}
