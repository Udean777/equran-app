import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class JadwalShalatRepository {
  Future<Either<Failure, List<String>>> getProvinsi();
  Future<Either<Failure, List<String>>> getKabkota(String provinsi);
  Future<Either<Failure, JadwalShalat>> getJadwalShalat({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
  });

  Future<Either<Failure, String?>> getLastProvinsi();
  Future<Either<Failure, Unit>> saveLastProvinsi(String provinsi);
  Future<Either<Failure, String?>> getLastKabkota();
  Future<Either<Failure, Unit>> saveLastKabkota(String kabkota);

  Future<Either<Failure, ShalatNotifPrefs>> getNotifPrefs();
  Future<Either<Failure, Unit>> saveNotifPrefs(ShalatNotifPrefs prefs);
}
