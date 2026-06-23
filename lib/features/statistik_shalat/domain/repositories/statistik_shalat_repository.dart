import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class StatistikShalatRepository {
  /// Ambil data shalat untuk tanggal tertentu.
  Future<Either<Failure, ShalatDayStats?>> getByDate(String date);

  /// Ambil data shalat untuk range tanggal.
  Future<Either<Failure, List<ShalatDayStats>>> getByDateRange(
    List<String> dates,
  );

  /// Simpan/update log shalat untuk satu waktu.
  Future<Either<Failure, Unit>> saveLog(ShalatLog log);

  /// Hapus data shalat untuk tanggal tertentu.
  Future<Either<Failure, Unit>> deleteByDate(String date);
}
