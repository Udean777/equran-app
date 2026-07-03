import 'dart:async';

import 'package:equran_app/core/providers.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/streak_badge.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/doa/presentation/pages/doa_list_page.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/pages/jadwal_shalat_page.dart';
import 'package:equran_app/features/qibla/presentation/pages/qibla_page.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/providers.dart';
import 'package:equran_app/features/statistik_shalat/presentation/widgets/daily_recap_modal.dart';
import 'package:equran_app/features/surat_list/presentation/pages/surat_list_page.dart';
import 'package:equran_app/features/tasbih/presentation/pages/tasbih_page.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late final List<Widget> _pages;
  late final AnimationController _navAnimController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = const [
      SuratListPage(),
      DoaListPage(),
      JadwalShalatPage(),
      TasbihPage(),
      QiblaPage(),
    ];
    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    unawaited(_navAnimController.forward());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkDailyRecap());
    });
  }

  Future<void> _checkDailyRecap() async {
    try {
      final settingsBox = ref.read(settingsBoxProvider);
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final lastShown = settingsBox.get('last_recap_shown_date');

      if (lastShown == todayStr) return; // Sudah tampil hari ini

      if (lastShown == null) {
        // Pengguna baru / baru pertama kali buka fitur ini
        // Jangan tampilkan modal 'Tidak ada catatan' untuk kemarin.
        unawaited(settingsBox.put('last_recap_shown_date', todayStr));
        return;
      }

      // Ambil data kemarin
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr = DateFormat('yyyy-MM-dd').format(yesterday);

      final getShalatByDate = ref.read(getShalatByDateProvider);
      final result = await getShalatByDate(yesterdayStr);

      result.fold(
        (_) {}, // Jika error biarkan
        (stats) {
          final statsToShow = stats ?? ShalatDayStats(date: yesterdayStr);
          // Hanya tampilkan jika fitur rekap menyala
          final isEnabled = settingsBox.get('shalat_recap_enabled') != 'false';
          if (isEnabled && mounted) {
            unawaited(DailyRecapModal.show(context, statsToShow));
            unawaited(settingsBox.put('last_recap_shown_date', todayStr));
          }
        },
      );
    } on Exception catch (_) {}
  }

  @override
  void dispose() {
    _navAnimController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const AppDrawer(
        streakBadge: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreakBadgeSlot(),
            _ShalatStreakBadge(),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _LuxuryBottomNav(
        currentIndex: _currentIndex,
        isDark: isDark,
        onDestinationSelected: _onDestinationSelected,
        l10n: l10n,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Audio player bar (shared between nav states)
// ---------------------------------------------------------------------------

class _AudioPlayerSection extends StatelessWidget {
  const _AudioPlayerSection();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final audioState = ref.watch(audioViewModelProvider);
        if (audioState.isIdle) return const SizedBox.shrink();
        return const Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.bottomNavFloatingMargin,
            0,
            AppDimens.bottomNavFloatingMargin,
            8,
          ),
          child: AudioPlayerBar(),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Floating Pill Navigation Bar
// ---------------------------------------------------------------------------

class _LuxuryBottomNav extends StatelessWidget {
  const _LuxuryBottomNav({
    required this.currentIndex,
    required this.isDark,
    required this.onDestinationSelected,
    required this.l10n,
  });

  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onDestinationSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Audio player bar (di luar floating bar)
          const _AudioPlayerSection(),

          // Floating pill container
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.bottomNavFloatingMargin,
              0,
              AppDimens.bottomNavFloatingMargin,
              8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(
                  AppDimens.bottomNavBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -2),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                    blurRadius: 40,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                height: AppDimens.bottomNavHeight,
                child: Row(
                  children: [
                    _NavItem(
                      index: 0,
                      currentIndex: currentIndex,
                      icon: Icons.menu_book_outlined,
                      selectedIcon: Icons.menu_book_rounded,
                      label: l10n.suratNav,
                      onTap: onDestinationSelected,
                      isDark: isDark,
                    ),
                    _NavItem(
                      index: 1,
                      currentIndex: currentIndex,
                      icon: Icons.auto_stories_outlined,
                      selectedIcon: Icons.auto_stories_rounded,
                      label: l10n.doaNav,
                      onTap: onDestinationSelected,
                      isDark: isDark,
                    ),
                    _NavItem(
                      index: 2,
                      currentIndex: currentIndex,
                      icon: Icons.mosque_outlined,
                      selectedIcon: Icons.mosque_rounded,
                      label: l10n.jadwalShalatNav,
                      onTap: onDestinationSelected,
                      isDark: isDark,
                    ),
                    _NavItem(
                      index: 3,
                      currentIndex: currentIndex,
                      icon: Icons.grain_outlined,
                      selectedIcon: Icons.grain_rounded,
                      label: l10n.tasbihNav,
                      onTap: onDestinationSelected,
                      isDark: isDark,
                    ),
                    _NavItem(
                      index: 4,
                      currentIndex: currentIndex,
                      icon: Icons.explore_outlined,
                      selectedIcon: Icons.explore_rounded,
                      label: l10n.qiblaNav,
                      onTap: onDestinationSelected,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShalatStreakBadge extends ConsumerWidget {
  const _ShalatStreakBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakCountProvider);
    if (streak == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: StreakBadge(
        streak: streak,
        variant: StreakBadgeVariant.onPrimary,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ValueChanged<int> onTap;
  final bool isDark;

  bool get _isSelected => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _isSelected
                      ? (isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryContainer)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(
                  _isSelected ? selectedIcon : icon,
                  size: AppDimens.bottomNavIconSize,
                  color: _isSelected ? primaryColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: _isSelected ? primaryColor : inactiveColor,
                  fontWeight: _isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
