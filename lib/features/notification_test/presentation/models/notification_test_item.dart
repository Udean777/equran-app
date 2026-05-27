import 'dart:async';
import 'package:flutter/material.dart';

/// Model representing a single notification test trigger item
class NotificationTestItem {
  const NotificationTestItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTest,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Future<void> Function() onTest;
}

/// Model representing a group/section of notification test triggers
class NotificationTestSection {
  const NotificationTestSection({
    required this.label,
    required this.items,
  });

  final String label;
  final List<NotificationTestItem> items;
}
