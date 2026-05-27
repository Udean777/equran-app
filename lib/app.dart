import 'dart:async';

import 'package:equran_app/core/debug/debug_overlay.dart';
import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/router/app_router.dart';
import 'package:equran_app/core/theme/app_theme.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_reminder_cubit.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()..load()),
        BlocProvider(create: (_) => getIt<LanguageCubit>()..load()),
        BlocProvider(create: (_) => getIt<ShalatNotifCubit>()..load()),
        BlocProvider(create: (_) => getIt<QuranFontCubit>()..load()),
        BlocProvider(create: (_) => getIt<QuranReminderCubit>()..load()),
        BlocProvider(
          create: (_) {
            final cubit = getIt<QuranStreakCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<HafalanCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(create: (_) => getIt<AudioCubit>()),
        BlocProvider(
          create: (_) {
            final cubit = getIt<BookmarkCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) => BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) => MaterialApp.router(
            title: 'eQuran',
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
            routerConfig: getIt<AppRouter>().router,
            // DebugOverlay di dalam MaterialApp agar punya Directionality context
            builder: (context, child) => DebugOverlay(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
