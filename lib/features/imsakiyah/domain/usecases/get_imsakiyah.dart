import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetImsakiyah {
  const GetImsakiyah(this._repository);

  final ImsakiyahRepository _repository;

  Future<Either<Failure, Imsakiyah>> call({
    required String provinsi,
    required String kabkota,
  }) => _repository.getImsakiyah(provinsi: provinsi, kabkota: kabkota);
}
