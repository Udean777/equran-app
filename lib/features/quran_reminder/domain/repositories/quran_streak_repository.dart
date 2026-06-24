import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class QuranStreakRepository {
  /// Ambil streak count saat ini. Returns 0 jika belum ada data.
  Future<Either<Failure, int>> getStreakCount();

  /// Ambil tanggal terakhir baca. Returns null jika belum pernah baca.
  Future<Either<Failure, String?>> getLastReadDate();

  /// Simpan streak — date format: 'yyyy-MM-dd'.
  Future<Either<Failure, Unit>> saveStreak({
    required String date,
    required int count,
  });
}
