import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class ShareUtils {
  /// Render widget dari [key] menjadi bytes PNG.
  /// [pixelRatio] default 3.0 untuk kualitas retina.
  /// Returns null jika render gagal.
  static Future<Uint8List?> renderWidgetToPngBytes(
    GlobalKey key, {
    double pixelRatio = 3.0,
  }) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  /// Simpan [bytes] PNG ke temporary directory sebagai [fileName].
  /// Return path file atau null jika gagal.
  static Future<String?> saveToTempFile(
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } on Object catch (e) {
      debugPrint('ShareUtils.saveToTempFile error: $e');
      return null;
    }
  }

  /// Simpan [bytes] PNG ke galeri perangkat.
  /// [name] digunakan sebagai nama file (tanpa .png).
  static Future<bool> saveToGallery(Uint8List bytes, String name) async {
    try {
      final filePath = await saveToTempFile(bytes, '${name}_share_temp.png');
      if (filePath == null) return false;
      await Gal.putImage(filePath);
      return true;
    } on GalException catch (e) {
      debugPrint('ShareUtils.saveToGallery GalException: ${e.type}');
      return false;
    } on Object catch (e) {
      debugPrint('ShareUtils.saveToGallery error: $e');
      return false;
    }
  }

  /// Biarkan user memilih lokasi penyimpanan untuk [bytes] PNG.
  /// [suggestedName] adalah nama file default (tanpa path).
  /// Return true jika berhasil disimpan, false jika dibatalkan atau gagal.
  static Future<bool> saveToCustomDirectory(
    Uint8List bytes,
    String suggestedName,
  ) async {
    try {
      final selectedPath = await FilePicker.saveFile(
        dialogTitle: 'Simpan Gambar',
        fileName: suggestedName,
        type: FileType.image,
        bytes: bytes,
      );
      if (selectedPath == null) return false;
      final file = File(selectedPath);
      await file.writeAsBytes(bytes);
      return true;
    } on Object catch (e) {
      debugPrint('ShareUtils.saveToCustomDirectory error: $e');
      return false;
    }
  }

  /// Share [bytes] PNG sebagai file dengan [caption] teks.
  /// [suggestedName] digunakan untuk nama file temporary.
  /// [shareOrigin] diperlukan di iOS untuk posisi popover (opsional).
  static Future<void> sharePngBytes(
    Uint8List bytes,
    String suggestedName, {
    String caption = '',
    Rect? shareOrigin,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$suggestedName');
    await file.writeAsBytes(bytes);

    final origin = shareOrigin ?? const Rect.fromLTWH(0, 100, 100, 100);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: caption,
      sharePositionOrigin: origin,
    );
  }
}
