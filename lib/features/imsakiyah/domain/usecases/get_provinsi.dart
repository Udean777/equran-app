import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetProvinsi {
  const GetProvinsi(this._repository);

  final ImsakiyahRepository _repository;

  Future<Either<Failure, List<String>>> call() => _repository.getProvinsi();
}
