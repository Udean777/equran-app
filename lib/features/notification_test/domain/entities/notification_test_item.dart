enum NotificationTestType {
  adzanDirect,
  adzanStop,
  adzanNotification,
  imsak,
  sahur,
  quranReminder,
  checklist,
  hafalan,
}

class NotificationTestItem {
  const NotificationTestItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  final String id;
  final String title;
  final String subtitle;
  final NotificationTestType type;
}

class NotificationTestSection {
  const NotificationTestSection({
    required this.label,
    required this.items,
  });

  final String label;
  final List<NotificationTestItem> items;
}
