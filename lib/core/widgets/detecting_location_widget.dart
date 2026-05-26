import 'package:flutter/material.dart';

/// Widget yang ditampilkan saat app sedang mendeteksi lokasi GPS user.
/// Dipakai di JadwalShalatPage dan ImsakiyahPage.
class DetectingLocationWidget extends StatelessWidget {
  const DetectingLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Icon(Icons.gps_fixed_rounded, size: 40),
          SizedBox(height: 12),
          Text(
            'Mendeteksi lokasi Anda...',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            'Jadwal akan dimuat secara otomatis',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
