import 'package:flutter/material.dart';

/// Widget prompt saat provinsi sudah dipilih tapi kabkota belum,
/// atau saat sedang loading kabkota/jadwal.
/// Menampilkan loading indicator atau tombol ganti lokasi.
class LocationChangePromptWidget extends StatelessWidget {
  const LocationChangePromptWidget({
    required this.message,
    required this.onSelectLocation,
    this.isLoading = false,
    super.key,
  });

  final String message;
  final VoidCallback onSelectLocation;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Memuat data...'),
          ] else ...[
            const Icon(Icons.location_searching_rounded, size: 64),
            const SizedBox(height: 16),
            Text(message),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onSelectLocation,
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('Pilih Lokasi'),
            ),
          ],
        ],
      ),
    );
  }
}
