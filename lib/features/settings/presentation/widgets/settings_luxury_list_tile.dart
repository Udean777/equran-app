import 'package:equran_app/core/widgets/luxury_list_tile.dart';

/// List tile untuk settings — wrapper tipis di atas [LuxuryListTile].
///
/// Re-export [LuxuryListTile] dengan nama yang lebih kontekstual untuk
/// penggunaan di settings. Gunakan [LuxuryListTile] langsung jika lebih suka.
///
/// Contoh:
/// ```dart
/// SettingsLuxuryListTile(
///   icon: Icons.text_fields_rounded,
///   title: 'Tampilan Teks',
///   subtitle: 'Ukuran & jenis font Arab',
///   trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14),
///   onTap: () => _showFontSettings(context),
/// )
/// ```
typedef SettingsLuxuryListTile = LuxuryListTile;
