import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAyatAudioParams extends Equatable {
  const DeleteAyatAudioParams({
    required this.suratNomor,
    required this.ayatNomor,
    required this.qari,
  });

  final int suratNomor;
  final int ayatNomor;
  final Qari qari;

  @override
  List<Object?> get props => [suratNomor, ayatNomor, qari];
}

class DeleteAyatAudio implements UseCase<Unit, DeleteAyatAudioParams> {
  const DeleteAyatAudio(this._repository);

  final AudioDownloadRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteAyatAudioParams params) =>
      _repository.deleteAyat(
        suratNomor: params.suratNomor,
        ayatNomor: params.ayatNomor,
        qari: params.qari,
      );
}
