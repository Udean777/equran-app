import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/utils/share_ayat_service.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_share_card.dart';
import 'package:flutter/material.dart';

class ShareAyatSheet extends StatefulWidget {
  const ShareAyatSheet({
    required this.ayat,
    required this.namaLatin,
    required this.suratNomor,
    super.key,
  });

  final Ayat ayat;
  final String namaLatin;
  final int suratNomor;

  @override
  State<ShareAyatSheet> createState() => _ShareAyatSheetState();
}

class _ShareAyatSheetState extends State<ShareAyatSheet> {
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _shareImageButtonKey = GlobalKey();
  bool _isGenerating = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;
    final textPrimary = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final textTertiary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXL),
        ),
        border: Border(
          top: BorderSide(color: borderColor),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.spaceMD),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.outlineDark
                      : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                    ),
                    child: Icon(
                      Icons.share_rounded,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceMD),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bagikan Ayat',
                        style: AppTypography.serifHeadingSmall.copyWith(
                          color: textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Q.S. ${widget.namaLatin} : ${widget.ayat.nomorAyat}',
                        style: TextStyle(
                          color: textTertiary,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceLG),

            // Card preview
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              child: RepaintBoundary(
                key: _cardKey,
                child: AyatShareCard(
                  ayat: widget.ayat,
                  namaLatin: widget.namaLatin,
                  suratNomor: widget.suratNomor,
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceLG),

            // Action buttons — 3 tombol: Teks | Simpan | Bagikan
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                0,
                AppDimens.pagePadding,
                AppDimens.spaceMD,
              ),
              child: Column(
                children: [
                  // Row 1: Teks + Simpan ke Galeri
                  Row(
                    children: [
                      // Share teks
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: (_isGenerating || _isSaving)
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  unawaited(
                                    ShareAyatService.shareText(
                                      ayat: widget.ayat,
                                      namaLatin: widget.namaLatin,
                                      suratNomor: widget.suratNomor,
                                    ),
                                  );
                                },
                          icon: Icon(
                            Icons.text_snippet_outlined,
                            size: 16,
                            color: isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary,
                          ),
                          label: Text(
                            'Teks',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusMD,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: AppDimens.spaceSM),

                      // Simpan ke galeri
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: (_isGenerating || _isSaving)
                              ? null
                              : _saveToGallery,
                          icon: _isSaving
                              ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDark
                                        ? AppColors.primaryLighter
                                        : AppColors.primary,
                                  ),
                                )
                              : Icon(
                                  Icons.download_rounded,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.primaryLighter
                                      : AppColors.primary,
                                ),
                          label: Text(
                            _isSaving ? 'Menyimpan...' : 'Simpan',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusMD,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceSM),

                  // Row 2: Bagikan Gambar (full width)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: _shareImageButtonKey,
                      onPressed: (_isGenerating || _isSaving)
                          ? null
                          : _shareImage,
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : const Icon(Icons.share_rounded, size: 18),
                      label: Text(
                        _isGenerating ? 'Membuat gambar...' : 'Bagikan Gambar',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.primaryLight
                            : AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMD,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareImage() async {
    setState(() => _isGenerating = true);
    try {
      await ShareAyatService.shareImage(
        cardKey: _cardKey,
        namaLatin: widget.namaLatin,
        suratNomor: widget.suratNomor,
        nomorAyat: widget.ayat.nomorAyat,
        shareButtonKey: _shareImageButtonKey,
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);
    // Simpan messenger sebelum async agar tidak crash jika context sudah invalid
    final messenger = ScaffoldMessenger.of(context);
    try {
      final success = await ShareAyatService.saveToGallery(
        cardKey: _cardKey,
        suratNomor: widget.suratNomor,
        nomorAyat: widget.ayat.nomorAyat,
      );
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Gambar disimpan ke galeri' : 'Gagal menyimpan gambar',
            ),
            backgroundColor: success ? AppColors.primary : AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on Object catch (e) {
      debugPrint('_saveToGallery error: $e');
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan gambar'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
