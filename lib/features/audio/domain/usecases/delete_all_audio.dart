import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteAllAudio implements UseCaseNoParams<Unit> {
  const DeleteAllAudio(this._repository);

  final AudioDownloadRepository _repository;

  @override
  Future<Either<Failure, Unit>> call() => _repository.deleteAll();
}
