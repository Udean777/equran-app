import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoaListViewModel extends StateNotifier<DoaListState> {
  DoaListViewModel(this._getDoaList) : super(const DoaListState.initial());

  final GetDoaList _getDoaList;

  Future<void> load() async {
    state = const DoaListState.loading();
    final result = await _getDoaList();
    result.fold(
      (failure) => state = DoaListState.failure(failure: failure),
      (doaList) => state = DoaListState.success(
        allDoa: doaList,
        grupList: _extractGrupList(doaList),
        tagList: _extractTagList(doaList),
      ),
    );
  }

  Future<void> refresh() => load();

  void search(String query) {
    final current = state;
    if (current is DoaListSuccess) {
      state = current.copyWith(query: query, activeGrup: null, activeTag: null);
    }
  }

  void filterByGrup(String? grup) {
    final current = state;
    if (current is DoaListSuccess) {
      state = current.copyWith(activeGrup: grup, activeTag: null, query: '');
    }
  }

  void filterByTag(String? tag) {
    final current = state;
    if (current is DoaListSuccess) {
      state = current.copyWith(activeTag: tag, activeGrup: null, query: '');
    }
  }

  void clearFilter() {
    final current = state;
    if (current is DoaListSuccess) {
      state = current.copyWith(activeGrup: null, activeTag: null, query: '');
    }
  }

  void retry() => load();

  List<String> _extractGrupList(List<Doa> doaList) {
    final seen = <String>{};
    return doaList.map((d) => d.grup).where(seen.add).toList();
  }

  List<String> _extractTagList(List<Doa> doaList) {
    final seen = <String>{};
    return doaList.expand((d) => d.tag).where(seen.add).toList()..sort();
  }
}
