import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ShalatNotifPrefsRepository {
  Future<Either<Failure, ShalatNotifPrefs>> getPrefs();
  Future<Either<Failure, Unit>> savePrefs(ShalatNotifPrefs prefs);
}
