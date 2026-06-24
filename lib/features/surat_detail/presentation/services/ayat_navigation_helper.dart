import 'dart:async';

import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/pages/share_ayat_page.dart';
import 'package:flutter/material.dart';

abstract final class AyatNavigationHelper {
  static void openSharePage(
    BuildContext context, {
    required Ayat ayat,
    required String namaLatin,
    required int suratNomor,
  }) {
    unawaited(
      Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => ShareAyatPage(
            ayat: ayat,
            namaLatin: namaLatin,
            suratNomor: suratNomor,
          ),
        ),
      ),
    );
  }
}
