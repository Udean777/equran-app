import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_reminder_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveQuranReminderPrefs implements UseCase<Unit, QuranReminderPrefs> {
  const SaveQuranReminderPrefs(this._repository);

  final QuranReminderRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(QuranReminderPrefs prefs) =>
      _repository.savePrefs(prefs);
}
