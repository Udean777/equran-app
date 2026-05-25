import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class QiblaRepository {
  /// Inisialisasi: request permission lokasi dan ambil koordinat user.
  Future<Either<Failure, Unit>> init();

  /// Stream arah kiblat real-time dari sensor kompas.
  /// Emit [QiblaDirection] setiap heading device berubah.
  /// Gagal dengan [Failure] jika sensor tidak tersedia atau permission ditolak.
  Either<Failure, Stream<QiblaDirection>> watch();
}
