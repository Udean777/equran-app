import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShalatNotifPrefs implements UseCaseNoParams<ShalatNotifPrefs> {
  const GetShalatNotifPrefs(this._repository);

  final JadwalShalatRepository _repository;

  @override
  Future<Either<Failure, ShalatNotifPrefs>> call() =>
      _repository.getNotifPrefs();
}
