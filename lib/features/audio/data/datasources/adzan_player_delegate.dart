import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart' show AudioCompositeHandler;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

/// Delegate yang handle playback audio adzan dari local asset.
/// Digunakan oleh [AudioCompositeHandler].
class AdzanPlayerDelegate {
  AdzanPlayerDelegate({
    required this.onPlaybackStateChanged,
    required this.onMediaItemChanged,
    required this.onAdzanCompleted,
    required this.onAdzanPlayingChanged,
  });

  final void Function({required bool playing, required Duration position})
  onPlaybackStateChanged;
  final void Function(MediaItem? item) onMediaItemChanged;
  final VoidCallback onAdzanCompleted;

  /// Dipanggil saat state adzan berubah (playing/stopped).
  /// Composite handler pakai ini untuk switch controls di notif.
  final void Function({required bool isPlaying}) onAdzanPlayingChanged;

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _stateSub;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Uri? _artworkUri;

  /// Extract app_icon.png dari assets ke filesDir agar bisa dipakai sebagai artUri.
  /// audio_service butuh file:// URI, bukan asset:// URI.
  Future<Uri> _getArtworkUri() async {
    if (_artworkUri != null) return _artworkUri!;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/adzan_artwork.png');
      if (!file.existsSync()) {
        final data = await rootBundle.load('assets/icons/app_icon.png');
        await file.writeAsBytes(data.buffer.asUint8List());
      }
      _artworkUri = Uri.file(file.path);
    } on Object catch (e) {
      debugPrint('AdzanPlayerDelegate: gagal extract artwork: $e');
      _artworkUri = Uri.parse('');
    }
    return _artworkUri!;
  }

  /// Play adzan dari Flutter asset.
  /// [isSubuh] menentukan file yang dipakai.
  /// [waktuNama] untuk label di notification.
  Future<void> playAdzan({
    required bool isSubuh,
    required String waktuNama,
  }) async {
    try {
      // Stop jika masih ada yang playing
      await stop();

      final assetPath =
          isSubuh ? 'assets/audio/adzan_subuh.m4a' : 'assets/audio/adzan.m4a';

      final artUri = await _getArtworkUri();

      onMediaItemChanged(
        MediaItem(
          id: assetPath,
          title: 'Waktu $waktuNama',
          artist: 'eQuran',
          album: 'Jadwal Shalat',
          artUri: artUri,
          displayTitle: 'Waktu $waktuNama',
          displaySubtitle: 'Sudah masuk waktu shalat $waktuNama',
        ),
      );

      await _player.setAsset(assetPath);

      _stateSub = _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          onAdzanPlayingChanged(isPlaying: false);
          onPlaybackStateChanged(playing: false, position: Duration.zero);
          onAdzanCompleted();
          unawaited(_stateSub?.cancel());
          _stateSub = null;
        } else if (state.playing) {
          _isPlaying = true;
          onAdzanPlayingChanged(isPlaying: true);
          onPlaybackStateChanged(
            playing: true,
            position: _player.position,
          );
        }
      });

      await _player.play();
      _isPlaying = true;
      onAdzanPlayingChanged(isPlaying: true);
    } on Object catch (e) {
      _isPlaying = false;
      debugPrint('AdzanPlayerDelegate playAdzan error: $e');
    }
  }

  /// Stop adzan.
  /// [notifyCompleted] = false saat stop manual (tidak trigger auto-resume Quran).
  Future<void> stop({bool notifyCompleted = false}) async {
    try {
      await _stateSub?.cancel();
      _stateSub = null;

      if (_player.playing) {
        await _player.stop();
      }
      _isPlaying = false;
      onAdzanPlayingChanged(isPlaying: false);
      onPlaybackStateChanged(playing: false, position: Duration.zero);

      if (notifyCompleted) {
        onAdzanCompleted();
      }
    } on Object catch (e) {
      debugPrint('AdzanPlayerDelegate stop error: $e');
    }
  }

  Future<void> dispose() async {
    await _stateSub?.cancel();
    await _player.dispose();
  }
}
