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

class FakePlayAudioParams extends Fake implements PlayAudioParams {}

void main() {
  late MockPlayAudio mockPlay;
  late MockPauseAudio mockPause;
  late MockResumeAudio mockResume;
  late MockStopAudio mockStop;
  late MockSeekAudio mockSeek;
  late MockAudioRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePlayAudioParams());
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockPlay = MockPlayAudio();
    mockPause = MockPauseAudio();
    mockResume = MockResumeAudio();
    mockStop = MockStopAudio();
    mockSeek = MockSeekAudio();
    mockRepository = MockAudioRepository();

    when(() => mockRepository.stateStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlay(any())).thenAnswer((_) async => right(unit));
    when(() => mockPause()).thenAnswer((_) async => right(unit));
    when(() => mockResume()).thenAnswer((_) async => right(unit));
    when(() => mockStop()).thenAnswer((_) async => right(unit));
    when(() => mockSeek(any())).thenAnswer((_) async => right(unit));
  });

  AudioCubit buildCubit() => AudioCubit(
    mockPlay,
    mockPause,
    mockResume,
    mockStop,
    mockSeek,
    mockRepository,
  );

  group('AudioCubit — playOrToggle', () {
    blocTest<AudioCubit, AudioPlayerState>(
      'play ayat baru memanggil _playAudio',
      build: buildCubit,
      act: (cubit) => cubit.playOrToggle(
        url: 'https://cdn.islamic.network/quran/audio/128/05/1.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      ),
      verify: (_) => verify(() => mockPlay(any())).called(1),
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'toggle pause jika ayat sama sedang playing',
      build: buildCubit,
      seed: () => const AudioPlayerState.playing(
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        position: Duration.zero,
        duration: Duration(seconds: 10),
      ),
      act: (cubit) => cubit.playOrToggle(
        url: 'https://cdn.islamic.network/quran/audio/128/05/1.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      ),
      verify: (_) {
        verify(() => mockPause()).called(1);
        verifyNever(() => mockPlay(any()));
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'toggle resume jika ayat sama sedang paused',
      build: buildCubit,
      seed: () => const AudioPlayerState.paused(
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
        position: Duration(seconds: 3),
        duration: Duration(seconds: 10),
      ),
      act: (cubit) => cubit.playOrToggle(
        url: 'https://cdn.islamic.network/quran/audio/128/05/1.mp3',
        ayatNomor: 1,
        qari: Qari.misyariRasyidAlAfasi,
      ),
      verify: (_) {
        verify(() => mockResume()).called(1);
        verifyNever(() => mockPlay(any()));
      },
    );
  });

  group('AudioCubit — playlist mode', () {
    final ayatList = List.generate(
      5,
      (i) => Ayat(
        nomorAyat: i + 1,
        teksArab: 'arab $i',
        teksLatin: 'latin $i',
        teksIndonesia: 'indonesia $i',
        audio: {'05': 'https://cdn.islamic.network/quran/audio/128/05/${i + 1}.mp3'},
      ),
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playFullSurat mengaktifkan playlist mode',
      build: buildCubit,
      act: (cubit) => cubit.playFullSurat(
        ayatList: ayatList,
        startIndex: 0,
        qari: Qari.misyariRasyidAlAfasi,
        suratNomor: 1,
        suratName: 'Al-Fatihah',
      ),
      verify: (cubit) {
        expect(cubit.isPlaylistMode, isTrue);
        expect(cubit.playlistIndex, equals(0));
        expect(cubit.playlistSuratName, equals('Al-Fatihah'));
        verify(() => mockPlay(any())).called(1);
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'nextAyat increment index dan play ayat berikutnya',
      build: buildCubit,
      act: (cubit) async {
        await cubit.playFullSurat(
          ayatList: ayatList,
          startIndex: 0,
          qari: Qari.misyariRasyidAlAfasi,
          suratNomor: 1,
          suratName: 'Al-Fatihah',
        );
        await cubit.nextAyat();
      },
      verify: (cubit) {
        expect(cubit.playlistIndex, equals(1));
        verify(() => mockPlay(any())).called(2); // play index 0 + index 1
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'previousAyat decrement index dan play ayat sebelumnya',
      build: buildCubit,
      act: (cubit) async {
        await cubit.playFullSurat(
          ayatList: ayatList,
          startIndex: 2,
          qari: Qari.misyariRasyidAlAfasi,
          suratNomor: 1,
          suratName: 'Al-Fatihah',
        );
        await cubit.previousAyat();
      },
      verify: (cubit) {
        expect(cubit.playlistIndex, equals(1));
        verify(() => mockPlay(any())).called(2);
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'stop() clear playlist mode',
      build: buildCubit,
      act: (cubit) async {
        await cubit.playFullSurat(
          ayatList: ayatList,
          startIndex: 0,
          qari: Qari.misyariRasyidAlAfasi,
          suratNomor: 1,
          suratName: 'Al-Fatihah',
        );
        await cubit.stop();
      },
      verify: (cubit) {
        expect(cubit.isPlaylistMode, isFalse);
        verify(() => mockStop()).called(1);
      },
    );

    blocTest<AudioCubit, AudioPlayerState>(
      'playOrToggle manual clear playlist mode',
      build: buildCubit,
      act: (cubit) async {
        await cubit.playFullSurat(
          ayatList: ayatList,
          startIndex: 0,
          qari: Qari.misyariRasyidAlAfasi,
          suratNomor: 1,
          suratName: 'Al-Fatihah',
        );
        // Play ayat lain secara manual → clear playlist
        await cubit.playOrToggle(
          url: 'https://cdn.islamic.network/quran/audio/128/05/99.mp3',
          ayatNomor: 99,
          qari: Qari.misyariRasyidAlAfasi,
        );
      },
      verify: (cubit) {
        expect(cubit.isPlaylistMode, isFalse);
      },
    );
  });
}
