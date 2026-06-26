import 'package:dio/dio.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/features/surat_detail/data/models/surat_detail_dto.dart';

abstract interface class SuratDetailRemoteDataSource {
  Future<SuratDetailResponseDto> fetchSuratDetail(int nomor);
}

class SuratDetailRemoteDataSourceImpl implements SuratDetailRemoteDataSource {
  const SuratDetailRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<SuratDetailResponseDto> fetchSuratDetail(int nomor) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.suratDetail(nomor),
    );
    return SuratDetailResponseDto.fromJson(response.data!);
  }
}
