import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_control_buttons.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_page.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_progress_bar.dart';
import 'package:equran_app/features/audio/presentation/widgets/qari_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerBar extends ConsumerWidget {
  const AudioPlayerBar({
    this.audioMap = const {},
    this.onPrevCard,
    this.onNextCard,
    this.onStop,
    super.key,
  });

  final Map<String, String> audioMap;

  final VoidCallback? onPrevCard;

  final VoidCallback? onNextCard;

  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioViewModelProvider);
    if (state.isIdle) return const SizedBox.shrink();

    final vm = ref.read(audioViewModelProvider.notifier);
    final effectiveAudioMap = audioMap.isNotEmpty ? audioMap : vm.lastAudioMap;
    final isPlaylist = vm.isPlaylistMode;
    final suratName = vm.playlistSuratName;
    final isDark = context.isDark;

    return _AudioPlayerBarContent(
      state: state,
      vm: vm,
      effectiveAudioMap: effectiveAudioMap,
      isPlaylist: isPlaylist,
      suratName: suratName,
      isDark: isDark,
      onPrevCard: onPrevCard,
      onNextCard: onNextCard,
      onStop: onStop,
    );
  }
}

class _AudioPlayerBarContent extends StatelessWidget {
  const _AudioPlayerBarContent({
    required this.state,
    required this.vm,
    required this.effectiveAudioMap,
    required this.isPlaylist,
    required this.suratName,
    required this.isDark,
    this.onPrevCard,
    this.onNextCard,
    this.onStop,
  });

  final AudioPlayerState state;
  final AudioViewModel vm;
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
                      borderRadius: BorderRadius.circular(AppDimens.radiusSM),
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
                    color: (onPrevCard != null || vm.playlistIndex > 0)
                        ? primaryColor
                        : (isDark
                              ? AppColors.outlineDark
                              : AppColors.textDisabled),
                    onPressed:
                        onPrevCard ??
                        (vm.playlistIndex > 0
                            ? () => unawaited(vm.previousAyat())
                            : null),
                  ),

                AudioIconBtn(
                  icon: Icons.stop_rounded,
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textSecondary,
                  onPressed: onStop ?? () => unawaited(vm.stop()),
                ),

                AudioPlayPauseButton(
                  state: state,
                  isDark: isDark,
                ),

                if (isPlaylist)
                  AudioIconBtn(
                    icon: Icons.skip_next_rounded,
                    color:
                        (onNextCard != null ||
                            vm.playlistIndex < vm.playlist.length - 1)
                        ? primaryColor
                        : (isDark
                              ? AppColors.outlineDark
                              : AppColors.textDisabled),
                    onPressed:
                        onNextCard ??
                        (vm.playlistIndex < vm.playlist.length - 1
                            ? () => unawaited(vm.nextAyat())
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
          pageBuilder: (_, animation, _) => const AudioPlayerPage(),
          transitionsBuilder: (_, animation, _, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
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
              ProviderScope.containerOf(context)
                  .read(audioViewModelProvider.notifier)
                  .changeQari(
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
