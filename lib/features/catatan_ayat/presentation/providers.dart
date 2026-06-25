import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/catatan_ayat/data/datasources/catatan_ayat_local_data_source.dart';
import 'package:equran_app/features/catatan_ayat/data/repositories/catatan_ayat_repository_impl.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/delete_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/get_all_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/save_catatan.dart';
import 'package:equran_app/features/catatan_ayat/presentation/viewmodels/catatan_ayat_state.dart';
import 'package:equran_app/features/catatan_ayat/presentation/viewmodels/catatan_ayat_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catatanAyatLocalDataSourceProvider = Provider<CatatanAyatLocalDataSource>(
  (ref) {
    final box = ref.watch(catatanBoxProvider).requireValue;
    return CatatanAyatLocalDataSourceImpl(box);
  },
);

final catatanAyatRepositoryProvider = Provider<CatatanAyatRepositoryImpl>((
  ref,
) {
  final datasource = ref.read(catatanAyatLocalDataSourceProvider);
  return CatatanAyatRepositoryImpl(datasource);
});

final getAllCatatanProvider = Provider<GetAllCatatan>((ref) {
  return GetAllCatatan(ref.read(catatanAyatRepositoryProvider));
});

final saveCatatanProvider = Provider<SaveCatatan>((ref) {
  return SaveCatatan(ref.read(catatanAyatRepositoryProvider));
});

final deleteCatatanProvider = Provider<DeleteCatatan>((ref) {
  return DeleteCatatan(ref.read(catatanAyatRepositoryProvider));
});

final catatanAyatViewModelProvider =
    AutoDisposeNotifierProvider<CatatanAyatViewModel, CatatanAyatState>(
      CatatanAyatViewModel.new,
    );
