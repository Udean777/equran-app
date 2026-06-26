import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/notification_test/data/repositories/notification_test_repository_impl.dart';
import 'package:equran_app/features/notification_test/domain/repositories/notification_test_repository.dart';
import 'package:equran_app/features/notification_test/domain/usecases/cancel_all_notification_tests.dart';
import 'package:equran_app/features/notification_test/domain/usecases/play_adzan_direct.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_adzan_notification.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_checklist_reminder.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_hafalan_reminder.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_imsak_notification.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_quran_reminder.dart';
import 'package:equran_app/features/notification_test/domain/usecases/schedule_sahur_notification.dart';
import 'package:equran_app/features/notification_test/domain/usecases/stop_adzan_direct.dart';
import 'package:equran_app/features/notification_test/presentation/viewmodels/notification_test_viewmodel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Repository ────────────────────────────────────────────────────────────

final notificationTestRepositoryProvider = Provider<NotificationTestRepository>(
  (ref) {
    return NotificationTestRepositoryImpl(
      ref.read(notificationServiceProvider),
      FlutterLocalNotificationsPlugin(),
      ref.watch(audioCompositeHandlerProvider),
    );
  },
);

// ─── Use Cases ─────────────────────────────────────────────────────────────

final scheduleAdzanNotificationProvider = Provider<ScheduleAdzanNotification>((
  ref,
) {
  return ScheduleAdzanNotification(
    ref.read(notificationTestRepositoryProvider),
  );
});

final scheduleImsakNotificationProvider = Provider<ScheduleImsakNotification>((
  ref,
) {
  return ScheduleImsakNotification(
    ref.read(notificationTestRepositoryProvider),
  );
});

final scheduleSahurNotificationProvider = Provider<ScheduleSahurNotification>((
  ref,
) {
  return ScheduleSahurNotification(
    ref.read(notificationTestRepositoryProvider),
  );
});

final scheduleQuranReminderProvider = Provider<ScheduleQuranReminder>((ref) {
  return ScheduleQuranReminder(ref.read(notificationTestRepositoryProvider));
});

final scheduleChecklistReminderProvider = Provider<ScheduleChecklistReminder>((
  ref,
) {
  return ScheduleChecklistReminder(
    ref.read(notificationTestRepositoryProvider),
  );
});

final scheduleHafalanReminderProvider = Provider<ScheduleHafalanReminder>((
  ref,
) {
  return ScheduleHafalanReminder(ref.read(notificationTestRepositoryProvider));
});

final playAdzanDirectProvider = Provider<PlayAdzanDirect>((ref) {
  return PlayAdzanDirect(ref.read(notificationTestRepositoryProvider));
});

final stopAdzanDirectProvider = Provider<StopAdzanDirect>((ref) {
  return StopAdzanDirect(ref.read(notificationTestRepositoryProvider));
});

final cancelAllNotificationTestsProvider = Provider<CancelAllNotificationTests>(
  (ref) {
    return CancelAllNotificationTests(
      ref.read(notificationTestRepositoryProvider),
    );
  },
);

// ─── ViewModel Provider ────────────────────────────────────────────────────

final AutoDisposeStateNotifierProvider<
  NotificationTestViewModel,
  NotificationTestState
>
notificationTestViewModelProvider =
    StateNotifierProvider.autoDispose<
      NotificationTestViewModel,
      NotificationTestState
    >((ref) {
      return NotificationTestViewModel(ref);
    });
