import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'doa_list_cubit.freezed.dart';
part 'doa_list_state.dart';

@injectable
class DoaListCubit extends Cubit<DoaListState> {
  DoaListCubit(this._getDoaList) : super(const DoaListState.initial());

  final GetDoaList _getDoaList;

  Future<void> load() async {
    emit(const DoaListState.loading());
    final result = await _getDoaList();
    result.fold(
      (failure) => emit(DoaListState.failure(failure: failure)),
      (doaList) => emit(
        DoaListState.success(
          allDoa: doaList,
          grupList: _extractGrupList(doaList),
          tagList: _extractTagList(doaList),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final result = await _getDoaList();
    result.fold(
      (failure) => emit(DoaListState.failure(failure: failure)),
      (doaList) => emit(
        DoaListState.success(
          allDoa: doaList,
          grupList: _extractGrupList(doaList),
          tagList: _extractTagList(doaList),
        ),
      ),
    );
  }

  void search(String query) {
    final current = state;
    if (current is DoaListSuccess) {
      emit(current.copyWith(query: query, activeGrup: null, activeTag: null));
    }
  }

  void filterByGrup(String? grup) {
    final current = state;
    if (current is DoaListSuccess) {
      emit(current.copyWith(activeGrup: grup, activeTag: null, query: ''));
    }
  }

  void filterByTag(String? tag) {
    final current = state;
    if (current is DoaListSuccess) {
      emit(current.copyWith(activeTag: tag, activeGrup: null, query: ''));
    }
  }

  void clearFilter() {
    final current = state;
    if (current is DoaListSuccess) {
      emit(
        current.copyWith(activeGrup: null, activeTag: null, query: ''),
      );
    }
  }

  void retry() => load();

  // --- helpers ---

  List<String> _extractGrupList(List<Doa> doaList) {
    final seen = <String>{};
    return doaList
        .map((d) => d.grup)
        .where(seen.add)
        .toList();
  }

  List<String> _extractTagList(List<Doa> doaList) {
    final seen = <String>{};
    return doaList
        .expand((d) => d.tag)
        .where(seen.add)
        .toList()
      ..sort();
  }
}
