import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equran_app/core/constants/network_config.dart';
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

// ─── Hive Box Providers (pre-opened in main.dart) ─────────────────────────

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

// Lazy boxes — opened on first access

final doaBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('doa_box');
});

final catatanBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('catatan_box');
});

final hafalanBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('hafalan_box');
});

final doaBookmarkBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('doa_bookmark_box');
});

final statistikShalatBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('statistik_shalat_box');
});

final readingHistoryBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('reading_history_box');
});

final suratBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('surat_box');
});

final tafsirBoxProvider = FutureProvider<LazyBox<String>>((ref) {
  return Hive.openLazyBox<String>('tafsir_box');
});

final tasbihBoxProvider = FutureProvider<Box<String>>((ref) {
  return Hive.openBox<String>('tasbih_box');
});

// ─── Location Service Provider ────────────────────────────────────────────

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationServiceImpl();
});

// ─── Notification Service Provider ────────────────────────────────────────

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(FlutterLocalNotificationsPlugin());
});
