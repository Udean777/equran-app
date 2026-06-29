import 'dart:async';

import 'package:equran_app/core/debug/debug_overlay.dart';
import 'package:equran_app/core/locale/providers.dart';
import 'package:equran_app/core/router/providers.dart';
import 'package:equran_app/core/theme/app_theme.dart';
import 'package:equran_app/core/theme/providers.dart';
import 'package:equran_app/core/widgets/app_logo.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/bookmark/presentation/providers.dart';
import 'package:equran_app/features/hafalan/presentation/providers.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/providers.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/presentation/providers.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _precached = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Initialize ViewModels after first frame (avoid modifying state during build)
        if (!_initialized) {
          _initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(themeViewModelProvider.notifier).load();
            ref.read(languageViewModelProvider.notifier).load();
            ref.read(quranFontViewModelProvider.notifier).load();
            unawaited(ref.read(shalatNotifViewModelProvider.notifier).load());
            unawaited(ref.read(quranReminderViewModelProvider.notifier).load());
            unawaited(ref.read(bookmarkViewModelProvider.notifier).load());
            unawaited(ref.read(quranStreakViewModelProvider.notifier).load());
            unawaited(ref.read(hafalanListViewModelProvider.notifier).load());
            unawaited(ref.read(readingProgressViewModelProvider.notifier).load());
          });
        }

        // Listen to audio playback for lastRead updates
        ref.listen<AudioPlayerState>(audioViewModelProvider, (prev, curr) {
          if (prev?.currentAyat == curr.currentAyat ||
              curr.currentAyat == null) {
            return;
          }
          final audioVm = ref.read(audioViewModelProvider.notifier);
          if (!audioVm.isPlaylistMode) return;
          if (!audioVm.shouldUpdateLastRead) return;
          final suratNomor = audioVm.playlistSuratNomor;
          final suratName = audioVm.playlistSuratName;
          if (suratNomor == null || suratName == null) return;

          ref
              .read(bookmarkViewModelProvider.notifier)
              .updateLastReadFromAudio(
                suratNomor: suratNomor,
                namaLatin: suratName,
                ayatNomor: curr.currentAyat!,
                totalAyat: audioVm.playlist.length,
              );
        });

        return child!;
      },
      child: Consumer(
        builder: (context, ref, child) {
          final themeState = ref.watch(themeViewModelProvider);
          final langState = ref.watch(languageViewModelProvider);

          return MaterialApp.router(
            title: 'Qurva',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeState.themeMode,
            locale: langState.locale,
            // --- OPTIMASI: Hanya dukung locale yang benar-benar dipakai ---
            // Membatasi locale mencegah Flutter mem-bundle 70+ bahasa yang tidak perlu
            supportedLocales: const [
              Locale('id'), // Indonesia (default)
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: ref.watch(appRouterProvider).router,
            // DebugOverlay di dalam MaterialApp agar punya Directionality context
            builder: (context, child) {
              if (!_precached) {
                _precached = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) unawaited(AppLogo.precache(context));
                });
              }
              return DebugOverlay(
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
