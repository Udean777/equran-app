import 'package:dio/dio.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/data/datasources/hafalan_compare_datasource.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_compare_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HafalanCompareRepository)
class HafalanCompareRepositoryImpl implements HafalanCompareRepository {
  const HafalanCompareRepositoryImpl(this._dataSource);

  final HafalanCompareDataSource _dataSource;

  @override
  Future<Either<Failure, SetoranCompareResult>> compare({
    required String audioFilePath,
    required String targetText,
    double threshold = 75.0,
  }) async {
    try {
      final result = await _dataSource.compare(
        audioFilePath: audioFilePath,
        targetText: targetText,
        threshold: threshold,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const Failure.network();
    }
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      if (statusCode != null) {
        return Failure.server(statusCode: statusCode);
      }
    }
    return Failure.unknown(message: e.message ?? 'Unknown Dio error');
  }
}
