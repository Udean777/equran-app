import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/notifications/shalat_notif_config.dart';
import 'package:equran_app/core/notifications/shalat_notification_scheduler.dart';
import 'package:equran_app/core/notifications/shalat_schedule_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class MockNotificationService extends Mock implements NotificationService {}

class FakeTZDateTime extends Fake implements tz.TZDateTime {}

class TestableScheduler extends ShalatNotificationScheduler {
  // ignore: use_super_parameters — super constructor param is private (_notificationService), cannot use super parameter syntax
  TestableScheduler(NotificationService service) : super(service);

  DateTime? parseWaktuForTest({
    required String waktuStr,
    required int menitSebelum,
    required DateTime referenceDate,
  }) {
    try {
      final parts = waktuStr.trim().split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
        minute,
      ).subtract(Duration(minutes: menitSebelum));
    } on Object catch (_) {
      return null;
    }
  }
}

void main() {
  late MockNotificationService mockService;
  late TestableScheduler scheduler;

  setUpAll(() {
    registerFallbackValue(FakeTZDateTime());
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
  });

  setUp(() {
    mockService = MockNotificationService();
    scheduler = TestableScheduler(mockService);
  });

  group('ShalatNotificationScheduler — parse waktu', () {
    final ref = DateTime(2026, 5, 25);

    test('parse "04:32" tanpa offset → 04:32', () {
      final result = scheduler.parseWaktuForTest(
        waktuStr: '04:32',
        menitSebelum: 0,
        referenceDate: ref,
      );
      expect(result, isNotNull);
      expect(result!.hour, equals(4));
      expect(result.minute, equals(32));
    });

    test('parse "12:00" dengan offset 10 menit → 11:50', () {
      final result = scheduler.parseWaktuForTest(
        waktuStr: '12:00',
        menitSebelum: 10,
        referenceDate: ref,
      );
      expect(result, isNotNull);
      expect(result!.hour, equals(11));
      expect(result.minute, equals(50));
    });

    test('parse "18:05" dengan offset 15 menit → 17:50', () {
      final result = scheduler.parseWaktuForTest(
        waktuStr: '18:05',
        menitSebelum: 15,
        referenceDate: ref,
      );
      expect(result, isNotNull);
      expect(result!.hour, equals(17));
      expect(result.minute, equals(50));
    });

    test('parse format tidak valid → return null', () {
      final result = scheduler.parseWaktuForTest(
        waktuStr: 'invalid',
        menitSebelum: 0,
        referenceDate: ref,
      );
      expect(result, isNull);
    });

    test('parse string kosong → return null', () {
      final result = scheduler.parseWaktuForTest(
        waktuStr: '',
        menitSebelum: 0,
        referenceDate: ref,
      );
      expect(result, isNull);
    });

    test('parse "00:01" dengan offset 5 menit → 23:56 hari sebelumnya', () {
      final result = scheduler.parseWaktuForTest(
        waktuStr: '00:01',
        menitSebelum: 5,
        referenceDate: ref,
      );
      expect(result, isNotNull);
      expect(result!.hour, equals(23));
      expect(result.minute, equals(56));
      expect(result.day, equals(24));
    });
  });

  group('ShalatNotificationScheduler — scheduleForToday', () {
    const entry = ShalatScheduleEntry(
      subuh: '04:32',
      dzuhur: '11:52',
      ashar: '15:12',
      maghrib: '17:52',
      isya: '19:02',
    );

    void stubMocks() {
      when(() => mockService.cancelAll()).thenAnswer((_) async {});
      when(() => mockService.cancelById(any())).thenAnswer((_) async {});
      when(
        () => mockService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          isSubuh: any(named: 'isSubuh'),
        ),
      ).thenAnswer((_) async {});
    }

    test('schedule semua waktu jika semua prefs enabled', () async {
      stubMocks();

      await scheduler.scheduleForToday(entry, const ShalatNotifConfig());

      verify(() => mockService.cancelById(any())).called(5);
      verify(
        () => mockService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          isSubuh: any(named: 'isSubuh'),
        ),
      ).called(5);
    });

    test('skip waktu yang disabled di prefs', () async {
      stubMocks();

      const prefs = ShalatNotifConfig(
        subuh: false,
        dzuhur: false,
        isya: false,
      );

      await scheduler.scheduleForToday(entry, prefs);

      verify(() => mockService.cancelById(any())).called(5);
      verify(
        () => mockService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          isSubuh: any(named: 'isSubuh'),
        ),
      ).called(2);
    });

    test('subuh menggunakan isSubuh: true', () async {
      stubMocks();

      const prefs = ShalatNotifConfig(
        dzuhur: false,
        ashar: false,
        maghrib: false,
        isya: false,
      );

      await scheduler.scheduleForToday(entry, prefs);

      verify(
        () => mockService.scheduleNotification(
          id: kNotifIdSubuh,
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          isSubuh: true,
        ),
      ).called(1);
    });

    test('cancelAll dipanggil meski semua prefs disabled', () async {
      when(() => mockService.cancelAll()).thenAnswer((_) async {});
      when(() => mockService.cancelById(any())).thenAnswer((_) async {});

      const prefs = ShalatNotifConfig(
        subuh: false,
        dzuhur: false,
        ashar: false,
        maghrib: false,
        isya: false,
      );

      await scheduler.scheduleForToday(entry, prefs);

      verify(() => mockService.cancelById(any())).called(5);
      verifyNever(
        () => mockService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          isSubuh: any(named: 'isSubuh'),
        ),
      );
    });
  });
}
