import 'dart:async';

import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/auto_read_state.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/card_stack_notifier.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/card_stack_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier untuk auto-read mode di SuratDetailCardView.
///
/// Mengelola lifecycle start/stop auto-read, sinkronisasi card dengan audio,
/// dan callback saat playlist selesai.
class AutoReadNotifier extends AutoDisposeFamilyNotifier<AutoReadState, int> {
  @override
  AutoReadState build(int totalAyat) {
    // totalAyat sebagai parameter family untuk scope per surat
    return const AutoReadState();
  }

  AudioViewModel get _audioViewModel =>
      ref.read(audioViewModelProvider.notifier);
  CardStackNotifier get _cardNotifier =>
      ref.read(cardStackProvider(arg).notifier);

  /// Mulai auto-read mode — play full surat dari awal.
  void start({
    required SuratDetail detail,
    required Qari qari,
  }) {
    if (state.isActive) return;
    state = state.copyWith(isActive: true);

    // Pindah ke ayat pertama
    _cardNotifier.goNext();

    // Callback saat semua ayat selesai
    _audioViewModel.onPlaylistCompleted = _onPlaylistCompleted;

    // Play full surat dari awal
    unawaited(
      _audioViewModel.playFullSurat(
        ayatList: detail.ayatList,
        startIndex: 0,
        qari: qari,
        suratNomor: detail.nomor,
        suratName: detail.namaLatin,
        audioMap: detail.audioFull,
      ),
    );
  }

  /// Hentikan auto-read mode.
  void stop() {
    if (!state.isActive) return;
    state = state.copyWith(isActive: false);
    _audioViewModel.onPlaylistCompleted = null;
    unawaited(_audioViewModel.stop());
  }

  /// Aktifkan mode tanpa memulai audio — dipakai saat sync dari audio aktif
  /// yang sudah berjalan sebelum page di-mount.
  void activateWithoutPlay({required VoidCallback onCompleted}) {
    if (state.isActive) return;
    state = state.copyWith(isActive: true);
    _audioViewModel.onPlaylistCompleted = () {
      _onPlaylistCompleted();
      onCompleted();
    };
  }

  void _onPlaylistCompleted() {
    state = state.copyWith(isActive: false);
    _audioViewModel.onPlaylistCompleted = null;
  }
}

/// Provider untuk CardStackNotifier
final AutoDisposeNotifierProviderFamily<CardStackNotifier, CardStackState, int>
cardStackProvider =
    AutoDisposeNotifierProvider.family<CardStackNotifier, CardStackState, int>(
      CardStackNotifier.new,
    );

/// Provider untuk AutoReadNotifier
final AutoDisposeNotifierProviderFamily<AutoReadNotifier, AutoReadState, int>
autoReadProvider =
    AutoDisposeNotifierProvider.family<AutoReadNotifier, AutoReadState, int>(
      AutoReadNotifier.new,
    );
