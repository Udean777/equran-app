import 'dart:async';

import 'package:equran_app/features/jadwal_shalat/presentation/cubit/jadwal_shalat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JadwalShalatLocationSelectorSheet extends StatefulWidget {
  const JadwalShalatLocationSelectorSheet({super.key});

  @override
  State<JadwalShalatLocationSelectorSheet> createState() =>
      _JadwalShalatLocationSelectorSheetState();
}

class _JadwalShalatLocationSelectorSheetState
    extends State<JadwalShalatLocationSelectorSheet> {
  String? _selectedProvinsi;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<JadwalShalatCubit, JadwalShalatState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      if (_selectedProvinsi != null)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () {
                            setState(() {
                              _selectedProvinsi = null;
                              _query = '';
                              _searchController.clear();
                            });
                          },
                        ),
                      Expanded(
                        child: Text(
                          _selectedProvinsi == null
                              ? 'Pilih Provinsi'
                              : _selectedProvinsi!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Search
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
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
                              onPressed: () {
                                setState(() {
                                  _query = '';
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v.toLowerCase()),
                  ),
                ),
                const Divider(height: 1),
                // List
                Expanded(
                  child: _buildList(context, state, scrollController),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    JadwalShalatState state,
    ScrollController scrollController,
  ) {
    if (_selectedProvinsi == null) {
      return _buildProvinsiList(context, state, scrollController);
    } else {
      return _buildKabkotaList(context, state, scrollController);
    }
  }

  Widget _buildProvinsiList(
    BuildContext context,
    JadwalShalatState state,
    ScrollController scrollController,
  ) {
    final provinsiList = switch (state) {
      JadwalShalatProvinsiLoaded() => state.provinsi,
      JadwalShalatKabkotaLoaded() => state.provinsi,
      JadwalShalatLoadingKabkota() => state.provinsi,
      JadwalShalatLoadingJadwal() => state.provinsi,
      JadwalShalatSuccess() => state.provinsi,
      JadwalShalatFailure() => state.provinsi ?? <String>[],
      _ => <String>[],
    };

    final filtered = _query.isEmpty
        ? provinsiList
        : provinsiList.where((p) => p.toLowerCase().contains(_query)).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Provinsi tidak ditemukan'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final provinsi = filtered[index];
        return ListTile(
          title: Text(provinsi),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {
            setState(() {
              _selectedProvinsi = provinsi;
              _query = '';
              _searchController.clear();
            });
            unawaited(
              context.read<JadwalShalatCubit>().selectProvinsi(provinsi),
            );
          },
        );
      },
    );
  }

  Widget _buildKabkotaList(
    BuildContext context,
    JadwalShalatState state,
    ScrollController scrollController,
  ) {
    if (state is JadwalShalatLoadingKabkota) {
      return const Center(child: CircularProgressIndicator());
    }

    final kabkotaList = switch (state) {
      JadwalShalatKabkotaLoaded() => state.kabkota,
      JadwalShalatLoadingJadwal() => state.kabkota,
      JadwalShalatSuccess() => state.kabkota,
      JadwalShalatFailure() => state.kabkota ?? <String>[],
      _ => <String>[],
    };

    final filtered = _query.isEmpty
        ? kabkotaList
        : kabkotaList.where((k) => k.toLowerCase().contains(_query)).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Kab/Kota tidak ditemukan'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final kabkota = filtered[index];
        return ListTile(
          title: Text(kabkota),
          onTap: () {
            unawaited(
              context.read<JadwalShalatCubit>().selectKabkota(kabkota),
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
