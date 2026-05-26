import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteAllAudio {
  const DeleteAllAudio(this._repository);

  final AudioRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.deleteAllAudio();
}
