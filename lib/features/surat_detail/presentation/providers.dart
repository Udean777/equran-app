import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/surat_detail/data/datasources/surat_detail_local_data_source.dart';
import 'package:equran_app/features/surat_detail/data/datasources/surat_detail_remote_data_source.dart';
import 'package:equran_app/features/surat_detail/data/repositories/surat_detail_repository_impl.dart';
import 'package:equran_app/features/surat_detail/domain/repositories/surat_detail_repository.dart';
import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/surat_detail_state.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/surat_detail_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/surat_detail_state.dart';

final suratDetailLocalDataSourceProvider = Provider<SuratDetailLocalDataSource>(
  (ref) {
    return SuratDetailLocalDataSourceImpl(ref.watch(suratBoxProvider));
  },
);

final suratDetailRemoteDataSourceProvider =
    Provider<SuratDetailRemoteDataSource>((ref) {
      return SuratDetailRemoteDataSourceImpl(ref.read(dioProvider));
    });

final suratDetailRepositoryProvider = Provider<SuratDetailRepository>((
  ref,
) {
  return SuratDetailRepositoryImpl(
    ref.read(suratDetailRemoteDataSourceProvider),
    ref.read(suratDetailLocalDataSourceProvider),
  );
});

final getSuratDetailProvider = Provider<GetSuratDetail>((ref) {
  return GetSuratDetail(ref.read(suratDetailRepositoryProvider));
});

final AutoDisposeNotifierProviderFamily<
  SuratDetailViewModel,
  SuratDetailState,
  int
>
suratDetailViewModelProvider = NotifierProvider.autoDispose
    .family<SuratDetailViewModel, SuratDetailState, int>(
      SuratDetailViewModel.new,
    );
