import 'package:equran_app/core/widgets/streak_badge.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreakBadgeSlot extends ConsumerWidget {
  const StreakBadgeSlot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quranStreakViewModelProvider);
    final streak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
    if (streak == 0) return const SizedBox.shrink();
    return StreakBadge(streak: streak);
  }
}
