import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:fpdart/fpdart.dart';

class PauseAudio implements UseCaseNoParams<Unit> {
  const PauseAudio(this._repository);

  final AudioRepository _repository;

  @override
  Future<Either<Failure, Unit>> call() => _repository.pause();
}
