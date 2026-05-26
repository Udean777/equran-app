import 'package:flutter/material.dart';

/// Tombol hamburger untuk membuka drawer dari AppBar.
///
/// Harus dipakai sebagai `leading` di dalam `AppBar` yang berada
/// di dalam `Scaffold` yang memiliki `drawer`.
///
/// Menggunakan [Builder] secara internal agar [Scaffold.of] menemukan
/// drawer di Scaffold yang tepat.
class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => IconButton(
        icon: const Icon(Icons.menu_rounded),
        tooltip: 'Menu',
        onPressed: () => Scaffold.of(ctx).openDrawer(),
      ),
    );
  }
}
