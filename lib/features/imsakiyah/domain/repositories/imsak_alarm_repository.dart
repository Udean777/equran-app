import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ImsakAlarmRepository {
  Future<Either<Failure, ImsakAlarmPrefs>> getPrefs();
  Future<Either<Failure, Unit>> savePrefs(ImsakAlarmPrefs prefs);
}
