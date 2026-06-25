import 'package:dio/dio.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/hafalan/constants/hafalan_constants.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';

abstract interface class HafalanCompareDataSource {
  Future<SetoranCompareResult> compare({
    required String audioFilePath,
    required String targetText,
    double threshold = HafalanConstants.defaultThreshold,
  });

  /// Ping health endpoint to warm up server.
  Future<void> warmUp();
}

class HafalanCompareDataSourceImpl implements HafalanCompareDataSource {
  const HafalanCompareDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<SetoranCompareResult> compare({
    required String audioFilePath,
    required String targetText,
    double threshold = HafalanConstants.defaultThreshold,
  }) async {
    final formData = FormData.fromMap({
      'user_audio': await MultipartFile.fromFile(
        audioFilePath,
        filename: 'recording.m4a',
      ),
      'target_text': targetText,
      'threshold': threshold.toString(),
    });

    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      '${HafalanConstants.apiBaseUrl}/compare',
      data: formData,
      options: Options(
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 60),
      ),
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response from comparison server');
    }
    return SetoranCompareResult.fromJson(data);
  }

  @override
  Future<void> warmUp() async {
    await _dioClient.dio.get<Map<String, dynamic>>(
      '${HafalanConstants.apiBaseUrl}/health',
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }
}
