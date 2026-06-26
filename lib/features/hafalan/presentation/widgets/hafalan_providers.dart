import 'package:flutter/material.dart';

/// Legacy wrapper — no longer provides anything.
/// Kept to avoid breaking imports during migration.
class HafalanProviders extends StatelessWidget {
  const HafalanProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
