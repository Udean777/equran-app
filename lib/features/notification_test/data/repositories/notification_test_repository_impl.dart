import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpdart/fpdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationTestRepositoryImpl implements NotificationTestRepository {
  NotificationTestRepositoryImpl(
    this._notificationService,
    this._plugin,
    this._audioHandler,
  );

  final NotificationService _notificationService;
  final FlutterLocalNotificationsPlugin _plugin;
  final AudioCompositeHandler _audioHandler;

  static Future<Either<Failure, Unit>> _safeCall(
    Future<void> Function() block,
  ) async {
    try {
      await block();
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleAdzanNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required bool isSubuh,
  }) => _safeCall(() async {
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
  });

  @override
  Future<Either<Failure, Unit>> scheduleImsak({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) => _safeCall(
    () => _notificationService.scheduleNotificationRaw(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: _notificationService.imsakNotificationDetails(),
      matchDateTimeComponents: null,
    ),
  );

  @override
  Future<Either<Failure, Unit>> scheduleSahur({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) => _safeCall(
    () => _notificationService.scheduleNotificationRaw(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: _notificationService.imsakNotificationDetails(),
      matchDateTimeComponents: null,
    ),
  );

  @override
  Future<Either<Failure, Unit>> scheduleQuranReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) => _safeCall(
    () => _notificationService.scheduleNotificationRaw(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: _notificationService.quranReminderNotificationDetails(),
      matchDateTimeComponents: null,
    ),
  );

  @override
  Future<Either<Failure, Unit>> scheduleChecklist({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) => _safeCall(
    () => _notificationService.scheduleNotificationRaw(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: _notificationService.checklistNotificationDetails(),
      matchDateTimeComponents: null,
    ),
  );

  @override
  Future<Either<Failure, Unit>> scheduleHafalan({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) => _safeCall(
    () => _notificationService.scheduleNotificationRaw(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: _notificationService.hafalanNotificationDetails(),
      matchDateTimeComponents: null,
    ),
  );

  @override
  Future<Either<Failure, Unit>> playAdzanDirect({
    required bool isSubuh,
    required String waktuNama,
  }) => _safeCall(
    () => _audioHandler.playAdzan(
      isSubuh: isSubuh,
      waktuNama: waktuNama,
    ),
  );

  @override
  Future<Either<Failure, Unit>> stopAdzanDirect() =>
      _safeCall(_audioHandler.stopAdzan);

  @override
  Future<Either<Failure, Unit>> cancelAllTests() =>
      _safeCall(_plugin.cancelAll);
}
