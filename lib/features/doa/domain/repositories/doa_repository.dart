import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DoaRepository {
  Future<Either<Failure, List<Doa>>> getDoaList();
  Future<Either<Failure, Doa>> getDoaDetail(int id);
}
