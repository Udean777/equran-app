import 'package:audio_service/audio_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:flutter/material.dart';

class AudioServiceModule {
  static Future<AudioCompositeHandler> createHandler() async {
    final handler = await AudioService.init<AudioCompositeHandler>(
      builder: AudioCompositeHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'id.ssajudn.equran_app.audio',
        androidNotificationChannelName: 'eQuran Audio',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'drawable/ic_notif',
        notificationColor: Color(0xFF1B5E20),
      ),
    );
    return handler;
  }
}
