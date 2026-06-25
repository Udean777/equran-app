import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleAdzanNotificationParams extends Equatable {
  const ScheduleAdzanNotificationParams({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.isSubuh,
  });

  final int id;
  final String title;
  final String body;
  final tz.TZDateTime scheduledTime;
  final bool isSubuh;

  @override
  List<Object?> get props => [id, title, body, scheduledTime, isSubuh];
}

class ScheduleAdzanNotification
    implements UseCase<Unit, ScheduleAdzanNotificationParams> {
  const ScheduleAdzanNotification(this._repository);

  final NotificationTestRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(
    ScheduleAdzanNotificationParams params,
  ) => _repository.scheduleAdzanNotification(
    id: params.id,
    title: params.title,
    body: params.body,
    scheduledTime: params.scheduledTime,
    isSubuh: params.isSubuh,
  );
}
