import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/jadwal_shalat_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/shalat_location_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/shalat_notif_prefs_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/shalat_location_repository.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/shalat_notif_prefs_repository.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notif_scheduler_service.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notification_scheduler.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notification_scheduler_impl.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_kabkota_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_provinsi_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/viewmodels/jadwal_shalat_state.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/viewmodels/jadwal_shalat_viewmodel.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/viewmodels/shalat_notif_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/jadwal_shalat_state.dart';

// ─── Data Sources ──────────────────────────────────────────────────────────

final jadwalShalatRemoteDataSourceProvider =
    Provider<JadwalShalatRemoteDataSource>((ref) {
      return JadwalShalatRemoteDataSourceImpl(ref.read(dioProvider));
    });

final jadwalShalatLocalDataSourceProvider =
    Provider<JadwalShalatLocalDataSource>((ref) {
      return JadwalShalatLocalDataSourceImpl(ref.watch(shalatBoxProvider));
    });

// ─── Repositories ──────────────────────────────────────────────────────────

final jadwalShalatRepositoryProvider = Provider<JadwalShalatRepository>((ref) {
  return JadwalShalatRepositoryImpl(
    ref.read(jadwalShalatRemoteDataSourceProvider),
    ref.read(jadwalShalatLocalDataSourceProvider),
  );
});

final shalatLocationRepositoryProvider = Provider<ShalatLocationRepository>((
  ref,
) {
  return ShalatLocationRepositoryImpl(ref.watch(shalatBoxProvider));
});

final shalatNotifPrefsRepositoryProvider = Provider<ShalatNotifPrefsRepository>(
  (ref) {
    return ShalatNotifPrefsRepositoryImpl(ref.watch(shalatBoxProvider));
  },
);

// ─── Use Cases ─────────────────────────────────────────────────────────────

final getProvinsiShalatProvider = Provider<GetProvinsiShalat>((ref) {
  return GetProvinsiShalat(ref.read(jadwalShalatRepositoryProvider));
});

final getKabkotaShalatProvider = Provider<GetKabkotaShalat>((ref) {
  return GetKabkotaShalat(ref.read(jadwalShalatRepositoryProvider));
});

final getJadwalShalatProvider = Provider<GetJadwalShalat>((ref) {
  return GetJadwalShalat(ref.read(jadwalShalatRepositoryProvider));
});

final getLastLocationShalatProvider = Provider<GetLastLocationShalat>((ref) {
  return GetLastLocationShalat(ref.read(shalatLocationRepositoryProvider));
});

final saveLastLocationShalatProvider = Provider<SaveLastLocationShalat>((ref) {
  return SaveLastLocationShalat(ref.read(shalatLocationRepositoryProvider));
});

final getShalatNotifPrefsProvider = Provider<GetShalatNotifPrefs>((ref) {
  return GetShalatNotifPrefs(ref.read(shalatNotifPrefsRepositoryProvider));
});

final saveShalatNotifPrefsProvider = Provider<SaveShalatNotifPrefs>((ref) {
  return SaveShalatNotifPrefs(ref.read(shalatNotifPrefsRepositoryProvider));
});

// ─── Notification Scheduler ────────────────────────────────────────────────

final shalatNotificationSchedulerProvider =
    Provider<IShalatNotificationScheduler>((ref) {
      return ShalatNotificationSchedulerImpl(
        ref.watch(notificationServiceProvider),
      );
    });

// ─── Services ──────────────────────────────────────────────────────────────

final shalatNotifSchedulerServiceProvider =
    Provider<ShalatNotifSchedulerService>((ref) {
      return ShalatNotifSchedulerService(
        ref.read(getShalatNotifPrefsProvider),
        ref.read(shalatNotificationSchedulerProvider),
        ref.read(getJadwalShalatProvider),
        ref.read(getLastLocationShalatProvider),
      );
    });

// ─── ViewModels ────────────────────────────────────────────────────────────

final shalatNotifViewModelProvider =
    NotifierProvider<ShalatNotifViewModel, ShalatNotifPrefs>(
      ShalatNotifViewModel.new,
    );

final AutoDisposeNotifierProvider<JadwalShalatViewModel, JadwalShalatState>
jadwalShalatViewModelProvider =
    NotifierProvider.autoDispose<JadwalShalatViewModel, JadwalShalatState>(
      JadwalShalatViewModel.new,
    );
