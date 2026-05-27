import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DownloadAyatAudio {
  const DownloadAyatAudio(this._repository);

  final AudioDownloadRepository _repository;

  /// Download audio ayat. Emit progress 0.0–1.0.
  /// Return [Left] jika gagal.
  Stream<Either<Failure, double>> call({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    required String url,
  }) =>
      _repository.downloadAyat(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
        url: url,
      );
}
