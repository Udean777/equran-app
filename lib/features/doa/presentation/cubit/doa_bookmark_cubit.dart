import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'doa_bookmark_cubit.freezed.dart';
part 'doa_bookmark_state.dart';

@lazySingleton
class DoaBookmarkCubit extends Cubit<DoaBookmarkState> {
  DoaBookmarkCubit(
    this._getDoaBookmarks,
    this._toggleDoaBookmark,
    this._getDoaList,
  ) : super(const DoaBookmarkState.initial());

  final GetDoaBookmarks _getDoaBookmarks;
  final ToggleDoaBookmark _toggleDoaBookmark;
  final GetDoaList _getDoaList;

  Future<void> load() async {
    emit(const DoaBookmarkState.loading());

    final doaBookmarksResult = await _getDoaBookmarks();
    final doaListResult = await _getDoaList();

    Failure? firstFailure;
    Set<int>? bookmarkedDoaIds;
    List<Doa>? allDoas;

    doaBookmarksResult.fold(
      (f) => firstFailure ??= f,
      (r) => bookmarkedDoaIds = r,
    );
    doaListResult.fold((f) => firstFailure ??= f, (r) => allDoas = r);

    if (firstFailure != null) {
      emit(DoaBookmarkState.failure(failure: firstFailure!));
      return;
    }

    final bookmarkedDoas = allDoas!
        .where((doa) => bookmarkedDoaIds!.contains(doa.id))
        .toList();

    emit(DoaBookmarkState.success(bookmarkedDoas: bookmarkedDoas));
  }

  Future<void> toggleBookmark(int id) async {
    final result = await _toggleDoaBookmark(id);
    result.fold(
      (failure) => emit(DoaBookmarkState.failure(failure: failure)),
      (_) => load(),
    );
  }

  Future<void> removeBookmark(int id) async {
    // toggle akan remove jika sudah di-bookmark
    await toggleBookmark(id);
  }
}
