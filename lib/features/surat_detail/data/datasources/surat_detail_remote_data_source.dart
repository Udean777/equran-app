import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/surat_detail/data/models/surat_detail_dto.dart';

abstract interface class SuratDetailRemoteDataSource {
  Future<SuratDetailResponseDto> fetchSuratDetail(int nomor);
}

class SuratDetailRemoteDataSourceImpl implements SuratDetailRemoteDataSource {
  const SuratDetailRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<SuratDetailResponseDto> fetchSuratDetail(int nomor) async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      ApiEndpoints.suratDetail(nomor),
    );
    return SuratDetailResponseDto.fromJson(response.data!);
  }
}
