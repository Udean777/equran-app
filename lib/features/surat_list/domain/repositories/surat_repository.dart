import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SuratRepository {
  Future<Either<Failure, List<Surat>>> getAllSurat();
}
