import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/tafsir/data/datasources/tafsir_local_data_source.dart';
import 'package:equran_app/features/tafsir/data/datasources/tafsir_remote_data_source.dart';
import 'package:equran_app/features/tafsir/data/mappers/tafsir_mapper.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';
import 'package:equran_app/features/tafsir/domain/repositories/tafsir_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TafsirRepository)
class TafsirRepositoryImpl implements TafsirRepository {
  const TafsirRepositoryImpl(this._remote, this._local);

  final TafsirRemoteDataSource _remote;
  final TafsirLocalDataSource _local;

  @override
  Future<Either<Failure, TafsirSurat>> getTafsir(int nomor) async {
    // Cache-first
    final cached = await _local.getCachedTafsir(nomor);
    if (cached != null) {
      return right(cached.toEntity());
    }

    // Network fallback
    return executeRequest(() async {
      final dto = await _remote.fetchTafsir(nomor);
      await _local.cacheTafsir(nomor, dto.data);
      return dto.data.toEntity();
    });
  }
}
