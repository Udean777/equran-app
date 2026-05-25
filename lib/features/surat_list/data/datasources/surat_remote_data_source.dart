import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';
import 'package:injectable/injectable.dart';

abstract interface class SuratRemoteDataSource {
  Future<SuratListResponseDto> fetchSuratList();
}

@LazySingleton(as: SuratRemoteDataSource)
class SuratRemoteDataSourceImpl implements SuratRemoteDataSource {
  const SuratRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<SuratListResponseDto> fetchSuratList() async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      ApiEndpoints.suratList,
    );
    return SuratListResponseDto.fromJson(response.data!);
  }
}
