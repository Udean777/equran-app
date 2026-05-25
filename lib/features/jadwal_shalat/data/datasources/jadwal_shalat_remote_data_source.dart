import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/jadwal_shalat/data/models/jadwal_shalat_dto.dart';
import 'package:injectable/injectable.dart';

abstract interface class JadwalShalatRemoteDataSource {
  Future<ProvinsiShalatResponseDto> fetchProvinsi();
  Future<KabkotaShalatResponseDto> fetchKabkota(String provinsi);
  Future<JadwalShalatResponseDto> fetchJadwalShalat({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
  });
}

@LazySingleton(as: JadwalShalatRemoteDataSource)
class JadwalShalatRemoteDataSourceImpl implements JadwalShalatRemoteDataSource {
  const JadwalShalatRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<ProvinsiShalatResponseDto> fetchProvinsi() async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      ApiEndpoints.shalatProvinsi,
    );
    return ProvinsiShalatResponseDto.fromJson(response.data!);
  }

  @override
  Future<KabkotaShalatResponseDto> fetchKabkota(String provinsi) async {
    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      ApiEndpoints.shalatKabkota,
      data: {'provinsi': provinsi},
    );
    return KabkotaShalatResponseDto.fromJson(response.data!);
  }

  @override
  Future<JadwalShalatResponseDto> fetchJadwalShalat({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
  }) async {
    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      ApiEndpoints.shalat,
      data: {
        'provinsi': provinsi,
        'kabkota': kabkota,
        'bulan': bulan,
        'tahun': tahun,
      },
    );
    return JadwalShalatResponseDto.fromJson(response.data!);
  }
}
