import 'package:dio/dio.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/hafalan/constants/hafalan_constants.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:injectable/injectable.dart';

abstract interface class HafalanCompareDataSource {
  Future<SetoranCompareResult> compare({
    required String audioFilePath,
    required String targetText,
    double threshold = HafalanConstants.defaultThreshold,
  });
}

@LazySingleton(as: HafalanCompareDataSource)
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
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response from comparison server');
    }
    return SetoranCompareResult.fromJson(data);
  }
}
