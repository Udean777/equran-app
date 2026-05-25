import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SeekAudio implements UseCase<Unit, Duration> {
  const SeekAudio(this._repository);

  final AudioRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Duration params) =>
      _repository.seek(params);
}
