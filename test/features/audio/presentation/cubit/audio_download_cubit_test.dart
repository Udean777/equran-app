import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart'
    show DownloadedAyatInfo;
import 'package:equran_app/features/audio/domain/usecases/download_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadAyatAudio extends Mock implements DownloadAyatAudio {}

class MockGetDownloadedAyats extends Mock implements GetDownloadedAyats {}

// Helper — buat Ayat dummy
Ayat _ayat(int nomor, {String? qariId, String? url}) => Ayat(
  nomorAyat: nomor,
  teksArab: 'arab $nomor',
  teksLatin: 'latin $nomor',
  teksIndonesia: 'indonesia $nomor',
  audio: qariId != null && url != null ? {qariId: url} : {},
);

void main() {
  late MockDownloadAyatAudio mockDownload;
  late MockGetDownloadedAyats mockGetDownloaded;

  const qari = Qari.misyariRasyidAlAfasi;
  const suratNomor = 1;

  setUp(() {
    mockDownload = MockDownloadAyatAudio();
    mockGetDownloaded = MockGetDownloadedAyats();
    registerFallbackValue(Qari.misyariRasyidAlAfasi);
  });

  AudioDownloadCubit buildCubit() => AudioDownloadCubit(
    mockDownload,
    mockGetDownloaded,
  );

  group('AudioDownloadState', () {
    test('stateFor() return idle jika key tidak ada', () {
      const state = AudioDownloadState();
      expect(
        state.stateFor(1, 1, '05'),
        const DownloadState.idle(),
      );
    });

    test('stateFor() return state yang benar jika key ada', () {
      const state = AudioDownloadState(
        downloadStates: {'1:1:05': DownloadState.done()},
      );
      expect(state.stateFor(1, 1, '05'), const DownloadState.done());
    });

    test('isAllDownloaded() return false jika list kosong', () {
      const state = AudioDownloadState();
      expect(state.isAllDownloaded(1, [], '05'), isFalse);
    });

    test('isAllDownloaded() return false jika ada ayat belum done', () {
      final ayatList = [_ayat(1), _ayat(2)];
      const state = AudioDownloadState(
        downloadStates: {'1:1:05': DownloadState.done()},
      );
      expect(state.isAllDownloaded(1, ayatList, '05'), isFalse);
    });

    test('isAllDownloaded() return true jika semua ayat done', () {
      final ayatList = [_ayat(1), _ayat(2)];
      const state = AudioDownloadState(
        downloadStates: {
          '1:1:05': DownloadState.done(),
          '1:2:05': DownloadState.done(),
        },
      );
      expect(state.isAllDownloaded(1, ayatList, '05'), isTrue);
    });
  });

  group('AudioDownloadCubit.loadDownloadedStatus()', () {
    test('initial state kosong', () {
      expect(buildCubit().state, const AudioDownloadState());
    });

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'emit done untuk ayat yang sudah didownload',
      build: () {
        when(() => mockGetDownloaded()).thenAnswer(
          (_) async => right([
            const DownloadedAyatInfo(
              suratNomor: suratNomor,
              ayatNomor: 1,
              qari: qari,
              filePath: '/audio/1.mp3',
              sizeBytes: 1024,
            ),
          ]),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.loadDownloadedStatus(
        suratNomor: suratNomor,
        ayatList: [_ayat(1), _ayat(2)],
        qari: qari,
      ),
      expect: () => [
        isA<AudioDownloadState>().having(
          (s) => s.stateFor(suratNomor, 1, qari.id),
          'ayat 1 done',
          const DownloadState.done(),
        ),
      ],
      verify: (cubit) {
        expect(
          cubit.state.stateFor(suratNomor, 2, qari.id),
          const DownloadState.idle(),
        );
      },
    );

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'tidak emit jika getDownloadedAyats gagal',
      build: () {
        when(() => mockGetDownloaded()).thenAnswer(
          (_) async => left(const Failure.unknown(message: 'error')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.loadDownloadedStatus(
        suratNomor: suratNomor,
        ayatList: [_ayat(1)],
        qari: qari,
      ),
      expect: () => <AudioDownloadState>[],
    );
  });

  group('AudioDownloadCubit.downloadAyat()', () {
    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'emit downloading lalu done saat download berhasil',
      build: () {
        when(
          () => mockDownload(
            suratNomor: any(named: 'suratNomor'),
            ayatNomor: any(named: 'ayatNomor'),
            qari: any(named: 'qari'),
            url: any(named: 'url'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([right<Failure, double>(0.5), right<Failure, double>(1)]));
        return buildCubit();
      },
      act: (cubit) => cubit.downloadAyat(
        suratNomor: suratNomor,
        ayat: _ayat(1, qariId: qari.id, url: 'https://cdn.test/1.mp3'),
        qari: qari,
      ),
      expect: () => [
        isA<AudioDownloadState>().having(
          (s) => s.stateFor(suratNomor, 1, qari.id),
          'downloading 0',
          const DownloadState.downloading(progress: 0),
        ),
        isA<AudioDownloadState>().having(
          (s) => s.stateFor(suratNomor, 1, qari.id),
          'downloading 0.5',
          const DownloadState.downloading(progress: 0.5),
        ),
        isA<AudioDownloadState>().having(
          (s) => s.stateFor(suratNomor, 1, qari.id),
          'done',
          const DownloadState.done(),
        ),
      ],
    );

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'emit error jika download gagal',
      build: () {
        when(
          () => mockDownload(
            suratNomor: any(named: 'suratNomor'),
            ayatNomor: any(named: 'ayatNomor'),
            qari: any(named: 'qari'),
            url: any(named: 'url'),
          ),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            left(const Failure.unknown(message: 'network error')),
          ]),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.downloadAyat(
        suratNomor: suratNomor,
        ayat: _ayat(1, qariId: qari.id, url: 'https://cdn.test/1.mp3'),
        qari: qari,
      ),
      expect: () => [
        isA<AudioDownloadState>().having(
          (s) => s.stateFor(suratNomor, 1, qari.id),
          'downloading 0',
          const DownloadState.downloading(progress: 0),
        ),
        isA<AudioDownloadState>().having(
          (s) => s.stateFor(suratNomor, 1, qari.id),
          'error',
          isA<DownloadError>(),
        ),
      ],
    );

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'skip jika ayat tidak punya URL untuk qari',
      build: buildCubit,
      act: (cubit) => cubit.downloadAyat(
        suratNomor: suratNomor,
        ayat: _ayat(1), // tidak ada audio map
        qari: qari,
      ),
      expect: () => <AudioDownloadState>[],
      verify: (_) {
        verifyNever(
          () => mockDownload(
            suratNomor: any(named: 'suratNomor'),
            ayatNomor: any(named: 'ayatNomor'),
            qari: any(named: 'qari'),
            url: any(named: 'url'),
          ),
        );
      },
    );

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'skip jika ayat sudah done',
      build: () => buildCubit()
        ..emit(
          const AudioDownloadState(
            downloadStates: {'1:1:05': DownloadState.done()},
          ),
        ),
      act: (cubit) => cubit.downloadAyat(
        suratNomor: suratNomor,
        ayat: _ayat(1, qariId: qari.id, url: 'https://cdn.test/1.mp3'),
        qari: qari,
      ),
      expect: () => <AudioDownloadState>[],
      verify: (_) {
        verifyNever(
          () => mockDownload(
            suratNomor: any(named: 'suratNomor'),
            ayatNomor: any(named: 'ayatNomor'),
            qari: any(named: 'qari'),
            url: any(named: 'url'),
          ),
        );
      },
    );
  });

  group('AudioDownloadCubit.downloadSurat()', () {
    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'download semua ayat sequential dan update progress',
      build: () {
        when(
          () => mockDownload(
            suratNomor: any(named: 'suratNomor'),
            ayatNomor: any(named: 'ayatNomor'),
            qari: any(named: 'qari'),
            url: any(named: 'url'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([right<Failure, double>(1)]));
        return buildCubit();
      },
      act: (cubit) => cubit.downloadSurat(
        suratNomor: suratNomor,
        ayatList: [
          _ayat(1, qariId: qari.id, url: 'https://cdn.test/1.mp3'),
          _ayat(2, qariId: qari.id, url: 'https://cdn.test/2.mp3'),
        ],
        qari: qari,
      ),
      verify: (cubit) {
        // Semua ayat harus done setelah selesai
        expect(
          cubit.state.stateFor(suratNomor, 1, qari.id),
          const DownloadState.done(),
        );
        expect(
          cubit.state.stateFor(suratNomor, 2, qari.id),
          const DownloadState.done(),
        );
        // isDownloadingSurat harus false setelah selesai
        expect(cubit.state.isDownloadingSurat, isFalse);
      },
    );

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'cancelSuratDownload() menghentikan download di tengah jalan',
      build: () {
        when(
          () => mockDownload(
            suratNomor: any(named: 'suratNomor'),
            ayatNomor: any(named: 'ayatNomor'),
            qari: any(named: 'qari'),
            url: any(named: 'url'),
          ),
        ).thenAnswer((_) async* {
          yield right<Failure, double>(1);
        });
        return buildCubit();
      },
      act: (cubit) async {
        // Cancel setelah mulai
        final future = cubit.downloadSurat(
          suratNomor: suratNomor,
          ayatList: [
            _ayat(1, qariId: qari.id, url: 'https://cdn.test/1.mp3'),
            _ayat(2, qariId: qari.id, url: 'https://cdn.test/2.mp3'),
            _ayat(3, qariId: qari.id, url: 'https://cdn.test/3.mp3'),
          ],
          qari: qari,
        );
        cubit.cancelSuratDownload();
        await future;
      },
      verify: (cubit) {
        // isDownloadingSurat harus false setelah cancel
        expect(cubit.state.isDownloadingSurat, isFalse);
      },
    );

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'skip jika semua ayat sudah done',
      build: () => buildCubit()
        ..emit(
          const AudioDownloadState(
            downloadStates: {
              '1:1:05': DownloadState.done(),
              '1:2:05': DownloadState.done(),
            },
          ),
        ),
      act: (cubit) => cubit.downloadSurat(
        suratNomor: suratNomor,
        ayatList: [
          _ayat(1, qariId: qari.id, url: 'https://cdn.test/1.mp3'),
          _ayat(2, qariId: qari.id, url: 'https://cdn.test/2.mp3'),
        ],
        qari: qari,
      ),
      expect: () => <AudioDownloadState>[],
      verify: (_) {
        verifyNever(
          () => mockDownload(
            suratNomor: any(named: 'suratNomor'),
            ayatNomor: any(named: 'ayatNomor'),
            qari: any(named: 'qari'),
            url: any(named: 'url'),
          ),
        );
      },
    );
  });

  // ── Memory leak prevention ────────────────────────────────────────────────

  group('AudioDownloadCubit memory leak prevention', () {
    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'loadDownloadedStatus() membersihkan states surat lama saat ganti surat',
      build: () {
        when(
          () => mockGetDownloaded(),
        ).thenAnswer((_) async => const Right([]));
        return buildCubit();
      },
      act: (cubit) async {
        // Load surat 1 dulu — set _currentSuratNomor = 1
        await cubit.loadDownloadedStatus(
          suratNomor: 1,
          ayatList: [_ayat(1), _ayat(2), _ayat(3)],
          qari: qari,
        );
        // Paksa emit state dengan states surat 1 (simulasi setelah download)
        cubit.emit(
          const AudioDownloadState(
            downloadStates: {
              '1:1:05': DownloadState.done(),
              '1:2:05': DownloadState.done(),
              '1:3:05': DownloadState.done(),
            },
          ),
        );
        // Ganti ke surat 2 — harus clear states surat 1
        await cubit.loadDownloadedStatus(
          suratNomor: 2,
          ayatList: [_ayat(1)],
          qari: qari,
        );
      },
      verify: (cubit) {
        // States surat 1 harus sudah dihapus
        expect(
          cubit.state.downloadStates.keys.where((k) => k.startsWith('1:')),
          isEmpty,
        );
      },
    );

    blocTest<AudioDownloadCubit, AudioDownloadState>(
      'loadDownloadedStatus() tidak clear states jika surat sama',
      build: () {
        when(
          () => mockGetDownloaded(),
        ).thenAnswer((_) async => const Right([]));
        return buildCubit();
      },
      seed: () => const AudioDownloadState(
        downloadStates: {
          '1:1:05': DownloadState.done(),
          '1:2:05': DownloadState.done(),
        },
      ),
      act: (cubit) async {
        // Load surat 1 dua kali — tidak boleh clear
        await cubit.loadDownloadedStatus(
          suratNomor: suratNomor,
          ayatList: [_ayat(1), _ayat(2)],
          qari: qari,
        );
        await cubit.loadDownloadedStatus(
          suratNomor: suratNomor,
          ayatList: [_ayat(1), _ayat(2)],
          qari: qari,
        );
      },
      verify: (cubit) {
        // States surat 1 masih ada (tidak di-clear karena surat sama)
        expect(
          cubit.state.downloadStates.keys.where((k) => k.startsWith('1:')),
          isNotEmpty,
        );
      },
    );

    test('close() reset _currentSuratNomor', () async {
      when(
        () => mockGetDownloaded(),
      ).thenAnswer((_) async => const Right([]));

      final cubit = buildCubit();
      await cubit.loadDownloadedStatus(
        suratNomor: suratNomor,
        ayatList: [_ayat(1)],
        qari: qari,
      );
      await cubit.close();
      // Tidak throw setelah close
      expect(cubit.isClosed, isTrue);
    });
  });
}
