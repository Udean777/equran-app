import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteAyatAudio {
  const DeleteAyatAudio(this._dataSource);

  final AudioDownloadDataSource _dataSource;

  Future<Either<Failure, Unit>> call({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  }) async {
    try {
      await _dataSource.deleteAyat(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
        qari: qari,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
