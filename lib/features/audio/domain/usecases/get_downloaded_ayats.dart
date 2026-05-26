import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetDownloadedAyats {
  const GetDownloadedAyats(this._dataSource);

  final AudioDownloadDataSource _dataSource;

  Future<Either<Failure, List<DownloadedAyatInfo>>> call() async {
    try {
      final result = await _dataSource.getDownloadedAyats();
      return right(result);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
