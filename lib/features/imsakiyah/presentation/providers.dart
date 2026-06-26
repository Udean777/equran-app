import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_cache_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_remote_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/repositories/imsak_alarm_repository_impl.dart';
import 'package:equran_app/features/imsakiyah/data/repositories/imsakiyah_location_repository_impl.dart';
import 'package:equran_app/features/imsakiyah/data/repositories/imsakiyah_repository_impl.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsak_alarm_repository.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_location_repository.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:equran_app/features/imsakiyah/domain/services/imsak_alarm_scheduler.dart';
import 'package:equran_app/features/imsakiyah/domain/services/imsak_alarm_scheduler_impl.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_last_location_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_last_location_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/presentation/viewmodels/imsak_alarm_state.dart';
import 'package:equran_app/features/imsakiyah/presentation/viewmodels/imsak_alarm_viewmodel.dart';
import 'package:equran_app/features/imsakiyah/presentation/viewmodels/imsakiyah_state.dart';
import 'package:equran_app/features/imsakiyah/presentation/viewmodels/imsakiyah_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/imsak_alarm_state.dart';
export 'viewmodels/imsakiyah_state.dart';

// ─── Data Sources ──────────────────────────────────────────────────────────

final imsakiyahRemoteDataSourceProvider = Provider<ImsakiyahRemoteDataSource>((
  ref,
) {
  return ImsakiyahRemoteDataSourceImpl(ref.read(dioProvider));
});

final imsakiyahCacheDataSourceProvider = Provider<ImsakiyahCacheDataSource>((
  ref,
) {
  return ImsakiyahCacheDataSourceImpl(ref.watch(imsakiyahBoxProvider));
});

// ─── Repositories ──────────────────────────────────────────────────────────

final imsakiyahRepositoryProvider = Provider<ImsakiyahRepository>((ref) {
  return ImsakiyahRepositoryImpl(
    ref.read(imsakiyahRemoteDataSourceProvider),
    ref.read(imsakiyahCacheDataSourceProvider),
  );
});

final imsakiyahLocationRepositoryProvider =
    Provider<ImsakiyahLocationRepository>((ref) {
      return ImsakiyahLocationRepositoryImpl(ref.watch(imsakiyahBoxProvider));
    });

final imsakAlarmRepositoryProvider = Provider<ImsakAlarmRepository>((ref) {
  return ImsakAlarmRepositoryImpl(ref.watch(imsakiyahBoxProvider));
});

// ─── Use Cases ─────────────────────────────────────────────────────────────

final getProvinsiProvider = Provider<GetProvinsi>((ref) {
  return GetProvinsi(ref.read(imsakiyahRepositoryProvider));
});

final getKabkotaProvider = Provider<GetKabkota>((ref) {
  return GetKabkota(ref.read(imsakiyahRepositoryProvider));
});

final getImsakiyahProvider = Provider<GetImsakiyah>((ref) {
  return GetImsakiyah(ref.read(imsakiyahRepositoryProvider));
});

final getLastLocationImsakiyahProvider = Provider<GetLastLocationImsakiyah>((
  ref,
) {
  return GetLastLocationImsakiyah(
    ref.read(imsakiyahLocationRepositoryProvider),
  );
});

final saveLastLocationImsakiyahProvider = Provider<SaveLastLocationImsakiyah>((
  ref,
) {
  return SaveLastLocationImsakiyah(
    ref.read(imsakiyahLocationRepositoryProvider),
  );
});

final getImsakAlarmPrefsProvider = Provider<GetImsakAlarmPrefs>((ref) {
  return GetImsakAlarmPrefs(ref.read(imsakAlarmRepositoryProvider));
});

final saveImsakAlarmPrefsProvider = Provider<SaveImsakAlarmPrefs>((ref) {
  return SaveImsakAlarmPrefs(ref.read(imsakAlarmRepositoryProvider));
});

// ─── Notification Scheduler ────────────────────────────────────────────────

final imsakAlarmSchedulerProvider = Provider<ImsakAlarmScheduler>((ref) {
  return ImsakAlarmSchedulerImpl(ref.watch(notificationServiceProvider));
});

// ─── ViewModels ────────────────────────────────────────────────────────────

final AutoDisposeNotifierProvider<ImsakiyahViewModel, ImsakiyahState>
imsakiyahViewModelProvider =
    NotifierProvider.autoDispose<ImsakiyahViewModel, ImsakiyahState>(
      ImsakiyahViewModel.new,
    );

final imsakAlarmViewModelProvider =
    NotifierProvider<ImsakAlarmViewModel, ImsakAlarmState>(
      ImsakAlarmViewModel.new,
    );
