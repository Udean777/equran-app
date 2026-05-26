import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:equran_app/features/audio/domain/usecases/pause_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/play_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/resume_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/seek_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/stop_audio.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayAudio extends Mock implements PlayAudio {}

class MockPauseAudio extends Mock implements PauseAudio {}

class MockResumeAudio extends Mock implements ResumeAudio {}

class MockStopAudio extends Mock implements StopAudio {}

class MockSeekAudio extends Mock implements SeekAudio {}

class MockAudioRepository extends Mock implements AudioRepository {}

void main() {
  late MockPlayAudio mockPlay;
  late MockPauseAudio mockPause;
  late MockResumeAudio mockResume;
  late MockStopAudio mockStop;
  late MockSeekAudio mockSeek;
  late MockAudioRepository mockRepository;
  late StreamController<AudioPlayerState> stateController;

  setUp(() {
    mockPlay = MockPlayAudio();
    mockPause = MockPauseAudio();
    mockResume = MockResumeAudio();
    mockStop = MockStopAudio();
    mockSeek = MockSeekAudio();
    mockRepository = MockAudioRepository();
    stateController = StreamController<AudioPlayerState>.broadcast();

    when(
      () => mockRepository.stateStream,
    ).thenAnswer((_) => stateController.stream);
    registerFallbackValue(
      const PlayAudioParams(
        url: 'https://test.com/audio.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      ),
    );
    registerFallbackValue(Duration.zero);
  });

  tearDown(() async {
    await stateController.close();
  });

  AudioCubit buildCubit() => AudioCubit(
    mockPlay,
    mockPause,
    mockResume,
    mockStop,
    mockSeek,
    mockRepository,
  );

  group('AudioCubit', () {
    test('initial state adalah idle', () async {
      final cubit = buildCubit();
      expect(cubit.state, const AudioPlayerState.idle());
      await cubit.close();
    });

    blocTest<AudioCubit, AudioPlayerState>(
      'emit state dari stateStream repository',
      build: buildCubit,
      act: (cubit) {
        stateController.add(
          const AudioPlayerState.loading(
            ayatNomor: 1,
            qari: Qari.misyariRasyidAlAfasi,
          ),
        );
      },
      expect: () => [
        const AudioPlayerState.loading(
          ayatNomor: 1,
          qari: Qari.misyariRasyidAlAfasi,
        ),
      ],
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playOrToggle() memanggil play untuk ayat baru',
      build: () {
        when(() => mockPlay(any())).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.playOrToggle(
        url: 'https://test.com/audio.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      ),
      verify: (_) {
        verify(() => mockPlay(any())).called(1);
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playOrToggle() memanggil pause jika ayat sama sedang playing',
      build: () {
        when(() => mockPause()).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      seed: () => const AudioPlayerState.playing(
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        position: Duration.zero,
        duration: Duration(seconds: 30),
      ),
      act: (cubit) => cubit.playOrToggle(
        url: 'https://test.com/audio.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      ),
      verify: (_) {
        verify(() => mockPause()).called(1);
        verifyNever(() => mockPlay(any()));
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playOrToggle() memanggil resume jika ayat sama sedang paused',
      build: () {
        when(() => mockResume()).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      seed: () => const AudioPlayerState.paused(
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        position: Duration(seconds: 10),
        duration: Duration(seconds: 30),
      ),
      act: (cubit) => cubit.playOrToggle(
        url: 'https://test.com/audio.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      ),
      verify: (_) {
        verify(() => mockResume()).called(1);
        verifyNever(() => mockPlay(any()));
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'stop() memanggil stopAudio usecase',
      build: () {
        when(() => mockStop()).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.stop(),
      verify: (_) {
        verify(() => mockStop()).called(1);
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'seek() memanggil seekAudio usecase dengan durasi yang benar',
      build: () {
        when(() => mockSeek(any())).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.seek(const Duration(seconds: 15)),
      verify: (_) {
        verify(() => mockSeek(const Duration(seconds: 15))).called(1);
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playOrToggle() menyimpan audioMap ke lastAudioMap',
      build: () {
        when(() => mockPlay(any())).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.playOrToggle(
        url: 'https://test.com/audio.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        audioMap: {'05': 'https://test.com/audio.mp3'},
      ),
      verify: (cubit) {
        expect(cubit.lastAudioMap, {'05': 'https://test.com/audio.mp3'});
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playOrToggle() tidak mengubah lastAudioMap jika audioMap kosong',
      build: () {
        when(() => mockPlay(any())).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) async {
        // Set audioMap pertama
        await cubit.playOrToggle(
          url: 'https://test.com/audio.mp3',
          ayatNomor: 1,
          qari: Qari.misyariRasyidAlAfasi,
          audioMap: {'05': 'https://test.com/audio.mp3'},
        );
        // Play lagi tanpa audioMap
        await cubit.playOrToggle(
          url: 'https://test.com/audio2.mp3',
          ayatNomor: 2,
          qari: Qari.misyariRasyidAlAfasi,
        );
      },
      verify: (cubit) {
        // lastAudioMap tetap dari call pertama
        expect(cubit.lastAudioMap, {'05': 'https://test.com/audio.mp3'});
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playFullSurat() menyimpan audioMap ke lastAudioMap',
      build: () {
        when(() => mockPlay(any())).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.playFullSurat(
        ayatList: [
          const Ayat(
            nomorAyat: 1,
            teksArab: 'arab',
            teksLatin: 'latin',
            teksIndonesia: 'indonesia',
            audio: {'05': 'https://test.com/1.mp3'},
          ),
        ],
        startIndex: 0,
        qari: Qari.misyariRasyidAlAfasi,
        suratNomor: 1,
        suratName: 'Al-Fatihah',
        audioMap: {'05': 'https://test.com/full.mp3'},
      ),
      verify: (cubit) {
        expect(cubit.lastAudioMap, {'05': 'https://test.com/full.mp3'});
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'changeQari() tidak melakukan apa-apa jika tidak ada ayat aktif',
      build: buildCubit,
      act: (cubit) => cubit.changeQari(
        qari: Qari.abdullahAlMatrood,
        audioMap: {'01': 'https://test.com/audio.mp3'},
      ),
      verify: (_) {
        verifyNever(() => mockPlay(any()));
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'changeQari() play ulang dengan qari baru jika ada ayat aktif',
      build: () {
        when(() => mockPlay(any())).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      seed: () => const AudioPlayerState.playing(
        ayatNomor: 3,
        qari: Qari.misyariRasyidAlAfasi,
        position: Duration.zero,
        duration: Duration(seconds: 45),
      ),
      act: (cubit) => cubit.changeQari(
        qari: Qari.abdullahAlMatrood,
        audioMap: {'01': 'https://test.com/audio-01.mp3'},
      ),
      verify: (_) {
        verify(
          () => mockPlay(
            const PlayAudioParams(
              url: 'https://test.com/audio-01.mp3',
              ayatNomor: 3,
              qari: Qari.abdullahAlMatrood,
            ),
          ),
        ).called(1);
      },
    );
  });

  group('AudioPlayerStateX', () {
    test('isIdle return true untuk idle state', () {
      expect(const AudioPlayerState.idle().isIdle, isTrue);
    });

    test('isPlaying return true untuk playing state', () {
      const state = AudioPlayerState.playing(
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        position: Duration.zero,
        duration: Duration(seconds: 30),
      );
      expect(state.isPlaying, isTrue);
    });

    test('currentAyat return null untuk idle state', () {
      expect(const AudioPlayerState.idle().currentAyat, isNull);
    });

    test('currentAyat return nomor ayat untuk playing state', () {
      const state = AudioPlayerState.playing(
        ayatNomor: 5,
        qari: Qari.misyariRasyidAlAfasi,
        position: Duration.zero,
        duration: Duration(seconds: 30),
      );
      expect(state.currentAyat, 5);
    });

    test('position return Duration.zero untuk idle state', () {
      expect(const AudioPlayerState.idle().position, Duration.zero);
    });

    test('currentQari default ke misyariRasyidAlAfasi untuk idle state', () {
      expect(
        const AudioPlayerState.idle().currentQari,
        Qari.misyariRasyidAlAfasi,
      );
    });
  });

  group('Qari', () {
    test('fromId() return qari yang benar', () {
      expect(Qari.fromId('01'), Qari.abdullahAlMatrood);
      expect(Qari.fromId('05'), Qari.misyariRasyidAlAfasi);
    });

    test(
      'fromId() fallback ke misyariRasyidAlAfasi untuk id tidak dikenal',
      () {
        expect(Qari.fromId('99'), Qari.misyariRasyidAlAfasi);
      },
    );
  });
}
