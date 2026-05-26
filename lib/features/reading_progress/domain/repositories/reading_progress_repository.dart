import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ReadingProgressRepository {
  /// Ambil riwayat baca untuk tanggal tertentu.
  Either<Failure, ReadingHistory?> getByDate(String date);

  /// Ambil riwayat baca untuk range tanggal.
  Either<Failure, List<ReadingHistory>> getByDateRange(List<String> dates);

  /// Simpan ayat yang dibaca (single).
  Future<Either<Failure, Unit>> saveAyat(String date, String ayatId);

  /// Simpan batch ayat yang dibaca (lebih efisien untuk flush saat dispose).
  Future<Either<Failure, Unit>> saveAyatBatch(
    String date,
    Set<String> ayatIds,
  );

  /// Hapus data lama (lebih dari [retentionDays] hari).
  Future<Either<Failure, Unit>> cleanupOldData(int retentionDays);

  /// Hitung statistik membaca dari data yang tersimpan.
  Either<Failure, ReadingStats> getStats({required String today});
}
