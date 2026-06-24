import 'package:equran_app/core/utils/share_utils.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
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

  /// Format caption untuk share gambar ayat.
  static String _formatCaption({
    required Ayat ayat,
    required String namaLatin,
    required int suratNomor,
  }) {
    return '﴿ ${ayat.teksArab} ﴾\n\n'
        '${ayat.teksIndonesia}\n\n'
        '— Q.S. $namaLatin ($suratNomor): ${ayat.nomorAyat}';
  }

  /// Format nama file untuk ayat.
  static String _formatFileName(int suratNomor, int nomorAyat) {
    return 'ayat_${suratNomor}_$nomorAyat.png';
  }

  /// Render [cardKey] menjadi gambar lalu share sebagai file beserta teks lengkap ayat.
  /// [shareButtonKey] digunakan untuk sharePositionOrigin di iOS/iPad.
  static Future<void> shareImage({
    required GlobalKey cardKey,
    required Ayat ayat,
    required String namaLatin,
    required int suratNomor,
    GlobalKey? shareButtonKey,
  }) async {
    final bytes = await ShareUtils.renderWidgetToPngBytes(cardKey);
    if (bytes == null) return;

    // Hitung posisi tombol untuk sharePositionOrigin (wajib di iOS/iPad)
    Rect? shareOrigin;
    if (shareButtonKey != null) {
      final box =
          shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final pos = box.localToGlobal(Offset.zero);
        shareOrigin = pos & box.size;
      }
    }

    final caption = _formatCaption(
      ayat: ayat,
      namaLatin: namaLatin,
      suratNomor: suratNomor,
    );
    final fileName = _formatFileName(suratNomor, ayat.nomorAyat);

    await ShareUtils.sharePngBytes(
      bytes,
      fileName,
      caption: caption,
      shareOrigin: shareOrigin,
    );
  }

  /// Render [cardKey] menjadi gambar lalu simpan ke gallery.
  /// Return true jika berhasil, false jika gagal atau permission ditolak.
  static Future<bool> saveToGallery({
    required GlobalKey cardKey,
    required int suratNomor,
    required int nomorAyat,
  }) async {
    final bytes = await ShareUtils.renderWidgetToPngBytes(cardKey);
    if (bytes == null) return false;

    final name = 'ayat_${suratNomor}_$nomorAyat';
    return ShareUtils.saveToGallery(bytes, name);
  }

  /// Render [cardKey] menjadi gambar lalu biarkan user memilih lokasi penyimpanan.
  /// Return true jika berhasil disimpan, false jika dibatalkan atau gagal.
  static Future<bool> saveToCustomDirectory({
    required GlobalKey cardKey,
    required int suratNomor,
    required int nomorAyat,
  }) async {
    final bytes = await ShareUtils.renderWidgetToPngBytes(cardKey);
    if (bytes == null) return false;

    final fileName = _formatFileName(suratNomor, nomorAyat);
    return ShareUtils.saveToCustomDirectory(bytes, fileName);
  }
}
