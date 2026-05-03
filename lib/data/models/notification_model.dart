// lib/data/models/notification_model.dart

enum NotificationType { order, payment, message, shipping, review, system }

enum NotificationFilter { all, unread, orders, payments, system }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime time;
  final bool isRead;
  final String? linkedId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
    this.linkedId,
  });

  String get typeLabel {
    switch (type) {
      case NotificationType.order:
        return 'Order';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.message:
        return 'Message';
      case NotificationType.shipping:
        return 'Shipping';
      case NotificationType.review:
        return 'Review';
      case NotificationType.system:
        return 'System';
    }
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      time: time,
      isRead: isRead ?? this.isRead,
      linkedId: linkedId,
    );
  }
}
