import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetStreakCount {
  const GetStreakCount(this._repository);

  final QuranStreakRepository _repository;

  Future<int> call() => _repository.getStreakCount();
}
