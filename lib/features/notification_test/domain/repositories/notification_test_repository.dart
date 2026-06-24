import 'package:equran_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:timezone/timezone.dart' as tz;

abstract interface class NotificationTestRepository {
  Future<Either<Failure, Unit>> scheduleAdzanNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required bool isSubuh,
  });

  Future<Either<Failure, Unit>> scheduleImsak({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  });

  Future<Either<Failure, Unit>> scheduleSahur({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  });

  Future<Either<Failure, Unit>> scheduleQuranReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  });

  Future<Either<Failure, Unit>> scheduleChecklist({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  });

  Future<Either<Failure, Unit>> scheduleHafalan({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  });

  Future<Either<Failure, Unit>> playAdzanDirect({
    required bool isSubuh,
    required String waktuNama,
  });

  Future<Either<Failure, Unit>> stopAdzanDirect();

  Future<Either<Failure, Unit>> cancelAllTests();
}
