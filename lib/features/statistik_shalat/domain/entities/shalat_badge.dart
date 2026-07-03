import 'package:flutter/material.dart';

enum BadgeType {
  pertamaKali(
    id: 'pertama_kali',
    name: 'Langkah Awal',
    description: 'Catat shalat pertamamu',
    icon: Icons.flag_rounded,
    tier: 1,
  ),
  konsisten7(
    id: 'konsisten_7',
    name: 'Istiqomah 7 Hari',
    description: '7 hari berturut-turut shalat 5 waktu',
    icon: Icons.local_fire_department_rounded,
    tier: 2,
  ),
  konsisten30(
    id: 'konsisten_30',
    name: 'Istiqomah 30 Hari',
    description: 'Sebulan penuh istiqomah shalat 5 waktu',
    icon: Icons.whatshot_rounded,
    tier: 3,
  ),
  pejuangSubuh7(
    id: 'pejuang_subuh_7',
    name: 'Pejuang Subuh',
    description: '7 hari berturut-turut shalat subuh tepat waktu',
    icon: Icons.wb_sunny_rounded,
    tier: 2,
  ),
  sempurnaHariIni(
    id: 'sempurna_hari_ini',
    name: 'Hari Sempurna',
    description: '5 waktu shalat hari ini tepat semua',
    icon: Icons.star_rounded,
    tier: 1,
  ),
  tepatWaktu70(
    id: 'tepat_waktu_70',
    name: 'Tepat Waktu',
    description: '70%+ shalat tepat waktu dalam 30 hari terakhir',
    icon: Icons.check_circle_rounded,
    tier: 2,
  ),
  qadhaPertama(
    id: 'qadha_pertama',
    name: 'Semangat Qadha',
    description: 'Qadha shalat pertamamu, lebih baik daripada meninggalkan',
    icon: Icons.restore_rounded,
    tier: 1,
  ),
  allSubuh(
    id: 'all_subuh',
    name: 'Rajin Subuh',
    description: 'Tidak pernah bolos Subuh dalam 7 hari terakhir',
    icon: Icons.wb_twilight_rounded,
    tier: 2,
  );

  const BadgeType({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.tier,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int tier;
}
