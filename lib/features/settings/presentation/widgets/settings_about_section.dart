import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Section sumber data & API — card equran.id dengan link.
class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
        ),
      ),
      color: Theme.of(context).cardColor.withValues(alpha: 0.4),
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.cloud_done_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sumber Data & API',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Didukung oleh equran.id',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMD),
            Text(
              'Seluruh data Al-Quran, terjemahan, tafsir Kemenag RI, serta kumpulan doa harian disinkronkan secara real-time dari API publik equran.id.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                height: 1.4,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: AppDimens.spaceSM),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _launchUrl(context),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text(
                  'Kunjungi equran.id',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context) async {
    final url = Uri.parse('https://equran.id/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka tautan')),
          );
        }
      }
    } on Exception catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat membuka tautan'),
          ),
        );
      }
    }
  }
}
