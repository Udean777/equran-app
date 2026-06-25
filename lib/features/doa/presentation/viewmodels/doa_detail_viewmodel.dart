import 'dart:async';

import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoaDetailViewModel extends StateNotifier<DoaDetailState> {
  DoaDetailViewModel(
    this._getDoaDetail,
    this._getDoaBookmarks,
    this._toggleDoaBookmark,
  ) : super(const DoaDetailState.initial());

  final GetDoaDetail _getDoaDetail;
  final GetDoaBookmarks _getDoaBookmarks;
  final ToggleDoaBookmark _toggleDoaBookmark;

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
