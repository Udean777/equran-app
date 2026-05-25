import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';
import 'package:equran_app/features/tafsir/domain/repositories/tafsir_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

class TafsirParams extends Equatable {
  const TafsirParams({required this.nomor});

  final int nomor;

  @override
  List<Object> get props => [nomor];
}

@injectable
class GetTafsir implements UseCase<TafsirSurat, TafsirParams> {
  const GetTafsir(this._repository);

  final TafsirRepository _repository;

  @override
  Future<Either<Failure, TafsirSurat>> call(TafsirParams params) =>
      _repository.getTafsir(params.nomor);
}
