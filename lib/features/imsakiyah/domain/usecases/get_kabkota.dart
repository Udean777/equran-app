import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetKabkota {
  const GetKabkota(this._repository);

  final ImsakiyahRepository _repository;

  Future<Either<Failure, List<String>>> call(String provinsi) =>
      _repository.getKabkota(provinsi);
}
