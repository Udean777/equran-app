import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/theme/share_templates_theme.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_share_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/save_options_sheet.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/share_ayat_action_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/template_selector.dart';
import 'package:equran_app/features/surat_detail/utils/share_ayat_service.dart';
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
    final isDark = context.isDark;
    final bgColor = context.scaffoldBackgroundColor;
    final textPrimary = context.textPrimaryColor;
    final textTertiary = context.textTertiaryColor;

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
          color: context.surfaceColor,
          border: Border(
            top: BorderSide(color: context.borderVariantColor),
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.pagePadding,
                ),
                child: TemplateSelector(
                  selectedStyle: _selectedStyle,
                  onTemplateChanged: (style) {
                    setState(() => _selectedStyle = style);
                  },
                ),
              ),
              const SizedBox(height: AppDimens.spaceMD),
              Divider(color: context.borderVariantColor, height: 1),
              const SizedBox(height: AppDimens.spaceMD),
              ShareAyatActionBar(
                onShare: _shareImage,
                onSaveToGallery: _showSaveOptionsSheet,
                isGenerating: _isGenerating,
                isSaving: _isSaving,
                shareButtonKey: _shareImageButtonKey,
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
    unawaited(
      SaveOptionsSheet.show(
        context: context,
        onGallerySave: () => _saveImage(toGallery: true),
        onCustomDirectorySave: () => _saveImage(toGallery: false),
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
}
