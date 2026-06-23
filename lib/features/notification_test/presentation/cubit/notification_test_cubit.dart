import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/notification_test/domain/entities/notification_test_item.dart';
import 'package:equran_app/features/notification_test/domain/usecases/cancel_all_notification_tests.dart';
import 'package:equran_app/features/notification_test/domain/usecases/play_adzan_direct.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_adzan_notification.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_checklist_reminder.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_hafalan_reminder.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_imsak_notification.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_quran_reminder.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_sahur_notification.dart';
import 'package:equran_app/features/notification_test/domain/usecases/stop_adzan_direct.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notification_test_state.dart';
part 'notification_test_cubit.freezed.dart';

const _testDelay = Duration(seconds: 5);

@injectable
class NotificationTestCubit extends Cubit<NotificationTestState> {
  NotificationTestCubit(
    this._scheduleAdzan,
    this._scheduleImsak,
    this._scheduleSahur,
    this._scheduleQuran,
    this._scheduleChecklist,
    this._scheduleHafalan,
    this._playAdzanDirect,
    this._stopAdzanDirect,
    this._cancelAll,
  ) : super(const NotificationTestState.initial());

  final ScheduleAdzanNotification _scheduleAdzan;
  final ScheduleImsakNotification _scheduleImsak;
  final ScheduleSahurNotification _scheduleSahur;
  final ScheduleQuranReminder _scheduleQuran;
  final ScheduleChecklistReminder _scheduleChecklist;
  final ScheduleHafalanReminder _scheduleHafalan;
  final PlayAdzanDirect _playAdzanDirect;
  final StopAdzanDirect _stopAdzanDirect;
  final CancelAllNotificationTests _cancelAll;

  static tz.TZDateTime _soon() => tz.TZDateTime.now(tz.local).add(_testDelay);

  Future<void> runTest(NotificationTestItem item) async {
    final scheduledTime = _soon();
    final statuses = Map<String, bool>.from(state.statuses);

    Either<Failure, Unit> result;
    switch (item.type) {
      case NotificationTestType.adzanDirect:
        result = await _playAdzanDirect(
          PlayAdzanDirectParams(
            isSubuh: item.id.contains('subuh'),
            waktuNama: item.id.contains('subuh') ? 'Subuh' : 'Dzuhur',
          ),
        );
      case NotificationTestType.adzanStop:
        result = await _stopAdzanDirect();
      case NotificationTestType.adzanNotification:
        result = await _scheduleAdzan(
          ScheduleAdzanNotificationParams(
            id: item.id.contains('subuh')
                ? NotificationIds.testSubuh
                : NotificationIds.testDzuhur,
            title: item.id.contains('subuh')
                ? '🌅 Waktu Subuh'
                : '☀️ Waktu Dzuhur',
            body: item.id.contains('subuh')
                ? 'Sudah masuk waktu shalat Subuh'
                : 'Sudah masuk waktu shalat Dzuhur',
            scheduledTime: scheduledTime,
            isSubuh: item.id.contains('subuh'),
          ),
        );
      case NotificationTestType.imsak:
        result = await _scheduleImsak(
          ScheduleImsakParams(
            id: NotificationIds.testImsak,
            title: '🌙 Waktu Imsak',
            body: 'Sudah masuk waktu imsak, hentikan makan dan minum',
            scheduledTime: scheduledTime,
          ),
        );
      case NotificationTestType.sahur:
        result = await _scheduleSahur(
          ScheduleSahurParams(
            id: NotificationIds.testSahur,
            title: '🍽️ Alarm Sahur',
            body: 'Sahur sekarang! Imsak 30 menit lagi',
            scheduledTime: scheduledTime,
          ),
        );
      case NotificationTestType.quranReminder:
        result = await _scheduleQuran(
          ScheduleQuranReminderParams(
            id: NotificationIds.testQuranReminder,
            title: '📖 Waktunya Baca Al-Quran',
            body: 'Luangkan waktu sejenak untuk membaca Al-Quran hari ini.',
            scheduledTime: scheduledTime,
          ),
        );
      case NotificationTestType.checklist:
        result = await _scheduleChecklist(
          ScheduleChecklistReminderParams(
            id: NotificationIds.testAshar,
            title: '✅ Sudah shalat Dzuhur?',
            body: 'Catat status shalat Dzuhur hari ini di Statistik Shalat.',
            scheduledTime: scheduledTime,
          ),
        );
      case NotificationTestType.hafalan:
        result = await _scheduleHafalan(
          ScheduleHafalanReminderParams(
            id: NotificationIds.testMaghrib,
            title: '📿 Murajaah Al-Fatihah',
            body: 'Sudah waktunya murajaah. Jangan sampai lupa!',
            scheduledTime: scheduledTime,
          ),
        );
    }

    result.fold(
      (failure) => emit(
        NotificationTestState.error(
          statuses: {...statuses, item.id: false},
          failure: failure,
        ),
      ),
      (_) => emit(
        NotificationTestState.running(
          statuses: {...statuses, item.id: true},
        ),
      ),
    );
  }

  Future<void> cancelAllTests() async {
    final result = await _cancelAll();
    result.fold(
      (failure) => emit(
        NotificationTestState.error(
          statuses: state.statuses,
          failure: failure,
        ),
      ),
      (_) => emit(const NotificationTestState.initial()),
    );
  }
}
