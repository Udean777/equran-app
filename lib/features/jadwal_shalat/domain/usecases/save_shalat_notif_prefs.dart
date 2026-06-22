import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveShalatNotifPrefs implements UseCase<Unit, ShalatNotifPrefs> {
  const SaveShalatNotifPrefs(this._repository);

  final JadwalShalatRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ShalatNotifPrefs params) =>
      _repository.saveNotifPrefs(params);
}
