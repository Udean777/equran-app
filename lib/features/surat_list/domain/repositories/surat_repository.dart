import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SuratRepository {
  Future<Either<Failure, List<Surat>>> getAllSurat();
}
