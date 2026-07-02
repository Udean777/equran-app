import 'package:equran_app/app/pages/main_page.dart';
import 'package:equran_app/core/pages/not_found_page.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/features/audio/presentation/pages/audio_storage_page.dart';
import 'package:equran_app/features/bookmark/presentation/pages/bookmark_page.dart';
import 'package:equran_app/features/catatan_ayat/presentation/pages/catatan_ayat_page.dart';
import 'package:equran_app/features/doa/presentation/pages/doa_detail_page.dart';
import 'package:equran_app/features/doa/presentation/pages/doa_list_page.dart';
import 'package:equran_app/features/doa/presentation/widgets/doa_bookmark_section.dart';
import 'package:equran_app/features/hafalan/presentation/pages/hafalan_detail_page.dart';
import 'package:equran_app/features/hafalan/presentation/pages/hafalan_page.dart';
import 'package:equran_app/features/hafalan/presentation/pages/hafalan_riwayat_page.dart';
import 'package:equran_app/features/hafalan/presentation/pages/hafalan_setoran_page.dart';
import 'package:equran_app/features/imsakiyah/presentation/pages/imsakiyah_page.dart';
import 'package:equran_app/features/notification_test/presentation/pages/notification_test_page.dart';
import 'package:equran_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:equran_app/features/qibla/presentation/pages/qibla_page.dart';
import 'package:equran_app/features/reading_progress/presentation/pages/reading_stats_page.dart';
import 'package:equran_app/features/settings/presentation/pages/settings_page.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/pages/focus_mode_page.dart';
import 'package:equran_app/features/statistik_shalat/presentation/pages/shalat_history_page.dart';
import 'package:equran_app/features/statistik_shalat/presentation/pages/statistik_shalat_page.dart';
import 'package:equran_app/features/surat_detail/presentation/pages/surat_detail_page.dart';
import 'package:equran_app/features/tasbih/presentation/pages/tasbih_history_page.dart';
import 'package:equran_app/features/tasbih/presentation/pages/tasbih_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required bool Function() isOnboardingDone})
    : _isOnboardingDone = isOnboardingDone;

  final bool Function() _isOnboardingDone;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isOnboarding = location == AppRoutes.onboarding;

      if (isOnboarding) return null;

      if (_isOnboardingDone()) return null;

      return AppRoutes.onboarding;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainPage(),
      ),

      // --- Surat ---
      GoRoute(
        path: AppRoutes.suratDetail,
        redirect: (context, state) {
          final raw = state.pathParameters['nomor'] ?? '';
          if (int.tryParse(raw) == null) return AppRoutes.home;
          return null;
        },
        builder: (context, state) {
          final nomor = int.parse(state.pathParameters['nomor']!);
          return SuratDetailPage(
            nomor: nomor,
            initialAyat: int.tryParse(
              state.uri.queryParameters['ayat'] ?? '',
            ),
            autoPlay: state.uri.queryParameters['autoPlay'] == 'true',
          );
        },
      ),

      // --- Doa ---
      GoRoute(
        path: AppRoutes.doaDetail,
        redirect: (context, state) {
          final raw = state.pathParameters['id'] ?? '';
          if (int.tryParse(raw) == null) return AppRoutes.home;
          return null;
        },
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DoaDetailPage(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.doaHarian,
        builder: (context, state) => const DoaListPage(),
      ),

      // --- Hafalan ---
      GoRoute(
        path: AppRoutes.hafalan,
        builder: (context, state) => const HafalanPage(),
      ),
      GoRoute(
        path: AppRoutes.hafalanDetail,
        redirect: (context, state) {
          final raw = state.pathParameters['suratNomor'] ?? '';
          if (int.tryParse(raw) == null) return AppRoutes.hafalan;
          return null;
        },
        builder: (context, state) {
          final nomor = int.parse(state.pathParameters['suratNomor']!);
          final juzNomor = int.tryParse(state.uri.queryParameters['juz'] ?? '');
          return HafalanDetailPage(suratNomor: nomor, juzNomor: juzNomor);
        },
      ),
      GoRoute(
        path: AppRoutes.hafalanSetoran,
        redirect: (context, state) {
          final raw = state.pathParameters['suratNomor'] ?? '';
          if (int.tryParse(raw) == null) return AppRoutes.hafalan;
          return null;
        },
        builder: (context, state) {
          final nomor = int.parse(state.pathParameters['suratNomor']!);
          final juzNomor = int.tryParse(state.uri.queryParameters['juz'] ?? '');
          return HafalanSetoranPage(suratNomor: nomor, juzNomor: juzNomor);
        },
      ),
      GoRoute(
        path: AppRoutes.hafalanRiwayat,
        redirect: (context, state) {
          final raw = state.pathParameters['suratNomor'] ?? '';
          if (int.tryParse(raw) == null) return AppRoutes.hafalan;
          return null;
        },
        builder: (context, state) {
          final nomor = int.parse(state.pathParameters['suratNomor']!);
          final juzNomor = int.tryParse(state.uri.queryParameters['juz'] ?? '');
          return HafalanRiwayatPage(suratNomor: nomor, juzNomor: juzNomor);
        },
      ),

      // --- Tasbih ---
      GoRoute(
        path: AppRoutes.tasbih,
        builder: (context, state) => const TasbihPage(),
      ),
      GoRoute(
        path: AppRoutes.tasbihHistory,
        builder: (context, state) => const TasbihHistoryPage(),
      ),

      // --- Utilitas ---
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.qibla,
        builder: (context, state) => const QiblaPage(),
      ),
      GoRoute(
        path: AppRoutes.imsakiyah,
        builder: (context, state) => const ImsakiyahPage(),
      ),
      GoRoute(
        path: AppRoutes.bookmark,
        builder: (context, state) => BookmarkPage(
          doaSectionBuilder: (onEmptyStateChanged) => DoaBookmarkSection(
            onEmptyStateChanged: onEmptyStateChanged,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.audioStorage,
        builder: (context, state) => const AudioStoragePage(),
      ),
      GoRoute(
        path: AppRoutes.catatan,
        builder: (context, state) => const CatatanAyatPage(),
      ),
      GoRoute(
        path: AppRoutes.statistikShalat,
        builder: (context, state) => const StatistikShalatPage(),
      ),
      GoRoute(
        path: AppRoutes.shalatHistory,
        builder: (context, state) => const ShalatHistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.shalatFocus,
        builder: (context, state) {
          final waktuStr = state.uri.queryParameters['waktu'];
          final waktu = WaktuShalat.values.firstWhere(
            (w) => w.name == waktuStr,
            orElse: () => WaktuShalat.subuh,
          );
          return FocusModePage(waktu: waktu);
        },
      ),
      GoRoute(
        path: AppRoutes.readingStats,
        builder: (context, state) => const ReadingStatsPage(),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.notificationTest,
          builder: (context, state) => const NotificationTestPage(),
        ),
    ],
  );
}
