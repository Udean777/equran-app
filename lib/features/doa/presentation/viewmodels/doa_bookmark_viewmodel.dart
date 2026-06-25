import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_bookmark_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoaBookmarkViewModel extends StateNotifier<DoaBookmarkState> {
  DoaBookmarkViewModel(
    this._getDoaBookmarks,
    this._toggleDoaBookmark,
    this._getDoaList,
  ) : super(const DoaBookmarkState.initial());

  final GetDoaBookmarks _getDoaBookmarks;
  final ToggleDoaBookmark _toggleDoaBookmark;
  final GetDoaList _getDoaList;

  Future<void> load() async {
    state = const DoaBookmarkState.loading();

    final doaBookmarksResult = await _getDoaBookmarks();
    final doaListResult = await _getDoaList();

    var firstFailure = doaBookmarksResult.fold(
      (f) => f,
      (_) => null,
    );
    doaListResult.fold(
      (f) => firstFailure ??= f,
      (_) {},
    );

    if (firstFailure != null) {
      state = DoaBookmarkState.failure(failure: firstFailure!);
      return;
    }

    final bookmarkedDoaIds = doaBookmarksResult.getOrElse((_) => const {});
    final allDoas = doaListResult.getOrElse((_) => const []);

    final bookmarkedDoas = allDoas
        .where((doa) => bookmarkedDoaIds.contains(doa.id))
        .toList();

    state = DoaBookmarkState.success(bookmarkedDoas: bookmarkedDoas);
  }

  Future<void> toggleBookmark(int id) async {
    final result = await _toggleDoaBookmark(id);
    result.fold(
      (failure) => state = DoaBookmarkState.failure(failure: failure),
      (_) => load(),
    );
  }

  Future<void> removeBookmark(int id) async {
    await toggleBookmark(id);
  }
}
