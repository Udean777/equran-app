import 'package:audio_service/audio_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AudioServiceModule {
  @preResolve
  @singleton
  Future<AudioBackgroundHandler> audioBackgroundHandler() async {
    final handler = await AudioService.init<AudioBackgroundHandler>(
      builder: AudioBackgroundHandler.new,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'id.ssajudn.equran_app.audio',
          androidNotificationChannelName: 'Audio Murottal',
          androidNotificationOngoing: true,
        ),
    );
    return handler;
  }
}
