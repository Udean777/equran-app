import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/downloaded_ayat_info.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AudioDownloadRepository {
  /// Download audio ayat ke storage lokal.
  /// Emit progress 0.0–1.0 via stream.
  Stream<Either<Failure, double>> downloadAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    required String url,
  });

  /// Hapus file audio ayat tertentu.
  Future<Either<Failure, Unit>> deleteAyat({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
  });

  /// Dapatkan list semua file yang sudah didownload.
  Future<Either<Failure, List<DownloadedAyatInfo>>> getDownloadedAyats();

  /// Hapus semua file audio yang sudah didownload.
  Future<Either<Failure, Unit>> deleteAll();
}
