import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/tafsir/data/datasources/tafsir_local_data_source.dart';
import 'package:equran_app/features/tafsir/data/datasources/tafsir_remote_data_source.dart';
import 'package:equran_app/features/tafsir/data/repositories/tafsir_repository_impl.dart';
import 'package:equran_app/features/tafsir/domain/repositories/tafsir_repository.dart';
import 'package:equran_app/features/tafsir/domain/usecases/get_tafsir.dart';
import 'package:equran_app/features/tafsir/presentation/viewmodels/tafsir_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tafsirLocalDataSourceProvider = Provider<TafsirLocalDataSource>((ref) {
  return TafsirLocalDataSourceImpl(ref.watch(tafsirBoxProvider));
});

final tafsirRemoteDataSourceProvider = Provider<TafsirRemoteDataSource>((ref) {
  return TafsirRemoteDataSourceImpl(ref.read(dioProvider));
});

final tafsirRepositoryProvider = Provider<TafsirRepository>((ref) {
  return TafsirRepositoryImpl(
    ref.read(tafsirRemoteDataSourceProvider),
    ref.read(tafsirLocalDataSourceProvider),
  );
});

final getTafsirProvider = Provider<GetTafsir>((ref) {
  return GetTafsir(ref.read(tafsirRepositoryProvider));
});

final AutoDisposeNotifierProvider<TafsirViewModel, TafsirState>
tafsirViewModelProvider =
    NotifierProvider.autoDispose<TafsirViewModel, TafsirState>(
      TafsirViewModel.new,
    );
