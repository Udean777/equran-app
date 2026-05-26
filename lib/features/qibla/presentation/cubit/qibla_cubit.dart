import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
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

  /// Threshold minimum perubahan sudut (derajat) sebelum emit state baru.
  /// Mencegah rebuild setiap sensor tick (~10-20x/detik).
  static const _angleThreshold = 1.0;
  double? _lastEmittedAngle;
  /// Mulai: request permission, ambil koordinat, subscribe stream kompas.
  Future<void> start() async {
    if (state is QiblaLoading) return;
    emit(const QiblaState.loading());

    // Init: permission + koordinat
    final initResult = await _initQibla.call();
    initResult.fold(
      (failure) => emit(QiblaState.error(message: failure.toUserMessage())),
      (_) => _subscribeToCompass(),
    );
  }

  void _subscribeToCompass() {
    _watchQiblaDirection.call().fold(
      (failure) {
        // Cek apakah failure karena tidak ada sensor kompas
        final isSensorFailure = switch (failure) {
          UnknownFailure(:final message) => message.contains('sensor kompas'),
          _ => false,
        };
        if (isSensorFailure) {
          emit(const QiblaState.noSensor());
        } else {
          emit(QiblaState.error(message: failure.toUserMessage()));
        }
      },
      (stream) {
        _subscription = stream.listen(
          (direction) {
            // Throttle: hanya emit jika perubahan deviceHeading > threshold
            final heading = direction.deviceHeading;
            if (_lastEmittedAngle == null ||
                (heading - _lastEmittedAngle!).abs() > _angleThreshold) {
              _lastEmittedAngle = heading;
              emit(QiblaState.loaded(direction: direction));
            }
          },
          onError: (Object e) =>
              emit(QiblaState.error(message: e.toString())),
        );
      },
    );
  }

  /// Stop stream dan reset ke initial.
  void stop() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    _lastEmittedAngle = null;
    emit(const QiblaState.initial());
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
