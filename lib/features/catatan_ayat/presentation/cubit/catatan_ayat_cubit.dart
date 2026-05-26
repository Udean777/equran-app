import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/delete_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/get_all_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/save_catatan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'catatan_ayat_state.dart';
part 'catatan_ayat_cubit.freezed.dart';

@injectable
class CatatanAyatCubit extends Cubit<CatatanAyatState> {
  CatatanAyatCubit(
    this._getAll,
    this._save,
    this._delete,
  ) : super(const CatatanAyatState.initial());

  final GetAllCatatan _getAll;
  final SaveCatatan _save;
  final DeleteCatatan _delete;

  /// Load semua catatan dari Hive.
  Future<void> load() async {
    emit(const CatatanAyatState.loading());
    final result = await _getAll();
    result.fold(
      (failure) => emit(const CatatanAyatState.failure('Gagal memuat catatan')),
      (list) => emit(CatatanAyatState.success(list)),
    );
  }

  /// Simpan atau update catatan. Reload setelah berhasil.
  Future<void> save(CatatanAyat catatan) async {
    final result = await _save(catatan);
    result.fold(
      (_) => emit(const CatatanAyatState.failure('Gagal menyimpan catatan')),
      (_) => load(),
    );
  }

  /// Hapus catatan. Reload setelah berhasil.
  Future<void> delete({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    final result = await _delete(
      suratNomor: suratNomor,
      ayatNomor: ayatNomor,
    );
    result.fold(
      (_) => emit(const CatatanAyatState.failure('Gagal menghapus catatan')),
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
