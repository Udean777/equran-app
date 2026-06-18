import 'dart:async';

import 'package:equran_app/core/constants/notification_ids.dart';

import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/notifications/shalat_checklist_reminder_scheduler.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:equran_app/features/notification_test/presentation/models/notification_test_item.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/cancel_all_button.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/info_banner.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/notif_card.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/section_label.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Halaman khusus untuk test semua jenis notifikasi.
/// Setiap notif dijadwalkan 5 detik dari sekarang.
class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final NotificationService _service = getIt<NotificationService>();
  final FlutterLocalNotificationsPlugin _plugin =
      getIt<FlutterLocalNotificationsPlugin>();
  final AudioCompositeHandler _audioHandler = getIt<AudioCompositeHandler>();

  // Status per notif: null = idle, true = scheduled, false = error
  final Map<String, bool?> _status = {};
  static const _delaySeconds = 5;

  tz.TZDateTime get _soon =>
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: _delaySeconds));

  List<NotificationTestSection> get _sections => [
    NotificationTestSection(
      label: 'Adzan Direct (Audio Player)',
      items: [
        NotificationTestItem(
          id: 'adzan_direct_dzuhur',
          icon: Icons.volume_up_rounded,
          title: 'Play Adzan Dzuhur (Direct)',
          subtitle: 'Langsung play audio adzan via AudioCompositeHandler',
          color: AppColors.primary,
          onTest: () => _testAdzanDirect(isSubuh: false),
        ),
        NotificationTestItem(
          id: 'adzan_direct_subuh',
          icon: Icons.volume_up_rounded,
          title: 'Play Adzan Subuh (Direct)',
          subtitle: 'Langsung play audio adzan subuh via AudioCompositeHandler',
          color: AppColors.primaryLight,
          onTest: () => _testAdzanDirect(isSubuh: true),
        ),
        NotificationTestItem(
          id: 'adzan_stop',
          icon: Icons.stop_circle_rounded,
          title: 'Stop Adzan',
          subtitle: 'Hentikan audio adzan yang sedang playing',
          color: AppColors.error,
          onTest: _stopAdzan,
        ),

      ],
    ),
    NotificationTestSection(
      label: 'Adzan Notifikasi (Visual)',
      items: [
        NotificationTestItem(
          id: 'adzan_dzuhur',
          icon: Icons.wb_sunny_rounded,
          title: 'Adzan Dzuhur',
          subtitle: 'Test notif adzan biasa (Dzuhur, Ashar, Maghrib, Isya)',
          color: AppColors.primary,
          onTest: () => _testAdzan(isSubuh: false),
          duration: const Duration(seconds: _delaySeconds),
        ),
        NotificationTestItem(
          id: 'adzan_subuh',
          icon: Icons.wb_twilight_rounded,
          title: 'Adzan Subuh',
          subtitle: 'Test notif adzan Subuh (sound berbeda)',
          color: AppColors.primaryLight,
          onTest: () => _testAdzan(isSubuh: true),
          duration: const Duration(seconds: _delaySeconds),
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Alarm Imsakiyah',
      items: [
        NotificationTestItem(
          id: 'imsak',
          icon: Icons.nightlight_round,
          title: 'Waktu Imsak',
          subtitle: 'Test alarm imsak Ramadan',
          color: AppColors.gold,
          onTest: _testImsak,
          duration: const Duration(seconds: _delaySeconds),
        ),
        NotificationTestItem(
          id: 'sahur',
          icon: Icons.restaurant_rounded,
          title: 'Alarm Sahur',
          subtitle: 'Test alarm sahur (30 menit sebelum imsak)',
          color: AppColors.goldDark,
          onTest: _testSahur,
          duration: const Duration(seconds: _delaySeconds),
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Reminder Baca Quran',
      items: [
        NotificationTestItem(
          id: 'quran_reminder',
          icon: Icons.auto_stories_rounded,
          title: 'Reminder Baca Quran',
          subtitle: 'Test pengingat harian membaca Al-Quran',
          color: AppColors.primaryLighter,
          onTest: _testQuranReminder,
          duration: const Duration(seconds: _delaySeconds),
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Reminder Checklist Shalat',
      items: [
        NotificationTestItem(
          id: 'checklist',
          icon: Icons.checklist_rounded,
          title: 'Checklist Shalat',
          subtitle: 'Test pengingat catat status shalat harian',
          color: AppColors.success,
          onTest: _testChecklist,
          duration: const Duration(seconds: _delaySeconds),
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Pengingat Hafalan',
      items: [
        NotificationTestItem(
          id: 'hafalan',
          icon: Icons.menu_book_rounded,
          title: 'Murajaah Hafalan',
          subtitle: 'Test pengingat jadwal murajaah hafalan',
          color: AppColors.warning,
          onTest: _testHafalan,
          duration: const Duration(seconds: _delaySeconds),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final sections = _sections;

    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Test Notifikasi'),
      backgroundColor: bgColor,
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.spaceMD,
          AppDimens.pagePadding,
          AppDimens.spaceXXL,
        ),
        itemCount: sections.length + 2, // InfoBanner + CancelAllButton
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoBanner(isDark: isDark),
                const SizedBox(height: AppDimens.spaceLG),
              ],
            );
          }

          if (index == sections.length + 1) {
            return Column(
              children: [
                const SizedBox(height: AppDimens.spaceLG),
                CancelAllButton(isDark: isDark, onTap: _cancelAll),
              ],
            );
          }

          final section = sections[index - 1];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 1) const SizedBox(height: AppDimens.spaceLG),
              SectionLabel(label: section.label, isDark: isDark),
              const SizedBox(height: AppDimens.spaceSM),
              ...section.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.spaceSM),
                  child: NotifCard(
                    id: item.id,
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    color: item.color,
                    status: _status[item.id],
                    duration: item.duration,
                    isDark: isDark,
                    onTest: item.onTest,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Test handlers
  // ---------------------------------------------------------------------------

  Future<void> _testAdzanDirect({required bool isSubuh}) async {
    final key = isSubuh ? 'adzan_direct_subuh' : 'adzan_direct_dzuhur';
    await _schedule(key, () async {
      await _audioHandler.playAdzan(
        isSubuh: isSubuh,
        waktuNama: isSubuh ? 'Subuh' : 'Dzuhur',
      );
    });
  }

  Future<void> _stopAdzan() async {
    await _schedule('adzan_stop', () async {
      await _audioHandler.stopAdzan();
    });
  }


  Future<void> _testAdzan({required bool isSubuh}) async {
    final key = isSubuh ? 'adzan_subuh' : 'adzan_dzuhur';
    await _schedule(key, () async {
      await _service.scheduleNotification(
        id: isSubuh ? NotificationIds.testSubuh : NotificationIds.testDzuhur,
        title: isSubuh ? '🌅 Waktu Subuh' : '☀️ Waktu Dzuhur',
        body: isSubuh
            ? 'Sudah masuk waktu shalat Subuh'
            : 'Sudah masuk waktu shalat Dzuhur',
        scheduledTime: _soon,
        isSubuh: isSubuh,
      );
    });
  }

  Future<void> _testImsak() async {
    await _schedule('imsak', () async {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact =
          await androidPlugin?.canScheduleExactNotifications() ?? false;

      await _plugin.zonedSchedule(
        NotificationIds.testImsak,
        '🌙 Waktu Imsak',
        'Sudah masuk waktu imsak, hentikan makan dan minum',
        _soon,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            kImsakChannelId,
            'Alarm Imsak & Sahur',
            channelDescription: 'Alarm pengingat waktu imsak dan sahur Ramadan',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    });
  }

  Future<void> _testSahur() async {
    await _schedule('sahur', () async {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact =
          await androidPlugin?.canScheduleExactNotifications() ?? false;

      await _plugin.zonedSchedule(
        NotificationIds.testSahur,
        '🍽️ Alarm Sahur',
        'Sahur sekarang! Imsak 30 menit lagi',
        _soon,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            kImsakChannelId,
            'Alarm Imsak & Sahur',
            channelDescription: 'Alarm pengingat waktu imsak dan sahur Ramadan',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    });
  }

  Future<void> _testQuranReminder() async {
    await _schedule('quran_reminder', () async {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact =
          await androidPlugin?.canScheduleExactNotifications() ?? false;

      await _plugin.zonedSchedule(
        NotificationIds.testQuranReminder,
        '📖 Waktunya Baca Al-Quran',
        'Luangkan waktu sejenak untuk membaca Al-Quran hari ini.',
        _soon,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            kQuranReminderChannelId,
            'Reminder Baca Quran',
            channelDescription: 'Pengingat harian untuk membaca Al-Quran',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    });
  }

  Future<void> _testChecklist() async {
    await _schedule('checklist', () async {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact =
          await androidPlugin?.canScheduleExactNotifications() ?? false;

      await _plugin.zonedSchedule(
        NotificationIds.testAshar,
        '✅ Sudah shalat Dzuhur?',
        'Catat status shalat Dzuhur hari ini di Statistik Shalat.',
        _soon,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            kShalatChecklistChannelId,
            'Reminder Checklist Shalat',
            channelDescription: 'Pengingat untuk mencatat status shalat harian',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    });
  }

  Future<void> _testHafalan() async {
    await _schedule('hafalan', () async {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact =
          await androidPlugin?.canScheduleExactNotifications() ?? false;

      await _plugin.zonedSchedule(
        NotificationIds.testMaghrib,
        '📿 Murajaah Al-Fatihah',
        'Sudah waktunya murajaah. Jangan sampai lupa!',
        _soon,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            kHafalanChannelId,
            'Pengingat Hafalan',
            channelDescription: 'Pengingat jadwal murajaah hafalan Al-Quran',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    });
  }

  Future<void> _cancelAll() async {
    try {
      await _plugin.cancelAll();
      if (!mounted) return;
      setState(() => _status.updateAll((_, _) => null));
      _showSnackbar('Semua notif test dibatalkan', isError: false);
    } on Object catch (e) {
      _showSnackbar('Gagal cancel: $e', isError: true);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _schedule(String key, Future<void> Function() fn) async {
    try {
      await fn();
      if (!mounted) return;
      setState(() => _status[key] = true);
      _showSnackbar(
        'Notif dijadwalkan $_delaySeconds detik lagi',
        isError: false,
      );
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _status[key] = false);
      _showSnackbar('Error: $e', isError: true);
    }
  }

  void _showSnackbar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
