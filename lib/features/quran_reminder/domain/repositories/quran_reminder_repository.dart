import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class QuranReminderRepository {
  Future<Either<Failure, QuranReminderPrefs>> getPrefs();
  Future<Either<Failure, Unit>> savePrefs(QuranReminderPrefs prefs);
}
