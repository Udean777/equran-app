import 'package:dio/dio.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDioClient mockDioClient;
  late MockDio mockDio;
  late ImsakiyahRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    dataSource = ImsakiyahRemoteDataSourceImpl(mockDioClient);
  });

  group('fetchProvinsi', () {
    test('mengembalikan ProvinsiResponseDto saat sukses', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          ApiEndpoints.imsakiyahProvinsi,
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'code': 200,
            'message': 'Data retrieved successfully',
            'data': tProvinsiList,
          },
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.fetchProvinsi();

      expect(result.data, tProvinsiList);
    });
  });

  group('fetchKabkota', () {
    test('mengembalikan KabkotaResponseDto saat sukses', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          ApiEndpoints.imsakiyahKabkota,
          queryParameters: {'provinsi': 'Sumatera Utara'},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'code': 200,
            'message': 'Data retrieved successfully',
            'data': tKabkotaList,
          },
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.fetchKabkota('Sumatera Utara');

      expect(result.data, tKabkotaList);
    });
  });

  group('fetchImsakiyah', () {
    test('mengembalikan ImsakiyahResponseDto saat sukses', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          ApiEndpoints.imsakiyah,
          queryParameters: {
            'provinsi': 'Sumatera Utara',
            'kabkota': 'Kab. Deli Serdang',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'code': 200,
            'message': 'Jadwal imsakiyah berhasil diambil',
            'data': {
              'provinsi': 'Sumatera Utara',
              'kabkota': 'Kab. Deli Serdang',
              'hijriah': '1447',
              'masehi': '2026',
              'imsakiyah': [
                {
                  'tanggal': 1,
                  'imsak': '05:12',
                  'subuh': '05:22',
                  'terbit': '06:35',
                  'dhuha': '07:02',
                  'dzuhur': '12:42',
                  'ashar': '16:00',
                  'maghrib': '18:42',
                  'isya': '19:51',
                },
              ],
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.fetchImsakiyah(
        provinsi: 'Sumatera Utara',
        kabkota: 'Kab. Deli Serdang',
      );

      expect(result.data.provinsi, 'Sumatera Utara');
      expect(result.data.kabkota, 'Kab. Deli Serdang');
      expect(result.data.imsakiyah.length, 1);
    });
  });
}
