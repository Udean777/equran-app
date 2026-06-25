import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HafalanCompareRepository {
  Future<Either<Failure, SetoranCompareResult>> compare({
    required String audioFilePath,
    required String targetText,
    double threshold = 75.0,
  });

  /// Ping health endpoint to warm up server (pre-load model).
  Future<Either<Failure, void>> warmUp();
}
