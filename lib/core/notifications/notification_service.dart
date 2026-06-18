import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/constants/quran_constants.dart';
import 'package:equran_app/core/constants/timezone_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Channel IDs
const String kAdzanChannelId = 'adzan_channel_v4';
const String kAdzanSubuhChannelId = 'adzan_subuh_channel_v4';
const String kQuranReminderChannelId = 'quran_reminder_channel_v4';
const String kImsakChannelId = 'imsak_channel_v4';
const String kHafalanChannelId = 'hafalan_channel_v4';

@lazySingleton
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  /// Inisialisasi plugin + timezone + request permission.
  /// Dipanggil sekali di `main.dart` sebelum `runApp`.
  Future<void> init() async {
    // Init timezone database & set ke local device timezone
    tz_data.initializeTimeZones();
    final timezoneName = await _resolveLocalTimezone();
    try {
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } on Object catch (e) {
      debugPrint(
        'NotificationService: timezone "$timezoneName" not found, '
        'falling back to Asia/Jakarta. Error: $e',
      );
      try {
        tz.setLocalLocation(tz.getLocation(TimezoneConstants.wib));
      } on Object catch (err) {
        debugPrint('NotificationService: fallback timezone failed: $err');
      }
    }

    const androidSettings = AndroidInitializationSettings(
      'ic_notif',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    // Buat notification channels Android
    await _createAndroidChannels();
  }

  /// Request permission notifikasi (Android 13+ / iOS).
  Future<bool> requestPermission() async {
    var granted = false;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final result = await androidPlugin.requestNotificationsPermission();
      granted = result ?? false;

      // Request exact alarm permission (Android 12+)
      try {
        final isExactPermitted =
            await androidPlugin.canScheduleExactNotifications() ?? false;
        if (!isExactPermitted) {
          await androidPlugin.requestExactAlarmsPermission();
        }
      } on Object catch (e) {
        debugPrint(
          'NotificationService: requestExactAlarmsPermission failed: $e',
        );
      }
    }

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      try {
        final result = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        granted = result ?? false;
      } on Object catch (e) {
        debugPrint('NotificationService: iOS requestPermissions failed: $e');
      }
    }

    return granted;
  }

  /// Schedule notifikasi adzan pada [scheduledTime].
  /// Menggunakan native notification sound (Android & iOS).
  /// [isSubuh] menentukan sound yang digunakan.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required bool isSubuh,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      isSubuh ? kAdzanSubuhChannelId : kAdzanChannelId,
      'Adzan',
      channelDescription: 'Notifikasi waktu shalat',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        isSubuh ? 'adzan_subuh' : 'adzan',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canExact =
        await androidPlugin?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Tampilkan notifikasi adzan secara instan (non-scheduled).
  /// Digunakan untuk test adzan atau manual trigger.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    bool isSubuh = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      isSubuh ? kAdzanSubuhChannelId : kAdzanChannelId,
      'Adzan',
      channelDescription: 'Notifikasi waktu shalat',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        isSubuh ? 'adzan_subuh' : 'adzan',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id,
      title,
      body,
      details,
    );
  }

  /// Schedule notifikasi harian pada [hour]:[minute].
  /// Menggunakan [DateTimeComponents.time] agar repeat otomatis setiap hari.
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Jika waktu sudah lewat hari ini, schedule untuk besok
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      kQuranReminderChannelId,
      'Reminder Baca Quran',
      channelDescription: 'Pengingat harian untuk membaca Al-Quran',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canExact =
        await androidPlugin?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule notifikasi dengan [NotificationDetails] custom.
  /// Digunakan oleh scheduler yang butuh channel spesifik (misal imsak).
  /// [matchDateTimeComponents] — null untuk one-shot, DateTimeComponents.time
  /// untuk repeat harian.
  Future<void> scheduleNotificationRaw({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required NotificationDetails details,
    DateTimeComponents? matchDateTimeComponents = DateTimeComponents.time,
  }) async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canExact =
        await androidPlugin?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchDateTimeComponents,
    );
  }

  /// Cancel notifikasi berdasarkan [id].
  Future<void> cancelById(int id) => _plugin.cancel(id);

  /// Cancel semua notifikasi (shalat, imsak, quran reminder, hafalan).
  Future<void> cancelAll() async {
    // Shalat
    await _plugin.cancel(NotificationIds.subuh);
    await _plugin.cancel(NotificationIds.dzuhur);
    await _plugin.cancel(NotificationIds.ashar);
    await _plugin.cancel(NotificationIds.maghrib);
    await _plugin.cancel(NotificationIds.isya);
    // Imsak & sahur
    await _plugin.cancel(NotificationIds.imsak);
    await _plugin.cancel(NotificationIds.sahur);
    // Quran reminder
    await _plugin.cancel(NotificationIds.quranReminder);
    // Hafalan muraja'ah (ID range 20–133, satu per surat 1–114)
    for (var i = 0; i < QuranConstants.totalSurat; i++) {
      await _plugin.cancel(NotificationIds.hafalanReminderBase + i);
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    // Delete channel lama agar tidak ada konflik.
    await androidPlugin.deleteNotificationChannel('adzan_channel');
    await androidPlugin.deleteNotificationChannel('adzan_subuh_channel');
    await androidPlugin.deleteNotificationChannel('adzan_playback_channel');
    await androidPlugin.deleteNotificationChannel('adzan_channel_v3');
    await androidPlugin.deleteNotificationChannel('adzan_subuh_channel_v3');
    await androidPlugin.deleteNotificationChannel('quran_reminder_channel_v2');
    await androidPlugin.deleteNotificationChannel('imsak_channel_v2');
    await androidPlugin.deleteNotificationChannel('hafalan_channel_v2');
    await androidPlugin.deleteNotificationChannel('shalat_checklist_channel');

    // Channel adzan
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kAdzanChannelId,
        'Adzan',
        description: 'Notifikasi waktu shalat',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('adzan'),
      ),
    );

    // Channel adzan subuh
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kAdzanSubuhChannelId,
        'Adzan Subuh',
        description: 'Notifikasi waktu shalat subuh',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('adzan_subuh'),
      ),
    );

    // Channel reminder baca Quran
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kQuranReminderChannelId,
        'Reminder Baca Quran',
        description: 'Pengingat harian untuk membaca Al-Quran',
      ),
    );

    // Channel alarm imsak & sahur
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kImsakChannelId,
        'Alarm Imsak & Sahur',
        description: 'Alarm pengingat waktu imsak dan sahur Ramadan',
        importance: Importance.max,
      ),
    );

    // Channel reminder hafalan muraja'ah
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kHafalanChannelId,
        'Pengingat Hafalan',
        description: 'Pengingat jadwal murajaah hafalan Al-Quran',
        importance: Importance.high,
      ),
    );
  }

  /// Resolve timezone name dari device ke IANA timezone name.
  /// Fallback ke 'Asia/Jakarta' jika gagal.
  Future<String> _resolveLocalTimezone() async {
    try {
      final offset = DateTime.now().timeZoneOffset;
      final offsetHours = offset.inHours;
      final tzName = DateTime.now().timeZoneName.toUpperCase();

      // Coba match dari offset dulu (paling reliable di Android)
      if (offsetHours == TimezoneConstants.wibOffsetHours) {
        return TimezoneConstants.wib;
      }
      if (offsetHours == TimezoneConstants.witaOffsetHours) {
        return TimezoneConstants.wita;
      }
      if (offsetHours == TimezoneConstants.witOffsetHours) {
        return TimezoneConstants.wit;
      }

      // Fallback: coba match dari nama timezone string
      if (tzName.contains('WIB') || tzName.contains('JAKARTA')) {
        return TimezoneConstants.wib;
      }
      if (tzName.contains('WITA') || tzName.contains('MAKASSAR')) {
        return TimezoneConstants.wita;
      }
      if (tzName.contains('WIT') || tzName.contains('JAYAPURA')) {
        return TimezoneConstants.wit;
      }

      // Coba pakai langsung jika sudah IANA format (misal dari flutter_timezone)
      final raw = DateTime.now().timeZoneName;
      if (raw.contains('/')) return raw;

      return TimezoneConstants.wib;
    } on Object catch (_) {
      debugPrint('NotificationService: timezone resolve failed, using WIB');
      return TimezoneConstants.wib;
    }
  }
}
