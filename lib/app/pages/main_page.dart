import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/doa/presentation/pages/doa_list_page.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/pages/jadwal_shalat_page.dart';
import 'package:equran_app/features/qibla/presentation/pages/qibla_page.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:equran_app/features/surat_list/presentation/pages/surat_list_page.dart';
import 'package:equran_app/features/tasbih/presentation/pages/tasbih_page.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
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
      drawer: const AppDrawer(streakBadge: StreakBadgeSlot()),
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
// Luxury Bottom Navigation Bar
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
    final theme = Theme.of(context);
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Audio player bar
        Consumer(
          builder: (context, ref, _) {
            final audioState = ref.watch(audioViewModelProvider);
            if (audioState.isIdle) return const SizedBox.shrink();
            return const AudioPlayerBar();
          },
        ),

        // Nav bar container dengan top border tipis
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppColors.outlineDark
                    : AppColors.outlineVariant,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
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
                    theme: theme,
                    isDark: isDark,
                  ),
                  _NavItem(
                    index: 1,
                    currentIndex: currentIndex,
                    icon: Icons.auto_stories_outlined,
                    selectedIcon: Icons.auto_stories_rounded,
                    label: l10n.doaNav,
                    onTap: onDestinationSelected,
                    theme: theme,
                    isDark: isDark,
                  ),
                  _NavItem(
                    index: 2,
                    currentIndex: currentIndex,
                    icon: Icons.mosque_outlined,
                    selectedIcon: Icons.mosque_rounded,
                    label: l10n.jadwalShalatNav,
                    onTap: onDestinationSelected,
                    theme: theme,
                    isDark: isDark,
                  ),
                  _NavItem(
                    index: 3,
                    currentIndex: currentIndex,
                    icon: Icons.grain_outlined,
                    selectedIcon: Icons.grain_rounded,
                    label: l10n.tasbihNav,
                    onTap: onDestinationSelected,
                    theme: theme,
                    isDark: isDark,
                  ),
                  _NavItem(
                    index: 4,
                    currentIndex: currentIndex,
                    icon: Icons.explore_outlined,
                    selectedIcon: Icons.explore_rounded,
                    label: l10n.qiblaNav,
                    onTap: onDestinationSelected,
                    theme: theme,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
    required this.theme,
    required this.isDark,
  });

  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ValueChanged<int> onTap;
  final ThemeData theme;
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXS),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon dengan indicator pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMD,
                  vertical: AppDimens.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: _isSelected
                      ? (isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryContainer)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
                child: Icon(
                  _isSelected ? selectedIcon : icon,
                  size: AppDimens.bottomNavIconSize,
                  color: _isSelected ? primaryColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 2),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.labelSmall!.copyWith(
                  color: _isSelected ? primaryColor : inactiveColor,
                  fontWeight: _isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 10,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
