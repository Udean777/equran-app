import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:flutter/material.dart';

/// Sheet generik untuk memilih lokasi (provinsi → kab/kota).
///
/// Tidak bergantung ke cubit manapun — semua interaksi via callback
/// sesuai Dependency Inversion Principle.
///
/// Contoh penggunaan:
/// ```dart
/// LocationSelectorSheet(
///   provinsiList: state.provinsi,
///   kabkotaList: state.kabkota,
///   isLoadingKabkota: state is LoadingKabkota,
///   onProvinsiSelected: (p) => cubit.selectProvinsi(p),
///   onKabkotaSelected: (k) {
///     cubit.selectKabkota(k);
///     Navigator.of(context).pop();
///   },
/// )
/// ```
class LocationSelectorSheet extends StatefulWidget {
  const LocationSelectorSheet({
    required this.provinsiList,
    required this.kabkotaList,
    required this.isLoadingKabkota,
    required this.onProvinsiSelected,
    required this.onKabkotaSelected,
    super.key,
  });

  /// Daftar provinsi yang tersedia.
  final List<String> provinsiList;

  /// Daftar kab/kota untuk provinsi yang dipilih.
  final List<String> kabkotaList;

  /// True saat kab/kota sedang dimuat dari remote.
  final bool isLoadingKabkota;

  /// Dipanggil saat user memilih provinsi.
  final ValueChanged<String> onProvinsiSelected;

  /// Dipanggil saat user memilih kab/kota.
  /// Caller bertanggung jawab menutup sheet jika diperlukan.
  final ValueChanged<String> onKabkotaSelected;

  @override
  State<LocationSelectorSheet> createState() => _LocationSelectorSheetState();
}

class _LocationSelectorSheetState extends State<LocationSelectorSheet> {
  String? _selectedProvinsi;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _query = '';
      _searchController.clear();
    });
  }

  void _selectProvinsi(String provinsi) {
    setState(() {
      _selectedProvinsi = provinsi;
      _query = '';
      _searchController.clear();
    });
    widget.onProvinsiSelected(provinsi);
  }

  void _backToProvinsi() {
    setState(() {
      _selectedProvinsi = null;
      _query = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: BottomSheetHandle(),
            ),

            // Title + back button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMD,
              ),
              child: Row(
                children: [
                  if (_selectedProvinsi != null)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: _backToProvinsi,
                    ),
                  Expanded(
                    child: Text(
                      _selectedProvinsi ?? 'Pilih Provinsi',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMD,
                vertical: AppDimens.spaceSM,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: _selectedProvinsi == null
                      ? 'Cari provinsi...'
                      : 'Cari kab/kota...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: _clearSearch,
                        )
                      : null,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                ),
                onChanged: (v) => setState(() => _query = v.toLowerCase()),
              ),
            ),

            const LuxuryDivider(),

            // List
            Expanded(
              child: _selectedProvinsi == null
                  ? _ProvinsiList(
                      provinsiList: widget.provinsiList,
                      query: _query,
                      onSelected: _selectProvinsi,
                    )
                  : _KabkotaList(
                      kabkotaList: widget.kabkotaList,
                      isLoading: widget.isLoadingKabkota,
                      query: _query,
                      onSelected: widget.onKabkotaSelected,
                      scrollController: scrollController,
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Provinsi list
// ---------------------------------------------------------------------------

class _ProvinsiList extends StatelessWidget {
  const _ProvinsiList({
    required this.provinsiList,
    required this.query,
    required this.onSelected,
  });

  final List<String> provinsiList;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final filtered = query.isEmpty
        ? provinsiList
        : provinsiList.where((p) => p.toLowerCase().contains(query)).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Provinsi tidak ditemukan'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) => _LocationItem(
        label: filtered[index],
        icon: Icons.location_city_rounded,
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 18,
        ),
        onTap: () => onSelected(filtered[index]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kab/kota list
// ---------------------------------------------------------------------------

class _KabkotaList extends StatelessWidget {
  const _KabkotaList({
    required this.kabkotaList,
    required this.isLoading,
    required this.query,
    required this.onSelected,
    required this.scrollController,
  });

  final List<String> kabkotaList;
  final bool isLoading;
  final String query;
  final ValueChanged<String> onSelected;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LoadingWidget();

    final filtered = query.isEmpty
        ? kabkotaList
        : kabkotaList.where((k) => k.toLowerCase().contains(query)).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Kab/Kota tidak ditemukan'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filtered.length,
      itemBuilder: (context, index) => _LocationItem(
        label: filtered[index],
        icon: Icons.place_rounded,
        onTap: () => onSelected(filtered[index]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Item baris lokasi
// ---------------------------------------------------------------------------

class _LocationItem extends StatelessWidget {
  const _LocationItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.pagePadding,
          vertical: AppDimens.spaceMD,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryDark
                    : AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMD),

            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark
                      ? AppColors.onSurfaceDark
                      : AppColors.textPrimary,
                ),
              ),
            ),

            if (trailing != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textTertiary,
                ),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
