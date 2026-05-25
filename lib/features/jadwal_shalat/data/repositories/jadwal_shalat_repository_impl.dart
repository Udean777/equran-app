import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/mappers/jadwal_shalat_mapper.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: JadwalShalatRepository)
class JadwalShalatRepositoryImpl implements JadwalShalatRepository {
  const JadwalShalatRepositoryImpl(this._remote, this._local);

  final JadwalShalatRemoteDataSource _remote;
  final JadwalShalatLocalDataSource _local;

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
  Future<Either<Failure, JadwalShalat>> getJadwalShalat({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
  }) async {
    final cached = await _local.getCachedJadwalShalat(
      provinsi,
      kabkota,
      bulan,
      tahun,
    );
    if (cached != null) return right(cached.toEntity());

    return executeRequest(() async {
      final dto = await _remote.fetchJadwalShalat(
        provinsi: provinsi,
        kabkota: kabkota,
        bulan: bulan,
        tahun: tahun,
      );
      await _local.cacheJadwalShalat(dto.data);
      return dto.data.toEntity();
    });
  }
}
