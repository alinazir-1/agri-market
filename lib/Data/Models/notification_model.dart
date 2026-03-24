import 'package:flutter/material.dart';

enum NotificationType { order, payment, message, shipping, review, system }

enum NotificationFilter { all, unread, orders, payments, system }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime time;
  bool isRead;
  final String? linkedId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
    this.linkedId,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_bag_outlined;
      case NotificationType.payment:
        return Icons.payments_outlined;
      case NotificationType.message:
        return Icons.chat_bubble_outline_rounded;
      case NotificationType.shipping:
        return Icons.local_shipping_outlined;
      case NotificationType.review:
        return Icons.rate_review_outlined;
      case NotificationType.system:
        return Icons.info_outline_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.order:
        return const Color(0xFF0E7C66);
      case NotificationType.payment:
        return const Color(0xFF0E7C66);
      case NotificationType.message:
        return const Color(0xFF3B82F6);
      case NotificationType.shipping:
        return const Color(0xFF0369A1);
      case NotificationType.review:
        return const Color(0xFFD97706);
      case NotificationType.system:
        return const Color(0xFF6B7280);
    }
  }

  Color get iconBg {
    switch (type) {
      case NotificationType.order:
        return const Color(0xFFD1FAE5);
      case NotificationType.payment:
        return const Color(0xFFD1FAE5);
      case NotificationType.message:
        return const Color(0xFFDBEAFE);
      case NotificationType.shipping:
        return const Color(0xFFE0F2FE);
      case NotificationType.review:
        return const Color(0xFFFEF3C7);
      case NotificationType.system:
        return const Color(0xFFF3F4F6);
    }
  }

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
}
