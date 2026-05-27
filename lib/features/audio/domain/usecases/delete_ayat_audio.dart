import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteAyatAudio {
  const DeleteAyatAudio(this._repository);

  final AudioDownloadRepository _repository;

  Future<Either<Failure, Unit>> call({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) =>
      _repository.deleteAyat(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
      );
}
