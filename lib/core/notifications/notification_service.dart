import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Channel IDs
const String kAdzanChannelId = 'adzan_channel';
const String kAdzanSubuhChannelId = 'adzan_subuh_channel';

/// Notification IDs per waktu shalat
const int kNotifIdSubuh = 1;
const int kNotifIdDzuhur = 2;
const int kNotifIdAshar = 3;
const int kNotifIdMaghrib = 4;
const int kNotifIdIsya = 5;

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
    tz.setLocalLocation(tz.getLocation(timezoneName));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
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

    // Request permission
    await requestPermission();
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
      await androidPlugin.requestExactAlarmsPermission();
    }

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      final result = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = result ?? false;
    }

    return granted;
  }

  /// Schedule notifikasi pada [scheduledTime].
  /// [isSubuh] menentukan channel + sound yang digunakan.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required bool isSubuh,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      isSubuh ? kAdzanSubuhChannelId : kAdzanChannelId,
      isSubuh ? 'Adzan Subuh' : 'Adzan Waktu Shalat',
      channelDescription: isSubuh
          ? 'Notifikasi adzan waktu Subuh'
          : 'Notifikasi adzan waktu shalat',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        isSubuh ? 'adzan_subuh' : 'adzan',
      ),
    );

    final iosDetails = DarwinNotificationDetails(
      sound: isSubuh ? 'adzan_subuh.caf' : 'adzan.caf',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancel notifikasi berdasarkan [id].
  Future<void> cancelById(int id) => _plugin.cancel(id);

  /// Cancel semua notifikasi shalat.
  Future<void> cancelAll() => _plugin.cancelAll();

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    // Channel adzan biasa (Dzuhur, Ashar, Maghrib, Isya)
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kAdzanChannelId,
        'Adzan Waktu Shalat',
        description: 'Notifikasi adzan waktu shalat',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('adzan'),
      ),
    );

    // Channel adzan subuh
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kAdzanSubuhChannelId,
        'Adzan Subuh',
        description: 'Notifikasi adzan waktu Subuh',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('adzan_subuh'),
      ),
    );
  }

  /// Resolve timezone name dari device.
  /// Fallback ke 'Asia/Jakarta' jika gagal.
  Future<String> _resolveLocalTimezone() async {
    try {
      final offset = DateTime.now().timeZoneOffset;
      final offsetHours = offset.inHours;

      if (offsetHours == 7) return 'Asia/Jakarta'; // WIB
      if (offsetHours == 8) return 'Asia/Makassar'; // WITA
      if (offsetHours == 9) return 'Asia/Jayapura'; // WIT

      return DateTime.now().timeZoneName;
    } on Object catch (_) {
      debugPrint('NotificationService: timezone resolve failed, using WIB');
      return 'Asia/Jakarta';
    }
  }
}
