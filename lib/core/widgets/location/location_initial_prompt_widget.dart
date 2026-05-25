import 'package:flutter/material.dart';

/// Widget prompt awal saat user belum memilih lokasi.
/// Menampilkan icon, teks instruksi, dan tombol pilih lokasi.
class LocationInitialPromptWidget extends StatelessWidget {
  const LocationInitialPromptWidget({
    required this.icon,
    required this.message,
    required this.onSelectLocation,
    super.key,
  });

  final IconData icon;
  final String message;
  final VoidCallback onSelectLocation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onSelectLocation,
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Pilih Lokasi'),
          ),
        ],
      ),
    );
  }
}
