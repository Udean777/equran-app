import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_shared.dart';
import 'package:flutter/material.dart';

/// Slide 5 — Fitur Hafalan & Statistik
class OnboardingSlide5 extends StatelessWidget {
  const OnboardingSlide5({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSlideBase(
      child: OnboardingFeatureSlide(
        icon: Icons.psychology_rounded,
        title: 'Hafalan & Statistik',
        subtitle: 'Pantau progress ibadah',
        description:
            'Sistem hafalan dengan metode spaced repetition untuk '
            'membantu kamu menghafal dan menjaga hafalan Al-Quran.',
        features: [
          OnboardingFeaturePoint(
            icon: Icons.menu_book_rounded,
            text: 'Mode setoran hafalan per surat',
          ),
          OnboardingFeaturePoint(
            icon: Icons.repeat_rounded,
            text: 'Pengingat murajaah otomatis dengan spaced repetition',
          ),
          OnboardingFeaturePoint(
            icon: Icons.bar_chart_rounded,
            text: 'Statistik shalat 5 waktu harian',
          ),
          OnboardingFeaturePoint(
            icon: Icons.local_fire_department_rounded,
            text: 'Streak baca Quran untuk menjaga konsistensi',
          ),
        ],
      ),
    );
  }
}
