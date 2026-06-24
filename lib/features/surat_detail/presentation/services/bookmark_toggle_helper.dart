import 'dart:async';

import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';

abstract final class BookmarkToggleHelper {
  static void toggle({
    required BookmarkCubit cubit,
    required SuratDetail detail,
    required Ayat ayat,
    required bool isBookmarked,
  }) {
    if (isBookmarked) {
      unawaited(
        cubit.removeBookmark(
          suratNomor: detail.nomor,
          ayatNomor: ayat.nomorAyat,
        ),
      );
    } else {
      unawaited(
        cubit.addBookmark(
          Bookmark(
            suratNomor: detail.nomor,
            ayatNomor: ayat.nomorAyat,
            namaLatin: detail.namaLatin,
            teksArab: ayat.teksArab,
            teksIndonesia: ayat.teksIndonesia,
            savedAt: DateTime.now(),
          ),
        ),
      );
    }
  }
}
