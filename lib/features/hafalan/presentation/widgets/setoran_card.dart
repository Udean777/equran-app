import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

/// Kartu ayat untuk mode setoran hafalan.
///
/// Menampilkan teks Arab, terjemahan toggle, dan progress bar.
class SetoranCard extends StatelessWidget {
  const SetoranCard({
    required this.ayat,
    required this.currentIndex,
    required this.totalAyat,
    required this.showTerjemahan,
    required this.onToggleTerjemahan,
    required this.onHafal,
    required this.onBelumHafal,
    super.key,
  });

  final Ayat ayat;
  final int currentIndex;
  final int totalAyat;
  final bool showTerjemahan;
  final VoidCallback onToggleTerjemahan;
  final VoidCallback onHafal;
  final VoidCallback onBelumHafal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Progress bar atas
        LinearProgressIndicator(
          value: (currentIndex + 1) / totalAyat,
          minHeight: 4,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Label ayat
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMD,
                      vertical: AppDimens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusFull,
                      ),
                    ),
                    child: Text(
                      'Ayat ${ayat.nomorAyat} dari $totalAyat',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceXL),

                // Teks Arab
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    ayat.teksArab,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'KFGQPC',
                      fontSize: 28,
                      height: 2.2,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceLG),

                // Terjemahan — toggle
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: showTerjemahan
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Center(
                    child: TextButton.icon(
                      onPressed: onToggleTerjemahan,
                      icon: const Icon(Icons.visibility_rounded, size: 16),
                      label: const Text('Tampilkan Terjemahan'),
                    ),
                  ),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ayat.teksLatin,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      Text(
                        ayat.teksIndonesia,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppDimens.spaceXS),
                      Center(
                        child: TextButton.icon(
                          onPressed: onToggleTerjemahan,
                          icon: const Icon(
                            Icons.visibility_off_rounded,
                            size: 16,
                          ),
                          label: const Text('Sembunyikan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tombol jawab
        SetoranJawabButtons(onHafal: onHafal, onBelumHafal: onBelumHafal),
      ],
    );
  }
}

/// Tombol jawab hafal / belum hafal di bagian bawah setoran.
class SetoranJawabButtons extends StatelessWidget {
  const SetoranJawabButtons({
    required this.onHafal,
    required this.onBelumHafal,
    super.key,
  });

  final VoidCallback onHafal;
  final VoidCallback onBelumHafal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onBelumHafal,
              icon: const Icon(Icons.close_rounded, color: AppColors.error),
              label: const Text(
                'Belum Hafal',
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: FilledButton.icon(
              onPressed: onHafal,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Hafal'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
