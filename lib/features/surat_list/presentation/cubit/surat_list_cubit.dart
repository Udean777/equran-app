import 'dart:async';

import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_list/domain/usecases/get_surat_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'surat_list_cubit.freezed.dart';
part 'surat_list_state.dart';

enum SuratCompletionFilter { all, incomplete, completed }

@injectable
class SuratListCubit extends Cubit<SuratListState> {
  SuratListCubit(this._getSuratList) : super(const SuratListState.initial());

  final GetSuratList _getSuratList;
  Timer? _debounce;

  Future<void> load() async {
    emit(const SuratListState.loading());
    final result = await _getSuratList();
    result.fold(
      (failure) => emit(SuratListState.failure(failure: failure)),
      (surats) => emit(SuratListState.success(surats: surats)),
    );
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final current = state;
      if (current is SuratListSuccess) {
        emit(current.copyWith(query: query));
      }
    });
  }

  void setFilter(SuratCompletionFilter filter) {
    final current = state;
    if (current is SuratListSuccess) {
      emit(current.copyWith(activeFilter: filter));
    }
  }

  void retry() => load();

  Future<void> refresh() => load();
}
