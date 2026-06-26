import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart';
import 'package:equran_app/features/audio/data/datasources/audio_player_data_source.dart';
import 'package:equran_app/features/audio/data/datasources/audio_service_module.dart';
import 'package:equran_app/features/audio/data/repositories/audio_download_repository_impl.dart';
import 'package:equran_app/features/audio/data/repositories/audio_repository_impl.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_repository.dart';
import 'package:equran_app/features/audio/domain/usecases/delete_all_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/delete_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/download_ayat_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/get_downloaded_ayats.dart';
import 'package:equran_app/features/audio/domain/usecases/pause_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/play_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/resume_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/seek_audio.dart';
import 'package:equran_app/features/audio/domain/usecases/stop_audio.dart';
import 'package:equran_app/features/audio/presentation/viewmodels/audio_download_state.dart';
import 'package:equran_app/features/audio/presentation/viewmodels/audio_download_viewmodel.dart';
import 'package:equran_app/features/audio/presentation/viewmodels/audio_storage_state.dart';
import 'package:equran_app/features/audio/presentation/viewmodels/audio_storage_viewmodel.dart';
import 'package:equran_app/features/audio/presentation/viewmodels/audio_viewmodel.dart';
import 'package:equran_app/features/surat_detail/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';

export 'viewmodels/audio_download_state.dart';
export 'viewmodels/audio_download_viewmodel.dart';
export 'viewmodels/audio_storage_state.dart';
export 'viewmodels/audio_viewmodel.dart';

// ─── DioClient ─────────────────────────────────────────────────────────────

final _dioClientProvider = Provider<DioClient>((ref) => DioClient());

// ─── Audio Composite Handler ─────────────────────────────────────────────

final audioCompositeHandlerProvider = Provider<AudioCompositeHandler>((ref) {
  return AudioServiceModule.handler;
});

// ─── Data Sources ──────────────────────────────────────────────────────────

final audioPlayerDataSourceProvider = Provider<AudioPlayerDataSource>((ref) {
  return AudioPlayerDataSourceImpl(ref.watch(audioCompositeHandlerProvider));
});

final audioDownloadDataSourceProvider = Provider<AudioDownloadDataSource>((
  ref,
) {
  return AudioDownloadDataSourceImpl(ref.read(_dioClientProvider));
});

// ─── Repositories ──────────────────────────────────────────────────────────

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepositoryImpl(
    ref.read(audioPlayerDataSourceProvider),
    ref.read(audioDownloadDataSourceProvider),
  );
});

final audioDownloadRepositoryProvider = Provider<AudioDownloadRepository>((
  ref,
) {
  return AudioDownloadRepositoryImpl(ref.read(audioDownloadDataSourceProvider));
});

// ─── Use Cases ─────────────────────────────────────────────────────────────

final playAudioProvider = Provider<PlayAudio>((ref) {
  return PlayAudio(ref.read(audioRepositoryProvider));
});

final pauseAudioProvider = Provider<PauseAudio>((ref) {
  return PauseAudio(ref.read(audioRepositoryProvider));
});

final resumeAudioProvider = Provider<ResumeAudio>((ref) {
  return ResumeAudio(ref.read(audioRepositoryProvider));
});

final stopAudioProvider = Provider<StopAudio>((ref) {
  return StopAudio(ref.read(audioRepositoryProvider));
});

final seekAudioProvider = Provider<SeekAudio>((ref) {
  return SeekAudio(ref.read(audioRepositoryProvider));
});

final downloadAyatAudioProvider = Provider<DownloadAyatAudio>((ref) {
  return DownloadAyatAudio(ref.read(audioDownloadRepositoryProvider));
});

final deleteAyatAudioProvider = Provider<DeleteAyatAudio>((ref) {
  return DeleteAyatAudio(ref.read(audioDownloadRepositoryProvider));
});

final deleteAllAudioProvider = Provider<DeleteAllAudio>((ref) {
  return DeleteAllAudio(ref.read(audioDownloadRepositoryProvider));
});

final getDownloadedAyatsProvider = Provider<GetDownloadedAyats>((ref) {
  return GetDownloadedAyats(ref.read(audioDownloadRepositoryProvider));
});

// ─── ViewModels ────────────────────────────────────────────────────────────

final audioViewModelProvider =
    StateNotifierProvider<AudioViewModel, AudioPlayerState>(
      (ref) {
        final vm = AudioViewModel(
          ref.read(playAudioProvider),
          ref.read(pauseAudioProvider),
          ref.read(resumeAudioProvider),
          ref.read(stopAudioProvider),
          ref.read(seekAudioProvider),
          ref.read(audioRepositoryProvider),
        );
        ref.onDispose(vm.dispose);
        return vm;
      },
    );

final audioDownloadViewModelProvider =
    AutoDisposeStateNotifierProvider<
      AudioDownloadViewModel,
      AudioDownloadState
    >(
      (ref) => AudioDownloadViewModel(
        ref.read(downloadAyatAudioProvider),
        ref.read(getDownloadedAyatsProvider),
      ),
    );

final audioStorageViewModelProvider =
    AutoDisposeStateNotifierProvider<AudioStorageViewModel, AudioStorageState>(
      (ref) => AudioStorageViewModel(
        ref.read(getDownloadedAyatsProvider),
        ref.read(deleteAyatAudioProvider),
        ref.read(deleteAllAudioProvider),
        ref.read(getSuratDetailProvider),
      ),
    );
