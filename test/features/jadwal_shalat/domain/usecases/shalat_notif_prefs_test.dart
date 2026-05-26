import 'package:equran_app/features/jadwal_shalat/data/datasources/shalat_notif_prefs_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShalatNotifPrefsDataSource extends Mock
    implements ShalatNotifPrefsDataSource {}

void main() {
  late MockShalatNotifPrefsDataSource mockDataSource;
  late GetShalatNotifPrefs getPrefs;
  late SaveShalatNotifPrefs savePrefs;

  setUp(() {
    mockDataSource = MockShalatNotifPrefsDataSource();
    getPrefs = GetShalatNotifPrefs(mockDataSource);
    savePrefs = SaveShalatNotifPrefs(mockDataSource);
  });

  group('GetShalatNotifPrefs', () {
    test('return default prefs jika datasource return default', () async {
      when(
        () => mockDataSource.getPrefs(),
      ).thenAnswer((_) async => const ShalatNotifPrefs());

      final result = await getPrefs();

      result.fold(
        (_) => fail('should be right'),
        (prefs) {
          expect(prefs.subuh, isTrue);
          expect(prefs.dzuhur, isTrue);
          expect(prefs.ashar, isTrue);
          expect(prefs.maghrib, isTrue);
          expect(prefs.isya, isTrue);
          expect(prefs.menitSebelum, equals(0));
        },
      );
    });

    test('return prefs yang tersimpan', () async {
      const saved = ShalatNotifPrefs(
        subuh: false,
        ashar: false,
        isya: false,
        menitSebelum: 10,
      );
      when(() => mockDataSource.getPrefs()).thenAnswer((_) async => saved);

      final result = await getPrefs();

      result.fold(
        (_) => fail('should be right'),
        (prefs) {
          expect(prefs.subuh, isFalse);
          expect(prefs.dzuhur, isTrue);
          expect(prefs.ashar, isFalse);
          expect(prefs.maghrib, isTrue);
          expect(prefs.isya, isFalse);
          expect(prefs.menitSebelum, equals(10));
        },
      );
    });

    test('return Failure jika datasource throw', () async {
      when(() => mockDataSource.getPrefs()).thenThrow(Exception('hive error'));

      final result = await getPrefs();

      expect(result.isLeft(), isTrue);
    });
  });

  group('SaveShalatNotifPrefs', () {
    test('panggil datasource.savePrefs dengan prefs yang benar', () async {
      const prefs = ShalatNotifPrefs(
        dzuhur: false,
        menitSebelum: 5,
      );
      when(() => mockDataSource.savePrefs(prefs)).thenAnswer((_) async {});

      final result = await savePrefs(prefs);

      expect(result.isRight(), isTrue);
      verify(() => mockDataSource.savePrefs(prefs)).called(1);
    });

    test('return Failure jika datasource throw', () async {
      const prefs = ShalatNotifPrefs();
      when(
        () => mockDataSource.savePrefs(prefs),
      ).thenThrow(Exception('write error'));

      final result = await savePrefs(prefs);

      expect(result.isLeft(), isTrue);
    });
  });

  group('ShalatNotifPrefs entity', () {
    test('default values semua true dan menitSebelum 0', () {
      const prefs = ShalatNotifPrefs();
      expect(prefs.subuh, isTrue);
      expect(prefs.dzuhur, isTrue);
      expect(prefs.ashar, isTrue);
      expect(prefs.maghrib, isTrue);
      expect(prefs.isya, isTrue);
      expect(prefs.menitSebelum, equals(0));
    });

    test('copyWith mengubah field yang ditentukan saja', () {
      const prefs = ShalatNotifPrefs();
      final updated = prefs.copyWith(subuh: false, menitSebelum: 15);

      expect(updated.subuh, isFalse);
      expect(updated.dzuhur, isTrue);
      expect(updated.ashar, isTrue);
      expect(updated.maghrib, isTrue);
      expect(updated.isya, isTrue);
      expect(updated.menitSebelum, equals(15));
    });

    test('equality — dua instance dengan nilai sama adalah equal', () {
      const a = ShalatNotifPrefs(subuh: false, menitSebelum: 5);
      const b = ShalatNotifPrefs(subuh: false, menitSebelum: 5);
      expect(a, equals(b));
    });
  });
}
