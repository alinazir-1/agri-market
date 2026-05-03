import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/data/models/notification_model.dart';

class NotificationsCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final Rx<NotificationFilter> activeFilter = NotificationFilter.all.obs;
  final Rx<NotificationModel?> selectedNotification =
      Rx<NotificationModel?>(null);
  final RxBool isLoading = false.obs;

  // ── Dummy Data ────────────────────────────────────────────────────────────
  final RxList<NotificationModel> notifications = <NotificationModel>[
    NotificationModel(
      id: 'N1',
      title: 'New Order Received',
      body:
          'Ahmed Khan placed an order for 50 Ton Sella Basmati Rice. Please review and confirm.',
      type: NotificationType.order,
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
      linkedId: 'ORD-2024-001',
    ),
    NotificationModel(
      id: 'N2',
      title: 'Payment Confirmed',
      body:
          'Payment of \$7,400 has been successfully processed for Order ORD-2024-002.',
      type: NotificationType.payment,
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      linkedId: 'ORD-2024-002',
    ),
    NotificationModel(
      id: 'N3',
      title: 'New Message from Sara',
      body: 'Can you confirm the exact delivery time for tomorrow?',
      type: NotificationType.message,
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: 'N4',
      title: 'Shipment Dispatched',
      body:
          'Your shipment for Fresh Mangoes has been picked up by the logistics partner.',
      type: NotificationType.shipping,
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      linkedId: 'SHP-98321',
    ),
    NotificationModel(
      id: 'N5',
      title: '5-Star Review Received',
      body: 'Usman Tariq left a 5-star review on your Diamond Potato listing.',
      type: NotificationType.review,
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: 'N6',
      title: 'System Update',
      body:
          'AgriMarket platform will undergo scheduled maintenance on Sunday at 2 AM UTC.',
      type: NotificationType.system,
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ].obs;

  // ── Computed Stats ────────────────────────────────────────────────────────
  int get totalCount => notifications.length;
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  int get todayCount {
    final now = DateTime.now();
    return notifications
        .where((n) =>
            n.time.year == now.year &&
            n.time.month == now.month &&
            n.time.day == now.day)
        .length;
  }

  // ── Filtered List ─────────────────────────────────────────────────────────
  List<NotificationModel> get filteredNotifications {
    List<NotificationModel> list = List.from(notifications);

    // Apply Category Filter
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
        list = list.where((n) => n.type == NotificationType.system).toList();
        break;
      case NotificationFilter.all:
      default:
        break;
    }

    // Apply Search Query
    if (searchQuery.value.trim().isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((n) =>
              n.title.toLowerCase().contains(q) ||
              n.body.toLowerCase().contains(q))
          .toList();
    }

    // Sort by Latest Time
    list.sort((a, b) => b.time.compareTo(a.time));
    return list;
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  void onSearch(String val) => searchQuery.value = val;

  void setFilter(NotificationFilter filter) {
    activeFilter.value = filter;
    selectedNotification.value = null; // Clear selection on filter change
  }

  void clearSelection() => selectedNotification.value = null;

  void selectNotification(NotificationModel n) {
    // Select the notification
    selectedNotification.value = n;

    // Mark as read automatically when clicked
    if (!n.isRead) {
      final index = notifications.indexWhere((element) => element.id == n.id);
      if (index != -1) {
        notifications[index] = n.copyWith(isRead: true);
        selectedNotification.value =
            notifications[index]; // Update selected with read status
      }
    }
  }

  void markAllRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    // Update selected notification if it was unread
    if (selectedNotification.value != null &&
        !selectedNotification.value!.isRead) {
      selectedNotification.value =
          selectedNotification.value!.copyWith(isRead: true);
    }
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${time.day} ${months[time.month - 1]}';
  }

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 180));
    isLoading.value = false;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
