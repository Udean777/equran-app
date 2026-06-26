import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/tasbih/data/datasources/tasbih_local_data_source.dart';
import 'package:equran_app/features/tasbih/data/repositories/tasbih_repository_impl.dart';
import 'package:equran_app/features/tasbih/domain/repositories/tasbih_repository.dart';
import 'package:equran_app/features/tasbih/domain/usecases/clear_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/delete_tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/usecases/get_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/save_tasbih_session.dart';
import 'package:equran_app/features/tasbih/presentation/viewmodels/tasbih_state.dart';
import 'package:equran_app/features/tasbih/presentation/viewmodels/tasbih_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Datasource ────────────────────────────────────────────────────────────

final tasbihLocalDataSourceProvider = Provider<TasbihLocalDataSource>((ref) {
  return TasbihLocalDataSourceImpl(
    ref.watch(tasbihBoxProvider),
  );
});

// ─── Repository ────────────────────────────────────────────────────────────

final tasbihRepositoryProvider = Provider<TasbihRepository>((ref) {
  return TasbihRepositoryImpl(ref.read(tasbihLocalDataSourceProvider));
});

// ─── Use Cases ─────────────────────────────────────────────────────────────

final getTasbihSessionsProvider = Provider<GetTasbihSessions>((ref) {
  return GetTasbihSessions(ref.read(tasbihRepositoryProvider));
});

final saveTasbihSessionProvider = Provider<SaveTasbihSession>((ref) {
  return SaveTasbihSession(ref.read(tasbihRepositoryProvider));
});

final deleteTasbihSessionProvider = Provider<DeleteTasbihSession>((ref) {
  return DeleteTasbihSession(ref.read(tasbihRepositoryProvider));
});

final clearTasbihSessionsProvider = Provider<ClearTasbihSessions>((ref) {
  return ClearTasbihSessions(ref.read(tasbihRepositoryProvider));
});

// ─── ViewModel Provider ────────────────────────────────────────────────────

final tasbihViewModelProvider = NotifierProvider<TasbihViewModel, TasbihState>(
  TasbihViewModel.new,
);
