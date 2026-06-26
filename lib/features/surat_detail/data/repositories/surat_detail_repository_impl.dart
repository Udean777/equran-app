import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/surat_detail/data/datasources/surat_detail_local_data_source.dart';
import 'package:equran_app/features/surat_detail/data/datasources/surat_detail_remote_data_source.dart';
import 'package:equran_app/features/surat_detail/data/mappers/surat_detail_mapper.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/domain/repositories/surat_detail_repository.dart';
import 'package:fpdart/fpdart.dart';

class SuratDetailRepositoryImpl implements SuratDetailRepository {
  const SuratDetailRepositoryImpl(this._remote, this._local);

  final SuratDetailRemoteDataSource _remote;
  final SuratDetailLocalDataSource _local;

  @override
  Future<Either<Failure, SuratDetail>> getSuratDetail(int nomor) async {
    // Cache-first — fall through to network on error
    try {
      final cached = await _local.getCachedSuratDetail(nomor);
      if (cached != null) {
        return right(cached.toEntity());
      }
    } on Object {
      // Cache error — ignore, try network
    }

    return executeRequest(() async {
      final dto = await _remote.fetchSuratDetail(nomor);
      await _local.cacheSuratDetail(nomor, dto.data);
      return dto.data.toEntity();
    });
  }
}
