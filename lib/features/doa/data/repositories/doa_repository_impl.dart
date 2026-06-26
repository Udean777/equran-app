import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/doa/data/datasources/doa_local_data_source.dart';
import 'package:equran_app/features/doa/data/datasources/doa_remote_data_source.dart';
import 'package:equran_app/features/doa/data/mappers/doa_mapper.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/repositories/doa_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoaRepositoryImpl implements DoaRepository {
  const DoaRepositoryImpl(this._remote, this._local);

  final DoaRemoteDataSource _remote;
  final DoaLocalDataSource _local;

  @override
  Future<Either<Failure, List<Doa>>> getDoaList() async {
    // Cache-first
    final cached = await _local.getCachedDoaList();
    if (cached != null && cached.isNotEmpty) {
      return right(cached.map((e) => e.toEntity()).toList());
    }

    // Network fallback
    return executeRequest(() async {
      final dto = await _remote.fetchDoaList();
      await _local.cacheDoaList(dto.data);
      return dto.data.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Doa>> getDoaDetail(int id) async {
    // Cache-first
    final cached = await _local.getCachedDoaDetail(id);
    if (cached != null) {
      return right(cached.toEntity());
    }

    // Network fallback
    return executeRequest(() async {
      final dto = await _remote.fetchDoaDetail(id);
      await _local.cacheDoaDetail(id, dto.data);
      return dto.data.toEntity();
    });
  }
}
