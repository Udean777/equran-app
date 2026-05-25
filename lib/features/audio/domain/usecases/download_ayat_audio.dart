import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DownloadAyatAudio {
  const DownloadAyatAudio(this._dataSource);

  final AudioDownloadDataSource _dataSource;

  /// Download audio ayat. Emit progress 0.0–1.0.
  /// Return [Left] jika gagal.
  Stream<Either<Failure, double>> call({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    required String url,
  }) async* {
    try {
      await for (final progress in _dataSource.downloadAyat(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
        url: url,
      )) {
        yield right(progress);
      }
    } on Object catch (e) {
      yield left(Failure.unknown(message: e.toString()));
    }
  }
}
