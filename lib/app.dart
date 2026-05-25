import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/pages/main_page.dart';
import 'package:equran_app/core/theme/app_theme.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/features/doa/presentation/pages/doa_detail_page.dart';
import 'package:equran_app/features/settings/presentation/pages/settings_page.dart';
import 'package:equran_app/features/surat_detail/presentation/pages/surat_detail_page.dart';
import 'package:equran_app/features/tasbih/presentation/pages/tasbih_page.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/surat/:nomor',
      builder: (context, state) => SuratDetailPage(
        nomor: int.parse(state.pathParameters['nomor']!),
        initialAyat: int.tryParse(state.uri.queryParameters['ayat'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/doa/:id',
      builder: (context, state) => DoaDetailPage(
        id: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/tasbih',
      builder: (context, state) => const TasbihPage(),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()..load()),
        BlocProvider(create: (_) => getIt<LanguageCubit>()..load()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) =>
            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, langState) => MaterialApp.router(
                title: 'eQuran',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeState.themeMode,
                locale: langState.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: _router,
              ),
            ),
      ),
    );
  }
}
