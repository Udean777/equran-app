import 'dart:async';

import 'package:equran_app/features/audio/presentation/providers.dart';
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
    required AudioViewModel audioViewModel,
    required CardStackController cardController,
    required Qari initialQari,
  }) : _audioViewModel = audioViewModel,
       _cardController = cardController,
       _currentQari = initialQari;

  final AudioViewModel _audioViewModel;
  final CardStackController _cardController;
  final Qari _currentQari;

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
    _audioViewModel.onPlaylistCompleted = _onPlaylistCompleted;

    // Play full surat dari awal
    unawaited(
      _audioViewModel.playFullSurat(
        ayatList: detail.ayatList,
        startIndex: 0,
        qari: _currentQari,
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
    _audioViewModel.onPlaylistCompleted = null;
    unawaited(_audioViewModel.stop());
    notifyListeners();
  }

  /// Aktifkan mode tanpa memulai audio — dipakai saat sync dari audio aktif
  /// yang sudah berjalan sebelum page di-mount.
  void activateWithoutPlay({required VoidCallback onCompleted}) {
    if (_isActive) return;
    _isActive = true;
    _audioViewModel.onPlaylistCompleted = () {
      _onPlaylistCompleted();
      onCompleted();
    };
    notifyListeners();
  }

  void _onPlaylistCompleted() {
    _isActive = false;
    _audioViewModel.onPlaylistCompleted = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Bersihkan callback agar tidak trigger setelah controller di-dispose
    if (_audioViewModel.onPlaylistCompleted == _onPlaylistCompleted) {
      _audioViewModel.onPlaylistCompleted = null;
    }
    super.dispose();
  }
}
