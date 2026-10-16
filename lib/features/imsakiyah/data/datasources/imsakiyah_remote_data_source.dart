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
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.imsakiyah,
        data: {'provinsi': provinsi, 'kabkota': kabkota},
      );
      return ImsakiyahResponseDto.fromJson(response.data!);
    } on DioException catch (error) {
      // Imsakiyah is a Ramadan-only dataset. Outside Ramadan the API returns
      // 404, while the year-round shalat endpoint still provides imsak and
      // all prayer times for the selected location.
      if (error.response?.statusCode != 404) rethrow;

      final now = DateTime.now();
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.shalat,
        data: {
          'provinsi': provinsi,
          'kabkota': kabkota,
          'bulan': now.month,
          'tahun': now.year,
        },
      );

      return _fromJadwalShalatResponse(
        response.data!,
        fallbackProvinsi: provinsi,
        fallbackKabkota: kabkota,
        fallbackTahun: now.year,
      );
    }
  }

  ImsakiyahResponseDto _fromJadwalShalatResponse(
    Map<String, dynamic> json, {
    required String fallbackProvinsi,
    required String fallbackKabkota,
    required int fallbackTahun,
  }) {
    final rawData = json['data'];
    if (rawData is! Map) {
      throw const FormatException(
        'Response jadwal shalat tidak memiliki data yang valid.',
      );
    }

    final data = rawData.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final rawJadwal = data['jadwal'];
    if (rawJadwal is! List) {
      throw const FormatException(
        'Response jadwal shalat tidak memiliki daftar jadwal.',
      );
    }

    return ImsakiyahResponseDto.fromJson({
      'code': (json['code'] as num?)?.toInt() ?? 200,
      'message': json['message'] as String? ?? 'Jadwal shalat berhasil diambil',
      'data': {
        'provinsi': data['provinsi'] ?? fallbackProvinsi,
        'kabkota': data['kabkota'] ?? fallbackKabkota,
        // These fields are only metadata for the Ramadan response. Keep the
        // DTO contract while making the year-round fallback explicit.
        'hijriah': 'Jadwal shalat',
        'masehi': '${data['tahun'] ?? fallbackTahun}',
        'imsakiyah': rawJadwal,
      },
    });
  }
}
