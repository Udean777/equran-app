import 'dart:async';

import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/adzan_alarm_scheduler.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/notifications/shalat_checklist_reminder_scheduler.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
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
  final FlutterLocalNotificationsPlugin _plugin = getIt<FlutterLocalNotificationsPlugin>();
  final AudioCompositeHandler _audioHandler = getIt<AudioCompositeHandler>();

  // Status per notif: null = idle, true = scheduled, false = error
  final Map<String, bool?> _status = {};
  static const _delaySeconds = 5;

  tz.TZDateTime get _soon =>
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: _delaySeconds));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;

    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Test Notifikasi'),
      backgroundColor: bgColor,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.spaceMD,
          AppDimens.pagePadding,
          AppDimens.spaceXXL,
        ),
        children: [
          _InfoBanner(isDark: isDark),
          const SizedBox(height: AppDimens.spaceLG),

          // ── Adzan Direct (Audio) ───────────────────────────────────────
          _SectionLabel(label: 'Adzan Direct (Audio Player)', isDark: isDark),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'adzan_direct_dzuhur',
            icon: Icons.volume_up_rounded,
            title: 'Play Adzan Dzuhur (Direct)',
            subtitle: 'Langsung play audio adzan via AudioCompositeHandler',
            color: AppColors.primary,
            status: _status['adzan_direct_dzuhur'],
            isDark: isDark,
            onTest: () => _testAdzanDirect(isSubuh: false),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'adzan_direct_subuh',
            icon: Icons.volume_up_rounded,
            title: 'Play Adzan Subuh (Direct)',
            subtitle: 'Langsung play audio adzan subuh via AudioCompositeHandler',
            color: AppColors.primaryLight,
            status: _status['adzan_direct_subuh'],
            isDark: isDark,
            onTest: () => _testAdzanDirect(isSubuh: true),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'adzan_stop',
            icon: Icons.stop_circle_rounded,
            title: 'Stop Adzan',
            subtitle: 'Hentikan audio adzan yang sedang playing',
            color: AppColors.error,
            status: _status['adzan_stop'],
            isDark: isDark,
            onTest: _stopAdzan,
          ),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'adzan_alarm_dzuhur',
            icon: Icons.alarm_rounded,
            title: 'Schedule Adzan Alarm (30 detik)',
            subtitle: 'Test AlarmManager → playAdzanCallback (lock device dulu)',
            color: AppColors.gold,
            status: _status['adzan_alarm_dzuhur'],
            isDark: isDark,
            onTest: () => _testAdzanAlarm(isSubuh: false),
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // ── Adzan Notif ────────────────────────────────────────────────
          _SectionLabel(label: 'Adzan Notifikasi (Visual)', isDark: isDark),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'adzan_dzuhur',
            icon: Icons.wb_sunny_rounded,
            title: 'Adzan Dzuhur',
            subtitle: 'Test notif adzan biasa (Dzuhur, Ashar, Maghrib, Isya)',
            color: AppColors.primary,
            status: _status['adzan_dzuhur'],
            isDark: isDark,
            onTest: () => _testAdzan(isSubuh: false),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'adzan_subuh',
            icon: Icons.wb_twilight_rounded,
            title: 'Adzan Subuh',
            subtitle: 'Test notif adzan Subuh (sound berbeda)',
            color: AppColors.primaryLight,
            status: _status['adzan_subuh'],
            isDark: isDark,
            onTest: () => _testAdzan(isSubuh: true),
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // ── Imsakiyah ──────────────────────────────────────────────────
          _SectionLabel(label: 'Alarm Imsakiyah', isDark: isDark),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'imsak',
            icon: Icons.nightlight_round,
            title: 'Waktu Imsak',
            subtitle: 'Test alarm imsak Ramadan',
            color: AppColors.gold,
            status: _status['imsak'],
            isDark: isDark,
            onTest: _testImsak,
          ),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'sahur',
            icon: Icons.restaurant_rounded,
            title: 'Alarm Sahur',
            subtitle: 'Test alarm sahur (30 menit sebelum imsak)',
            color: AppColors.goldDark,
            status: _status['sahur'],
            isDark: isDark,
            onTest: _testSahur,
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // ── Quran Reminder ─────────────────────────────────────────────
          _SectionLabel(label: 'Reminder Baca Quran', isDark: isDark),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'quran_reminder',
            icon: Icons.auto_stories_rounded,
            title: 'Reminder Baca Quran',
            subtitle: 'Test pengingat harian membaca Al-Quran',
            color: AppColors.primaryLighter,
            status: _status['quran_reminder'],
            isDark: isDark,
            onTest: _testQuranReminder,
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // ── Checklist Shalat ───────────────────────────────────────────
          _SectionLabel(label: 'Reminder Checklist Shalat', isDark: isDark),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'checklist',
            icon: Icons.checklist_rounded,
            title: 'Checklist Shalat',
            subtitle: 'Test pengingat catat status shalat harian',
            color: AppColors.success,
            status: _status['checklist'],
            isDark: isDark,
            onTest: _testChecklist,
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // ── Hafalan ────────────────────────────────────────────────────
          _SectionLabel(label: 'Pengingat Hafalan', isDark: isDark),
          const SizedBox(height: AppDimens.spaceSM),
          _NotifCard(
            id: 'hafalan',
            icon: Icons.menu_book_rounded,
            title: 'Murajaah Hafalan',
            subtitle: 'Test pengingat jadwal murajaah hafalan',
            color: AppColors.warning,
            status: _status['hafalan'],
            isDark: isDark,
            onTest: _testHafalan,
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // ── Cancel All ─────────────────────────────────────────────────
          _CancelAllButton(isDark: isDark, onTap: _cancelAll),
        ],
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

  Future<void> _testAdzanAlarm({required bool isSubuh}) async {
    final key = isSubuh ? 'adzan_alarm_subuh' : 'adzan_alarm_dzuhur';
    await _schedule(key, () async {
      final scheduledTime = DateTime.now().add(const Duration(seconds: 30));
      await scheduleAdzanAlarm(
        id: isSubuh ? 911 : 912,
        scheduledTime: scheduledTime,
        isSubuh: isSubuh,
        nama: isSubuh ? 'Subuh' : 'Dzuhur',
      );
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

// ---------------------------------------------------------------------------
// Info banner
// ---------------------------------------------------------------------------

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryDark.withValues(alpha: 0.5)
            : AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: isDark
              ? AppColors.primaryLight.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
            size: AppDimens.iconMD,
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Expanded(
            child: Text(
              'Setiap notif akan muncul 5 detik setelah tombol ditekan. '
              'Pastikan app di-minimize atau layar mati agar notif terlihat.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section label
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimens.spaceXS),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Text(
            label,
            style: AppTypography.serifHeadingSmall.copyWith(
              fontSize: 13,
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notif card
// ---------------------------------------------------------------------------

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.status,
    required this.isDark,
    required this.onTest,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool? status; // null=idle, true=ok, false=error
  final bool isDark;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: status == true
              ? AppColors.success.withValues(alpha: 0.5)
              : status == false
              ? AppColors.error.withValues(alpha: 0.5)
              : borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.cardPadding),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(icon, color: color, size: AppDimens.iconMD),
            ),
            const SizedBox(width: AppDimens.spaceMD),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (status != null)
                        Icon(
                          status!
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          size: 16,
                          color: status! ? AppColors.success : AppColors.error,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textTertiary,
                      height: 1.4,
                    ),
                  ),
                  if (status == true) ...[
                    const SizedBox(height: AppDimens.spaceXS),
                    const Text(
                      'Dijadwalkan — tunggu 5 detik',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSM),

            // Button
            _TestButton(color: color, isDark: isDark, onTap: onTest),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Test button
// ---------------------------------------------------------------------------

class _TestButton extends StatelessWidget {
  const _TestButton({
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceSM,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.2 : 0.12),
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          'Test',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cancel all button
// ---------------------------------------------------------------------------

class _CancelAllButton extends StatelessWidget {
  const _CancelAllButton({required this.isDark, required this.onTap});

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_rounded,
              color: AppColors.error,
              size: AppDimens.iconMD,
            ),
            SizedBox(width: AppDimens.spaceSM),
            Text(
              'Batalkan Semua Notif Test',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
