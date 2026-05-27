import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:fpdart/fpdart.dart';

/// Info file audio yang sudah didownload.
class DownloadedAyatInfo {
  const DownloadedAyatInfo({
    required this.suratNomor,
    required this.ayatNomor,
    required this.qari,
    required this.filePath,
    required this.sizeBytes,
  });

  final int suratNomor;
  final int ayatNomor;
  final Qari qari;
  final String filePath;
  final int sizeBytes;
}

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

  /// Total ukuran storage yang digunakan (bytes).
  Future<Either<Failure, int>> getTotalStorageBytes();
}
