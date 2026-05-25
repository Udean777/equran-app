import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/tafsir/data/models/tafsir_dto.dart';
import 'package:injectable/injectable.dart';

abstract interface class TafsirRemoteDataSource {
  Future<TafsirResponseDto> fetchTafsir(int nomor);
}

@LazySingleton(as: TafsirRemoteDataSource)
class TafsirRemoteDataSourceImpl implements TafsirRemoteDataSource {
  const TafsirRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<TafsirResponseDto> fetchTafsir(int nomor) async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      ApiEndpoints.tafsir(nomor),
    );
    return TafsirResponseDto.fromJson(response.data!);
  }
}
