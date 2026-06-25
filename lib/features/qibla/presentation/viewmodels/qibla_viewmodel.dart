import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/qibla/domain/usecases/init_qibla.dart';
import 'package:equran_app/features/qibla/domain/usecases/watch_qibla_direction.dart';
import 'package:equran_app/features/qibla/presentation/providers.dart';
import 'package:equran_app/features/qibla/presentation/viewmodels/qibla_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QiblaViewModel extends AutoDisposeNotifier<QiblaState> {
  StreamSubscription<dynamic>? _subscription;
  Timer? _timeoutTimer;

  InitQibla get _initQibla => ref.read(initQiblaProvider);
  WatchQiblaDirection get _watchQiblaDirection =>
      ref.read(watchQiblaDirectionProvider);

  /// Threshold minimum perubahan sudut (derajat) sebelum emit state baru.
  static const _angleThreshold = 1.0;

  /// Timeout init (permission + GPS) — 15 detik.
  static const _initTimeout = Duration(seconds: 15);

  double? _lastEmittedAngle;

  @override
  QiblaState build() {
    ref.onDispose(_dispose);
    return const QiblaState.initial();
  }

  void _dispose() {
    _timeoutTimer?.cancel();
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  /// Mulai: request permission, ambil koordinat, subscribe stream kompas.
  Future<void> start() async {
    if (state is QiblaLoading) return;
    await _subscription?.cancel();
    _subscription = null;
    _lastEmittedAngle = null;
    _timeoutTimer?.cancel();

    state = const QiblaState.loading();

    // Timeout guard — jika init > 15s, emit error agar tidak stuck
    _timeoutTimer = Timer(_initTimeout, () {
      if (state is QiblaLoading) {
        state = const QiblaState.error(
          message:
              'Waktu habis. Pastikan GPS aktif dan izin lokasi diberikan, lalu coba lagi.',
        );
      }
    });

    // Init: permission + koordinat
    final initResult = await _initQibla.call();
    _timeoutTimer?.cancel();

    initResult.fold(
      (failure) => state = QiblaState.error(message: failure.toUserMessage()),
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
          state = const QiblaState.noSensor();
        } else {
          state = QiblaState.error(message: failure.toUserMessage());
        }
      },
      (stream) {
        _subscription = stream.listen(
          (direction) {
            final heading = direction.deviceHeading;
            if (_lastEmittedAngle == null ||
                (heading - _lastEmittedAngle!).abs() > _angleThreshold) {
              _lastEmittedAngle = heading;
              state = QiblaState.loaded(direction: direction);
            }
          },
          onError: (Object e) {
            state = QiblaState.error(message: e.toString());
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
    state = const QiblaState.initial();
  }
}
