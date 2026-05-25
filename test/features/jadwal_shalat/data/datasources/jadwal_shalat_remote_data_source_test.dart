import 'package:dio/dio.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDioClient mockDioClient;
  late MockDio mockDio;
  late JadwalShalatRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    dataSource = JadwalShalatRemoteDataSourceImpl(mockDioClient);
  });

  group('fetchProvinsi', () {
    test('mengembalikan ProvinsiShalatResponseDto saat sukses', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(ApiEndpoints.shalatProvinsi),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'code': 200,
            'message': 'Daftar provinsi berhasil diambil',
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
    test('mengembalikan KabkotaShalatResponseDto saat sukses', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          ApiEndpoints.shalatKabkota,
          data: {'provinsi': 'DKI Jakarta'},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'code': 200,
            'message': 'Daftar kabupaten/kota di DKI Jakarta',
            'data': tKabkotaJakartaList,
          },
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.fetchKabkota('DKI Jakarta');

      expect(result.data, tKabkotaJakartaList);
    });
  });

  group('fetchJadwalShalat', () {
    test('mengembalikan JadwalShalatResponseDto saat sukses', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          ApiEndpoints.shalat,
          data: {
            'provinsi': 'DKI Jakarta',
            'kabkota': 'Kota Jakarta',
            'bulan': 5,
            'tahun': 2026,
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'code': 200,
            'message': 'Jadwal shalat berhasil diambil',
            'data': {
              'provinsi': 'DKI Jakarta',
              'kabkota': 'Kota Jakarta',
              'bulan': 5,
              'tahun': 2026,
              'bulan_nama': 'Mei',
              'jadwal': [
                {
                  'tanggal': 25,
                  'tanggal_lengkap': '2026-05-25',
                  'hari': 'Senin',
                  'imsak': '04:26',
                  'subuh': '04:36',
                  'terbit': '05:50',
                  'dhuha': '06:18',
                  'dzuhur': '11:53',
                  'ashar': '15:14',
                  'maghrib': '17:50',
                  'isya': '19:00',
                },
              ],
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await dataSource.fetchJadwalShalat(
        provinsi: 'DKI Jakarta',
        kabkota: 'Kota Jakarta',
        bulan: 5,
        tahun: 2026,
      );

      expect(result.data.provinsi, 'DKI Jakarta');
      expect(result.data.kabkota, 'Kota Jakarta');
      expect(result.data.bulan, 5);
      expect(result.data.tahun, 2026);
      expect(result.data.bulanNama, 'Mei');
      expect(result.data.jadwal.length, 1);
      expect(result.data.jadwal.first.tanggalLengkap, '2026-05-25');
      expect(result.data.jadwal.first.hari, 'Senin');
    });
  });
}
