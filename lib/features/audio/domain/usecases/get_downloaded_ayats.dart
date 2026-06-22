import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/audio/domain/entities/downloaded_ayat_info.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetDownloadedAyats implements UseCaseNoParams<List<DownloadedAyatInfo>> {
  const GetDownloadedAyats(this._repository);

  final AudioDownloadRepository _repository;

  @override
  Future<Either<Failure, List<DownloadedAyatInfo>>> call() =>
      _repository.getDownloadedAyats();
}
