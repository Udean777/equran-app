import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equran_app/core/constants/network_config.dart';
import 'package:equran_app/core/location/location_matching_service.dart';
import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/core/network/api_endpoints.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

// ─── Dio Provider ─────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
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
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }

  return dio;
});

// ─── Hive Box Providers (all pre-opened in main.dart) ─────────────────────

final settingsBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('settings_box');
});

final bookmarkBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('bookmark_box');
});

final shalatBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('shalat_box');
});

final imsakiyahBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('imsakiyah_box');
});

final doaBoxProvider = Provider<LazyBox<String>>((ref) {
  return Hive.lazyBox<String>('doa_box');
});

final catatanBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('catatan_box');
});

final hafalanBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('hafalan_box');
});

final doaBookmarkBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('doa_bookmark_box');
});

final statistikShalatBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('statistik_shalat_box');
});

final readingHistoryBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('reading_history_box');
});

final suratBoxProvider = Provider<LazyBox<String>>((ref) {
  return Hive.lazyBox<String>('surat_box');
});

final tafsirBoxProvider = Provider<LazyBox<String>>((ref) {
  return Hive.lazyBox<String>('tafsir_box');
});

final tasbihBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('tasbih_box');
});

// ─── Location Service Providers ────────────────────────────────────────────

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationServiceImpl();
});

final locationMatchingServiceProvider = Provider<LocationMatchingService>((ref) {
  return LocationMatchingService();
});

// ─── Notification Service Provider ────────────────────────────────────────

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(FlutterLocalNotificationsPlugin());
});
