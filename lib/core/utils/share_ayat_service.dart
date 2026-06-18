import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
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

  /// Render [cardKey] menjadi bytes PNG.
  static Future<List<int>?> _renderCardBytes(GlobalKey cardKey) async {
    final boundary =
        cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
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
    final bytes = await _renderCardBytes(cardKey);
    if (bytes == null) return;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ayat_${suratNomor}_${ayat.nomorAyat}.png');
    await file.writeAsBytes(bytes);

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
    shareOrigin ??= const Rect.fromLTWH(0, 100, 100, 100);

    final caption =
        '﴿ ${ayat.teksArab} ﴾\n\n'
        '${ayat.teksIndonesia}\n\n'
        '— Q.S. $namaLatin ($suratNomor): ${ayat.nomorAyat}';

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: caption,
      sharePositionOrigin: shareOrigin,
    );
  }

  /// Render [cardKey] menjadi gambar lalu simpan ke gallery.
  /// Return true jika berhasil, false jika gagal atau permission ditolak.
  static Future<bool> saveToGallery({
    required GlobalKey cardKey,
    required int suratNomor,
    required int nomorAyat,
  }) async {
    try {
      final bytes = await _renderCardBytes(cardKey);
      if (bytes == null) return false;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ayat_${suratNomor}_$nomorAyat.png');
      await file.writeAsBytes(bytes);

      // Langsung putImage — gal handle permission secara internal di Android 10+
      // Tidak pakai album agar tidak butuh permission WRITE_EXTERNAL_STORAGE
      await Gal.putImage(file.path);
      return true;
    } on GalException catch (e) {
      debugPrint('ShareAyatService.saveToGallery GalException: ${e.type}');
      return false;
    } on Object catch (e) {
      debugPrint('ShareAyatService.saveToGallery error: $e');
      return false;
    }
  }

  /// Render [cardKey] menjadi gambar lalu biarkan user memilih lokasi penyimpanan.
  /// Return true jika berhasil disimpan, false jika dibatalkan atau gagal.
  static Future<bool> saveToCustomDirectory({
    required GlobalKey cardKey,
    required int suratNomor,
    required int nomorAyat,
  }) async {
    try {
      final bytes = await _renderCardBytes(cardKey);
      if (bytes == null) return false;

      final u8List = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
      final fileName = 'ayat_${suratNomor}_$nomorAyat.png';

      // Buka dialog penyimpanan file bawaan sistem secara statis
      final selectedPath = await FilePicker.saveFile(
        dialogTitle: 'Simpan Gambar Ayat',
        fileName: fileName,
        type: FileType.image,
        bytes: u8List,
      );

      if (selectedPath != null) {
        final file = File(selectedPath);
        await file.writeAsBytes(u8List);
        return true;
      }
      return false;
    } on Object catch (e) {
      debugPrint('ShareAyatService.saveToCustomDirectory error: $e');
      return false;
    }
  }
}
