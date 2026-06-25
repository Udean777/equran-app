import 'package:equatable/equatable.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleChecklistReminderParams extends Equatable {
  const ScheduleChecklistReminderParams({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
  });

  final int id;
  final String title;
  final String body;
  final tz.TZDateTime scheduledTime;

  @override
  List<Object?> get props => [id, title, body, scheduledTime];
}

class ScheduleChecklistReminder
    implements UseCase<Unit, ScheduleChecklistReminderParams> {
  const ScheduleChecklistReminder(this._repository);

  final NotificationTestRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(
    ScheduleChecklistReminderParams params,
  ) => _repository.scheduleChecklist(
    id: params.id,
    title: params.title,
    body: params.body,
    scheduledTime: params.scheduledTime,
  );
}
