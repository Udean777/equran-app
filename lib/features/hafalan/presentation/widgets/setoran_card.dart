import 'dart:async';
import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum SetoranRecordState { idle, recording, comparing }

/// Kartu ayat untuk mode setoran hafalan.
class SetoranCard extends StatelessWidget {
  const SetoranCard({
    required this.ayat,
    required this.currentIndex,
    required this.totalAyat,
    required this.showTerjemahan,
    required this.onToggleTerjemahan,
    required this.recordState,
    required this.onStartRecord,
    required this.onStopRecord,
    required this.onNextAyat,
    this.compareResult,
    this.userAudioPath,
    super.key,
  });

  final Ayat ayat;
  final int currentIndex;
  final int totalAyat;
  final bool showTerjemahan;
  final VoidCallback onToggleTerjemahan;

  /// State perekaman untuk ayat ini.
  final SetoranRecordState recordState;

  /// Hasil AI comparison (null sebelum selesai).
  final SetoranCompareResult? compareResult;

  final VoidCallback onStartRecord;
  final VoidCallback onStopRecord;
  final VoidCallback onNextAyat;
  final String? userAudioPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Column(
      children: [
        // Progress bar atas — gold
        LinearProgressIndicator(
          value: (currentIndex + 1) / totalAyat,
          minHeight: 3,
          backgroundColor: isDark
              ? AppColors.outlineDark
              : AppColors.outlineVariant,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),

        Expanded(
          child: ColoredBox(
            color: bgColor,
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
                        color: isDark
                            ? AppColors.surfaceDarkVariant
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusFull,
                        ),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(
                        'Ayat ${ayat.nomorAyat}  ·  ${currentIndex + 1} / $totalAyat',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // Card teks Arab
                  Container(
                    padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(AppDimens.radiusXL),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.04 : 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Gold ornamen atas
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.goldDark,
                                AppColors.gold,
                                AppColors.goldDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusFull,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLG),

                        // Teks Arab
                        Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Text(
                            ayat.teksArab,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 30,
                              height: 2.2,
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppDimens.spaceLG),
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.goldDark,
                                AppColors.gold,
                                AppColors.goldDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusFull,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // Terjemahan toggle
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: showTerjemahan
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Center(
                      child: OutlinedButton.icon(
                        onPressed: onToggleTerjemahan,
                        icon: Icon(
                          Icons.visibility_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textSecondary,
                        ),
                        label: Text(
                          'Tampilkan Terjemahan',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.onSurfaceDarkVariant
                                : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusFull,
                            ),
                          ),
                        ),
                      ),
                    ),
                    secondChild: Container(
                      padding: const EdgeInsets.all(AppDimens.cardPadding),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDarkVariant
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            ayat.teksIndonesia,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.onSurfaceDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceSM),
                          Center(
                            child: TextButton.icon(
                              onPressed: onToggleTerjemahan,
                              icon: Icon(
                                Icons.visibility_off_rounded,
                                size: 14,
                                color: isDark
                                    ? AppColors.onSurfaceDarkVariant
                                    : AppColors.textTertiary,
                              ),
                              label: Text(
                                'Sembunyikan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.onSurfaceDarkVariant
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Recording / Answer area
        _buildBottomArea(theme: theme, isDark: isDark),
      ],
    );
  }

  Widget _buildBottomArea({
    required ThemeData theme,
    required bool isDark,
  }) {
    if (compareResult != null) {
      return _buildResultArea(theme: theme, isDark: isDark);
    }

    switch (recordState) {
      case SetoranRecordState.idle:
        return _buildIdleArea(isDark: isDark);
      case SetoranRecordState.recording:
        return _buildRecordingArea(isDark: isDark);
      case SetoranRecordState.comparing:
        return _buildComparingArea(isDark: isDark);
    }
  }

  Widget _buildIdleArea({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStartRecord,
              icon: const Icon(Icons.mic_rounded, size: 20),
              label: const Text('Rekam Bacaan'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingArea({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fiber_manual_record_rounded,
                color: Colors.red,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Merekam...',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStopRecord,
              icon: const Icon(Icons.stop_rounded, size: 20),
              label: const Text('Berhenti Rekam'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparingArea({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          SizedBox(height: AppDimens.spaceSM),
          Text(
            'Membandingkan bacaan...',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResultArea({
    required ThemeData theme,
    required bool isDark,
  }) {
    final result = compareResult!;
    final scoreColor = result.passed ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${result.score.toStringAsFixed(0)}%',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Icon(
                result.passed
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: scoreColor,
                size: 28,
              ),
            ],
          ),
          if (!result.passed && result.wordErrors.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceSM),
            Text(
              'Kata yang tidak cocok:',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXS),
            ...result.wordErrors
                .take(3)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      '${e.position + 1}. Diharapkan: "${e.expected}" → Terbaca: "${e.actual}"',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
          ],
          const SizedBox(height: AppDimens.spaceMD),
          const SizedBox(height: AppDimens.spaceMD),
          if (userAudioPath != null && ayat.audio.isNotEmpty) ...[
            _MiniAudioPlayer(
              title: 'Audio Anda',
              audioSource: userAudioPath!,
              isLocal: true,
            ),
            const SizedBox(height: AppDimens.spaceSM),
            _MiniAudioPlayer(
              title: 'Audio Ayat',
              audioSource: ayat.audio.values.first,
              isLocal: false,
            ),
            const SizedBox(height: AppDimens.spaceMD),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onStartRecord,
                  icon: const Icon(Icons.replay_rounded, size: 18),
                  label: const Text('Rekam Ulang'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceSM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onNextAyat,
                  icon: const Icon(Icons.skip_next_rounded, size: 18),
                  label: Text(
                    currentIndex < totalAyat - 1
                        ? 'Ayat Berikutnya'
                        : 'Selesai',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceSM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniAudioPlayer extends StatefulWidget {
  const _MiniAudioPlayer({
    required this.title,
    required this.audioSource,
    required this.isLocal,
  });

  final String title;
  final String audioSource;
  final bool isLocal;

  @override
  State<_MiniAudioPlayer> createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<_MiniAudioPlayer> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initPlayer());
  }

  Future<void> _initPlayer() async {
    try {
      if (widget.isLocal) {
        await _player.setFilePath(widget.audioSource);
      } else {
        await _player.setUrl(widget.audioSource);
      }

      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            if (state.processingState == ProcessingState.completed) {
              _isPlaying = false;
              unawaited(_player.seek(Duration.zero));
              unawaited(_player.pause());
            }
          });
        }
      });
    } on Object catch (_) {
      if (mounted) {
        setState(() => _isError = true);
      }
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  void _togglePlay() {
    if (_isError) return;
    if (_isPlaying) {
      unawaited(_player.pause());
    } else {
      unawaited(_player.play());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _togglePlay,
            icon: Icon(
              _isError
                  ? Icons.error_outline_rounded
                  : _isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
            ),
            color: _isError ? AppColors.error : AppColors.primary,
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
