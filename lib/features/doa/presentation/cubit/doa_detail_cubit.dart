import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'doa_detail_cubit.freezed.dart';
part 'doa_detail_state.dart';

@injectable
class DoaDetailCubit extends Cubit<DoaDetailState> {
  DoaDetailCubit(
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
    emit(const DoaDetailState.loading());
    final result = await _getDoaDetail(id);
    result.fold(
      (failure) => emit(DoaDetailState.failure(failure: failure)),
      (doa) async {
        // Load bookmark status setelah detail berhasil
        final bookmarkResult = await _getDoaBookmarks();
        final isBookmarked = bookmarkResult.fold(
          (_) => false,
          (ids) => ids.contains(id),
        );
        emit(DoaDetailState.success(doa: doa, isBookmarked: isBookmarked));
      },
    );
  }

  Future<void> toggleBookmark() async {
    final current = state;
    if (current is! DoaDetailSuccess) return;

    final result = await _toggleDoaBookmark(current.doa.id);
    result.fold(
      (_) {},
      (isNowBookmarked) => emit(
        current.copyWith(isBookmarked: isNowBookmarked),
      ),
    );
  }

  void retry() {
    if (_lastId != null) unawaited(load(_lastId!));
  }
}
