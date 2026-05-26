import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/widgets/audio_player_bar.dart';
import 'package:equran_app/features/doa/presentation/pages/doa_list_page.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/pages/jadwal_shalat_page.dart';
import 'package:equran_app/features/qibla/presentation/pages/qibla_page.dart';
import 'package:equran_app/features/surat_list/presentation/pages/surat_list_page.dart';
import 'package:equran_app/features/tasbih/presentation/pages/tasbih_page.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  late final List<Widget> _pages;

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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Global AudioPlayerBar — muncul di semua halaman saat audio aktif
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<AudioCubit, AudioPlayerState>(
            buildWhen: (prev, next) => prev.isIdle != next.isIdle,
            builder: (context, state) {
              if (state.isIdle) return const SizedBox.shrink();
              return const AudioPlayerBar();
            },
          ),
          NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.menu_book_outlined),
                selectedIcon: const Icon(Icons.menu_book_rounded),
                label: l10n.suratNav,
              ),
              NavigationDestination(
                icon: const Icon(Icons.auto_stories_outlined),
                selectedIcon: const Icon(Icons.auto_stories_rounded),
                label: l10n.doaNav,
              ),
              NavigationDestination(
                icon: const Icon(Icons.mosque_outlined),
                selectedIcon: const Icon(Icons.mosque_rounded),
                label: l10n.jadwalShalatNav,
              ),
              const NavigationDestination(
                icon: Icon(Icons.grain_outlined),
                selectedIcon: Icon(Icons.grain_rounded),
                label: 'Tasbih',
              ),
              const NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore_rounded),
                label: 'Qibla',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
