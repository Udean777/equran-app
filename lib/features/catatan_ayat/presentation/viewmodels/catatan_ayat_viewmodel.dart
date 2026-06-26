import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/delete_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/get_all_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/save_catatan.dart';
import 'package:equran_app/features/catatan_ayat/presentation/providers.dart';
import 'package:equran_app/features/catatan_ayat/presentation/viewmodels/catatan_ayat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatatanAyatViewModel extends AutoDisposeNotifier<CatatanAyatState> {
  GetAllCatatan get _getAll => ref.read(getAllCatatanProvider);
  SaveCatatan get _save => ref.read(saveCatatanProvider);
  DeleteCatatan get _delete => ref.read(deleteCatatanProvider);

  @override
  CatatanAyatState build() => const CatatanAyatState.initial();

  /// Load semua catatan dari Hive.
  Future<void> load() async {
    state = const CatatanAyatState.loading();
    final result = await _getAll();
    result.fold(
      (failure) => state = CatatanAyatState.failure(failure),
      (list) => state = CatatanAyatState.success(list),
    );
  }

  /// Simpan atau update catatan. Reload setelah berhasil.
  Future<void> save(CatatanAyat catatan) async {
    final result = await _save(catatan);
    result.fold(
      (failure) => state = CatatanAyatState.failure(failure),
      (_) => load(),
    );
  }

  /// Hapus catatan. Reload setelah berhasil.
  Future<void> delete({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    final result = await _delete(
      DeleteCatatanParams(suratNomor: suratNomor, ayatNomor: ayatNomor),
    );
    result.fold(
      (failure) => state = CatatanAyatState.failure(failure),
      (_) => load(),
    );
  }

  /// Cek apakah ayat tertentu punya catatan (dari state success).
  bool hasCatatan({required int suratNomor, required int ayatNomor}) {
    return state.maybeMap(
      success: (s) => s.catatan.any(
        (c) => c.suratNomor == suratNomor && c.ayatNomor == ayatNomor,
      ),
      orElse: () => false,
    );
  }

  /// Ambil catatan untuk ayat tertentu (dari state success).
  CatatanAyat? getCatatan({
    required int suratNomor,
    required int ayatNomor,
  }) {
    return state.maybeMap(
      success: (s) {
        final matches = s.catatan.where(
          (c) => c.suratNomor == suratNomor && c.ayatNomor == ayatNomor,
        );
        return matches.isEmpty ? null : matches.first;
      },
      orElse: () => null,
    );
  }
}
