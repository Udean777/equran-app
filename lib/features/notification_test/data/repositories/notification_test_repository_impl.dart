import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

@Singleton(as: NotificationTestRepository)
class NotificationTestRepositoryImpl implements NotificationTestRepository {
  NotificationTestRepositoryImpl(
    this._notificationService,
    this._plugin,
    this._audioHandler,
  );

  final NotificationService _notificationService;
  final FlutterLocalNotificationsPlugin _plugin;
  final AudioCompositeHandler _audioHandler;

  @override
  Future<Either<Failure, Unit>> scheduleAdzanNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required bool isSubuh,
  }) async {
    try {
      final details = _notificationService.adzanNotificationDetails(
        isSubuh: isSubuh,
      );
      await _notificationService.scheduleNotificationRaw(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: details,
        matchDateTimeComponents: null,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleImsak({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    try {
      await _notificationService.scheduleNotificationRaw(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: _notificationService.imsakNotificationDetails(),
        matchDateTimeComponents: null,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleSahur({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    try {
      await _notificationService.scheduleNotificationRaw(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: _notificationService.imsakNotificationDetails(),
        matchDateTimeComponents: null,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleQuranReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    try {
      await _notificationService.scheduleNotificationRaw(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: _notificationService.quranReminderNotificationDetails(),
        matchDateTimeComponents: null,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleChecklist({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    try {
      await _notificationService.scheduleNotificationRaw(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: _notificationService.checklistNotificationDetails(),
        matchDateTimeComponents: null,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleHafalan({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    try {
      await _notificationService.scheduleNotificationRaw(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: _notificationService.hafalanNotificationDetails(),
        matchDateTimeComponents: null,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> playAdzanDirect({
    required bool isSubuh,
    required String waktuNama,
  }) async {
    try {
      await _audioHandler.playAdzan(
        isSubuh: isSubuh,
        waktuNama: waktuNama,
      );
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> stopAdzanDirect() async {
    try {
      await _audioHandler.stopAdzan();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAllTests() async {
    try {
      await _plugin.cancelAll();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
