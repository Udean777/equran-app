import 'package:equran_app/features/audio/domain/constants/audio_constants.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/foundation.dart';

class AudioPlaylistManager {
  VoidCallback? onPlaylistCompleted;

  List<Ayat> _playlist = [];
  int _playlistIndex = -1;
  int? _playlistSuratNomor;
  String? _playlistSuratName;
  Qari _playlistQari = Qari.misyariRasyidAlAfasi;

  final Map<int, Duration> _discoveredDurations = {};
  Duration? _pendingSeek;
  bool _shouldUpdateLastRead = true;

  Map<String, String> _lastAudioMap = {};

  bool get isPlaylistMode => _playlist.isNotEmpty;
  int get index => _playlistIndex;
  int? get suratNomor => _playlistSuratNomor;
  String? get suratName => _playlistSuratName;
  Qari get qari => _playlistQari;
  bool get shouldUpdateLastRead => _shouldUpdateLastRead;
  int get length => _playlist.length;
  List<Ayat> get list => List.unmodifiable(_playlist);
  Map<String, String> get lastAudioMap => Map.unmodifiable(_lastAudioMap);

  bool get _hasArabText =>
      _playlist.isNotEmpty && _playlist.first.teksArab.isNotEmpty;

  static const double _msPerArabChar = AudioConstants.msPerArabChar;
  static const Duration _minAyatDuration = AudioConstants.minAyatDuration;
  static const Duration _maxAyatDuration = AudioConstants.maxAyatDuration;

  void setPlaylist({
    required List<Ayat> ayatList,
    required int startIndex,
    required Qari qari,
    required int suratNomor,
    required String suratName,
    Map<String, String> audioMap = const {},
    bool updateLastRead = true,
  }) {
    if (audioMap.isNotEmpty) _lastAudioMap = audioMap;
    _playlist = List.of(ayatList);
    _playlistIndex = startIndex;
    _playlistQari = qari;
    _playlistSuratNomor = suratNomor;
    _playlistSuratName = suratName;
    _shouldUpdateLastRead = updateLastRead;
  }

  // ignore: use_setters_to_change_properties (method intentionally avoids setter syntax for clarity)
  void setQari(Qari value) => _playlistQari = value;

  void discoverDuration(int ayatNomor, Duration duration) {
    if (duration > Duration.zero) {
      _discoveredDurations[ayatNomor] = duration;
    }
  }

  Ayat? getCurrentAyat() {
    if (_playlistIndex < 0 || _playlistIndex >= _playlist.length) return null;
    return _playlist[_playlistIndex];
  }

  String? getUrlForCurrentAyat() {
    final ayat = getCurrentAyat();
    if (ayat == null) return null;
    return ayat.audio[_playlistQari.id] ?? ayat.audio.values.firstOrNull;
  }

  int? advanceToNext() {
    if (!isPlaylistMode) return null;
    if (_playlistIndex >= _playlist.length - 1) {
      clear();
      onPlaylistCompleted?.call();
      return null;
    }
    return ++_playlistIndex;
  }

  int? goToPrevious() {
    if (!isPlaylistMode) return null;
    if (_playlistIndex <= 0) return null;
    return --_playlistIndex;
  }

  bool get isAtEnd => _playlistIndex >= _playlist.length - 1;

  bool get isAtStart => _playlistIndex <= 0;

  Duration get totalDuration {
    if (!isPlaylistMode || !_hasArabText) return Duration.zero;
    return _playlist.fold(
      Duration.zero,
      (sum, ayat) => sum + _durationFor(ayat),
    );
  }

  Duration currentPosition(Duration currentAyatPosition) {
    if (!isPlaylistMode || !_hasArabText) return Duration.zero;
    var offset = Duration.zero;
    for (var i = 0; i < _playlistIndex; i++) {
      offset += _durationFor(_playlist[i]);
    }
    return offset + currentAyatPosition;
  }

  ({int index, Duration localOffset})? seekToGlobal(Duration globalPosition) {
    if (_playlist.isEmpty) return null;

    var accumulated = Duration.zero;
    var targetIndex = 0;
    var localOffset = Duration.zero;

    for (var i = 0; i < _playlist.length; i++) {
      final dur = _durationFor(_playlist[i]);
      if (accumulated + dur > globalPosition || i == _playlist.length - 1) {
        targetIndex = i;
        localOffset = globalPosition - accumulated;
        if (localOffset < Duration.zero) localOffset = Duration.zero;
        if (localOffset > dur) {
          localOffset = dur - const Duration(milliseconds: 100);
        }
        break;
      }
      accumulated += dur;
    }

    return (index: targetIndex, localOffset: localOffset);
  }

  // ignore: use_setters_to_change_properties (method intentionally avoids setter syntax for clarity)
  void setPendingSeek(Duration offset) => _pendingSeek = offset;

  Duration? consumePendingSeek() {
    final seek = _pendingSeek;
    _pendingSeek = null;
    return seek;
  }

  // ignore: use_setters_to_change_properties (method intentionally avoids setter syntax for clarity)
  void setLastAudioMap(Map<String, String> value) => _lastAudioMap = value;

  // ignore: use_setters_to_change_properties (method intentionally avoids setter syntax for clarity)
  void jumpToIndex(int value) => _playlistIndex = value;

  void clear() {
    _playlist = [];
    _playlistIndex = -1;
    _playlistSuratNomor = null;
    _playlistSuratName = null;
    _discoveredDurations.clear();
    _pendingSeek = null;
    _shouldUpdateLastRead = true;
  }

  Duration _estimateDuration(Ayat ayat) {
    final ms = (ayat.teksArab.length * _msPerArabChar).round();
    final estimated = Duration(milliseconds: ms);
    if (estimated < _minAyatDuration) return _minAyatDuration;
    if (estimated > _maxAyatDuration) return _maxAyatDuration;
    return estimated;
  }

  Duration _durationFor(Ayat ayat) =>
      _discoveredDurations[ayat.nomorAyat] ?? _estimateDuration(ayat);
}
