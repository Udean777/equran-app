import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/services/audio_recorder_service.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/hafalan/domain/usecases/compare_recitation.dart';
import 'package:equran_app/features/hafalan/domain/usecases/delete_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_by_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/compare_recitation_params.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/hafalan_params.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/save_hafalan_params.dart';
import 'package:equran_app/features/hafalan/domain/usecases/save_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/notifications/hafalan_reminder_scheduler.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_detail_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_detail_state.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHafalanBySurat extends Mock implements GetHafalanBySurat {}

class MockSaveHafalanSurat extends Mock implements SaveHafalanSurat {}

class MockDeleteHafalanSurat extends Mock implements DeleteHafalanSurat {}

class MockHafalanReminderScheduler extends Mock
    implements HafalanReminderScheduler {}

class MockHafalanListCubit extends Mock implements HafalanListCubit {}

class MockCompareRecitation extends Mock implements CompareRecitation {}

class MockAudioRecorderService extends Mock implements AudioRecorderService {}

// Fake for registerFallbackValue
class FakeCompareRecitationParams extends Fake
    implements CompareRecitationParams {}

class FakeHafalanSuratParams extends Fake implements HafalanSuratParams {}

class FakeSaveHafalanParams extends Fake implements SaveHafalanParams {}

void main() {
  late HafalanDetailCubit cubit;
  late MockGetHafalanBySurat mockGetHafalanBySurat;
  late MockSaveHafalanSurat mockSaveHafalanSurat;
  late MockDeleteHafalanSurat mockDeleteHafalanSurat;
  late MockHafalanReminderScheduler mockReminderScheduler;
  late MockHafalanListCubit mockListCubit;
  late MockCompareRecitation mockCompareRecitation;
  late MockAudioRecorderService mockAudioRecorderService;

  setUpAll(() {
    registerFallbackValue(FakeCompareRecitationParams());
    registerFallbackValue(FakeHafalanSuratParams());
    registerFallbackValue(FakeSaveHafalanParams());
  });

  setUp(() {
    mockGetHafalanBySurat = MockGetHafalanBySurat();
    mockSaveHafalanSurat = MockSaveHafalanSurat();
    mockDeleteHafalanSurat = MockDeleteHafalanSurat();
    mockReminderScheduler = MockHafalanReminderScheduler();
    mockListCubit = MockHafalanListCubit();
    mockCompareRecitation = MockCompareRecitation();
    mockAudioRecorderService = MockAudioRecorderService();

    cubit = HafalanDetailCubit(
      mockGetHafalanBySurat,
      mockSaveHafalanSurat,
      mockDeleteHafalanSurat,
      mockReminderScheduler,
      mockListCubit,
      mockCompareRecitation,
      mockAudioRecorderService,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('compareRecitation', () {
    const tAyatNomor = 1;
    const tTargetText = 'bismillahirrahmanirrahim';

    const tCompareResult = SetoranCompareResult(
      score: 85.5,
      passed: true,
      threshold: 75,
      transcribed: 'bismillahirrahmanirrahim',
      target: 'bismillahirrahmanirrahim',
      cer: 0,
      durationMs: 1500,
    );

    blocTest<HafalanDetailCubit, HafalanDetailState>(
      'emits [comparing, compareSuccess] when comparison is successful',
      build: () {
        when(() => mockAudioRecorderService.hasPermission())
            .thenAnswer((_) async => true);
        when(() => mockAudioRecorderService.stopRecording())
            .thenAnswer((_) async => '/tmp/audio.m4a');
        when(() => mockCompareRecitation(any()))
            .thenAnswer((_) async => const Right(tCompareResult));
        return cubit;
      },
      act: (cubit) => cubit.compareRecitation(
        ayatNomor: tAyatNomor,
        targetText: tTargetText,
      ),
      expect: () => [
        const HafalanDetailState.comparing(tAyatNomor),
        const HafalanDetailState.compareSuccess(
          ayatNomor: tAyatNomor,
          result: tCompareResult,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioRecorderService.hasPermission()).called(1);
        verify(() => mockAudioRecorderService.stopRecording()).called(1);
        verify(() => mockCompareRecitation(any())).called(1);
      },
    );

    blocTest<HafalanDetailCubit, HafalanDetailState>(
      'emits [comparing, compareFailure] when permission is denied',
      build: () {
        when(() => mockAudioRecorderService.hasPermission())
            .thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.compareRecitation(
        ayatNomor: tAyatNomor,
        targetText: tTargetText,
      ),
      expect: () => [
        const HafalanDetailState.comparing(tAyatNomor),
        const HafalanDetailState.compareFailure(
          ayatNomor: tAyatNomor,
          message: 'Izin mikrofon tidak diberikan',
        ),
      ],
      verify: (_) {
        verify(() => mockAudioRecorderService.hasPermission()).called(1);
        verifyNever(() => mockAudioRecorderService.stopRecording());
      },
    );

    blocTest<HafalanDetailCubit, HafalanDetailState>(
      'emits [comparing, compareFailure] when recording returns null',
      build: () {
        when(() => mockAudioRecorderService.hasPermission())
            .thenAnswer((_) async => true);
        when(() => mockAudioRecorderService.stopRecording())
            .thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.compareRecitation(
        ayatNomor: tAyatNomor,
        targetText: tTargetText,
      ),
      expect: () => [
        const HafalanDetailState.comparing(tAyatNomor),
        const HafalanDetailState.compareFailure(
          ayatNomor: tAyatNomor,
          message: 'Rekaman gagal, silakan coba lagi',
        ),
      ],
    );

    blocTest<HafalanDetailCubit, HafalanDetailState>(
      'emits [comparing, compareFailure] when comparison fails with network error',
      build: () {
        when(() => mockAudioRecorderService.hasPermission())
            .thenAnswer((_) async => true);
        when(() => mockAudioRecorderService.stopRecording())
            .thenAnswer((_) async => '/tmp/audio.m4a');
        when(() => mockCompareRecitation(any()))
            .thenAnswer((_) async => const Left(Failure.network()));
        return cubit;
      },
      act: (cubit) => cubit.compareRecitation(
        ayatNomor: tAyatNomor,
        targetText: tTargetText,
      ),
      expect: () => [
        const HafalanDetailState.comparing(tAyatNomor),
        const HafalanDetailState.compareFailure(
          ayatNomor: tAyatNomor,
          message: 'Gagal membandingkan bacaan: Tidak ada koneksi internet. Periksa jaringan Anda.',
        ),
      ],
    );

    blocTest<HafalanDetailCubit, HafalanDetailState>(
      'emits [comparing, compareFailure] when comparison fails with server error',
      build: () {
        when(() => mockAudioRecorderService.hasPermission())
            .thenAnswer((_) async => true);
        when(() => mockAudioRecorderService.stopRecording())
            .thenAnswer((_) async => '/tmp/audio.m4a');
        when(() => mockCompareRecitation(any())).thenAnswer(
          (_) async => const Left(Failure.server(statusCode: 500)),
        );
        return cubit;
      },
      act: (cubit) => cubit.compareRecitation(
        ayatNomor: tAyatNomor,
        targetText: tTargetText,
      ),
      expect: () => [
        const HafalanDetailState.comparing(tAyatNomor),
        const HafalanDetailState.compareFailure(
          ayatNomor: tAyatNomor,
          message: 'Gagal membandingkan bacaan: Terjadi kesalahan pada server.',
        ),
      ],
    );

    blocTest<HafalanDetailCubit, HafalanDetailState>(
      'emits [comparing, compareFailure] when comparison fails with unknown error',
      build: () {
        when(() => mockAudioRecorderService.hasPermission())
            .thenAnswer((_) async => true);
        when(() => mockAudioRecorderService.stopRecording())
            .thenAnswer((_) async => '/tmp/audio.m4a');
        when(() => mockCompareRecitation(any())).thenAnswer(
          (_) async => const Left(Failure.unknown(message: 'Something went wrong')),
        );
        return cubit;
      },
      act: (cubit) => cubit.compareRecitation(
        ayatNomor: tAyatNomor,
        targetText: tTargetText,
      ),
      expect: () => [
        const HafalanDetailState.comparing(tAyatNomor),
        const HafalanDetailState.compareFailure(
          ayatNomor: tAyatNomor,
          message: 'Gagal membandingkan bacaan: Terjadi kesalahan yang tidak diketahui.',
        ),
      ],
    );
  });

  group('clearCompareResult', () {
    blocTest<HafalanDetailCubit, HafalanDetailState>(
      'emits nothing when already in initial state',
      build: () => cubit,
      act: (cubit) => cubit.clearCompareResult(),
      expect: () => <HafalanDetailState>[],
      verify: (_) {
        expect(cubit.state, const HafalanDetailState.initial());
      },
    );
  });
}
