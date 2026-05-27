import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_control_buttons.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_page.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_progress_bar.dart';
import 'package:equran_app/features/audio/presentation/widgets/qari_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlayerBar extends StatelessWidget {
  const AudioPlayerBar({
    this.audioMap = const {},
    this.onPrevCard,
    this.onNextCard,
    this.onStop,
    super.key,
  });

  /// Map qari id → audio URL dari response API.
  /// Jika kosong, fallback ke [AudioCubit.lastAudioMap].
  final Map<String, String> audioMap;

  /// Callback saat tombol prev di-tap — swipe card ke sebelumnya.
  final VoidCallback? onPrevCard;

  /// Callback saat tombol next di-tap — swipe card ke berikutnya.
  final VoidCallback? onNextCard;

  /// Callback saat tombol stop di-tap — override default stop behavior.
  /// Jika null, pakai [AudioCubit.stop()] langsung.
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioPlayerState>(
      buildWhen: (prev, curr) =>
          prev.isIdle != curr.isIdle ||
          prev.currentAyat != curr.currentAyat ||
          prev.currentQari != curr.currentQari ||
          prev.isPlaying != curr.isPlaying ||
          prev.isPaused != curr.isPaused ||
          prev.isLoading != curr.isLoading,
      builder: (context, state) {
        if (state.isIdle) return const SizedBox.shrink();

        final cubit = context.read<AudioCubit>();
        final effectiveAudioMap =
            audioMap.isNotEmpty ? audioMap : cubit.lastAudioMap;
        final isPlaylist = cubit.isPlaylistMode;
        final suratName = cubit.playlistSuratName;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return _AudioPlayerBarContent(
          state: state,
          cubit: cubit,
          effectiveAudioMap: effectiveAudioMap,
          isPlaylist: isPlaylist,
          suratName: suratName,
          isDark: isDark,
          onPrevCard: onPrevCard,
          onNextCard: onNextCard,
          onStop: onStop,
        );
      },
    );
  }
}

class _AudioPlayerBarContent extends StatelessWidget {
  const _AudioPlayerBarContent({
    required this.state,
    required this.cubit,
    required this.effectiveAudioMap,
    required this.isPlaylist,
    required this.suratName,
    required this.isDark,
    this.onPrevCard,
    this.onNextCard,
    this.onStop,
  });

  final AudioPlayerState state;
  final AudioCubit cubit;
  final Map<String, String> effectiveAudioMap;
  final bool isPlaylist;
  final String? suratName;
  final bool isDark;
  final VoidCallback? onPrevCard;
  final VoidCallback? onNextCard;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar tipis — tanpa label waktu
          AudioProgressBar(isDark: isDark, showLabels: false),

          // Main row — artwork + info + controls + chevron up
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMD,
              0,
              AppDimens.spaceXS,
              AppDimens.spaceSM,
            ),
            child: Row(
              children: [
                // Artwork — app icon dalam rounded square
                GestureDetector(
                  onTap: () => _openFullPlayer(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusSM),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: AppDimens.spaceMD),

                // Info — nama surat + qari
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openFullPlayer(context),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nama surat atau "Ayat X"
                        Text(
                          isPlaylist && suratName != null
                              ? suratName!
                              : (state.currentAyat != null
                                    ? 'Ayat ${state.currentAyat}'
                                    : ''),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Qari selector
                        GestureDetector(
                          onTap: () => _showQariSelector(
                            context,
                            state,
                            effectiveAudioMap,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  state.currentQari.name,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isDark
                                        ? AppColors.onSurfaceDarkVariant
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: isDark
                                    ? AppColors.onSurfaceDarkVariant
                                    : AppColors.textTertiary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Controls
                if (isPlaylist)
                  AudioIconBtn(
                    icon: Icons.skip_previous_rounded,
                    color: (onPrevCard != null || cubit.playlistIndex > 0)
                        ? primaryColor
                        : (isDark
                              ? AppColors.outlineDark
                              : AppColors.textDisabled),
                    onPressed: onPrevCard ??
                        (cubit.playlistIndex > 0
                            ? () => unawaited(cubit.previousAyat())
                            : null),
                  ),

                AudioIconBtn(
                  icon: Icons.stop_rounded,
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textSecondary,
                  onPressed: onStop ?? () => unawaited(cubit.stop()),
                ),

                AudioPlayPauseButton(
                  state: state,
                  isDark: isDark,
                ),

                if (isPlaylist)
                  AudioIconBtn(
                    icon: Icons.skip_next_rounded,
                    color: (onNextCard != null ||
                            cubit.playlistIndex < cubit.playlist.length - 1)
                        ? primaryColor
                        : (isDark
                              ? AppColors.outlineDark
                              : AppColors.textDisabled),
                    onPressed: onNextCard ??
                        (cubit.playlistIndex < cubit.playlist.length - 1
                            ? () => unawaited(cubit.nextAyat())
                            : null),
                  ),

                // Chevron up — buka full player
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary,
                    size: 24,
                  ),
                  onPressed: () => _openFullPlayer(context),
                  padding: const EdgeInsets.all(AppDimens.spaceXS),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  tooltip: 'Buka player',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFullPlayer(BuildContext context) {
    unawaited(
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          pageBuilder: (_, animation, _) => BlocProvider.value(
            value: context.read<AudioCubit>(),
            child: const AudioPlayerPage(),
          ),
          transitionsBuilder: (_, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
    );
  }

  void _showQariSelector(
    BuildContext context,
    AudioPlayerState state,
    Map<String, String> audioMap,
  ) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => QariSelectorSheet(
          selectedQari: state.currentQari,
          audioMap: audioMap,
          onQariSelected: (qari) {
            unawaited(
              context.read<AudioCubit>().changeQari(
                qari: qari,
                audioMap: audioMap,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
