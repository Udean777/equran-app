import 'package:equran_app/core/theme/app_theme.dart';
import 'package:equran_app/features/surat_detail/presentation/pages/surat_detail_page.dart';
import 'package:equran_app/features/surat_list/presentation/pages/surat_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SuratListPage(),
    ),
    GoRoute(
      path: '/surat/:nomor',
      builder: (context, state) => SuratDetailPage(
        nomor: int.parse(state.pathParameters['nomor']!),
      ),
    ),
    GoRoute(
      path: '/tafsir/:nomor',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Tafsir')),
        body: Center(
          child: Text('Tafsir ${state.pathParameters['nomor']}'),
        ),
      ),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'eQuran',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}
