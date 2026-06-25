import 'dart:async';

import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/surat_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuratDetailViewModel extends StateNotifier<SuratDetailState> {
  SuratDetailViewModel(this._getSuratDetail)
    : super(const SuratDetailState.initial());

  final GetSuratDetail _getSuratDetail;

  Future<void> load(int nomor) async {
    state = const SuratDetailState.loading();
    final result = await _getSuratDetail(SuratDetailParams(nomor: nomor));
    result.fold(
      (failure) => state = SuratDetailState.failure(failure: failure),
      (detail) => state = SuratDetailState.success(detail: detail),
    );
  }

  void retry(int nomor) => load(nomor);
}
