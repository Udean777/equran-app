import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_local_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_remote_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/mappers/imsakiyah_mapper.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ImsakiyahRepository)
class ImsakiyahRepositoryImpl implements ImsakiyahRepository {
  const ImsakiyahRepositoryImpl(this._remote, this._local);

  final ImsakiyahRemoteDataSource _remote;
  final ImsakiyahLocalDataSource _local;

  @override
  Future<Either<Failure, List<String>>> getProvinsi() async {
    final cached = await _local.getCachedProvinsi();
    if (cached != null && cached.isNotEmpty) return right(cached);

    return executeRequest(() async {
      final dto = await _remote.fetchProvinsi();
      await _local.cacheProvinsi(dto.data);
      return dto.data;
    });
  }

  @override
  Future<Either<Failure, List<String>>> getKabkota(String provinsi) async {
    final cached = await _local.getCachedKabkota(provinsi);
    if (cached != null && cached.isNotEmpty) return right(cached);

    return executeRequest(() async {
      final dto = await _remote.fetchKabkota(provinsi);
      await _local.cacheKabkota(provinsi, dto.data);
      return dto.data;
    });
  }

  @override
  Future<Either<Failure, Imsakiyah>> getImsakiyah({
    required String provinsi,
    required String kabkota,
  }) async {
    final cached = await _local.getCachedImsakiyah(provinsi, kabkota);
    if (cached != null) return right(cached.toEntity());

    return executeRequest(() async {
      final dto = await _remote.fetchImsakiyah(
        provinsi: provinsi,
        kabkota: kabkota,
      );
      await _local.cacheImsakiyah(dto.data);
      return dto.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, String?>> getLastProvinsi() async {
    try {
      return right(await _local.getLastProvinsi());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastProvinsi(String provinsi) async {
    try {
      await _local.saveLastProvinsi(provinsi);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getLastKabkota() async {
    try {
      return right(await _local.getLastKabkota());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastKabkota(String kabkota) async {
    try {
      await _local.saveLastKabkota(kabkota);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
