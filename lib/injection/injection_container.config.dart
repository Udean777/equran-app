// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:equran_app/core/cache/hive_module.dart' as _i815;
import 'package:equran_app/core/locale/cubit/language_cubit.dart' as _i157;
import 'package:equran_app/core/location/location_service.dart' as _i177;
import 'package:equran_app/core/network/dio_client.dart' as _i870;
import 'package:equran_app/core/notifications/hafalan_reminder_scheduler.dart'
    as _i480;
import 'package:equran_app/core/notifications/imsak_alarm_scheduler.dart'
    as _i98;
import 'package:equran_app/core/notifications/notification_module.dart'
    as _i1066;
import 'package:equran_app/core/notifications/notification_service.dart'
    as _i175;
import 'package:equran_app/core/notifications/quran_reminder_scheduler.dart'
    as _i745;
import 'package:equran_app/core/notifications/shalat_checklist_reminder_scheduler.dart'
    as _i1057;
import 'package:equran_app/core/notifications/shalat_notification_scheduler.dart'
    as _i804;
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart' as _i205;
import 'package:equran_app/core/theme/cubit/theme_cubit.dart' as _i729;
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart'
    as _i813;
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart'
    as _i503;
import 'package:equran_app/features/audio/data/datasources/audio_player_data_source.dart'
    as _i945;
import 'package:equran_app/features/audio/data/datasources/audio_service_module.dart'
    as _i718;
import 'package:equran_app/features/audio/data/repositories/audio_repository_impl.dart'
    as _i550;
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart'
    as _i451;
import 'package:equran_app/features/audio/domain/usecases/delete_all_audio.dart'
    as _i425;
import 'package:equran_app/features/audio/domain/usecases/delete_ayat_audio.dart'
    as _i380;
import 'package:equran_app/features/audio/domain/usecases/download_ayat_audio.dart'
    as _i434;
import 'package:equran_app/features/audio/domain/usecases/get_available_qari.dart'
    as _i372;
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart'
    as _i232;
import 'package:equran_app/features/audio/domain/usecases/pause_audio.dart'
    as _i665;
import 'package:equran_app/features/audio/domain/usecases/play_audio.dart'
    as _i556;
import 'package:equran_app/features/audio/domain/usecases/resume_audio.dart'
    as _i748;
import 'package:equran_app/features/audio/domain/usecases/seek_audio.dart'
    as _i637;
import 'package:equran_app/features/audio/domain/usecases/stop_audio.dart'
    as _i710;
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart'
    as _i729;
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart'
    as _i146;
import 'package:equran_app/features/audio/presentation/cubit/audio_storage_cubit.dart'
    as _i330;
import 'package:equran_app/features/bookmark/data/datasources/bookmark_local_data_source.dart'
    as _i701;
import 'package:equran_app/features/bookmark/data/repositories/bookmark_repository_impl.dart'
    as _i720;
import 'package:equran_app/features/bookmark/domain/repositories/bookmark_repository.dart'
    as _i182;
import 'package:equran_app/features/bookmark/domain/usecases/add_bookmark.dart'
    as _i749;
import 'package:equran_app/features/bookmark/domain/usecases/get_bookmarks.dart'
    as _i1008;
import 'package:equran_app/features/bookmark/domain/usecases/get_last_read.dart'
    as _i994;
import 'package:equran_app/features/bookmark/domain/usecases/remove_bookmark.dart'
    as _i778;
import 'package:equran_app/features/bookmark/domain/usecases/save_last_read.dart'
    as _i187;
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart'
    as _i194;
import 'package:equran_app/features/catatan_ayat/data/datasources/catatan_ayat_local_datasource.dart'
    as _i289;
import 'package:equran_app/features/catatan_ayat/data/repositories/catatan_ayat_repository_impl.dart'
    as _i410;
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart'
    as _i321;
import 'package:equran_app/features/catatan_ayat/domain/usecases/delete_catatan.dart'
    as _i451;
import 'package:equran_app/features/catatan_ayat/domain/usecases/get_all_catatan.dart'
    as _i508;
import 'package:equran_app/features/catatan_ayat/domain/usecases/get_catatan_by_ayat.dart'
    as _i563;
import 'package:equran_app/features/catatan_ayat/domain/usecases/save_catatan.dart'
    as _i559;
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart'
    as _i914;
import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart'
    as _i553;
import 'package:equran_app/features/doa/data/datasources/doa_local_data_source.dart'
    as _i547;
import 'package:equran_app/features/doa/data/datasources/doa_remote_data_source.dart'
    as _i34;
import 'package:equran_app/features/doa/data/repositories/doa_repository_impl.dart'
    as _i164;
import 'package:equran_app/features/doa/domain/repositories/doa_repository.dart'
    as _i420;
import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart'
    as _i254;
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart'
    as _i422;
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart'
    as _i254;
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart'
    as _i107;
import 'package:equran_app/features/doa/presentation/cubit/doa_detail_cubit.dart'
    as _i290;
import 'package:equran_app/features/doa/presentation/cubit/doa_list_cubit.dart'
    as _i345;
import 'package:equran_app/features/hafalan/data/datasources/hafalan_local_datasource.dart'
    as _i445;
import 'package:equran_app/features/hafalan/data/repositories/hafalan_repository_impl.dart'
    as _i804;
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart'
    as _i663;
import 'package:equran_app/features/hafalan/domain/usecases/delete_hafalan_surat.dart'
    as _i29;
import 'package:equran_app/features/hafalan/domain/usecases/get_all_hafalan.dart'
    as _i7;
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_by_surat.dart'
    as _i539;
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_stats.dart'
    as _i868;
import 'package:equran_app/features/hafalan/domain/usecases/save_hafalan_surat.dart'
    as _i702;
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart'
    as _i538;
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_local_data_source.dart'
    as _i555;
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_remote_data_source.dart'
    as _i575;
import 'package:equran_app/features/imsakiyah/data/repositories/imsakiyah_repository_impl.dart'
    as _i648;
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart'
    as _i36;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsak_alarm_prefs.dart'
    as _i395;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart'
    as _i28;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart'
    as _i815;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_last_location_imsakiyah.dart'
    as _i387;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart'
    as _i410;
import 'package:equran_app/features/imsakiyah/domain/usecases/save_imsak_alarm_prefs.dart'
    as _i578;
import 'package:equran_app/features/imsakiyah/domain/usecases/save_last_location_imsakiyah.dart'
    as _i1070;
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsak_alarm_cubit.dart'
    as _i12;
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsakiyah_cubit.dart'
    as _i165;
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart'
    as _i560;
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart'
    as _i264;
import 'package:equran_app/features/jadwal_shalat/data/datasources/shalat_notif_prefs_data_source.dart'
    as _i185;
import 'package:equran_app/features/jadwal_shalat/data/repositories/jadwal_shalat_repository_impl.dart'
    as _i443;
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart'
    as _i414;
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart'
    as _i1042;
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_kabkota_shalat.dart'
    as _i173;
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart'
    as _i88;
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_provinsi_shalat.dart'
    as _i598;
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart'
    as _i8;
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_last_location_shalat.dart'
    as _i584;
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart'
    as _i69;
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/jadwal_shalat_cubit.dart'
    as _i83;
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart'
    as _i615;
import 'package:equran_app/features/qibla/data/datasources/qibla_data_source.dart'
    as _i473;
import 'package:equran_app/features/qibla/data/repositories/qibla_repository_impl.dart'
    as _i369;
import 'package:equran_app/features/qibla/domain/repositories/qibla_repository.dart'
    as _i480;
import 'package:equran_app/features/qibla/domain/usecases/init_qibla.dart'
    as _i321;
import 'package:equran_app/features/qibla/domain/usecases/watch_qibla_direction.dart'
    as _i247;
import 'package:equran_app/features/qibla/presentation/cubit/qibla_cubit.dart'
    as _i238;
import 'package:equran_app/features/quran_reminder/data/datasources/quran_reminder_prefs_data_source.dart'
    as _i843;
import 'package:equran_app/features/quran_reminder/data/datasources/quran_streak_local_data_source.dart'
    as _i770;
import 'package:equran_app/features/quran_reminder/data/repositories/quran_reminder_repository_impl.dart'
    as _i258;
import 'package:equran_app/features/quran_reminder/data/repositories/quran_streak_repository_impl.dart'
    as _i54;
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_reminder_repository.dart'
    as _i698;
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart'
    as _i1011;
import 'package:equran_app/features/quran_reminder/domain/usecases/get_quran_reminder_prefs.dart'
    as _i23;
import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart'
    as _i458;
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart'
    as _i659;
import 'package:equran_app/features/quran_reminder/domain/usecases/save_quran_reminder_prefs.dart'
    as _i0;
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_reminder_cubit.dart'
    as _i443;
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart'
    as _i69;
import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart'
    as _i607;
import 'package:equran_app/features/reading_progress/data/repositories/reading_progress_repository_impl.dart'
    as _i403;
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart'
    as _i203;
import 'package:equran_app/features/reading_progress/domain/usecases/cleanup_old_reading_data.dart'
    as _i230;
import 'package:equran_app/features/reading_progress/domain/usecases/get_reading_history_by_date.dart'
    as _i251;
import 'package:equran_app/features/reading_progress/domain/usecases/get_reading_stats.dart'
    as _i821;
import 'package:equran_app/features/reading_progress/domain/usecases/save_ayat_read.dart'
    as _i91;
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart'
    as _i924;
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart'
    as _i815;
import 'package:equran_app/features/statistik_shalat/data/repositories/statistik_shalat_repository_impl.dart'
    as _i892;
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart'
    as _i278;
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_by_date.dart'
    as _i696;
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_by_date_range.dart'
    as _i302;
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_stats.dart'
    as _i525;
import 'package:equran_app/features/statistik_shalat/domain/usecases/save_shalat_log.dart'
    as _i413;
import 'package:equran_app/features/statistik_shalat/presentation/cubit/statistik_shalat_cubit.dart'
    as _i265;
import 'package:equran_app/features/surat_detail/data/datasources/surat_detail_local_data_source.dart'
    as _i349;
import 'package:equran_app/features/surat_detail/data/datasources/surat_detail_remote_data_source.dart'
    as _i959;
import 'package:equran_app/features/surat_detail/data/repositories/surat_detail_repository_impl.dart'
    as _i992;
import 'package:equran_app/features/surat_detail/domain/repositories/surat_detail_repository.dart'
    as _i246;
import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart'
    as _i115;
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart'
    as _i438;
import 'package:equran_app/features/surat_list/data/datasources/surat_local_data_source.dart'
    as _i107;
import 'package:equran_app/features/surat_list/data/datasources/surat_remote_data_source.dart'
    as _i1071;
import 'package:equran_app/features/surat_list/data/repositories/surat_repository_impl.dart'
    as _i291;
import 'package:equran_app/features/surat_list/domain/repositories/surat_repository.dart'
    as _i647;
import 'package:equran_app/features/surat_list/domain/usecases/get_surat_list.dart'
    as _i291;
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart'
    as _i334;
import 'package:equran_app/features/tafsir/data/datasources/tafsir_local_data_source.dart'
    as _i398;
import 'package:equran_app/features/tafsir/data/datasources/tafsir_remote_data_source.dart'
    as _i713;
import 'package:equran_app/features/tafsir/data/repositories/tafsir_repository_impl.dart'
    as _i734;
import 'package:equran_app/features/tafsir/domain/repositories/tafsir_repository.dart'
    as _i485;
import 'package:equran_app/features/tafsir/domain/usecases/get_tafsir.dart'
    as _i160;
import 'package:equran_app/features/tafsir/presentation/cubit/tafsir_cubit.dart'
    as _i974;
import 'package:equran_app/features/tasbih/data/datasources/tasbih_local_data_source.dart'
    as _i415;
import 'package:equran_app/features/tasbih/data/repositories/tasbih_repository_impl.dart'
    as _i940;
import 'package:equran_app/features/tasbih/domain/repositories/tasbih_repository.dart'
    as _i419;
import 'package:equran_app/features/tasbih/domain/usecases/clear_tasbih_sessions.dart'
    as _i603;
import 'package:equran_app/features/tasbih/domain/usecases/delete_tasbih_session.dart'
    as _i1029;
import 'package:equran_app/features/tasbih/domain/usecases/get_tasbih_sessions.dart'
    as _i998;
import 'package:equran_app/features/tasbih/domain/usecases/save_tasbih_session.dart'
    as _i259;
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart'
    as _i1068;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_ce/hive.dart' as _i738;
import 'package:hive_ce_flutter/hive_flutter.dart' as _i919;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final audioServiceModule = _$AudioServiceModule();
    final notificationModule = _$NotificationModule();
    final hiveModule = _$HiveModule();
    gh.singleton<_i870.DioClient>(() => _i870.DioClient());
    await gh.singletonAsync<_i813.AudioBackgroundHandler>(
      () => audioServiceModule.audioBackgroundHandler(),
      preResolve: true,
    );
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => notificationModule.flutterLocalNotificationsPlugin,
    );
    gh.lazySingleton<_i372.GetAvailableQari>(
      () => const _i372.GetAvailableQari(),
    );
    gh.lazySingleton<_i473.QiblaDataSource>(() => _i473.QiblaDataSource());
    gh.lazySingleton<_i503.AudioDownloadDataSource>(
      () => _i503.AudioDownloadDataSourceImpl(gh<_i870.DioClient>()),
    );
    await gh.factoryAsync<_i919.LazyBox<String>>(
      () => hiveModule.tafsirBox(),
      instanceName: 'tafsirBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.settingsBox(),
      instanceName: 'settingsBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.tasbihBox(),
      instanceName: 'tasbihBox',
      preResolve: true,
    );
    gh.lazySingleton<_i415.TasbihLocalDataSource>(
      () => _i415.TasbihLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'tasbihBox'),
      ),
    );
    gh.lazySingleton<_i843.QuranReminderPrefsDataSource>(
      () => _i843.QuranReminderPrefsDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'settingsBox'),
      ),
    );
    gh.lazySingleton<_i177.LocationService>(() => _i177.LocationServiceImpl());
    gh.lazySingleton<_i380.DeleteAyatAudio>(
      () => _i380.DeleteAyatAudio(gh<_i503.AudioDownloadDataSource>()),
    );
    gh.lazySingleton<_i434.DownloadAyatAudio>(
      () => _i434.DownloadAyatAudio(gh<_i503.AudioDownloadDataSource>()),
    );
    gh.lazySingleton<_i232.GetDownloadedAyats>(
      () => _i232.GetDownloadedAyats(gh<_i503.AudioDownloadDataSource>()),
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.readingHistoryBox(),
      instanceName: 'readingHistoryBox',
      preResolve: true,
    );
    gh.singleton<_i157.LanguageCubit>(
      () => _i157.LanguageCubit(
        gh<_i738.Box<String>>(instanceName: 'settingsBox'),
      ),
    );
    gh.singleton<_i205.QuranFontCubit>(
      () => _i205.QuranFontCubit(
        gh<_i738.Box<String>>(instanceName: 'settingsBox'),
      ),
    );
    gh.singleton<_i729.ThemeCubit>(
      () =>
          _i729.ThemeCubit(gh<_i738.Box<String>>(instanceName: 'settingsBox')),
    );
    gh.singleton<_i945.AudioPlayerDataSource>(
      () => _i945.AudioPlayerDataSourceImpl(gh<_i813.AudioBackgroundHandler>()),
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.shalatBox(),
      instanceName: 'shalatBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.imsakiyahBox(),
      instanceName: 'imsakiyahBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.statistikShalatBox(),
      instanceName: 'statistikShalatBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.catatanBox(),
      instanceName: 'catatanBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.LazyBox<String>>(
      () => hiveModule.suratBox(),
      instanceName: 'suratBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.bookmarkBox(),
      instanceName: 'bookmarkBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.LazyBox<String>>(
      () => hiveModule.doaBox(),
      instanceName: 'doaBox',
      preResolve: true,
    );
    gh.lazySingleton<_i770.QuranStreakLocalDataSource>(
      () => _i770.QuranStreakLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'settingsBox'),
      ),
    );
    gh.lazySingleton<_i185.ShalatNotifPrefsDataSource>(
      () => _i185.ShalatNotifPrefsDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'settingsBox'),
      ),
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.doaBookmarkBox(),
      instanceName: 'doaBookmarkBox',
      preResolve: true,
    );
    gh.lazySingleton<_i701.BookmarkLocalDataSource>(
      () => _i701.BookmarkLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'bookmarkBox'),
      ),
    );
    gh.lazySingleton<_i349.SuratDetailLocalDataSource>(
      () => _i349.SuratDetailLocalDataSourceImpl(
        gh<_i738.LazyBox<String>>(instanceName: 'suratBox'),
      ),
    );
    gh.lazySingleton<_i182.BookmarkRepository>(
      () => _i720.BookmarkRepositoryImpl(gh<_i701.BookmarkLocalDataSource>()),
    );
    await gh.factoryAsync<_i919.Box<String>>(
      () => hiveModule.hafalanBox(),
      instanceName: 'hafalanBox',
      preResolve: true,
    );
    gh.lazySingleton<_i480.QiblaRepository>(
      () => _i369.QiblaRepositoryImpl(gh<_i473.QiblaDataSource>()),
    );
    gh.lazySingleton<_i607.ReadingHistoryLocalDataSource>(
      () => _i607.ReadingHistoryLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'readingHistoryBox'),
      ),
    );
    gh.factory<_i749.AddBookmark>(
      () => _i749.AddBookmark(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i1008.GetBookmarks>(
      () => _i1008.GetBookmarks(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i994.GetLastRead>(
      () => _i994.GetLastRead(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i778.RemoveBookmark>(
      () => _i778.RemoveBookmark(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i187.SaveLastRead>(
      () => _i187.SaveLastRead(gh<_i182.BookmarkRepository>()),
    );
    gh.singleton<_i451.AudioRepository>(
      () => _i550.AudioRepositoryImpl(
        gh<_i945.AudioPlayerDataSource>(),
        gh<_i503.AudioDownloadDataSource>(),
      ),
    );
    gh.lazySingleton<_i289.CatatanAyatLocalDatasource>(
      () => _i289.CatatanAyatLocalDatasourceImpl(
        gh<_i738.Box<String>>(instanceName: 'catatanBox'),
      ),
    );
    gh.lazySingleton<_i264.JadwalShalatRemoteDataSource>(
      () => _i264.JadwalShalatRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i1071.SuratRemoteDataSource>(
      () => _i1071.SuratRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i175.NotificationService>(
      () => _i175.NotificationService(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
      ),
    );
    gh.lazySingleton<_i395.GetImsakAlarmPrefs>(
      () => _i395.GetImsakAlarmPrefs(
        gh<_i738.Box<String>>(instanceName: 'imsakiyahBox'),
      ),
    );
    gh.lazySingleton<_i578.SaveImsakAlarmPrefs>(
      () => _i578.SaveImsakAlarmPrefs(
        gh<_i738.Box<String>>(instanceName: 'imsakiyahBox'),
      ),
    );
    gh.lazySingleton<_i575.ImsakiyahRemoteDataSource>(
      () => _i575.ImsakiyahRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i698.QuranReminderRepository>(
      () => _i258.QuranReminderRepositoryImpl(
        gh<_i843.QuranReminderPrefsDataSource>(),
      ),
    );
    gh.lazySingleton<_i959.SuratDetailRemoteDataSource>(
      () => _i959.SuratDetailRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i815.ShalatLogLocalDataSource>(
      () => _i815.ShalatLogLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'statistikShalatBox'),
      ),
    );
    gh.lazySingleton<_i419.TasbihRepository>(
      () => _i940.TasbihRepositoryImpl(gh<_i415.TasbihLocalDataSource>()),
    );
    gh.lazySingleton<_i555.ImsakiyahLocalDataSource>(
      () => _i555.ImsakiyahLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'imsakiyahBox'),
      ),
    );
    gh.lazySingleton<_i553.DoaBookmarkDataSource>(
      () => _i553.DoaBookmarkDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'doaBookmarkBox'),
      ),
    );
    gh.lazySingleton<_i8.GetShalatNotifPrefs>(
      () => _i8.GetShalatNotifPrefs(gh<_i185.ShalatNotifPrefsDataSource>()),
    );
    gh.lazySingleton<_i69.SaveShalatNotifPrefs>(
      () => _i69.SaveShalatNotifPrefs(gh<_i185.ShalatNotifPrefsDataSource>()),
    );
    gh.lazySingleton<_i1011.QuranStreakRepository>(
      () => _i54.QuranStreakRepositoryImpl(
        gh<_i770.QuranStreakLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i480.HafalanReminderScheduler>(
      () => _i480.HafalanReminderScheduler(gh<_i175.NotificationService>()),
    );
    gh.lazySingleton<_i98.ImsakAlarmScheduler>(
      () => _i98.ImsakAlarmScheduler(gh<_i175.NotificationService>()),
    );
    gh.lazySingleton<_i745.QuranReminderScheduler>(
      () => _i745.QuranReminderScheduler(gh<_i175.NotificationService>()),
    );
    gh.lazySingleton<_i804.ShalatNotificationScheduler>(
      () => _i804.ShalatNotificationScheduler(gh<_i175.NotificationService>()),
    );
    gh.factory<_i321.InitQibla>(
      () => _i321.InitQibla(gh<_i480.QiblaRepository>()),
    );
    gh.factory<_i247.WatchQiblaDirection>(
      () => _i247.WatchQiblaDirection(gh<_i480.QiblaRepository>()),
    );
    gh.singleton<_i615.ShalatNotifCubit>(
      () => _i615.ShalatNotifCubit(
        gh<_i8.GetShalatNotifPrefs>(),
        gh<_i69.SaveShalatNotifPrefs>(),
      ),
    );
    gh.lazySingleton<_i398.TafsirLocalDataSource>(
      () => _i398.TafsirLocalDataSourceImpl(
        gh<_i738.LazyBox<String>>(instanceName: 'tafsirBox'),
      ),
    );
    gh.lazySingleton<_i713.TafsirRemoteDataSource>(
      () => _i713.TafsirRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i34.DoaRemoteDataSource>(
      () => _i34.DoaRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i560.JadwalShalatLocalDataSource>(
      () => _i560.JadwalShalatLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'shalatBox'),
      ),
    );
    gh.factory<_i146.AudioDownloadCubit>(
      () => _i146.AudioDownloadCubit(
        gh<_i434.DownloadAyatAudio>(),
        gh<_i232.GetDownloadedAyats>(),
      ),
    );
    gh.lazySingleton<_i246.SuratDetailRepository>(
      () => _i992.SuratDetailRepositoryImpl(
        gh<_i959.SuratDetailRemoteDataSource>(),
        gh<_i349.SuratDetailLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i107.SuratLocalDataSource>(
      () => _i107.SuratLocalDataSourceImpl(
        gh<_i738.LazyBox<String>>(instanceName: 'suratBox'),
      ),
    );
    gh.factory<_i254.GetDoaBookmarks>(
      () => _i254.GetDoaBookmarks(gh<_i553.DoaBookmarkDataSource>()),
    );
    gh.factory<_i107.ToggleDoaBookmark>(
      () => _i107.ToggleDoaBookmark(gh<_i553.DoaBookmarkDataSource>()),
    );
    gh.lazySingleton<_i278.StatistikShalatRepository>(
      () => _i892.StatistikShalatRepositoryImpl(
        gh<_i815.ShalatLogLocalDataSource>(),
      ),
    );
    gh.factory<_i12.ImsakAlarmCubit>(
      () => _i12.ImsakAlarmCubit(
        gh<_i395.GetImsakAlarmPrefs>(),
        gh<_i578.SaveImsakAlarmPrefs>(),
        gh<_i98.ImsakAlarmScheduler>(),
      ),
    );
    gh.factory<_i603.ClearTasbihSessions>(
      () => _i603.ClearTasbihSessions(gh<_i419.TasbihRepository>()),
    );
    gh.factory<_i1029.DeleteTasbihSession>(
      () => _i1029.DeleteTasbihSession(gh<_i419.TasbihRepository>()),
    );
    gh.factory<_i998.GetTasbihSessions>(
      () => _i998.GetTasbihSessions(gh<_i419.TasbihRepository>()),
    );
    gh.factory<_i259.SaveTasbihSession>(
      () => _i259.SaveTasbihSession(gh<_i419.TasbihRepository>()),
    );
    gh.lazySingleton<_i23.GetQuranReminderPrefs>(
      () => _i23.GetQuranReminderPrefs(gh<_i698.QuranReminderRepository>()),
    );
    gh.lazySingleton<_i0.SaveQuranReminderPrefs>(
      () => _i0.SaveQuranReminderPrefs(gh<_i698.QuranReminderRepository>()),
    );
    gh.lazySingleton<_i547.DoaLocalDataSource>(
      () => _i547.DoaLocalDataSourceImpl(
        gh<_i738.LazyBox<String>>(instanceName: 'doaBox'),
      ),
    );
    gh.lazySingleton<_i425.DeleteAllAudio>(
      () => _i425.DeleteAllAudio(gh<_i451.AudioRepository>()),
    );
    gh.factory<_i665.PauseAudio>(
      () => _i665.PauseAudio(gh<_i451.AudioRepository>()),
    );
    gh.factory<_i556.PlayAudio>(
      () => _i556.PlayAudio(gh<_i451.AudioRepository>()),
    );
    gh.factory<_i748.ResumeAudio>(
      () => _i748.ResumeAudio(gh<_i451.AudioRepository>()),
    );
    gh.factory<_i637.SeekAudio>(
      () => _i637.SeekAudio(gh<_i451.AudioRepository>()),
    );
    gh.factory<_i710.StopAudio>(
      () => _i710.StopAudio(gh<_i451.AudioRepository>()),
    );
    gh.lazySingleton<_i414.JadwalShalatRepository>(
      () => _i443.JadwalShalatRepositoryImpl(
        gh<_i264.JadwalShalatRemoteDataSource>(),
        gh<_i560.JadwalShalatLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i458.GetStreakCount>(
      () => _i458.GetStreakCount(gh<_i1011.QuranStreakRepository>()),
    );
    gh.lazySingleton<_i659.RecordQuranRead>(
      () => _i659.RecordQuranRead(gh<_i1011.QuranStreakRepository>()),
    );
    gh.lazySingleton<_i1042.GetJadwalShalat>(
      () => _i1042.GetJadwalShalat(gh<_i414.JadwalShalatRepository>()),
    );
    gh.lazySingleton<_i173.GetKabkotaShalat>(
      () => _i173.GetKabkotaShalat(gh<_i414.JadwalShalatRepository>()),
    );
    gh.lazySingleton<_i88.GetLastLocationShalat>(
      () => _i88.GetLastLocationShalat(gh<_i414.JadwalShalatRepository>()),
    );
    gh.lazySingleton<_i598.GetProvinsiShalat>(
      () => _i598.GetProvinsiShalat(gh<_i414.JadwalShalatRepository>()),
    );
    gh.lazySingleton<_i584.SaveLastLocationShalat>(
      () => _i584.SaveLastLocationShalat(gh<_i414.JadwalShalatRepository>()),
    );
    gh.lazySingleton<_i445.HafalanLocalDatasource>(
      () => _i445.HafalanLocalDatasourceImpl(
        gh<_i738.Box<String>>(instanceName: 'hafalanBox'),
      ),
    );
    gh.lazySingleton<_i203.ReadingProgressRepository>(
      () => _i403.ReadingProgressRepositoryImpl(
        gh<_i607.ReadingHistoryLocalDataSource>(),
      ),
    );
    gh.singleton<_i729.AudioCubit>(
      () => _i729.AudioCubit(
        gh<_i556.PlayAudio>(),
        gh<_i665.PauseAudio>(),
        gh<_i748.ResumeAudio>(),
        gh<_i710.StopAudio>(),
        gh<_i637.SeekAudio>(),
        gh<_i451.AudioRepository>(),
      ),
    );
    gh.factory<_i330.AudioStorageCubit>(
      () => _i330.AudioStorageCubit(
        gh<_i232.GetDownloadedAyats>(),
        gh<_i380.DeleteAyatAudio>(),
        gh<_i425.DeleteAllAudio>(),
      ),
    );
    gh.lazySingleton<_i696.GetShalatByDate>(
      () => _i696.GetShalatByDate(gh<_i278.StatistikShalatRepository>()),
    );
    gh.lazySingleton<_i302.GetShalatByDateRange>(
      () => _i302.GetShalatByDateRange(gh<_i278.StatistikShalatRepository>()),
    );
    gh.lazySingleton<_i525.GetShalatStats>(
      () => _i525.GetShalatStats(gh<_i278.StatistikShalatRepository>()),
    );
    gh.lazySingleton<_i413.SaveShalatLog>(
      () => _i413.SaveShalatLog(gh<_i278.StatistikShalatRepository>()),
    );
    gh.factory<_i83.JadwalShalatCubit>(
      () => _i83.JadwalShalatCubit(
        gh<_i598.GetProvinsiShalat>(),
        gh<_i173.GetKabkotaShalat>(),
        gh<_i1042.GetJadwalShalat>(),
        gh<_i88.GetLastLocationShalat>(),
        gh<_i584.SaveLastLocationShalat>(),
        gh<_i177.LocationService>(),
        gh<_i804.ShalatNotificationScheduler>(),
        gh<_i8.GetShalatNotifPrefs>(),
        gh<_i69.SaveShalatNotifPrefs>(),
      ),
    );
    gh.lazySingleton<_i36.ImsakiyahRepository>(
      () => _i648.ImsakiyahRepositoryImpl(
        gh<_i575.ImsakiyahRemoteDataSource>(),
        gh<_i555.ImsakiyahLocalDataSource>(),
      ),
    );
    gh.factory<_i321.CatatanAyatRepository>(
      () => _i410.CatatanAyatRepositoryImpl(
        gh<_i289.CatatanAyatLocalDatasource>(),
      ),
    );
    gh.factory<_i115.GetSuratDetail>(
      () => _i115.GetSuratDetail(gh<_i246.SuratDetailRepository>()),
    );
    gh.lazySingleton<_i1057.ShalatChecklistReminderScheduler>(
      () => _i1057.ShalatChecklistReminderScheduler(
        gh<_i175.NotificationService>(),
        gh<_i163.FlutterLocalNotificationsPlugin>(),
      ),
    );
    gh.factory<_i451.DeleteCatatan>(
      () => _i451.DeleteCatatan(gh<_i321.CatatanAyatRepository>()),
    );
    gh.factory<_i508.GetAllCatatan>(
      () => _i508.GetAllCatatan(gh<_i321.CatatanAyatRepository>()),
    );
    gh.factory<_i563.GetCatatanByAyat>(
      () => _i563.GetCatatanByAyat(gh<_i321.CatatanAyatRepository>()),
    );
    gh.factory<_i559.SaveCatatan>(
      () => _i559.SaveCatatan(gh<_i321.CatatanAyatRepository>()),
    );
    gh.singleton<_i443.QuranReminderCubit>(
      () => _i443.QuranReminderCubit(
        gh<_i23.GetQuranReminderPrefs>(),
        gh<_i0.SaveQuranReminderPrefs>(),
        gh<_i745.QuranReminderScheduler>(),
      ),
    );
    gh.factory<_i238.QiblaCubit>(
      () => _i238.QiblaCubit(
        initQibla: gh<_i321.InitQibla>(),
        watchQiblaDirection: gh<_i247.WatchQiblaDirection>(),
      ),
    );
    gh.lazySingleton<_i647.SuratRepository>(
      () => _i291.SuratRepositoryImpl(
        gh<_i1071.SuratRemoteDataSource>(),
        gh<_i107.SuratLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i485.TafsirRepository>(
      () => _i734.TafsirRepositoryImpl(
        gh<_i713.TafsirRemoteDataSource>(),
        gh<_i398.TafsirLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i420.DoaRepository>(
      () => _i164.DoaRepositoryImpl(
        gh<_i34.DoaRemoteDataSource>(),
        gh<_i547.DoaLocalDataSource>(),
      ),
    );
    gh.factory<_i914.CatatanAyatCubit>(
      () => _i914.CatatanAyatCubit(
        gh<_i508.GetAllCatatan>(),
        gh<_i559.SaveCatatan>(),
        gh<_i451.DeleteCatatan>(),
      ),
    );
    gh.factory<_i291.GetSuratList>(
      () => _i291.GetSuratList(gh<_i647.SuratRepository>()),
    );
    gh.lazySingleton<_i230.CleanupOldReadingData>(
      () => _i230.CleanupOldReadingData(gh<_i203.ReadingProgressRepository>()),
    );
    gh.lazySingleton<_i251.GetReadingHistoryByDate>(
      () =>
          _i251.GetReadingHistoryByDate(gh<_i203.ReadingProgressRepository>()),
    );
    gh.lazySingleton<_i821.GetReadingStats>(
      () => _i821.GetReadingStats(gh<_i203.ReadingProgressRepository>()),
    );
    gh.lazySingleton<_i91.SaveAyatRead>(
      () => _i91.SaveAyatRead(gh<_i203.ReadingProgressRepository>()),
    );
    gh.lazySingleton<_i91.SaveAyatReadBatch>(
      () => _i91.SaveAyatReadBatch(gh<_i203.ReadingProgressRepository>()),
    );
    gh.factory<_i265.StatistikShalatCubit>(
      () => _i265.StatistikShalatCubit(
        gh<_i696.GetShalatByDate>(),
        gh<_i525.GetShalatStats>(),
        gh<_i413.SaveShalatLog>(),
      ),
    );
    gh.lazySingleton<_i1068.TasbihCubit>(
      () => _i1068.TasbihCubit(
        gh<_i998.GetTasbihSessions>(),
        gh<_i259.SaveTasbihSession>(),
        gh<_i1029.DeleteTasbihSession>(),
        gh<_i603.ClearTasbihSessions>(),
      ),
    );
    gh.singleton<_i69.QuranStreakCubit>(
      () => _i69.QuranStreakCubit(
        gh<_i458.GetStreakCount>(),
        gh<_i659.RecordQuranRead>(),
      ),
    );
    gh.factory<_i422.GetDoaDetail>(
      () => _i422.GetDoaDetail(gh<_i420.DoaRepository>()),
    );
    gh.factory<_i254.GetDoaList>(
      () => _i254.GetDoaList(gh<_i420.DoaRepository>()),
    );
    gh.lazySingleton<_i28.GetImsakiyah>(
      () => _i28.GetImsakiyah(gh<_i36.ImsakiyahRepository>()),
    );
    gh.lazySingleton<_i815.GetKabkota>(
      () => _i815.GetKabkota(gh<_i36.ImsakiyahRepository>()),
    );
    gh.lazySingleton<_i387.GetLastLocationImsakiyah>(
      () => _i387.GetLastLocationImsakiyah(gh<_i36.ImsakiyahRepository>()),
    );
    gh.lazySingleton<_i410.GetProvinsi>(
      () => _i410.GetProvinsi(gh<_i36.ImsakiyahRepository>()),
    );
    gh.lazySingleton<_i1070.SaveLastLocationImsakiyah>(
      () => _i1070.SaveLastLocationImsakiyah(gh<_i36.ImsakiyahRepository>()),
    );
    gh.factory<_i438.SuratDetailCubit>(
      () => _i438.SuratDetailCubit(gh<_i115.GetSuratDetail>()),
    );
    gh.factory<_i160.GetTafsir>(
      () => _i160.GetTafsir(gh<_i485.TafsirRepository>()),
    );
    gh.factory<_i290.DoaDetailCubit>(
      () => _i290.DoaDetailCubit(
        gh<_i422.GetDoaDetail>(),
        gh<_i254.GetDoaBookmarks>(),
        gh<_i107.ToggleDoaBookmark>(),
      ),
    );
    gh.lazySingleton<_i663.HafalanRepository>(
      () => _i804.HafalanRepositoryImpl(gh<_i445.HafalanLocalDatasource>()),
    );
    gh.factory<_i165.ImsakiyahCubit>(
      () => _i165.ImsakiyahCubit(
        gh<_i410.GetProvinsi>(),
        gh<_i815.GetKabkota>(),
        gh<_i28.GetImsakiyah>(),
        gh<_i387.GetLastLocationImsakiyah>(),
        gh<_i1070.SaveLastLocationImsakiyah>(),
        gh<_i177.LocationService>(),
      ),
    );
    gh.factory<_i345.DoaListCubit>(
      () => _i345.DoaListCubit(gh<_i254.GetDoaList>()),
    );
    gh.factory<_i974.TafsirCubit>(
      () => _i974.TafsirCubit(gh<_i160.GetTafsir>()),
    );
    gh.factory<_i334.SuratListCubit>(
      () => _i334.SuratListCubit(gh<_i291.GetSuratList>()),
    );
    gh.factory<_i924.ReadingProgressCubit>(
      () => _i924.ReadingProgressCubit(
        gh<_i821.GetReadingStats>(),
        gh<_i91.SaveAyatReadBatch>(),
        gh<_i230.CleanupOldReadingData>(),
      ),
    );
    gh.factory<_i194.BookmarkCubit>(
      () => _i194.BookmarkCubit(
        gh<_i1008.GetBookmarks>(),
        gh<_i749.AddBookmark>(),
        gh<_i778.RemoveBookmark>(),
        gh<_i994.GetLastRead>(),
        gh<_i187.SaveLastRead>(),
        gh<_i254.GetDoaBookmarks>(),
        gh<_i254.GetDoaList>(),
        gh<_i107.ToggleDoaBookmark>(),
      ),
    );
    gh.factory<_i29.DeleteHafalanSurat>(
      () => _i29.DeleteHafalanSurat(gh<_i663.HafalanRepository>()),
    );
    gh.factory<_i7.GetAllHafalan>(
      () => _i7.GetAllHafalan(gh<_i663.HafalanRepository>()),
    );
    gh.factory<_i539.GetHafalanBySurat>(
      () => _i539.GetHafalanBySurat(gh<_i663.HafalanRepository>()),
    );
    gh.factory<_i868.GetHafalanStats>(
      () => _i868.GetHafalanStats(gh<_i663.HafalanRepository>()),
    );
    gh.factory<_i702.SaveHafalanSurat>(
      () => _i702.SaveHafalanSurat(gh<_i663.HafalanRepository>()),
    );
    gh.lazySingleton<_i538.HafalanCubit>(
      () => _i538.HafalanCubit(
        gh<_i7.GetAllHafalan>(),
        gh<_i702.SaveHafalanSurat>(),
        gh<_i29.DeleteHafalanSurat>(),
        gh<_i868.GetHafalanStats>(),
        gh<_i480.HafalanReminderScheduler>(),
      ),
    );
    return this;
  }
}

class _$AudioServiceModule extends _i718.AudioServiceModule {}

class _$NotificationModule extends _i1066.NotificationModule {}

class _$HiveModule extends _i815.HiveModule {}
