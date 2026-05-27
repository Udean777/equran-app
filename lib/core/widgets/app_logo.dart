import 'package:flutter/material.dart';

/// Widget kustom untuk memanggil ikon aplikasi eQuran.
///
/// Menyediakan optimasi otomatis pemanggilan gambar lewat pembatasan ukuran decoding (`cacheWidth` & `cacheHeight`)
/// agar RAM tidak terbebani oleh file resolusi tinggi, serta menyediakan fungsi `precache` statis.
class AppLogo extends StatelessWidget {
  const AppLogo({
    required this.size,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.border,
    this.boxShadow,
    super.key,
  });

  /// Dimensi gambar (lebar & tinggi).
  final double size;

  /// Bentuk kliping logo (lingkaran atau persegi panjang).
  final BoxShape shape;

  /// Radius sudut jika menggunakan bentuk kotak.
  final BorderRadiusGeometry? borderRadius;

  /// Garis tepi tambahan di sekeliling logo.
  final BoxBorder? border;

  /// Efek bayangan mewah.
  final List<BoxShadow>? boxShadow;

  /// Jalur aset ikon aplikasi eQuran.
  static const String assetPath = 'assets/icons/app_icon.png';

  /// Melakukan pra-pemuatan gambar ke memori cache Flutter agar tampil instan saat pertama dipanggil.
  static Future<void> precache(BuildContext context) {
    return precacheImage(
      const AssetImage(assetPath),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    // OPTIMASI:
    // Gunakan cacheWidth / cacheHeight berdasarkan device pixel ratio agar Flutter mendekode gambar
    // sesuai ukuran render riil di layar, bukan resolusi asli file mentahnya.
    // Hal ini secara signifikan memangkas pemakaian RAM.
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheSize = (size * devicePixelRatio).round();

    final imageWidget = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      cacheWidth: cacheSize,
      cacheHeight: cacheSize,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        border: border,
        boxShadow: boxShadow,
      ),
      child: shape == BoxShape.circle
          ? ClipOval(child: imageWidget)
          : ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: imageWidget,
            ),
    );
  }
}
