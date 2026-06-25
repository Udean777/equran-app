import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/shalat_notif_prefs_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveShalatNotifPrefs implements UseCase<Unit, ShalatNotifPrefs> {
  const SaveShalatNotifPrefs(this._repository);

  final ShalatNotifPrefsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ShalatNotifPrefs params) =>
      _repository.savePrefs(params);
}
