import 'dart:async';

import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:equran_app/features/doa/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoaDetailViewModel extends AutoDisposeNotifier<DoaDetailState> {
  @override
  DoaDetailState build() => const DoaDetailState.initial();

  GetDoaDetail get _getDoaDetail => ref.read(getDoaDetailProvider);
  GetDoaBookmarks get _getDoaBookmarks => ref.read(getDoaBookmarksProvider);
  ToggleDoaBookmark get _toggleDoaBookmark =>
      ref.read(toggleDoaBookmarkProvider);

  int? _lastId;

  Future<void> load(int id) async {
    _lastId = id;
    state = const DoaDetailState.loading();
    final result = await _getDoaDetail(id);
    result.fold(
      (failure) => state = DoaDetailState.failure(failure: failure),
      (doa) async {
        final bookmarkResult = await _getDoaBookmarks();
        final isBookmarked = bookmarkResult.fold(
          (_) => false,
          (ids) => ids.contains(id),
        );
        state = DoaDetailState.success(doa: doa, isBookmarked: isBookmarked);
      },
    );
  }

  Future<void> toggleBookmark() async {
    final current = state;
    if (current is! DoaDetailSuccess) return;

    final result = await _toggleDoaBookmark(current.doa.id);
    result.fold(
      (_) {},
      (isNowBookmarked) =>
          state = current.copyWith(isBookmarked: isNowBookmarked),
    );
  }

  void retry() {
    if (_lastId != null) unawaited(load(_lastId!));
  }
}
