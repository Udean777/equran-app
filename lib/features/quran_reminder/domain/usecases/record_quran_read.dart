import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@lazySingleton
class RecordQuranRead implements UseCase<int, int> {
  const RecordQuranRead(this._repository);

  final QuranStreakRepository _repository;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Catat aktivitas baca hari ini dan kembalikan streak count terbaru.
  ///
  /// Logic:
  /// - Sudah baca hari ini → return [currentStreak] tanpa perubahan
  /// - Baca kemarin → streak++ dan simpan
  /// - Lebih dari kemarin / belum pernah → reset ke 1 dan simpan
  @override
  Future<Either<Failure, int>> call(int currentStreak) async {
    final today = _dateFormat.format(DateTime.now());
    final lastDateResult = await _repository.getLastReadDate();

    return lastDateResult.fold(
      left,
      (lastDate) async {
        if (lastDate == today) return right(currentStreak);

        final yesterday = _dateFormat.format(
          DateTime.now().subtract(const Duration(days: 1)),
        );

        final newCount = lastDate == yesterday ? currentStreak + 1 : 1;
        final saveResult = await _repository.saveStreak(
          date: today,
          count: newCount,
        );
        return saveResult.fold(
          left,
          (_) => right(newCount),
        );
      },
    );
  }
}
