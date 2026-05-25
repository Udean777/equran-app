import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMD,
                vertical: AppDimens.spaceLG,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.onPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMD),
                  Text(
                    'eQuran',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceSM),

            // Menu items
            _DrawerItem(
              icon: Icons.mosque_outlined,
              selectedIcon: Icons.mosque_rounded,
              label: l10n.imsakiyahNav,
              onTap: () {
                Navigator.pop(context);
                unawaited(context.push('/imsakiyah'));
              },
            ),
            _DrawerItem(
              icon: Icons.bookmark_outline_rounded,
              selectedIcon: Icons.bookmark_rounded,
              label: l10n.bookmarkNav,
              onTap: () {
                Navigator.pop(context);
                unawaited(context.push('/bookmark'));
              },
            ),
            _DrawerItem(
              icon: Icons.auto_stories_outlined,
              selectedIcon: Icons.auto_stories_rounded,
              label: 'Doa Harian',
              onTap: () {
                Navigator.pop(context);
                unawaited(context.push('/doa-harian'));
              },
            ),
            _DrawerItem(
              icon: Icons.audio_file_outlined,
              selectedIcon: Icons.audio_file_rounded,
              label: 'Manajemen Audio',
              onTap: () {
                Navigator.pop(context);
                unawaited(context.push('/audio/storage'));
              },
            ),

            const Divider(height: AppDimens.spaceLG),

            _DrawerItem(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings_rounded,
              label: 'Pengaturan',
              onTap: () async {
                Navigator.pop(context);
                await context.push('/settings');
              },
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMD),
              child: Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
    );
  }
}
