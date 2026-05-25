import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SuratDetailRepository {
  Future<Either<Failure, SuratDetail>> getSuratDetail(int nomor);
}
