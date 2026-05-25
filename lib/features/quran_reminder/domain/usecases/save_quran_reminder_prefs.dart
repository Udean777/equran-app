import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_reminder_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveQuranReminderPrefs {
  const SaveQuranReminderPrefs(this._repository);

  final QuranReminderRepository _repository;

  Future<Either<Failure, Unit>> call(QuranReminderPrefs prefs) =>
      _repository.savePrefs(prefs);
}
