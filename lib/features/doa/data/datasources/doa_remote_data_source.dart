import 'package:dio/dio.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/features/doa/data/models/doa_dto.dart';

abstract interface class DoaRemoteDataSource {
  Future<DoaListResponseDto> fetchDoaList();
  Future<DoaDetailResponseDto> fetchDoaDetail(int id);
}

class DoaRemoteDataSourceImpl implements DoaRemoteDataSource {
  const DoaRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<DoaListResponseDto> fetchDoaList() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.doaListUrl(),
    );
    return DoaListResponseDto.fromJson(response.data!);
  }

  @override
  Future<DoaDetailResponseDto> fetchDoaDetail(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.doaDetailUrl(id),
    );
    return DoaDetailResponseDto.fromJson(response.data!);
  }
}
