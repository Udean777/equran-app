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
import 'package:equran_app/core/network/dio_client.dart' as _i870;
import 'package:equran_app/core/theme/cubit/theme_cubit.dart' as _i729;
import 'package:equran_app/features/audio/data/datasources/audio_player_data_source.dart'
    as _i945;
import 'package:equran_app/features/audio/data/repositories/audio_repository_impl.dart'
    as _i550;
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart'
    as _i451;
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
import 'package:equran_app/features/bookmark/domain/usecases/is_bookmarked.dart'
    as _i46;
import 'package:equran_app/features/bookmark/domain/usecases/remove_bookmark.dart'
    as _i778;
import 'package:equran_app/features/bookmark/domain/usecases/save_last_read.dart'
    as _i187;
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart'
    as _i194;
import 'package:equran_app/features/doa/data/datasources/doa_local_data_source.dart'
    as _i547;
import 'package:equran_app/features/doa/data/datasources/doa_remote_data_source.dart'
    as _i34;
import 'package:equran_app/features/doa/data/repositories/doa_repository_impl.dart'
    as _i164;
import 'package:equran_app/features/doa/domain/repositories/doa_repository.dart'
    as _i420;
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart'
    as _i422;
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart'
    as _i254;
import 'package:equran_app/features/doa/presentation/cubit/doa_detail_cubit.dart'
    as _i290;
import 'package:equran_app/features/doa/presentation/cubit/doa_list_cubit.dart'
    as _i345;
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_local_data_source.dart'
    as _i555;
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_remote_data_source.dart'
    as _i575;
import 'package:equran_app/features/imsakiyah/data/repositories/imsakiyah_repository_impl.dart'
    as _i648;
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart'
    as _i36;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart'
    as _i28;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart'
    as _i815;
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart'
    as _i410;
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsakiyah_cubit.dart'
    as _i165;
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
    final hiveModule = _$HiveModule();
    gh.singleton<_i870.DioClient>(() => _i870.DioClient());
    await gh.factoryAsync<_i919.Box<dynamic>>(
      () => hiveModule.tafsirBox(),
      instanceName: 'tafsirBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<dynamic>>(
      () => hiveModule.settingsBox(),
      instanceName: 'settingsBox',
      preResolve: true,
    );
    gh.singleton<_i945.AudioPlayerDataSource>(
      () => _i945.AudioPlayerDataSourceImpl(),
    );
    await gh.factoryAsync<_i919.Box<dynamic>>(
      () => hiveModule.imsakiyahBox(),
      instanceName: 'imsakiyahBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<dynamic>>(
      () => hiveModule.suratBox(),
      instanceName: 'suratBox',
      preResolve: true,
    );
    gh.singleton<_i157.LanguageCubit>(
      () => _i157.LanguageCubit(
        gh<_i738.Box<dynamic>>(instanceName: 'settingsBox'),
      ),
    );
    gh.singleton<_i729.ThemeCubit>(
      () =>
          _i729.ThemeCubit(gh<_i738.Box<dynamic>>(instanceName: 'settingsBox')),
    );
    await gh.factoryAsync<_i919.Box<dynamic>>(
      () => hiveModule.bookmarkBox(),
      instanceName: 'bookmarkBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i919.Box<dynamic>>(
      () => hiveModule.doaBox(),
      instanceName: 'doaBox',
      preResolve: true,
    );
    gh.lazySingleton<_i701.BookmarkLocalDataSource>(
      () => _i701.BookmarkLocalDataSourceImpl(
        gh<_i738.Box<dynamic>>(instanceName: 'bookmarkBox'),
      ),
    );
    gh.lazySingleton<_i555.ImsakiyahLocalDataSource>(
      () => _i555.ImsakiyahLocalDataSourceImpl(
        gh<_i738.Box<dynamic>>(instanceName: 'imsakiyahBox'),
      ),
    );
    gh.lazySingleton<_i398.TafsirLocalDataSource>(
      () => _i398.TafsirLocalDataSourceImpl(
        gh<_i738.Box<dynamic>>(instanceName: 'tafsirBox'),
      ),
    );
    gh.lazySingleton<_i349.SuratDetailLocalDataSource>(
      () => _i349.SuratDetailLocalDataSourceImpl(
        gh<_i738.Box<dynamic>>(instanceName: 'suratBox'),
      ),
    );
    gh.singleton<_i451.AudioRepository>(
      () => _i550.AudioRepositoryImpl(gh<_i945.AudioPlayerDataSource>()),
    );
    gh.lazySingleton<_i1071.SuratRemoteDataSource>(
      () => _i1071.SuratRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i575.ImsakiyahRemoteDataSource>(
      () => _i575.ImsakiyahRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i959.SuratDetailRemoteDataSource>(
      () => _i959.SuratDetailRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i107.SuratLocalDataSource>(
      () => _i107.SuratLocalDataSourceImpl(
        gh<_i738.Box<dynamic>>(instanceName: 'suratBox'),
      ),
    );
    gh.lazySingleton<_i547.DoaLocalDataSource>(
      () => _i547.DoaLocalDataSourceImpl(
        gh<_i738.Box<dynamic>>(instanceName: 'doaBox'),
      ),
    );
    gh.lazySingleton<_i713.TafsirRemoteDataSource>(
      () => _i713.TafsirRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i34.DoaRemoteDataSource>(
      () => _i34.DoaRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i246.SuratDetailRepository>(
      () => _i992.SuratDetailRepositoryImpl(
        gh<_i959.SuratDetailRemoteDataSource>(),
        gh<_i349.SuratDetailLocalDataSource>(),
      ),
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
    gh.lazySingleton<_i182.BookmarkRepository>(
      () => _i720.BookmarkRepositoryImpl(gh<_i701.BookmarkLocalDataSource>()),
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
    gh.factory<_i749.AddBookmark>(
      () => _i749.AddBookmark(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i1008.GetBookmarks>(
      () => _i1008.GetBookmarks(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i994.GetLastRead>(
      () => _i994.GetLastRead(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i46.IsBookmarked>(
      () => _i46.IsBookmarked(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i778.RemoveBookmark>(
      () => _i778.RemoveBookmark(gh<_i182.BookmarkRepository>()),
    );
    gh.factory<_i187.SaveLastRead>(
      () => _i187.SaveLastRead(gh<_i182.BookmarkRepository>()),
    );
    gh.lazySingleton<_i36.ImsakiyahRepository>(
      () => _i648.ImsakiyahRepositoryImpl(
        gh<_i575.ImsakiyahRemoteDataSource>(),
        gh<_i555.ImsakiyahLocalDataSource>(),
      ),
    );
    gh.factory<_i194.BookmarkCubit>(
      () => _i194.BookmarkCubit(
        gh<_i1008.GetBookmarks>(),
        gh<_i749.AddBookmark>(),
        gh<_i778.RemoveBookmark>(),
        gh<_i994.GetLastRead>(),
        gh<_i187.SaveLastRead>(),
      ),
    );
    gh.factory<_i115.GetSuratDetail>(
      () => _i115.GetSuratDetail(gh<_i246.SuratDetailRepository>()),
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
    gh.factory<_i291.GetSuratList>(
      () => _i291.GetSuratList(gh<_i647.SuratRepository>()),
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
    gh.lazySingleton<_i410.GetProvinsi>(
      () => _i410.GetProvinsi(gh<_i36.ImsakiyahRepository>()),
    );
    gh.factory<_i290.DoaDetailCubit>(
      () => _i290.DoaDetailCubit(gh<_i422.GetDoaDetail>()),
    );
    gh.factory<_i438.SuratDetailCubit>(
      () => _i438.SuratDetailCubit(gh<_i115.GetSuratDetail>()),
    );
    gh.factory<_i160.GetTafsir>(
      () => _i160.GetTafsir(gh<_i485.TafsirRepository>()),
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
    gh.factory<_i165.ImsakiyahCubit>(
      () => _i165.ImsakiyahCubit(
        gh<_i410.GetProvinsi>(),
        gh<_i815.GetKabkota>(),
        gh<_i28.GetImsakiyah>(),
        gh<_i555.ImsakiyahLocalDataSource>(),
      ),
    );
    return this;
  }
}

class _$HiveModule extends _i815.HiveModule {}
