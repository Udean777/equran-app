import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equran_app/core/constants/network_config.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient {
  DioClient() : _dio = _createDio();

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: NetworkConfig.connectTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,
        headers: {HttpHeaders.acceptHeader: 'application/json'},
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }

    return dio;
  }
}
