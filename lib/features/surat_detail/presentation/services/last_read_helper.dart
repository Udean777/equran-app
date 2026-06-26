import 'dart:async';

import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/presentation/viewmodels/bookmark_viewmodel.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/card_stack_state.dart';

abstract final class LastReadHelper {
  static void saveLastRead({
    required BookmarkViewModel viewModel,
    required CardStackState cardState,
    required SuratDetail detail,
  }) {
    final totalAyat = detail.ayatList.length;
    final ayatNomor = cardState.lastReadAyatNomor.clamp(1, totalAyat);
    final scrollPercent = totalAyat > 0
        ? (ayatNomor / totalAyat).clamp(0.0, 1.0)
        : 0.0;
    final maxScrollPercent = cardState.maxProgress.clamp(0.0, 1.0);

    unawaited(
      viewModel.saveLastRead(
        LastRead(
          suratNomor: detail.nomor,
          ayatNomor: ayatNomor,
          namaLatin: detail.namaLatin,
          readAt: DateTime.now(),
          scrollPercent: scrollPercent,
          maxScrollPercent: maxScrollPercent,
          totalAyat: totalAyat,
        ),
      ),
    );
  }
}
