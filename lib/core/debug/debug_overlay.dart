import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Debug overlay untuk performance monitoring.
/// Hanya aktif di debug mode — tidak ada di release build.
///
/// Cara pakai: wrap MaterialApp dengan DebugOverlay di app.dart.
/// Toggle performance overlay dengan tap tombol di pojok kanan bawah.
class DebugOverlay extends StatefulWidget {
  const DebugOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  bool _showPerformanceOverlay = false;

  @override
  Widget build(BuildContext context) {
    // Di release build, langsung return child tanpa overhead apapun
    if (!kDebugMode) return widget.child;

    return Stack(
      children: [
        widget.child,

        // Performance overlay di atas child
        if (_showPerformanceOverlay)
          Positioned.fill(
            child: IgnorePointer(
              child: PerformanceOverlay.allEnabled(),
            ),
          ),

        // Tombol debug tersembunyi di pojok kanan bawah
        Positioned(
          bottom: 80,
          right: 8,
          child: _DebugFab(
            isActive: _showPerformanceOverlay,
            onTap: () => setState(
              () => _showPerformanceOverlay = !_showPerformanceOverlay,
            ),
          ),
        ),
      ],
    );
  }
}

class _DebugFab extends StatelessWidget {
  const _DebugFab({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'debug_perf_fab',
      backgroundColor: isActive ? Colors.red[700] : Colors.grey[800],
      onPressed: onTap,
      child: const Icon(Icons.speed_rounded, color: Colors.white, size: 16),
    );
  }
}
