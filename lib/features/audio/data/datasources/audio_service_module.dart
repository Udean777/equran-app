import 'package:audio_service/audio_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:flutter/material.dart';

class AudioServiceModule {
  static AudioCompositeHandler? _instance;

  static AudioCompositeHandler get handler {
    assert(
      _instance != null,
      'AudioServiceModule not initialized. Call init() first.',
    );
    return _instance!;
  }

  static Future<AudioCompositeHandler> init() async {
    if (_instance != null) return _instance!;
    _instance = await AudioService.init<AudioCompositeHandler>(
      builder: AudioCompositeHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'id.ssajudn.equran_app.audio',
        androidNotificationChannelName: 'eQuran Audio',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'drawable/ic_notif',
        notificationColor: Color(0xFF1B5E20),
      ),
    );
    return _instance!;
  }
}
