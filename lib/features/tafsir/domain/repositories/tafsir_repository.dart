import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TafsirRepository {
  Future<Either<Failure, TafsirSurat>> getTafsir(int nomor);
}
