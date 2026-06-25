import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_cache_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_remote_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/mappers/imsakiyah_mapper.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:fpdart/fpdart.dart';

class ImsakiyahRepositoryImpl implements ImsakiyahRepository {
  const ImsakiyahRepositoryImpl(this._remote, this._cache);

  final ImsakiyahRemoteDataSource _remote;
  final ImsakiyahCacheDataSource _cache;

  @override
  Future<Either<Failure, List<String>>> getProvinsi() async {
    final cached = await _cache.getCachedProvinsi();
    if (cached != null && cached.isNotEmpty) return right(cached);

    return executeRequest(() async {
      final dto = await _remote.fetchProvinsi();
      await _cache.cacheProvinsi(dto.data);
      return dto.data;
    });
  }

  @override
  Future<Either<Failure, List<String>>> getKabkota(String provinsi) async {
    final cached = await _cache.getCachedKabkota(provinsi);
    if (cached != null && cached.isNotEmpty) return right(cached);

    return executeRequest(() async {
      final dto = await _remote.fetchKabkota(provinsi);
      await _cache.cacheKabkota(provinsi, dto.data);
      return dto.data;
    });
  }

  @override
  Future<Either<Failure, Imsakiyah>> getImsakiyah({
    required String provinsi,
    required String kabkota,
  }) async {
    final cached = await _cache.getCachedImsakiyah(provinsi, kabkota);
    if (cached != null) return right(cached.toEntity());

    return executeRequest(() async {
      final dto = await _remote.fetchImsakiyah(
        provinsi: provinsi,
        kabkota: kabkota,
      );
      await _cache.cacheImsakiyah(dto.data);
      return dto.data.toEntity();
    });
  }
}
