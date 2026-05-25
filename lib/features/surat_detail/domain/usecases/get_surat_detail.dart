import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/domain/repositories/surat_detail_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

class SuratDetailParams extends Equatable {
  const SuratDetailParams({required this.nomor});

  final int nomor;

  @override
  List<Object> get props => [nomor];
}

@injectable
class GetSuratDetail implements UseCase<SuratDetail, SuratDetailParams> {
  const GetSuratDetail(this._repository);

  final SuratDetailRepository _repository;

  @override
  Future<Either<Failure, SuratDetail>> call(SuratDetailParams params) =>
      _repository.getSuratDetail(params.nomor);
}
