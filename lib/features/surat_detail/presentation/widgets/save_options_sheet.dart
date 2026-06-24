import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class SaveOptionsSheet {
  static Future<void> show({
    required BuildContext context,
    required Future<void> Function() onGallerySave,
    required Future<void> Function() onCustomDirectorySave,
  }) {
    final surfaceColor = context.surfaceColor;
    final textPrimary = context.textPrimaryColor;
    final textSecondary = context.textSecondaryColor;
    final borderColor = context.borderVariantColor;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimens.radiusXL),
            ),
            border: Border(
              top: BorderSide(color: borderColor),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.spaceMD),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusFull,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMD),
                Text(
                  'Pilih Lokasi Penyimpanan',
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: textPrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLG),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.primaryContainerColor,
                      borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: context.primaryActionColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'Simpan ke Galeri / Foto',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Menyimpan gambar langsung ke album foto perangkat Anda',
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await onGallerySave();
                  },
                ),
                Divider(color: borderColor, height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.primaryContainerColor,
                      borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                    ),
                    child: Icon(
                      Icons.folder_open_rounded,
                      color: context.primaryActionColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'Simpan ke Folder Kustom (File)',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Pilih lokasi penyimpanan kustom sendiri di memori perangkat',
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await onCustomDirectorySave();
                  },
                ),
                const SizedBox(height: AppDimens.spaceLG),
              ],
            ),
          ),
        );
      },
    );
  }
}
