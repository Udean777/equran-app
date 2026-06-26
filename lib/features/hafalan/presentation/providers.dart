import 'package:equran_app/core/providers.dart';
import 'package:equran_app/core/services/audio_recorder_service.dart';
import 'package:equran_app/features/hafalan/data/datasources/hafalan_compare_datasource.dart';
import 'package:equran_app/features/hafalan/data/datasources/hafalan_local_datasource.dart';
import 'package:equran_app/features/hafalan/data/repositories/hafalan_compare_repository_impl.dart';
import 'package:equran_app/features/hafalan/data/repositories/hafalan_repository_impl.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_compare_repository.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:equran_app/features/hafalan/domain/services/hafalan_reminder_scheduler.dart';
import 'package:equran_app/features/hafalan/domain/usecases/compare_recitation.dart';
import 'package:equran_app/features/hafalan/domain/usecases/delete_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_all_hafalan.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_by_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/usecases/save_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_detail_state.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_detail_viewmodel.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_list_state.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_list_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/hafalan_detail_state.dart';
export 'viewmodels/hafalan_list_state.dart';

// ─── Audio Recorder Service ────────────────────────────────────────────────

final audioRecorderServiceProvider = Provider<AudioRecorderService>((ref) {
  return RecordAudioRecorderService();
});

// ─── Data Sources ──────────────────────────────────────────────────────────

final hafalanLocalDatasourceProvider = Provider<HafalanLocalDatasource>((ref) {
  return HafalanLocalDatasourceImpl(ref.watch(hafalanBoxProvider));
});

final hafalanCompareDataSourceProvider = Provider<HafalanCompareDataSource>((
  ref,
) {
  return HafalanCompareDataSourceImpl(ref.read(dioProvider));
});

// ─── Repositories ──────────────────────────────────────────────────────────

final hafalanRepositoryProvider = Provider<HafalanRepository>((ref) {
  return HafalanRepositoryImpl(ref.read(hafalanLocalDatasourceProvider));
});

final hafalanCompareRepositoryProvider = Provider<HafalanCompareRepository>((
  ref,
) {
  return HafalanCompareRepositoryImpl(
    ref.read(hafalanCompareDataSourceProvider),
  );
});

// ─── Services ──────────────────────────────────────────────────────────────

final hafalanReminderSchedulerProvider = Provider<HafalanReminderScheduler>((
  ref,
) {
  return HafalanReminderScheduler(ref.watch(notificationServiceProvider));
});

// ─── Use Cases ─────────────────────────────────────────────────────────────

final getAllHafalanProvider = Provider<GetAllHafalan>((ref) {
  return GetAllHafalan(ref.read(hafalanRepositoryProvider));
});

final getHafalanStatsProvider = Provider<GetHafalanStats>((ref) {
  return GetHafalanStats(ref.read(hafalanRepositoryProvider));
});

final getHafalanBySuratProvider = Provider<GetHafalanBySurat>((ref) {
  return GetHafalanBySurat(ref.read(hafalanRepositoryProvider));
});

final saveHafalanSuratProvider = Provider<SaveHafalanSurat>((ref) {
  return SaveHafalanSurat(ref.read(hafalanRepositoryProvider));
});

final deleteHafalanSuratProvider = Provider<DeleteHafalanSurat>((ref) {
  return DeleteHafalanSurat(ref.read(hafalanRepositoryProvider));
});

final compareRecitationProvider = Provider<CompareRecitation>((ref) {
  return CompareRecitation(ref.read(hafalanCompareRepositoryProvider));
});

// ─── ViewModels ────────────────────────────────────────────────────────────

final hafalanListViewModelProvider =
    NotifierProvider<HafalanListViewModel, HafalanListState>(
      HafalanListViewModel.new,
    );

final AutoDisposeNotifierProviderFamily<
  HafalanDetailViewModel,
  HafalanDetailState,
  int
>
hafalanDetailViewModelProvider = NotifierProvider.autoDispose
    .family<HafalanDetailViewModel, HafalanDetailState, int>(
      HafalanDetailViewModel.new,
    );
