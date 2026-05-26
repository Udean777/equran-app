import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/notifications/imsak_alarm_config.dart';
import 'package:equran_app/core/notifications/imsak_alarm_scheduler.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsak_alarm_cubit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// ---------------------------------------------------------------------------
// Mocks & Fakes
// ---------------------------------------------------------------------------

class MockNotificationService extends Mock implements NotificationService {}

class MockImsakAlarmScheduler extends Mock implements ImsakAlarmScheduler {}

class MockGetImsakAlarmPrefs extends Mock implements GetImsakAlarmPrefs {}

class MockSaveImsakAlarmPrefs extends Mock implements SaveImsakAlarmPrefs {}

class FakeTZDateTime extends Fake implements tz.TZDateTime {}

class FakeNotificationDetails extends Fake implements NotificationDetails {}

class FakeImsakAlarmPrefs extends Fake implements ImsakAlarmPrefs {}

class FakeImsakiyahEntry extends Fake implements ImsakiyahEntry {}

class FakeImsakAlarmConfig extends Fake implements ImsakAlarmConfig {}

// ---------------------------------------------------------------------------
// Fake data
// ---------------------------------------------------------------------------

const tEntry = ImsakiyahEntry(
  tanggal: 1,
  imsak: '04:28',
  subuh: '04:38',
  terbit: '05:52',
  dhuha: '06:18',
  dzuhur: '11:58',
  ashar: '15:18',
  maghrib: '17:58',
  isya: '19:08',
);

const tPrefsDefault = ImsakAlarmPrefs();
const tPrefsImsakOn = ImsakAlarmPrefs(imsakEnabled: true);
const tPrefsSahurOn = ImsakAlarmPrefs(sahurEnabled: true);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    registerFallbackValue(FakeTZDateTime());
    registerFallbackValue(FakeNotificationDetails());
    registerFallbackValue(FakeImsakAlarmPrefs());
    registerFallbackValue(FakeImsakiyahEntry());
    registerFallbackValue(FakeImsakAlarmConfig());
  });

  // ── ImsakAlarmScheduler unit tests ────────────────────────────────────────
  group('ImsakAlarmScheduler', () {
    late MockNotificationService mockNotif;
    late ImsakAlarmScheduler scheduler;

    setUp(() {
      mockNotif = MockNotificationService();
      scheduler = ImsakAlarmScheduler(mockNotif);

      when(() => mockNotif.cancelById(any())).thenAnswer((_) async {});
      when(
        () => mockNotif.scheduleNotificationRaw(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          details: any(named: 'details'),
        ),
      ).thenAnswer((_) async {});
    });

    test('cancelAll hanya cancel ID 6 dan 7', () async {
      await scheduler.cancelAll();

      verify(() => mockNotif.cancelById(kNotifIdImsak)).called(1);
      verify(() => mockNotif.cancelById(kNotifIdSahur)).called(1);
      verifyNever(() => mockNotif.cancelById(1));
      verifyNever(() => mockNotif.cancelById(2));
      verifyNever(() => mockNotif.cancelById(10));
    });

    test('scheduleForToday tidak schedule jika semua disabled', () async {
      await scheduler.scheduleForToday(tEntry, const ImsakAlarmConfig());

      verify(() => mockNotif.cancelById(kNotifIdImsak)).called(1);
      verify(() => mockNotif.cancelById(kNotifIdSahur)).called(1);
      verifyNever(
        () => mockNotif.scheduleNotificationRaw(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          details: any(named: 'details'),
        ),
      );
    });

    test('scheduleForToday schedule imsak jika imsakEnabled = true', () async {
      await scheduler.scheduleForToday(
        tEntry,
        const ImsakAlarmConfig(imsakEnabled: true),
      );

      verify(
        () => mockNotif.scheduleNotificationRaw(
          id: kNotifIdImsak,
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          details: any(named: 'details'),
        ),
      ).called(1);
    });

    test('scheduleForToday schedule sahur jika sahurEnabled = true', () async {
      await scheduler.scheduleForToday(
        tEntry,
        const ImsakAlarmConfig(sahurEnabled: true),
      );

      verify(
        () => mockNotif.scheduleNotificationRaw(
          id: kNotifIdSahur,
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          details: any(named: 'details'),
        ),
      ).called(1);
    });

    test('scheduleForToday schedule keduanya jika keduanya enabled', () async {
      await scheduler.scheduleForToday(
        tEntry,
        const ImsakAlarmConfig(imsakEnabled: true, sahurEnabled: true),
      );

      verify(
        () => mockNotif.scheduleNotificationRaw(
          id: kNotifIdImsak,
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          details: any(named: 'details'),
        ),
      ).called(1);

      verify(
        () => mockNotif.scheduleNotificationRaw(
          id: kNotifIdSahur,
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
          details: any(named: 'details'),
        ),
      ).called(1);
    });
  });

  // ── ImsakAlarmCubit tests ─────────────────────────────────────────────────
  group('ImsakAlarmCubit', () {
    late MockGetImsakAlarmPrefs mockGetPrefs;
    late MockSaveImsakAlarmPrefs mockSavePrefs;
    late MockImsakAlarmScheduler mockScheduler;

    setUp(() {
      mockGetPrefs = MockGetImsakAlarmPrefs();
      mockSavePrefs = MockSaveImsakAlarmPrefs();
      mockScheduler = MockImsakAlarmScheduler();

      when(() => mockGetPrefs()).thenAnswer((_) async => tPrefsDefault);
      when(() => mockSavePrefs(any())).thenAnswer((_) async {});
      when(() => mockScheduler.cancelAll()).thenAnswer((_) async {});
      when(
        () => mockScheduler.scheduleForToday(any(), any()),
      ).thenAnswer((_) async {});
    });

    ImsakAlarmCubit buildCubit() => ImsakAlarmCubit(
          mockGetPrefs,
          mockSavePrefs,
          mockScheduler,
        );

    test('initial state adalah ImsakAlarmInitial', () {
      expect(buildCubit().state, const ImsakAlarmState.initial());
    });

    blocTest<ImsakAlarmCubit, ImsakAlarmState>(
      'load() emit loaded dengan prefs dari storage',
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      ],
    );

    blocTest<ImsakAlarmCubit, ImsakAlarmState>(
      'toggleImsak() flip imsakEnabled dan persist',
      build: buildCubit,
      seed: () => const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      act: (c) => c.toggleImsak(entry: tEntry),
      expect: () => [
        const ImsakAlarmState.loaded(prefs: tPrefsImsakOn),
      ],
      verify: (_) {
        verify(() => mockSavePrefs(tPrefsImsakOn)).called(1);
      },
    );

    blocTest<ImsakAlarmCubit, ImsakAlarmState>(
      'toggleImsak() dua kali kembali ke default',
      build: buildCubit,
      seed: () => const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      act: (c) async {
        await c.toggleImsak(entry: tEntry);
        await c.toggleImsak(entry: tEntry);
      },
      expect: () => [
        const ImsakAlarmState.loaded(prefs: tPrefsImsakOn),
        const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      ],
    );

    blocTest<ImsakAlarmCubit, ImsakAlarmState>(
      'toggleSahur() flip sahurEnabled dan persist',
      build: buildCubit,
      seed: () => const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      act: (c) => c.toggleSahur(entry: tEntry),
      expect: () => [
        const ImsakAlarmState.loaded(prefs: tPrefsSahurOn),
      ],
      verify: (_) {
        verify(() => mockSavePrefs(tPrefsSahurOn)).called(1);
      },
    );

    blocTest<ImsakAlarmCubit, ImsakAlarmState>(
      'setMenitSebelum() update menitSebelumImsak',
      build: buildCubit,
      seed: () => const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      act: (c) => c.setMenitSebelum(30, entry: tEntry),
      expect: () => [
        const ImsakAlarmState.loaded(
          prefs: ImsakAlarmPrefs(menitSebelumImsak: 30),
        ),
      ],
      verify: (_) {
        verify(
          () => mockSavePrefs(const ImsakAlarmPrefs(menitSebelumImsak: 30)),
        ).called(1);
      },
    );

    blocTest<ImsakAlarmCubit, ImsakAlarmState>(
      'toggleImsak() tanpa entry memanggil cancelAll',
      build: buildCubit,
      seed: () => const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      act: (c) => c.toggleImsak(),
      verify: (_) {
        verify(() => mockScheduler.cancelAll()).called(1);
      },
    );

    blocTest<ImsakAlarmCubit, ImsakAlarmState>(
      'toggleImsak() dengan entry memanggil scheduleForToday',
      build: buildCubit,
      seed: () => const ImsakAlarmState.loaded(prefs: tPrefsDefault),
      act: (c) => c.toggleImsak(entry: tEntry),
      verify: (_) {
        verify(
          () => mockScheduler.scheduleForToday(tEntry, any()),
        ).called(1);
      },
    );

    test('todayEntry() return entry dengan tanggal hari ini', () {
      final today = DateTime.now().day;
      final entry = ImsakiyahEntry(
        tanggal: today,
        imsak: '04:28',
        subuh: '04:38',
        terbit: '05:52',
        dhuha: '06:18',
        dzuhur: '11:58',
        ashar: '15:18',
        maghrib: '17:58',
        isya: '19:08',
      );
      final imsakiyah = _fakeImsakiyah([entry]);
      expect(ImsakAlarmCubit.todayEntry(imsakiyah), entry);
    });

    test('todayEntry() return null jika tidak ada entry hari ini', () {
      const entry = ImsakiyahEntry(
        tanggal: 0,
        imsak: '04:28',
        subuh: '04:38',
        terbit: '05:52',
        dhuha: '06:18',
        dzuhur: '11:58',
        ashar: '15:18',
        maghrib: '17:58',
        isya: '19:08',
      );
      final imsakiyah = _fakeImsakiyah([entry]);
      expect(ImsakAlarmCubit.todayEntry(imsakiyah), isNull);
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Imsakiyah _fakeImsakiyah(List<ImsakiyahEntry> entries) => Imsakiyah(
      provinsi: 'DKI Jakarta',
      kabkota: 'Kota Jakarta Pusat',
      hijriah: 'Ramadan 1446',
      masehi: 'Maret 2025',
      imsakiyah: entries,
    );
