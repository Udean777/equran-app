import 'dart:io';
import 'dart:ui' as ui;

import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareAyatService {
  /// Share ayat sebagai plain text.
  static Future<void> shareText({
    required Ayat ayat,
    required String namaLatin,
    required int suratNomor,
  }) async {
    final text =
        '﴿ ${ayat.teksArab} ﴾\n\n'
        '${ayat.teksIndonesia}\n\n'
        '— Q.S. $namaLatin ($suratNomor): ${ayat.nomorAyat}';
    await Share.share(text);
  }

  /// Render [cardKey] menjadi gambar lalu share sebagai file.
  static Future<void> shareImage({
    required GlobalKey cardKey,
    required String namaLatin,
    required int suratNomor,
    required int nomorAyat,
  }) async {
    final boundary =
        cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final bytes = byteData.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/ayat_${suratNomor}_$nomorAyat.png',
    );
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: 'Q.S. $namaLatin ($suratNomor): $nomorAyat',
    );
  }
}
