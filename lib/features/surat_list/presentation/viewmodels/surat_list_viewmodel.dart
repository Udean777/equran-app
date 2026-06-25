import 'dart:async';

import 'package:equran_app/features/surat_list/domain/usecases/get_surat_list.dart';
import 'package:equran_app/features/surat_list/presentation/viewmodels/surat_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuratListViewModel extends StateNotifier<SuratListState> {
  SuratListViewModel(this._getSuratList)
    : super(const SuratListState.initial());

  final GetSuratList _getSuratList;
  Timer? _debounce;

  Future<void> load() async {
    state = const SuratListState.loading();
    final result = await _getSuratList();
    result.fold(
      (failure) => state = SuratListState.failure(failure: failure),
      (surats) => state = SuratListState.success(surats: surats),
    );
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final current = state;
      if (current is SuratListSuccess) {
        state = current.copyWith(query: query);
      }
    });
  }

  void setFilter(SuratCompletionFilter filter) {
    final current = state;
    if (current is SuratListSuccess) {
      state = current.copyWith(activeFilter: filter);
    }
  }

  void retry() => load();
  Future<void> refresh() => load();
}
