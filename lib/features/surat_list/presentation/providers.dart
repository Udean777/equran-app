import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/surat_list/data/datasources/surat_local_data_source.dart';
import 'package:equran_app/features/surat_list/data/datasources/surat_remote_data_source.dart';
import 'package:equran_app/features/surat_list/data/repositories/surat_repository_impl.dart';
import 'package:equran_app/features/surat_list/domain/repositories/surat_repository.dart';
import 'package:equran_app/features/surat_list/domain/usecases/get_surat_list.dart';
import 'package:equran_app/features/surat_list/presentation/viewmodels/surat_list_state.dart';
import 'package:equran_app/features/surat_list/presentation/viewmodels/surat_list_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/surat_list_state.dart';

final suratLocalDataSourceProvider = Provider<SuratLocalDataSource>((ref) {
  return SuratLocalDataSourceImpl(ref.watch(suratBoxProvider));
});

final suratRemoteDataSourceProvider = Provider<SuratRemoteDataSource>((ref) {
  return SuratRemoteDataSourceImpl(ref.read(dioProvider));
});

final suratRepositoryProvider = Provider<SuratRepository>((ref) {
  return SuratRepositoryImpl(
    ref.read(suratRemoteDataSourceProvider),
    ref.read(suratLocalDataSourceProvider),
  );
});

final getSuratListProvider = Provider<GetSuratList>((ref) {
  return GetSuratList(ref.read(suratRepositoryProvider));
});

final AutoDisposeNotifierProvider<SuratListViewModel, SuratListState>
suratListViewModelProvider =
    NotifierProvider.autoDispose<SuratListViewModel, SuratListState>(
      SuratListViewModel.new,
    );
