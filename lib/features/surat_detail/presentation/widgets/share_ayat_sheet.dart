import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMD,
          AppDimens.spaceMD,
          AppDimens.spaceMD,
          AppDimens.spaceLG,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Judul
            Text(
              'Bagikan Ayat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceLG),

            // Preview kartu — dibungkus RepaintBoundary untuk capture
            Center(
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

            // Tombol share teks
            OutlinedButton.icon(
              onPressed: _isGenerating
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
              icon: const Icon(Icons.text_snippet_outlined),
              label: const Text('Bagikan Teks'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: AppDimens.spaceSM),

            // Tombol share gambar
            FilledButton.icon(
              onPressed: _isGenerating ? null : _shareImage,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : const Icon(Icons.image_outlined),
              label: Text(
                _isGenerating ? 'Membuat gambar...' : 'Bagikan Gambar',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
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
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
    if (mounted) Navigator.pop(context);
  }
}
