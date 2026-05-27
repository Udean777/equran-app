import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

/// Service untuk menyimpan dan mengecek status onboarding.
/// Menggunakan settingsBox (Hive) yang sudah ada.
@lazySingleton
class OnboardingService {
  OnboardingService(@Named('settingsBox') this._box);

  final Box<String> _box;

  static const _key = 'onboarding_done';

  /// Apakah onboarding sudah selesai?
  bool get isDone => _box.get(_key) == 'true';

  /// Tandai onboarding selesai.
  Future<void> markDone() => _box.put(_key, 'true');

  /// Reset onboarding (untuk testing).
  Future<void> reset() => _box.delete(_key);
}
