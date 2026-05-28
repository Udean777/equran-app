import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/utils/share_ayat_service.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/theme/share_templates_theme.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_share_card.dart';
import 'package:flutter/material.dart';

class ShareAyatPage extends StatefulWidget {
  const ShareAyatPage({
    required this.ayat,
    required this.namaLatin,
    required this.suratNomor,
    super.key,
  });

  final Ayat ayat;
  final String namaLatin;
  final int suratNomor;

  @override
  State<ShareAyatPage> createState() => _ShareAyatPageState();
}

class _ShareAyatPageState extends State<ShareAyatPage> {
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _shareImageButtonKey = GlobalKey();
  bool _isGenerating = false;
  bool _isSaving = false;
  ShareTemplateStyle _selectedStyle = ShareTemplateStyle.classicEmerald;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;
    final textPrimary = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final textTertiary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          color: textPrimary,
          iconSize: 20,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bagikan Ayat',
              style: AppTypography.serifHeadingSmall.copyWith(
                color: textPrimary,
                fontSize: 18,
              ),
            ),
            Text(
              'Q.S. ${widget.namaLatin} : ${widget.ayat.nomorAyat}',
              style: TextStyle(
                color: textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceLG),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              child: RepaintBoundary(
                key: _cardKey,
                child: AyatShareCard(
                  ayat: widget.ayat,
                  namaLatin: widget.namaLatin,
                  suratNomor: widget.suratNomor,
                  style: _selectedStyle,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(
            top: BorderSide(color: borderColor),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(
          0,
          AppDimens.spaceMD,
          0,
          AppDimens.spaceLG,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template Selector Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.pagePadding,
                ),
                child: Text(
                  'PILIH DESAIN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textTertiary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceSM),

              // Template Selector Slider
              SizedBox(
                height: 80,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.pagePadding,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: ShareTemplateStyle.values.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppDimens.spaceMD),
                  itemBuilder: (context, index) {
                    final style = ShareTemplateStyle.values[index];
                    final isSelected = _selectedStyle == style;
                    return _buildTemplateSelectorItem(
                      style,
                      isSelected,
                      isDark,
                    );
                  },
                ),
              ),

              const SizedBox(height: AppDimens.spaceMD),
              Divider(color: borderColor, height: 1),
              const SizedBox(height: AppDimens.spaceMD),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.pagePadding,
                ),
                child: Row(
                  children: [
                    // Button 1: Bagikan (FilledButton, 50% width)
                    Expanded(
                      child: FilledButton.icon(
                        key: _shareImageButtonKey,
                        onPressed: (_isGenerating || _isSaving)
                            ? null
                            : _shareImage,
                        icon: _isGenerating
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Icon(Icons.share_rounded, size: 16),
                        label: Text(
                          _isGenerating ? 'Membuat...' : 'Bagikan',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
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

                    // Button 2: Simpan (OutlinedButton, 50% width)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: (_isGenerating || _isSaving)
                            ? null
                            : _showSaveOptionsSheet,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark
                              ? AppColors.primaryLighter
                              : AppColors.primary,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareImage() async {
    setState(() => _isGenerating = true);
    try {
      await ShareAyatService.shareImage(
        cardKey: _cardKey,
        ayat: widget.ayat,
        namaLatin: widget.namaLatin,
        suratNomor: widget.suratNomor,
        shareButtonKey: _shareImageButtonKey,
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  void _showSaveOptionsSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final textPrimary = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textSecondary;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
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
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusFull,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMD),
                  Text(
                    'Pilih Lokasi Penyimpanan',
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLG),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                      ),
                      child: Icon(
                        Icons.photo_library_rounded,
                        color: isDark
                            ? AppColors.primaryLighter
                            : AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Simpan ke Galeri / Foto',
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Menyimpan gambar langsung ke album foto perangkat Anda',
                      style: TextStyle(color: textSecondary, fontSize: 11),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _saveImage(toGallery: true);
                    },
                  ),
                  Divider(color: borderColor, height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                      ),
                      child: Icon(
                        Icons.folder_open_rounded,
                        color: isDark
                            ? AppColors.primaryLighter
                            : AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Simpan ke Folder Kustom (File)',
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Pilih lokasi penyimpanan kustom sendiri di memori perangkat',
                      style: TextStyle(color: textSecondary, fontSize: 11),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _saveImage(toGallery: false);
                    },
                  ),
                  const SizedBox(height: AppDimens.spaceLG),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveImage({required bool toGallery}) async {
    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bool success;
      if (toGallery) {
        success = await ShareAyatService.saveToGallery(
          cardKey: _cardKey,
          suratNomor: widget.suratNomor,
          nomorAyat: widget.ayat.nomorAyat,
        );
      } else {
        success = await ShareAyatService.saveToCustomDirectory(
          cardKey: _cardKey,
          suratNomor: widget.suratNomor,
          nomorAyat: widget.ayat.nomorAyat,
        );
      }

      if (mounted) {
        final message = toGallery
            ? (success ? 'Gambar disimpan ke galeri' : 'Gagal menyimpan gambar')
            : (success
                  ? 'Gambar berhasil disimpan ke lokasi pilihan'
                  : 'Penyimpanan gambar dibatalkan');

        final bgColor = success
            ? AppColors.primary
            : (toGallery ? AppColors.error : AppColors.outlineDark);

        messenger.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: bgColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on Object catch (e) {
      debugPrint('_saveImage error: $e');
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

  Widget _buildTemplateSelectorItem(
    ShareTemplateStyle style,
    bool isSelected,
    bool isDark,
  ) {
    final textTertiary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;
    final textPrimary = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStyle = style;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: style.backgroundColors,
                stops: style.stops,
              ),
              border: isSelected
                  ? Border.all(
                      color: AppColors.gold,
                      width: 2.5,
                    )
                  : Border.all(
                      color: isDark ? AppColors.outlineDark : AppColors.outline,
                    ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            style.displayName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? textPrimary : textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
