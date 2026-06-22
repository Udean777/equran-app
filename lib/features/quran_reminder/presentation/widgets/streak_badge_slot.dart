import 'package:equran_app/core/widgets/streak_badge.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StreakBadgeSlot extends StatelessWidget {
  const StreakBadgeSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranStreakCubit, QuranStreakState>(
      builder: (context, state) {
        final streak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
        if (streak == 0) return const SizedBox.shrink();
        return StreakBadge(streak: streak);
      },
    );
  }
}
