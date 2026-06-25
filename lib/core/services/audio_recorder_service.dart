import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

abstract class AudioRecorderService {
  Future<bool> hasPermission();
  Future<void> startRecording();
  Future<String?> stopRecording();
  bool get isRecording;
  Future<void> dispose();
}

class RecordAudioRecorderService implements AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;
  bool _isRecording = false;

  @override
  bool get isRecording => _isRecording;

  @override
  Future<bool> hasPermission() async {
    final ok = await _recorder.hasPermission();
    return ok;
  }

  @override
  Future<void> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _currentPath = '${dir.path}/recording_$timestamp.m4a';

    await _recorder.start(
      const RecordConfig(),
      path: _currentPath!,
    );
    _isRecording = true;
  }

  @override
  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    final path = await _recorder.stop();
    _isRecording = false;

    if (path != null && File(path).existsSync()) {
      _currentPath = path;
    } else {
      _currentPath = null;
    }

    return _currentPath;
  }

  @override
  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
