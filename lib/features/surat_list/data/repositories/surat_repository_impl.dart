import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/surat_list/data/datasources/surat_local_data_source.dart';
import 'package:equran_app/features/surat_list/data/datasources/surat_remote_data_source.dart';
import 'package:equran_app/features/surat_list/data/mappers/surat_mapper.dart';
import 'package:equran_app/features/surat_list/domain/repositories/surat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SuratRepository)
class SuratRepositoryImpl implements SuratRepository {
  const SuratRepositoryImpl(this._remote, this._local);

  final SuratRemoteDataSource _remote;
  final SuratLocalDataSource _local;

  @override
  Future<Either<Failure, List<Surat>>> getAllSurat() async {
    // Cache-first
    final cached = await _local.getCachedSuratList();
    if (cached != null && cached.isNotEmpty) {
      return right(cached.map((e) => e.toEntity()).toList());
    }

    // Network fallback
    return executeRequest(() async {
      final dto = await _remote.fetchSuratList();
      await _local.cacheSuratList(dto.data);
      return dto.data.map((e) => e.toEntity()).toList();
    });
  }
}
