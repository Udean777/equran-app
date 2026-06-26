import 'dart:async';

import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuratDetailViewModel extends AutoDisposeFamilyNotifier<SuratDetailState, int> {
  @override
  SuratDetailState build(int nomor) {
    unawaited(load(nomor));
    return const SuratDetailState.initial();
  }

  GetSuratDetail get _getSuratDetail => ref.read(getSuratDetailProvider);

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
