import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsak_alarm_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveImsakAlarmPrefs implements UseCase<Unit, ImsakAlarmPrefs> {
  const SaveImsakAlarmPrefs(this._repository);

  final ImsakAlarmRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ImsakAlarmPrefs params) =>
      _repository.savePrefs(params);
}
