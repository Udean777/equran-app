import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/domain/repositories/surat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSuratList implements UseCaseNoParams<List<Surat>> {
  const GetSuratList(this._repository);

  final SuratRepository _repository;

  @override
  Future<Either<Failure, List<Surat>>> call() => _repository.getAllSurat();
}
