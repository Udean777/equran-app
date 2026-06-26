import 'package:dio/dio.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/features/imsakiyah/data/models/imsakiyah_dto.dart';

abstract interface class ImsakiyahRemoteDataSource {
  Future<ProvinsiResponseDto> fetchProvinsi();
  Future<KabkotaResponseDto> fetchKabkota(String provinsi);
  Future<ImsakiyahResponseDto> fetchImsakiyah({
    required String provinsi,
    required String kabkota,
  });
}

class ImsakiyahRemoteDataSourceImpl implements ImsakiyahRemoteDataSource {
  const ImsakiyahRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ProvinsiResponseDto> fetchProvinsi() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.imsakiyahProvinsi,
    );
    return ProvinsiResponseDto.fromJson(response.data!);
  }

  @override
  Future<KabkotaResponseDto> fetchKabkota(String provinsi) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.imsakiyahKabkota,
      data: {'provinsi': provinsi},
    );
    return KabkotaResponseDto.fromJson(response.data!);
  }

  @override
  Future<ImsakiyahResponseDto> fetchImsakiyah({
    required String provinsi,
    required String kabkota,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.imsakiyah,
      data: {'provinsi': provinsi, 'kabkota': kabkota},
    );
    return ImsakiyahResponseDto.fromJson(response.data!);
  }
}
