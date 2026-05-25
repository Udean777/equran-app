import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TasbihRepository {
  /// Simpan sesi tasbih yang sudah selesai ke Hive.
  Future<Either<Failure, Unit>> saveSession(TasbihSession session);

  /// Ambil semua riwayat sesi, diurutkan terbaru dulu.
  Future<Either<Failure, List<TasbihSession>>> getSessions();

  /// Hapus satu sesi berdasarkan id.
  Future<Either<Failure, Unit>> deleteSession(String id);

  /// Hapus semua riwayat sesi.
  Future<Either<Failure, Unit>> clearSessions();
}
