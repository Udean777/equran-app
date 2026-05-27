import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/domain/usecases/get_surat_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'surat_list_cubit.freezed.dart';
part 'surat_list_state.dart';

/// Filter tampilan daftar surat berdasarkan progress membaca.
enum SuratCompletionFilter { all, incomplete, completed }

@injectable
class SuratListCubit extends Cubit<SuratListState> {
  SuratListCubit(this._getSuratList) : super(const SuratListState.initial());

  final GetSuratList _getSuratList;

  Future<void> load() async {
    emit(const SuratListState.loading());
    final result = await _getSuratList();
    result.fold(
      (failure) => emit(SuratListState.failure(failure: failure)),
      (surats) => emit(SuratListState.success(surats: surats)),
    );
  }

  void onQueryChanged(String query) {
    final current = state;
    if (current is SuratListSuccess) {
      emit(current.copyWith(query: query));
    }
  }

  void retry() => load();

  Future<void> refresh() async {
    emit(const SuratListState.loading());
    final result = await _getSuratList();
    result.fold(
      (failure) => emit(SuratListState.failure(failure: failure)),
      (surats) => emit(SuratListState.success(surats: surats)),
    );
  }
}
