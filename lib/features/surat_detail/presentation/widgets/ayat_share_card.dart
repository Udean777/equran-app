import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

/// Widget yang di-render menjadi gambar untuk dibagikan.
/// Dibungkus [RepaintBoundary] oleh parent (ShareAyatSheet).
class AyatShareCard extends StatelessWidget {
  const AyatShareCard({
    required this.ayat,
    required this.namaLatin,
    required this.suratNomor,
    super.key,
  });

  final Ayat ayat;
  final String namaLatin;
  final int suratNomor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo + nama app
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: AppColors.onPrimary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'eQuran',
                style: TextStyle(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Teks Arab
          Text(
            ayat.teksArab,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'KFGQPC',
              fontSize: 28,
              color: AppColors.onPrimary,
              height: 2,
            ),
          ),
          const SizedBox(height: 20),

          // Divider
          Divider(
            color: AppColors.onPrimary.withValues(alpha: 0.3),
            thickness: 1,
          ),
          const SizedBox(height: 16),

          // Teks terjemahan
          Text(
            ayat.teksIndonesia,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onPrimary.withValues(alpha: 0.85),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),

          // Sumber
          Text(
            'Q.S. $namaLatin ($suratNomor): ${ayat.nomorAyat}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onPrimary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
