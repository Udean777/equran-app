import 'package:dio/dio.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/features/tafsir/data/models/tafsir_dto.dart';

abstract interface class TafsirRemoteDataSource {
  Future<TafsirResponseDto> fetchTafsir(int nomor);
}

class TafsirRemoteDataSourceImpl implements TafsirRemoteDataSource {
  const TafsirRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<TafsirResponseDto> fetchTafsir(int nomor) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.tafsir(nomor),
    );
    return TafsirResponseDto.fromJson(response.data!);
  }
}
