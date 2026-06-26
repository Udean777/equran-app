import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:equran_app/features/doa/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoaBookmarkViewModel extends Notifier<DoaBookmarkState> {
  @override
  DoaBookmarkState build() => const DoaBookmarkState.initial();

  GetDoaBookmarks get _getDoaBookmarks => ref.read(getDoaBookmarksProvider);
  ToggleDoaBookmark get _toggleDoaBookmark => ref.read(toggleDoaBookmarkProvider);
  GetDoaList get _getDoaList => ref.read(getDoaListProvider);

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
