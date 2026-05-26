import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/luxury_card.dart';
import 'package:flutter/material.dart';

/// Card container untuk grup settings — border outline + optional shadow.
///
/// Contoh:
/// ```dart
/// SettingsLuxuryCard(
///   children: [
///     LuxuryListTile(...),
///     LuxuryDivider(),
///     LuxuryListTile(...),
///   ],
/// )
/// ```
class SettingsLuxuryCard extends StatelessWidget {
  const SettingsLuxuryCard({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
      child: LuxuryCard(
        padding: EdgeInsets.zero,
        radius: AppDimens.radiusXL,
        hasShadow: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
