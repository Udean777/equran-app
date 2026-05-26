import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/usecases/delete_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/download_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioDownloadDataSource extends Mock
    implements AudioDownloadDataSource {}

void main() {
  late MockAudioDownloadDataSource mockDataSource;
  late DownloadAyatAudio downloadAyatAudio;
  late DeleteAyatAudio deleteAyatAudio;
  late GetDownloadedAyats getDownloadedAyats;

  setUpAll(() {
    registerFallbackValue(Qari.misyariRasyidAlAfasi);
  });

  setUp(() {
    mockDataSource = MockAudioDownloadDataSource();
    downloadAyatAudio = DownloadAyatAudio(mockDataSource);
    deleteAyatAudio = DeleteAyatAudio(mockDataSource);
    getDownloadedAyats = GetDownloadedAyats(mockDataSource);
  });

  group('DownloadAyatAudio', () {
    test('emit right(1.0) saat download selesai', () async {
      when(
        () => mockDataSource.downloadAyat(
          suratNomor: any(named: 'suratNomor'),
          ayatNomor: any(named: 'ayatNomor'),
          qari: any(named: 'qari'),
          url: any(named: 'url'),
        ),
      ).thenAnswer((_) => Stream.value(1));

      final results = await downloadAyatAudio(
        suratNomor: 1,
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        url: 'https://cdn.islamic.network/quran/audio/128/05/1.mp3',
      ).toList();

      expect(results.length, equals(1));
      expect(results.first.isRight(), isTrue);
      results.first.fold(
        (_) => fail('should be right'),
        (progress) => expect(progress, equals(1.0)),
      );
    });

    test('emit left(Failure) saat download error', () async {
      when(
        () => mockDataSource.downloadAyat(
          suratNomor: any(named: 'suratNomor'),
          ayatNomor: any(named: 'ayatNomor'),
          qari: any(named: 'qari'),
          url: any(named: 'url'),
        ),
      ).thenAnswer((_) => Stream.error(Exception('network error')));

      final results = await downloadAyatAudio(
        suratNomor: 1,
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        url: 'https://cdn.islamic.network/quran/audio/128/05/1.mp3',
      ).toList();

      expect(results.length, equals(1));
      expect(results.first.isLeft(), isTrue);
    });
  });

  group('DeleteAyatAudio', () {
    test('return right(unit) saat delete berhasil', () async {
      when(
        () => mockDataSource.deleteAyat(
          suratNomor: any(named: 'suratNomor'),
          ayatNomor: any(named: 'ayatNomor'),
          qari: any(named: 'qari'),
        ),
      ).thenAnswer((_) async {});

      final result = await deleteAyatAudio(
        suratNomor: 1,
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      );

      expect(result, equals(right<Failure, Unit>(unit)));
      verify(
        () => mockDataSource.deleteAyat(
          suratNomor: 1,
          ayatNomor: 1,
          qari: Qari.misyariRasyidAlAfasi,
        ),
      ).called(1);
    });

    test('return left(Failure) saat delete error', () async {
      when(
        () => mockDataSource.deleteAyat(
          suratNomor: any(named: 'suratNomor'),
          ayatNomor: any(named: 'ayatNomor'),
          qari: any(named: 'qari'),
        ),
      ).thenThrow(Exception('delete error'));

      final result = await deleteAyatAudio(
        suratNomor: 1,
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetDownloadedAyats', () {
    test('return list file yang sudah didownload', () async {
      final files = [
        const DownloadedAyatInfo(
          suratNomor: 1,
          ayatNomor: 1,
          qari: Qari.misyariRasyidAlAfasi,
          filePath: '/audio/05/1/1.mp3',
          sizeBytes: 12345,
        ),
        const DownloadedAyatInfo(
          suratNomor: 1,
          ayatNomor: 2,
          qari: Qari.misyariRasyidAlAfasi,
          filePath: '/audio/05/1/2.mp3',
          sizeBytes: 23456,
        ),
      ];

      when(() => mockDataSource.getDownloadedAyats())
          .thenAnswer((_) async => files);

      final result = await getDownloadedAyats();

      result.fold(
        (_) => fail('should be right'),
        (list) {
          expect(list.length, equals(2));
          expect(list.first.suratNomor, equals(1));
          expect(list.first.ayatNomor, equals(1));
          expect(list.first.sizeBytes, equals(12345));
        },
      );
    });

    test('return empty list jika tidak ada file', () async {
      when(() => mockDataSource.getDownloadedAyats())
          .thenAnswer((_) async => []);

      final result = await getDownloadedAyats();

      result.fold(
        (_) => fail('should be right'),
        (list) => expect(list, isEmpty),
      );
    });

    test('return left(Failure) jika datasource throw', () async {
      when(() => mockDataSource.getDownloadedAyats())
          .thenThrow(Exception('storage error'));

      final result = await getDownloadedAyats();

      expect(result.isLeft(), isTrue);
    });
  });
}
