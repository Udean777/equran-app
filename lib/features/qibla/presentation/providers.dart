import 'package:equran_app/features/qibla/data/datasources/qibla_data_source.dart';
import 'package:equran_app/features/qibla/data/repositories/qibla_repository_impl.dart';
import 'package:equran_app/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:equran_app/features/qibla/domain/usecases/init_qibla.dart';
import 'package:equran_app/features/qibla/domain/usecases/watch_qibla_direction.dart';
import 'package:equran_app/features/qibla/presentation/viewmodels/qibla_state.dart';
import 'package:equran_app/features/qibla/presentation/viewmodels/qibla_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Datasource ────────────────────────────────────────────────────────────

final qiblaDataSourceProvider = Provider<QiblaDataSource>((ref) {
  return QiblaDataSource();
});

// ─── Repository ────────────────────────────────────────────────────────────

final qiblaRepositoryProvider = Provider<QiblaRepository>((ref) {
  return QiblaRepositoryImpl(ref.read(qiblaDataSourceProvider));
});

// ─── Use Cases ─────────────────────────────────────────────────────────────

final initQiblaProvider = Provider<InitQibla>((ref) {
  return InitQibla(ref.read(qiblaRepositoryProvider));
});

final watchQiblaDirectionProvider = Provider<WatchQiblaDirection>((ref) {
  return WatchQiblaDirection(ref.read(qiblaRepositoryProvider));
});

// ─── ViewModel Provider ────────────────────────────────────────────────────

final qiblaViewModelProvider =
    AutoDisposeNotifierProvider<QiblaViewModel, QiblaState>(
      QiblaViewModel.new,
    );
