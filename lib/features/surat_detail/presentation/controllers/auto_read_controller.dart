import 'dart:async';

import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:flutter/foundation.dart';

/// Controller untuk auto-read mode di SuratDetailCardView.
///
/// Mengelola lifecycle start/stop auto-read, sinkronisasi card dengan audio,
/// dan callback saat playlist selesai. Dipisah dari StatefulWidget agar
/// orchestration logic tidak bercampur dengan widget lifecycle.
class AutoReadController extends ChangeNotifier {
  AutoReadController({
    required AudioCubit audioCubit,
    required CardStackController cardController,
  }) : _audioCubit = audioCubit,
       _cardController = cardController;

  final AudioCubit _audioCubit;
  final CardStackController _cardController;

  bool _isActive = false;

  bool get isActive => _isActive;

  /// Mulai auto-read mode — play full surat dari awal.
  void start(SuratDetail detail) {
    if (_isActive) return;
    _isActive = true;
    notifyListeners();

    // Pindah ke ayat pertama
    _cardController.goNext();

    // Callback saat semua ayat selesai
    _audioCubit.onPlaylistCompleted = _onPlaylistCompleted;

    // Play full surat dari awal
    unawaited(
      _audioCubit.playFullSurat(
        ayatList: detail.ayatList,
        startIndex: 0,
        qari: _audioCubit.state.currentQari,
        suratNomor: detail.nomor,
        suratName: detail.namaLatin,
        audioMap: detail.audioFull,
      ),
    );
  }

  /// Hentikan auto-read mode.
  void stop() {
    if (!_isActive) return;
    _isActive = false;
    _audioCubit.onPlaylistCompleted = null;
    unawaited(_audioCubit.stop());
    notifyListeners();
  }

  /// Aktifkan mode tanpa memulai audio — dipakai saat sync dari audio aktif
  /// yang sudah berjalan sebelum page di-mount.
  void activateWithoutPlay({required VoidCallback onCompleted}) {
    if (_isActive) return;
    _isActive = true;
    _audioCubit.onPlaylistCompleted = () {
      _onPlaylistCompleted();
      onCompleted();
    };
    notifyListeners();
  }

  void _onPlaylistCompleted() {
    _isActive = false;
    _audioCubit.onPlaylistCompleted = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Bersihkan callback agar tidak trigger setelah controller di-dispose
    if (_audioCubit.onPlaylistCompleted == _onPlaylistCompleted) {
      _audioCubit.onPlaylistCompleted = null;
    }
    super.dispose();
  }
}
