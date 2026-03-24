import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Data/Models/notification_model.dart';

class NotificationsCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<NotificationFilter> activeFilter = NotificationFilter.all.obs;

  final RxList<NotificationModel> notifications = <NotificationModel>[
    NotificationModel(
      id: 'N1',
      title: 'New Order Received',
      body: 'Sara Malik placed an order for 200 Ton Sella Basmati Rice — \$29,600',
      type: NotificationType.order,
      time: DateTime.now().subtract(const Duration(minutes: 8)),
      isRead: false,
      linkedId: 'ORD-2024-0892',
    ),
    NotificationModel(
      id: 'N2',
      title: 'Payment Received',
      body: 'Ahmed Khan paid \$4,750 for Order #ORD-2024-0887',
      type: NotificationType.payment,
      time: DateTime.now().subtract(const Duration(minutes: 35)),
      isRead: false,
      linkedId: 'ORD-2024-0887',
    ),
    NotificationModel(
      id: 'N3',
      title: 'New Message',
      body: 'Usman Tariq: "What is the booking price for the advance booking on Mangoes?"',
      type: NotificationType.message,
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      linkedId: 'C4',
    ),
    NotificationModel(
      id: 'N4',
      title: 'Shipment Delayed',
      body: 'Order #ORD-2024-0880 shipment via TCS Express is delayed by 2 days',
      type: NotificationType.shipping,
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      linkedId: 'ORD-2024-0880',
    ),
    NotificationModel(
      id: 'N5',
      title: 'New Review Posted',
      body: 'Ali Hassan left a 5-star review on Premium Soybean',
      type: NotificationType.review,
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      linkedId: null,
    ),
    NotificationModel(
      id: 'N6',
      title: 'Low Stock Alert',
      body: 'Sella Basmati Rice stock is below 50 Ton. Consider restocking soon.',
      type: NotificationType.system,
      time: DateTime.now().subtract(const Duration(hours: 7)),
      isRead: true,
      linkedId: null,
    ),
    NotificationModel(
      id: 'N7',
      title: 'Payment Pending',
      body: 'Fatima Zahra has a pending payment of \$1,480 due in 2 days',
      type: NotificationType.payment,
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      linkedId: null,
    ),
    NotificationModel(
      id: 'N8',
      title: 'Order Delivered',
      body: 'Order #ORD-2024-0875 was delivered to Ali Hassan in Dubai, UAE',
      type: NotificationType.order,
      time: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
      linkedId: 'ORD-2024-0875',
    ),
    NotificationModel(
      id: 'N9',
      title: 'New Message',
      body: 'Ahmed Khan: "I want to place an order for 50 Ton of Sella Basmati Rice."',
      type: NotificationType.message,
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      linkedId: 'C2',
    ),
    NotificationModel(
      id: 'N10',
      title: 'Account Verified',
      body: 'Your seller account has been fully verified. You can now access all features.',
      type: NotificationType.system,
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      linkedId: null,
    ),
  ].obs;

  // ── Computed ──────────────────────────────────────────────────────────────

  int get totalCount => notifications.length;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  int get todayCount {
    final today = DateTime.now();
    return notifications
        .where((n) =>
            n.time.year == today.year &&
            n.time.month == today.month &&
            n.time.day == today.day)
        .length;
  }

  List<NotificationModel> get filteredNotifications {
    List<NotificationModel> list = List.from(notifications);

    switch (activeFilter.value) {
      case NotificationFilter.unread:
        list = list.where((n) => !n.isRead).toList();
        break;
      case NotificationFilter.orders:
        list = list
            .where((n) =>
                n.type == NotificationType.order ||
                n.type == NotificationType.shipping)
            .toList();
        break;
      case NotificationFilter.payments:
        list = list.where((n) => n.type == NotificationType.payment).toList();
        break;
      case NotificationFilter.system:
        list = list
            .where((n) =>
                n.type == NotificationType.system ||
                n.type == NotificationType.review)
            .toList();
        break;
      case NotificationFilter.all:
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((n) =>
              n.title.toLowerCase().contains(q) ||
              n.body.toLowerCase().contains(q))
          .toList();
    }

    return list;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void setFilter(NotificationFilter f) => activeFilter.value = f;

  void onSearch(String val) => searchQuery.value = val;

  void markAsRead(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notifications[idx].isRead = true;
      notifications.refresh();
    }
  }

  void markAllRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  String formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
