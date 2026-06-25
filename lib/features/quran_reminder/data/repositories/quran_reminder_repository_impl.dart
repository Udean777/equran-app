import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/quran_reminder/data/datasources/quran_reminder_prefs_data_source.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_reminder_repository.dart';
import 'package:fpdart/fpdart.dart';

class QuranReminderRepositoryImpl implements QuranReminderRepository {
  const QuranReminderRepositoryImpl(this._dataSource);

  final QuranReminderPrefsDataSource _dataSource;

  @override
  Future<Either<Failure, QuranReminderPrefs>> getPrefs() async {
    try {
      final prefs = await _dataSource.getPrefs();
      return right(prefs);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePrefs(QuranReminderPrefs prefs) async {
    try {
      await _dataSource.savePrefs(prefs);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
