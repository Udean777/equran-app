import 'dart:async';

import 'package:equran_app/core/constants/card_swipe_config.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/auto_read_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/ayat_swipe_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_completion_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_app_bar.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_info_card.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/swipe_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Scaffold utama SuratDetailPage — card stack Tinder-style per ayat.
class SuratDetailCardView extends StatefulWidget {
  const SuratDetailCardView({
    required this.detail,
    required this.controller,
    required this.onToggleAutoScroll,
    required this.autoScrollEnabled,
    required this.suratNomor,
    super.key,
  });

  final SuratDetail detail;
  final CardStackController controller;
  final VoidCallback onToggleAutoScroll;
  final bool autoScrollEnabled;
  final int suratNomor;

  @override
  State<SuratDetailCardView> createState() => _SuratDetailCardViewState();
}

class _SuratDetailCardViewState extends State<SuratDetailCardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _snapAnimation;
  late AutoReadController _autoReadController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _snapAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    widget.controller.addListener(_onControllerChanged);

    // AutoReadController dibuat di initState — AudioCubit sudah tersedia via context
    // karena initState dipanggil setelah widget tree terbentuk.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _autoReadController = AutoReadController(
        audioCubit: context.read<AudioCubit>(),
        cardController: widget.controller,
      );
      _autoReadController.addListener(_onAutoReadChanged);
      _isAutoReadControllerInitialized = true;

      // Sync card ke audio aktif saat page pertama kali mount.
      // Kasus: user tap LastReadCard dari luar saat audio playlist masih berjalan
      // untuk surat yang sama — card harus langsung ke ayat audio terkini.
      final audioCubit = context.read<AudioCubit>();
      if (!audioCubit.isPlaylistMode) return;
      if (audioCubit.playlistSuratNomor != widget.suratNomor) return;

      final currentAyat = audioCubit.state.currentAyat;
      if (currentAyat == null) return;

      // Jump langsung tanpa animasi — ini initial sync, bukan advance
      if (widget.controller.currentIndex != currentAyat) {
        widget.controller.jumpTo(currentAyat);
      }

      // Aktifkan auto-read mode agar BlocListener mulai sync selanjutnya
      _autoReadController.activateWithoutPlay(
        onCompleted: () {
          if (!mounted) return;
          _animateToIndex(widget.controller.totalCards - 1);
        },
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    widget.controller.removeListener(_onControllerChanged);
    // AutoReadController mungkin belum diinisialisasi jika addPostFrameCallback
    // belum dipanggil saat dispose (edge case unmount sangat cepat).
    if (_isAutoReadControllerInitialized) {
      _autoReadController
        ..removeListener(_onAutoReadChanged)
        ..dispose();
    }
    super.dispose();
  }

  // Guard untuk edge case dispose sebelum postFrameCallback
  bool _isAutoReadControllerInitialized = false;

  void _onAutoReadChanged() {
    if (mounted) setState(() {});
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    var newOffset = widget.controller.dragOffset + details.delta.dx;

    // Begitu juga pada info card, berarti dia gabisa swipe ke kanan, karna gaada card sebelum dia
    if (widget.controller.isFirst && newOffset > 0) {
      newOffset = 0;
    }

    // Dan jika sudah mentok di card selesai membaca (completion card), berarti gabisa di swipe lagi ke kiri
    if (widget.controller.isLast && newOffset < 0) {
      // Kita beri rubber band effect (resistance) agar kerasa mental/mentok, batas max -60
      newOffset = (widget.controller.dragOffset + details.delta.dx * 0.2).clamp(
        -60.0,
        0.0,
      );
    }

    widget.controller.updateDrag(newOffset);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.primaryVelocity ?? 0;
    final offset = widget.controller.dragOffset;

    // Threshold: 30% layar atau velocity > 500
    final ratio = offset / screenWidth;

    if (ratio < -CardSwipeConfig.swipeThreshold ||
        velocity < -CardSwipeConfig.velocityThreshold) {
      // Halaman selanjutnya (jika ada)
      if (!widget.controller.isLast) {
        // Matikan auto-read jika user swipe manual
        if (_isAutoReadControllerInitialized && _autoReadController.isActive) {
          _stopAutoRead();
        }
        _animateOut(toLeft: true);
      } else {
        _snapBack();
      }
    } else if (ratio > CardSwipeConfig.swipeThreshold ||
        velocity > CardSwipeConfig.velocityThreshold) {
      // Halaman sebelumnya (jika ada)
      if (!widget.controller.isFirst) {
        // Matikan auto-read jika user swipe manual
        if (_isAutoReadControllerInitialized && _autoReadController.isActive) {
          _stopAutoRead();
        }
        _animateOut(toLeft: false);
      } else {
        _snapBack();
      }
    } else {
      _snapBack();
    }
  }

  void _animateOut({required bool toLeft}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final step = screenWidth - AppDimens.pagePadding;
    final target = toLeft ? -step : step;

    _isAnimating = true;
    _snapAnimation =
        Tween<double>(
          begin: widget.controller.dragOffset,
          end: target,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.reset();
    unawaited(
      _animController.forward().then((_) {
        _isAnimating = false;
        if (toLeft) {
          widget.controller.goNext();
        } else {
          widget.controller.goPrev();
        }
      }),
    );
  }

  /// Animasi tumble ke index tertentu — dipakai oleh auto-read mode.
  /// Selalu animasi ke kiri (next card).
  void _animateToIndex(int targetIndex) {
    if (_isAnimating) return;
    if (targetIndex <= widget.controller.currentIndex) return;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final step = screenWidth - AppDimens.pagePadding;

    _isAnimating = true;
    _snapAnimation =
        Tween<double>(
          begin: 0,
          end: -step,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.reset();
    unawaited(
      _animController.forward().then((_) {
        _isAnimating = false;
        widget.controller.jumpTo(targetIndex);
      }),
    );
  }

  void _snapBack() {
    _isAnimating = true;
    _snapAnimation =
        Tween<double>(
          begin: widget.controller.dragOffset,
          end: 0,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
        );

    _animController.reset();
    unawaited(
      _animController.forward().then((_) {
        _isAnimating = false;
        widget.controller.updateDrag(0);
      }),
    );
  }

  void _showSuccessDialog() {
    context.go(AppRoutes.home);
  }

  void _startAutoRead() {
    if (!_isAutoReadControllerInitialized) return;
    showSettingsToast(context, 'Mode Baca Otomatis aktif');
    _autoReadController.start(widget.detail);
  }

  void _stopAutoRead({bool showToast = true}) {
    if (!_isAutoReadControllerInitialized) return;
    if (!_autoReadController.isActive) return;
    _autoReadController.stop();
    if (showToast && mounted) {
      showSettingsToast(
        context,
        'Mode Baca Otomatis dimatikan',
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final controller = widget.controller;
    final isAutoRead =
        _isAutoReadControllerInitialized && _autoReadController.isActive;

    return BlocListener<AudioCubit, AudioPlayerState>(
      // Sync card swipe dengan audio advance saat auto-read aktif
      listenWhen: (prev, curr) =>
          isAutoRead && prev.currentAyat != curr.currentAyat,
      listener: (context, audioState) {
        if (!isAutoRead) return;

        // Sync card ke ayat yang sedang diplay dengan animasi tumble
        final currentAyat = audioState.currentAyat;
        if (currentAyat == null) return;
        final targetIndex = currentAyat; // index 1-based = ayat nomor
        if (widget.controller.currentIndex != targetIndex) {
          _animateToIndex(targetIndex);
        }

        // Buffer ayat ke reading progress saat auto-read advance
        context.read<ReadingProgressCubit>().bufferAyat(
          widget.detail.info.nomor,
          currentAyat,
        );
      },
      child: BlocBuilder<AudioCubit, AudioPlayerState>(
        buildWhen: (prev, next) =>
            prev.isPlaying != next.isPlaying ||
            prev.isPaused != next.isPaused ||
            prev.isIdle != next.isIdle ||
            prev.currentQari != next.currentQari,
        builder: (context, audioState) {
          final audioCubit = context.read<AudioCubit>();
          final isCompletionCard = controller.isLast;

          return Scaffold(
            appBar: _JuzAwareAppBar(
              detail: detail,
              controller: controller,
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Action bar — tombol berlabel untuk Hafalan, Download, Play
                _SuratActionBar(
                  detail: detail,
                  autoScrollEnabled: widget.autoScrollEnabled,
                  onToggleAutoScroll: widget.onToggleAutoScroll,
                ),
                ListenableBuilder(
                  listenable: controller,
                  builder: (_, _) => SwipeNavBar(
                    controller: controller,
                    onComplete: _showSuccessDialog,
                  ),
                ),
                // Sembunyikan AudioPlayerBar di completion card
                if (!isCompletionCard)
                  AudioPlayerBar(
                    audioMap: detail.audioFull,
                    // Stop: jika auto-read aktif, matikan mode juga
                    onStop: isAutoRead ? _stopAutoRead : null,
                    // Prev: swipe card + audio prev
                    onPrevCard:
                        audioCubit.isPlaylistMode &&
                            audioCubit.playlistIndex > 0
                        ? () {
                            unawaited(audioCubit.previousAyat());
                            controller.goPrev();
                          }
                        : null,
                    // Next: swipe card + audio next
                    onNextCard:
                        audioCubit.isPlaylistMode &&
                            audioCubit.playlistIndex <
                                audioCubit.playlist.length - 1
                        ? () {
                            unawaited(audioCubit.nextAyat());
                            controller.goNext();
                          }
                        : null,
                  ),
              ],
            ),
            body: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pagePadding,
                  AppDimens.spaceMD,
                  AppDimens.pagePadding,
                  AppDimens.spaceMD,
                ),
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) {
                    final offset = _isAnimating
                        ? _snapAnimation.value
                        : controller.dragOffset;
                    return _CardStack(
                      detail: detail,
                      controller: controller,
                      dragOffset: offset,
                      onStartAutoRead: _startAutoRead,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Surat Action Bar — tombol berlabel (Hafalan, Download)
// ---------------------------------------------------------------------------

/// Bar aksi dengan tombol pill berlabel agar user tahu fungsinya.
/// Ditempatkan di atas SwipeNavBar di dalam bottomNavigationBar.
class _SuratActionBar extends StatelessWidget {
  const _SuratActionBar({
    required this.detail,
    required this.autoScrollEnabled,
    required this.onToggleAutoScroll,
  });

  final SuratDetail detail;
  final bool autoScrollEnabled;
  final VoidCallback onToggleAutoScroll;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return BlocSelector<BookmarkCubit, BookmarkState, bool>(
      selector: (state) =>
          state.mapOrNull(
            success: (s) => s.suratProgressMap[detail.info.nomor] == 1.0,
          ) ??
          false,
      builder: (context, isCompleted) {
        return BlocBuilder<AudioDownloadCubit, AudioDownloadState>(
          builder: (context, downloadState) {
            final downloadCubit = context.read<AudioDownloadCubit>();

            return BlocBuilder<AudioCubit, AudioPlayerState>(
              buildWhen: (prev, next) => prev.currentQari != next.currentQari,
              builder: (context, audioState) {
                final audioCubit = context.read<AudioCubit>();
                final qari = audioState.currentQari;

                final isAllDownloaded = downloadState.isAllDownloaded(
                  detail.info.nomor,
                  detail.ayatList,
                  qari.id,
                );

                return Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMD,
                    vertical: AppDimens.spaceXS + 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Hafalan
                      _ActionPill(
                        icon: Icons.auto_stories_outlined,
                        label: 'Hafalan',
                        isDark: isDark,
                        onTap: () => unawaited(
                          context.push(
                            AppRoutes.hafalanSurat(detail.info.nomor),
                          ),
                        ),
                      ),

                      _ActionDivider(isDark: isDark),

                      // Download — terkunci jika belum selesai baca semua ayat
                      if (downloadState.isDownloadingSurat)
                        _DownloadingPill(
                          downloadState: downloadState,
                          onCancel: downloadCubit.cancelSuratDownload,
                          isDark: isDark,
                        )
                      else
                        _ActionPill(
                          icon: isAllDownloaded
                              ? Icons.download_done_rounded
                              : (isCompleted
                                    ? Icons.download_for_offline_outlined
                                    : Icons.lock_outline_rounded),
                          label: isAllDownloaded ? 'Terunduh' : 'Unduh Audio',
                          isDark: isDark,
                          iconColor: isAllDownloaded
                              ? AppColors.success
                              : (isCompleted
                                    ? null
                                    : (isDark
                                          ? AppColors.onSurfaceDarkVariant
                                          : AppColors.textTertiary)),
                          onTap: isAllDownloaded
                              ? null
                              : (isCompleted
                                    ? () => unawaited(
                                        context
                                            .read<AudioDownloadCubit>()
                                            .downloadSurat(
                                              suratNomor: detail.info.nomor,
                                              ayatList: detail.ayatList,
                                              qari: qari,
                                            ),
                                      )
                                    : () => showLockedToast(
                                        context,
                                        'Selesaikan membaca semua ayat terlebih dahulu untuk mengunduh surat',
                                      )),
                        ),

                      // Auto-scroll toggle — hanya muncul saat playlist aktif
                      if (audioCubit.isPlaylistMode) ...[
                        _ActionDivider(isDark: isDark),
                        _ActionPill(
                          icon: autoScrollEnabled
                              ? Icons.gps_fixed_rounded
                              : Icons.gps_not_fixed_rounded,
                          label: autoScrollEnabled ? 'Sinkron' : 'Manual',
                          isDark: isDark,
                          iconColor: autoScrollEnabled
                              ? (isDark
                                    ? AppColors.primaryLighter
                                    : AppColors.primary)
                              : null,
                          onTap: onToggleAutoScroll,
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final disabledColor = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;
    final resolvedIconColor = onTap == null
        ? disabledColor
        : (iconColor ?? primaryColor);
    final labelColor = onTap == null ? disabledColor : null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceXS,
          vertical: AppDimens.spaceXS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: resolvedIconColor),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color:
                    labelColor ??
                    (isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadingPill extends StatelessWidget {
  const _DownloadingPill({
    required this.downloadState,
    required this.onCancel,
    required this.isDark,
  });

  final AudioDownloadState downloadState;
  final VoidCallback onCancel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final progress = downloadState.suratDownloadTotal > 0
        ? downloadState.suratDownloadDone / downloadState.suratDownloadTotal
        : null;

    return GestureDetector(
      onTap: onCancel,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceXS,
          vertical: AppDimens.spaceXS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                    value: progress,
                    color: primaryColor,
                  ),
                  Icon(Icons.close, size: 9, color: primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text(
              progress != null ? '${(progress * 100).round()}%' : 'Unduh...',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  const _ActionDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: (isDark ? AppColors.outlineDark : AppColors.outlineVariant),
    );
  }
}

// ---------------------------------------------------------------------------
// Side-by-Side Horizontal Card View
// ---------------------------------------------------------------------------

class _CardStack extends StatelessWidget {
  const _CardStack({
    required this.detail,
    required this.controller,
    required this.dragOffset,
    this.onStartAutoRead,
  });

  final SuratDetail detail;
  final CardStackController controller;
  final double dragOffset;
  final VoidCallback? onStartAutoRead;

  @override
  Widget build(BuildContext context) {
    final currentIndex = controller.currentIndex;
    final totalCards = controller.totalCards;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Previous card (left)
        if (currentIndex > 0)
          _buildSideCard(context, currentIndex - 1, isLeft: true),

        // Next card (right)
        if (currentIndex < totalCards - 1)
          _buildSideCard(context, currentIndex + 1, isLeft: false),

        // Current card (center)
        _buildActiveCard(context, currentIndex),
      ],
    );
  }

  Widget _buildActiveCard(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dragRatio = (dragOffset / screenWidth).clamp(-1.0, 1.0);

    // Tumble rotation: tilt as it moves
    final rotationAngle = dragRatio * CardSwipeConfig.rotationFactor; // max ~17 degrees

    // Tumble scale: shrink slightly
    final scale = 1.0 - dragRatio.abs() * CardSwipeConfig.scaleFactor;

    // Tumble opacity: fade slightly
    final opacity = (1.0 - dragRatio.abs() * CardSwipeConfig.opacityFactor).clamp(0.0, 1.0);

    // Tumble translation: horizontal + slight downward drop
    final translateY = dragRatio.abs() * CardSwipeConfig.translateYFactor;

    return Transform(
      transform: Matrix4.translationValues(dragOffset, translateY, 0)
        ..rotateZ(rotationAngle),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: _buildCard(context, index),
        ),
      ),
    );
  }

  Widget _buildSideCard(
    BuildContext context,
    int index, {
    required bool isLeft,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final step = screenWidth - AppDimens.pagePadding;
    final baseOffset = isLeft ? -step : step;
    final offset = baseOffset + dragOffset;

    // progress: 0.0 when fully centered, 1.0 when fully off-screen
    final progress = (offset.abs() / step).clamp(0.0, 1.0);
    final activeFactor =
        1.0 - progress; // 1.0 when centered, 0.0 when off-screen

    // Tumble rotation for side card: tilts when off-screen, upright when centered
    final tiltSign = isLeft ? -1.0 : 1.0;
    final rotationAngle =
        tiltSign * CardSwipeConfig.sideCardRotation * (1.0 - activeFactor); // ~11 degrees off-screen tilt

    // Tumble scale: 0.92 when off-screen, 1.0 when centered
    final scale = CardSwipeConfig.sideCardScale + CardSwipeConfig.scaleFactor * activeFactor;

    // Tumble opacity: 0.6 when off-screen, 1.0 when centered
    final opacity = (CardSwipeConfig.sideCardOpacity + CardSwipeConfig.opacityFactor * activeFactor).clamp(0.0, 1.0);

    // Tumble translation: horizontal + slight vertical position adjustment
    final translateY = CardSwipeConfig.sideCardTranslateY * (1.0 - activeFactor);

    return Transform(
      transform: Matrix4.translationValues(offset, translateY, 0)
        ..rotateZ(rotationAngle),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: _buildCard(context, index),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    Widget card;
    if (index == 0) {
      final isCompleted =
          context.watch<BookmarkCubit>().state.mapOrNull(
            success: (s) => s.suratProgressMap[detail.info.nomor] == 1.0,
          ) ??
          false;
      card = SuratInfoCard(
        detail: detail,
        isCompleted: isCompleted,
        onStartAutoRead: onStartAutoRead,
      );
    } else if (index == controller.totalCards - 1) {
      card = SuratCompletionCard(
        detail: detail,
        onBackToHome: () {
          context.go(AppRoutes.home);
        },
        onRestart: () {
          controller.jumpTo(0);
        },
      );
    } else {
      final ayatIndex = index - 1;
      if (ayatIndex >= detail.ayatList.length) return const SizedBox.shrink();

      final ayat = detail.ayatList[ayatIndex];

      card = BlocBuilder<BookmarkCubit, BookmarkState>(
        buildWhen: (prev, next) =>
            prev.mapOrNull(success: (s) => s.bookmarks) !=
            next.mapOrNull(success: (s) => s.bookmarks),
        builder: (context, bookmarkState) {
          final bookmarks =
              bookmarkState.mapOrNull(success: (s) => s.bookmarks) ?? [];
          final isBookmarked = bookmarks.any(
            (b) =>
                b.suratNomor == detail.info.nomor &&
                b.ayatNomor == ayat.nomorAyat,
          );

          return AyatSwipeCard(
            ayat: ayat,
            suratDetail: detail,
            isBookmarked: isBookmarked,
            onBookmarkToggle: () {
              if (isBookmarked) {
                unawaited(
                  context.read<BookmarkCubit>().removeBookmark(
                    suratNomor: detail.info.nomor,
                    ayatNomor: ayat.nomorAyat,
                  ),
                );
              } else {
                unawaited(
                  context.read<BookmarkCubit>().addBookmark(
                    Bookmark(
                      suratNomor: detail.info.nomor,
                      ayatNomor: ayat.nomorAyat,
                      namaLatin: detail.info.namaLatin,
                      teksArab: ayat.teksArab,
                      teksIndonesia: ayat.teksIndonesia,
                      savedAt: DateTime.now(),
                    ),
                  ),
                );
              }
            },
          );
        },
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * CardSwipeConfig.cardMaxHeightRatio,
        ),
        child: card,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar yang update label juz sesuai ayat aktif di card stack
// ---------------------------------------------------------------------------

class _JuzAwareAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _JuzAwareAppBar({
    required this.detail,
    required this.controller,
  });

  final SuratDetail detail;
  final CardStackController controller;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) => SuratDetailAppBar(
        detail: detail,
        currentAyatNomor: controller.currentAyatNomor,
      ),
    );
  }
}
