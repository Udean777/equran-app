import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ReadingProgressRepository {
  /// Ambil progress semua surat — key: suratNomor, value: maxScrollPercent (0.0–1.0)
  Either<Failure, Map<int, double>> getAllSuratProgress();

  /// Simpan progress satu surat (hanya update jika lebih tinggi)
  Future<Either<Failure, Unit>> saveSuratProgress(
    int suratNomor,
    double maxProgress,
  );
}
