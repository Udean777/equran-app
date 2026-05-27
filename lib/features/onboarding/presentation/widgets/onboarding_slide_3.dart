import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_shared.dart';
import 'package:flutter/material.dart';

/// Slide 3 — Fitur Al-Quran
class OnboardingSlide3 extends StatelessWidget {
  const OnboardingSlide3({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSlideBase(
      child: OnboardingFeatureSlide(
        icon: Icons.auto_stories_rounded,
        title: 'Al-Quran Lengkap',
        subtitle: 'Baca, dengar, dan hafal',
        description:
            'Baca 114 surat dengan teks Arab, latin, dan terjemahan. '
            'Dilengkapi audio murottal dari berbagai qari pilihan.',
        features: [
          OnboardingFeaturePoint(
            icon: Icons.text_fields_rounded,
            text: 'Font Arab & ukuran teks yang bisa disesuaikan',
          ),
          OnboardingFeaturePoint(
            icon: Icons.headphones_rounded,
            text: 'Audio murottal per ayat atau per surat penuh',
          ),
          OnboardingFeaturePoint(
            icon: Icons.bookmark_rounded,
            text: 'Bookmark ayat & catatan pribadi',
          ),
          OnboardingFeaturePoint(
            icon: Icons.download_rounded,
            text: 'Download audio untuk didengar offline',
          ),
        ],
      ),
    );
  }
}
