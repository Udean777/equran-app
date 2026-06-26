import 'package:dio/dio.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';

abstract interface class SuratRemoteDataSource {
  Future<SuratListResponseDto> fetchSuratList();
}

class SuratRemoteDataSourceImpl implements SuratRemoteDataSource {
  const SuratRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<SuratListResponseDto> fetchSuratList() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.suratList,
    );
    return SuratListResponseDto.fromJson(response.data!);
  }
}
