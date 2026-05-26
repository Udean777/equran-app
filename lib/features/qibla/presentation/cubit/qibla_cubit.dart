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
  Timer? _timeoutTimer;

  /// Threshold minimum perubahan sudut (derajat) sebelum emit state baru.
  static const _angleThreshold = 1.0;

  /// Timeout init (permission + GPS) — 15 detik.
  static const _initTimeout = Duration(seconds: 15);

  double? _lastEmittedAngle;

  /// Mulai: request permission, ambil koordinat, subscribe stream kompas.
  Future<void> start() async {
    if (state is QiblaLoading) return;
    await _subscription?.cancel();
    _subscription = null;
    _lastEmittedAngle = null;
    _timeoutTimer?.cancel();

    emit(const QiblaState.loading());

    // Timeout guard — jika init > 15s, emit error agar tidak stuck
    _timeoutTimer = Timer(_initTimeout, () {
      if (state is QiblaLoading) {
        emit(
          const QiblaState.error(
            message:
                'Waktu habis. Pastikan GPS aktif dan izin lokasi diberikan, lalu coba lagi.',
          ),
        );
      }
    });

    // Init: permission + koordinat
    final initResult = await _initQibla.call();
    _timeoutTimer?.cancel();

    if (isClosed) return;

    initResult.fold(
      (failure) => emit(QiblaState.error(message: failure.toUserMessage())),
      (_) => _subscribeToCompass(),
    );
  }

  void _subscribeToCompass() {
    _watchQiblaDirection.call().fold(
      (failure) {
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
            if (isClosed) return;
            final heading = direction.deviceHeading;
            if (_lastEmittedAngle == null ||
                (heading - _lastEmittedAngle!).abs() > _angleThreshold) {
              _lastEmittedAngle = heading;
              emit(QiblaState.loaded(direction: direction));
            }
          },
          onError: (Object e) {
            if (!isClosed) emit(QiblaState.error(message: e.toString()));
          },
        );
      },
    );
  }

  /// Stop stream dan reset ke initial.
  void stop() {
    _timeoutTimer?.cancel();
    unawaited(_subscription?.cancel());
    _subscription = null;
    _lastEmittedAngle = null;
    emit(const QiblaState.initial());
  }

  @override
  Future<void> close() async {
    _timeoutTimer?.cancel();
    await _subscription?.cancel();
    await super.close();
  }
}
