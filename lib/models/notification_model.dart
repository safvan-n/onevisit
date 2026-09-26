enum NotificationCategory {
  queue,
  application,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationCategory category;
  final DateTime timestamp;
  bool isRead;
  final String? targetRoute;
  final String? relatedId;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timestamp,
    this.isRead = false,
    this.targetRoute,
    this.relatedId,
  });
}
