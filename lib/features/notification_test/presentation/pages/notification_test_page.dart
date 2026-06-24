import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/notification_test/domain/entities/notification_test_item.dart';
import 'package:equran_app/features/notification_test/presentation/cubit/notification_test_cubit.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/cancel_all_button.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/info_banner.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/notif_card.dart';
import 'package:equran_app/features/notification_test/presentation/widgets/section_label.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationTestPage extends StatelessWidget {
  const NotificationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationTestCubit>(),
      child: const _NotificationTestView(),
    );
  }
}

class _NotificationTestView extends StatelessWidget {
  const _NotificationTestView();

  static const List<NotificationTestSection> _sections = [
    NotificationTestSection(
      label: 'Adzan Direct (Audio Player)',
      items: [
        NotificationTestItem(
          id: 'adzan_direct_dzuhur',
          title: 'Play Adzan Dzuhur (Direct)',
          subtitle: 'Langsung play audio adzan via AudioCompositeHandler',
          type: NotificationTestType.adzanDirect,
        ),
        NotificationTestItem(
          id: 'adzan_direct_subuh',
          title: 'Play Adzan Subuh (Direct)',
          subtitle: 'Langsung play audio adzan subuh via AudioCompositeHandler',
          type: NotificationTestType.adzanDirect,
        ),
        NotificationTestItem(
          id: 'adzan_stop',
          title: 'Stop Adzan',
          subtitle: 'Hentikan audio adzan yang sedang playing',
          type: NotificationTestType.adzanStop,
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Adzan Notifikasi (Visual)',
      items: [
        NotificationTestItem(
          id: 'adzan_dzuhur',
          title: 'Adzan Dzuhur',
          subtitle: 'Test notif adzan biasa (Dzuhur, Ashar, Maghrib, Isya)',
          type: NotificationTestType.adzanNotification,
        ),
        NotificationTestItem(
          id: 'adzan_subuh',
          title: 'Adzan Subuh',
          subtitle: 'Test notif adzan Subuh (sound berbeda)',
          type: NotificationTestType.adzanNotification,
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Alarm Imsakiyah',
      items: [
        NotificationTestItem(
          id: 'imsak',
          title: 'Waktu Imsak',
          subtitle: 'Test alarm imsak Ramadan',
          type: NotificationTestType.imsak,
        ),
        NotificationTestItem(
          id: 'sahur',
          title: 'Alarm Sahur',
          subtitle: 'Test alarm sahur (30 menit sebelum imsak)',
          type: NotificationTestType.sahur,
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Reminder Baca Quran',
      items: [
        NotificationTestItem(
          id: 'quran_reminder',
          title: 'Reminder Baca Quran',
          subtitle: 'Test pengingat harian membaca Al-Quran',
          type: NotificationTestType.quranReminder,
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Reminder Checklist Shalat',
      items: [
        NotificationTestItem(
          id: 'checklist',
          title: 'Checklist Shalat',
          subtitle: 'Test pengingat catat status shalat harian',
          type: NotificationTestType.checklist,
        ),
      ],
    ),
    NotificationTestSection(
      label: 'Pengingat Hafalan',
      items: [
        NotificationTestItem(
          id: 'hafalan',
          title: 'Murajaah Hafalan',
          subtitle: 'Test pengingat jadwal murajaah hafalan',
          type: NotificationTestType.hafalan,
        ),
      ],
    ),
  ];

  static (IconData icon, Color color) _itemConfig(String id) {
    return switch (id) {
      'adzan_direct_dzuhur' => (Icons.volume_up_rounded, AppColors.primary),
      'adzan_direct_subuh' => (Icons.volume_up_rounded, AppColors.primaryLight),
      'adzan_stop' => (Icons.stop_circle_rounded, AppColors.error),
      'adzan_dzuhur' => (Icons.wb_sunny_rounded, AppColors.primary),
      'adzan_subuh' => (Icons.wb_twilight_rounded, AppColors.primaryLight),
      'imsak' => (Icons.nightlight_round, AppColors.gold),
      'sahur' => (Icons.restaurant_rounded, AppColors.goldDark),
      'quran_reminder' => (
        Icons.auto_stories_rounded,
        AppColors.primaryLighter,
      ),
      'checklist' => (Icons.checklist_rounded, AppColors.success),
      'hafalan' => (Icons.menu_book_rounded, AppColors.warning),
      _ => (Icons.notifications_rounded, AppColors.primary),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationTestCubit, NotificationTestState>(
      listenWhen: (previous, current) =>
          current is NotificationTestError &&
          previous is! NotificationTestError,
      listener: (context, state) {
        state.mapOrNull(
          error: (s) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.failure.toUserMessage()),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          },
        );
      },
      child: Scaffold(
        appBar: const LuxuryAppBar(title: 'Test Notifikasi'),
        body: BlocBuilder<NotificationTestCubit, NotificationTestState>(
          builder: (context, state) {
            final isDark = context.isDark;
            final bgColor = isDark
                ? AppColors.backgroundDark
                : AppColors.background;
            final statuses = state.statuses;

            return Scaffold(
              backgroundColor: bgColor,
              body: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pagePadding,
                  AppDimens.spaceMD,
                  AppDimens.pagePadding,
                  AppDimens.spaceXXL,
                ),
                itemCount: _sections.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoBanner(),
                        SizedBox(height: AppDimens.spaceLG),
                      ],
                    );
                  }

                  if (index == _sections.length + 1) {
                    return Column(
                      children: [
                        const SizedBox(height: AppDimens.spaceLG),
                        CancelAllButton(
                          onTap: () {
                            unawaited(
                              context
                                  .read<NotificationTestCubit>()
                                  .cancelAllTests(),
                            );
                          },
                        ),
                      ],
                    );
                  }

                  final section = _sections[index - 1];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index > 1) const SizedBox(height: AppDimens.spaceLG),
                      SectionLabel(label: section.label),
                      const SizedBox(height: AppDimens.spaceSM),
                      ...section.items.map((item) {
                        final (icon, color) = _itemConfig(item.id);
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimens.spaceSM,
                          ),
                          child: NotifCard(
                            id: item.id,
                            icon: icon,
                            title: item.title,
                            subtitle: item.subtitle,
                            color: color,
                            status: statuses[item.id],
                            onTest: () {
                              unawaited(
                                context.read<NotificationTestCubit>().runTest(
                                  item,
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
