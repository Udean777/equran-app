// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:equran_app/core/cache/hive_module.dart' as _i815;
import 'package:equran_app/core/network/dio_client.dart' as _i870;
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
      () => hiveModule.suratBox(),
      instanceName: 'suratBox',
      preResolve: true,
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
    gh.lazySingleton<_i1071.SuratRemoteDataSource>(
      () => _i1071.SuratRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i959.SuratDetailRemoteDataSource>(
      () => _i959.SuratDetailRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i107.SuratLocalDataSource>(
      () => _i107.SuratLocalDataSourceImpl(
        gh<_i738.Box<dynamic>>(instanceName: 'suratBox'),
      ),
    );
    gh.lazySingleton<_i713.TafsirRemoteDataSource>(
      () => _i713.TafsirRemoteDataSourceImpl(gh<_i870.DioClient>()),
    );
    gh.lazySingleton<_i246.SuratDetailRepository>(
      () => _i992.SuratDetailRepositoryImpl(
        gh<_i959.SuratDetailRemoteDataSource>(),
        gh<_i349.SuratDetailLocalDataSource>(),
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
    gh.factory<_i291.GetSuratList>(
      () => _i291.GetSuratList(gh<_i647.SuratRepository>()),
    );
    gh.factory<_i438.SuratDetailCubit>(
      () => _i438.SuratDetailCubit(gh<_i115.GetSuratDetail>()),
    );
    gh.factory<_i160.GetTafsir>(
      () => _i160.GetTafsir(gh<_i485.TafsirRepository>()),
    );
    gh.factory<_i974.TafsirCubit>(
      () => _i974.TafsirCubit(gh<_i160.GetTafsir>()),
    );
    gh.factory<_i334.SuratListCubit>(
      () => _i334.SuratListCubit(gh<_i291.GetSuratList>()),
    );
    return this;
  }
}

class _$HiveModule extends _i815.HiveModule {}
