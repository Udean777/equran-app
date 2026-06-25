import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_control_buttons.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_progress_bar.dart';
import 'package:equran_app/features/audio/presentation/widgets/qari_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full player page ala Spotify — dibuka via slide-up transition dari AudioPlayerBar.
class AudioPlayerPage extends ConsumerWidget {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AudioPlayerState>(audioViewModelProvider, (prev, curr) {
      if (prev != null && !prev.isIdle && curr.isIdle) {
        final vm = ref.read(audioViewModelProvider.notifier);
        if (!vm.isPlaylistMode && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    });

    final state = ref.watch(audioViewModelProvider);
    if (state.isIdle) return const SizedBox.shrink();

    final vm = ref.read(audioViewModelProvider.notifier);
    final isDark = context.isDark;
    final effectiveAudioMap = vm.lastAudioMap;

    return _AudioPlayerPageContent(
      state: state,
      vm: vm,
      isDark: isDark,
      effectiveAudioMap: effectiveAudioMap,
    );
  }
}

class _AudioPlayerPageContent extends StatelessWidget {
  const _AudioPlayerPageContent({
    required this.state,
    required this.vm,
    required this.isDark,
    required this.effectiveAudioMap,
  });

  final AudioPlayerState state;
  final AudioViewModel vm;
  final bool isDark;
  final Map<String, String> effectiveAudioMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final artworkSize = (screenWidth * 0.72).clamp(0.0, 300.0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header — chevron down
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceSM,
                AppDimens.spaceSM,
                AppDimens.spaceSM,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.textPrimary,
                      size: 32,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Tutup',
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Artwork
            Container(
              width: artworkSize,
              height: artworkSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.4 : 0.15,
                    ),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/icons/app_icon.png',
                fit: BoxFit.cover,
              ),
            ),

            const Spacer(),

            // Info — nama surat + ayat badge + qari
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              child: Row(
                children: [
                  // Nama surat + qari
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (vm.isPlaylistMode && vm.playlistSuratName != null)
                          Text(
                            vm.playlistSuratName!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isDark
                                  ? AppColors.onSurfaceDark
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: AppDimens.spaceXS),
                        // Qari selector
                        GestureDetector(
                          onTap: () => _showQariSelector(context, state),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  state.currentQari.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
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
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ayat badge
                  if (state.currentAyat != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMD,
                        vertical: AppDimens.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusFull,
                        ),
                      ),
                      child: Text(
                        'Ayat ${state.currentAyat}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Progress bar dengan label waktu
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSM,
              ),
              child: AudioProgressBar(isDark: isDark),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Control buttons — lebih besar dari mini bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (vm.isPlaylistMode)
                    AudioIconBtn(
                      icon: Icons.skip_previous_rounded,
                      iconSize: 28,
                      buttonSize: 48,
                      color: vm.playlistIndex > 0
                          ? primaryColor
                          : (isDark
                                ? AppColors.outlineDark
                                : AppColors.textDisabled),
                      onPressed: vm.playlistIndex > 0
                          ? () => unawaited(vm.previousAyat())
                          : null,
                    ),

                  AudioIconBtn(
                    icon: Icons.stop_rounded,
                    iconSize: 28,
                    buttonSize: 48,
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary,
                    onPressed: () => unawaited(vm.stop()),
                  ),

                  AudioPlayPauseButton(
                    state: state,
                    isDark: isDark,
                    size: 56,
                    iconSize: 28,
                    showLoadingIndicator: true,
                  ),

                  if (vm.isPlaylistMode)
                    AudioIconBtn(
                      icon: Icons.skip_next_rounded,
                      iconSize: 28,
                      buttonSize: 48,
                      color: vm.playlistIndex < vm.playlist.length - 1
                          ? primaryColor
                          : (isDark
                                ? AppColors.outlineDark
                                : AppColors.textDisabled),
                      onPressed: vm.playlistIndex < vm.playlist.length - 1
                          ? () => unawaited(vm.nextAyat())
                          : null,
                    ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showQariSelector(BuildContext context, AudioPlayerState state) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => QariSelectorSheet(
          selectedQari: state.currentQari,
          audioMap: effectiveAudioMap,
          onQariSelected: (qari) {
            unawaited(
              ProviderScope.containerOf(context)
                  .read(audioViewModelProvider.notifier)
                  .changeQari(
                    qari: qari,
                    audioMap: effectiveAudioMap,
                  ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
