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
import 'package:equran_app/features/notification_test/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notification_test_state.dart';
part 'notification_test_viewmodel.freezed.dart';

const _testDelay = Duration(seconds: 5);

class NotificationTestViewModel extends AutoDisposeNotifier<NotificationTestState> {
  @override
  NotificationTestState build() => const NotificationTestState.initial();

  // Getters untuk use cases
  ScheduleAdzanNotification get _scheduleAdzan =>
      ref.read(scheduleAdzanNotificationProvider);
  ScheduleImsakNotification get _scheduleImsak =>
      ref.read(scheduleImsakNotificationProvider);
  ScheduleSahurNotification get _scheduleSahur =>
      ref.read(scheduleSahurNotificationProvider);
  ScheduleQuranReminder get _scheduleQuran =>
      ref.read(scheduleQuranReminderProvider);
  ScheduleChecklistReminder get _scheduleChecklist =>
      ref.read(scheduleChecklistReminderProvider);
  ScheduleHafalanReminder get _scheduleHafalan =>
      ref.read(scheduleHafalanReminderProvider);
  PlayAdzanDirect get _playAdzanDirect => ref.read(playAdzanDirectProvider);
  StopAdzanDirect get _stopAdzanDirect => ref.read(stopAdzanDirectProvider);
  CancelAllNotificationTests get _cancelAll =>
      ref.read(cancelAllNotificationTestsProvider);

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
      (failure) {
        state = NotificationTestState.error(
          statuses: {...statuses, item.id: false},
          failure: failure,
        );
      },
      (_) {
        state = NotificationTestState.running(
          statuses: {...statuses, item.id: true},
        );
      },
    );
  }

  Future<void> cancelAllTests() async {
    final result = await _cancelAll();
    result.fold(
      (failure) {
        state = NotificationTestState.error(
          statuses: state.statuses,
          failure: failure,
        );
      },
      (_) {
        state = const NotificationTestState.initial();
      },
    );
  }
}
