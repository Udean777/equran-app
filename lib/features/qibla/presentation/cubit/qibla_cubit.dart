import 'dart:async';

import 'package:equran_app/features/qibla/domain/usecases/init_qibla.dart';
import 'package:equran_app/features/qibla/domain/usecases/watch_qibla_direction.dart';
import 'package:equran_app/features/qibla/presentation/cubit/qibla_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    required InitQibla initQibla,
    required WatchQiblaDirection watchQiblaDirection,
  }) : _initQibla = initQibla,
       _watchQiblaDirection = watchQiblaDirection,
       super(const QiblaState.initial());

  final InitQibla _initQibla;
  final WatchQiblaDirection _watchQiblaDirection;
  StreamSubscription<dynamic>? _subscription;

  /// Mulai: request permission, ambil koordinat, subscribe stream kompas.
  Future<void> start() async {
    if (state is QiblaLoading) return;
    emit(const QiblaState.loading());

    // Init: permission + koordinat
    final initResult = await _initQibla.call();
    initResult.fold(
      (failure) => emit(QiblaState.error(message: failure.toString())),
      (_) => _subscribeToCompass(),
    );
  }

  void _subscribeToCompass() {
    _watchQiblaDirection.call().fold(
      (failure) {
        // Cek apakah failure karena tidak ada sensor
        final message = failure.toString();
        if (message.contains('sensor kompas')) {
          emit(const QiblaState.noSensor());
        } else {
          emit(QiblaState.error(message: message));
        }
      },
      (stream) {
        _subscription = stream.listen(
          (direction) => emit(QiblaState.loaded(direction: direction)),
          onError: (Object e) => emit(QiblaState.error(message: e.toString())),
        );
      },
    );
  }

  /// Stop stream dan reset ke initial.
  void stop() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    emit(const QiblaState.initial());
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
