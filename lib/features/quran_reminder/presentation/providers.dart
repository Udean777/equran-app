import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/quran_reminder/data/datasources/quran_reminder_prefs_data_source.dart';
import 'package:equran_app/features/quran_reminder/data/datasources/quran_streak_local_data_source.dart';
import 'package:equran_app/features/quran_reminder/data/repositories/quran_reminder_repository_impl.dart';
import 'package:equran_app/features/quran_reminder/data/repositories/quran_streak_repository_impl.dart';
import 'package:equran_app/features/quran_reminder/data/services/quran_reminder_scheduler.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/save_quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/presentation/viewmodels/quran_reminder_state.dart';
import 'package:equran_app/features/quran_reminder/presentation/viewmodels/quran_reminder_viewmodel.dart';
import 'package:equran_app/features/quran_reminder/presentation/viewmodels/quran_streak_state.dart';
import 'package:equran_app/features/quran_reminder/presentation/viewmodels/quran_streak_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/quran_reminder_state.dart';
export 'viewmodels/quran_streak_state.dart';

// --- Data Sources ---

final quranReminderPrefsDataSourceProvider =
    Provider<QuranReminderPrefsDataSourceImpl>((ref) {
      return QuranReminderPrefsDataSourceImpl(ref.watch(settingsBoxProvider));
    });

final quranStreakLocalDataSourceProvider =
    Provider<QuranStreakLocalDataSourceImpl>((ref) {
      return QuranStreakLocalDataSourceImpl(ref.watch(shalatBoxProvider));
    });

// --- Repositories ---

final quranReminderRepositoryProvider = Provider<QuranReminderRepositoryImpl>((
  ref,
) {
  return QuranReminderRepositoryImpl(
    ref.read(quranReminderPrefsDataSourceProvider),
  );
});

final quranStreakRepositoryProvider = Provider<QuranStreakRepositoryImpl>((
  ref,
) {
  return QuranStreakRepositoryImpl(
    ref.read(quranStreakLocalDataSourceProvider),
  );
});

// --- Use Cases ---

final getQuranReminderPrefsProvider = Provider<GetQuranReminderPrefs>((ref) {
  return GetQuranReminderPrefs(ref.read(quranReminderRepositoryProvider));
});

final saveQuranReminderPrefsProvider = Provider<SaveQuranReminderPrefs>((ref) {
  return SaveQuranReminderPrefs(ref.read(quranReminderRepositoryProvider));
});

final getStreakCountProvider = Provider<GetStreakCount>((ref) {
  return GetStreakCount(ref.read(quranStreakRepositoryProvider));
});

final recordQuranReadProvider = Provider<RecordQuranRead>((ref) {
  return RecordQuranRead(ref.read(quranStreakRepositoryProvider));
});

// --- Service ---

final quranReminderSchedulerProvider = Provider<QuranReminderScheduler>((ref) {
  return QuranReminderScheduler(ref.watch(notificationServiceProvider));
});

// --- ViewModels ---

final quranReminderViewModelProvider =
    StateNotifierProvider<QuranReminderViewModel, QuranReminderState>(
      (ref) => QuranReminderViewModel(
        ref.read(getQuranReminderPrefsProvider),
        ref.read(saveQuranReminderPrefsProvider),
        ref.read(quranReminderSchedulerProvider),
      ),
    );

final quranStreakViewModelProvider =
    StateNotifierProvider<QuranStreakViewModel, QuranStreakState>(
      (ref) => QuranStreakViewModel(
        ref.read(getStreakCountProvider),
        ref.read(recordQuranReadProvider),
      ),
    );
