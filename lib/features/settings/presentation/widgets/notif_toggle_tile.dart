import 'package:equran_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Toggle tile untuk notifikasi waktu shalat di SettingsPage.
class NotifToggleTile extends StatelessWidget {
  const NotifToggleTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(label),
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}
