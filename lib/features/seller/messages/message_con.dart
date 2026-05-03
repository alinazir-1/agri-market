// lib/features/seller/messages/message_con.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/data/models/message_model.dart';
import 'package:agri_market/features/seller/messages/widgets/call_phone_dialog.dart';

class MessagesCon extends GetxController {
  final TextEditingController topSearchController = TextEditingController();
  final TextEditingController convSearchController = TextEditingController();
  final TextEditingController messageInputController = TextEditingController();

  final RxString topSearch = ''.obs;
  final RxString convSearch = ''.obs;
  final Rx<ConversationTab> activeTab = ConversationTab.all.obs;
  final RxString selectedConversationId = 'C1'.obs;

  /// Voice call overlay (UI-only; WebRTC integration later).
  final RxBool callActive = false.obs;
  final RxBool callMinimized = false.obs;
  final RxString callPeerName = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  // ── Hex helper ────────────────────────────────────────────────────────────
  static Color hexToColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  // ── Conversations Data ─────────────────────────────────────────────────────
  final RxList<ConversationModel> conversations = <ConversationModel>[
    ConversationModel(
      id: 'C1',
      buyerName: 'Sara Malik',
      buyerEmail: 'sara@mail.com',
      buyerLocation: 'Lahore, PK',
      avatarHex: '#7C3AED',
      lastMessage: 'Can you confirm the delivery date?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 2)),
      unreadCount: 3,
      isOnline: true,
      isVip: true,
      totalOrders: 28,
      totalSpent: 18600,
      memberSince: 'Jan 2025',
      recentOrders: [
        RecentOrderInfo(
            productName: 'Sella Basmati Rice',
            status: 'Processing',
            date: 'Mar 15, 2026',
            amount: '\$29,600',
            isDelivered: false),
        RecentOrderInfo(
            productName: 'Premium Soybean',
            status: 'Delivered',
            date: 'Feb 28, 2026',
            amount: '\$14,800',
            isDelivered: true),
      ],
      messages: [
        MessageModel(
            id: 'm1',
            text:
                'Hi! I wanted to ask about the Sella Basmati Rice delivery schedule for my last order.',
            isMine: false,
            time: DateTime.now().subtract(const Duration(minutes: 10))),
        MessageModel(
            id: 'm2',
            text:
                'Hello Sara! Your order is being processed. Expected delivery is within 5-7 business days.',
            isMine: true,
            time: DateTime.now().subtract(const Duration(minutes: 8))),
        MessageModel(
            id: 'm3',
            text:
                'Can you confirm the delivery date? Here is the order reference:',
            isMine: false,
            time: DateTime.now().subtract(const Duration(minutes: 6)),
            type: MessageType.orderCard,
            orderCard: const OrderCardData(
                orderId: 'ORD-2024-0892',
                productName: 'Sella Basmati Rice',
                quantity: '200 Ton',
                total: '\$29,600')),
        MessageModel(
            id: 'm4',
            text:
                'Confirmed! Your order will be dispatched on March 22nd. I\'ll send you the tracking details once it ships.',
            isMine: true,
            time: DateTime.now().subtract(const Duration(minutes: 4))),
        MessageModel(
            id: 'm5',
            text: 'Perfect, thank you! Looking forward to it.',
            isMine: false,
            time: DateTime.now().subtract(const Duration(minutes: 2))),
      ],
    ),
    ConversationModel(
      id: 'C2',
      buyerName: 'Ahmed Khan',
      buyerEmail: 'ahmed@mail.com',
      buyerLocation: 'Karachi, PK',
      avatarHex: '#0E7C66',
      lastMessage: 'I want to place an order for 50 Ton',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 1,
      isOnline: true,
      isVip: false,
      totalOrders: 12,
      totalSpent: 4820,
      memberSince: 'Mar 2025',
      recentOrders: [
        const RecentOrderInfo(
            productName: 'Desiree Potato',
            status: 'Delivered',
            date: 'Mar 10, 2026',
            amount: '\$4,750',
            isDelivered: true),
      ],
      messages: [
        MessageModel(
            id: 'm1',
            text:
                'Hello, I want to place an order for 50 Ton of Sella Basmati Rice.',
            isMine: false,
            time: DateTime.now().subtract(const Duration(hours: 1))),
      ],
    ),
    ConversationModel(
      id: 'C3',
      buyerName: 'Ali Hassan',
      buyerEmail: 'ali@mail.com',
      buyerLocation: 'Dubai, UAE',
      avatarHex: '#0891B2',
      lastMessage: 'Thanks, received the samples',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 0,
      isOnline: false,
      isVip: false,
      totalOrders: 7,
      totalSpent: 9240,
      memberSince: 'Jun 2025',
      recentOrders: [
        RecentOrderInfo(
            productName: 'Fresh Mangoes',
            status: 'Delivered',
            date: 'Mar 5, 2026',
            amount: '\$2,400',
            isDelivered: true),
      ],
      messages: [
        MessageModel(
            id: 'm1',
            text: 'Thanks, received the samples. Quality is great!',
            isMine: false,
            time: DateTime.now().subtract(const Duration(hours: 3))),
      ],
    ),
    ConversationModel(
      id: 'C4',
      buyerName: 'Usman Tariq',
      buyerEmail: 'usman@mail.com',
      buyerLocation: 'Multan, PK',
      avatarHex: '#D97706',
      lastMessage: 'What is the booking price for...',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      isOnline: false,
      isVip: true,
      totalOrders: 34,
      totalSpent: 24500,
      memberSince: 'Nov 2024',
      recentOrders: [
        const RecentOrderInfo(
            productName: 'Premium Soybean',
            status: 'Processing',
            date: 'Mar 8, 2026',
            amount: '\$11,200',
            isDelivered: false),
      ],
      messages: [
        MessageModel(
            id: 'm1',
            text:
                'What is the booking price for the advance booking on Mangoes?',
            isMine: false,
            time: DateTime.now().subtract(const Duration(days: 1))),
      ],
    ),
    ConversationModel(
      id: 'C5',
      buyerName: 'Fatima Zahra',
      buyerEmail: 'fatima@mail.com',
      buyerLocation: 'Islamabad, PK',
      avatarHex: '#DC2626',
      lastMessage: 'Is the grade A stock still available?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      isOnline: false,
      isVip: false,
      totalOrders: 3,
      totalSpent: 1480,
      memberSince: 'Sep 2025',
      recentOrders: [],
      messages: [
        MessageModel(
            id: 'm1',
            text: 'Is the grade A stock still available?',
            isMine: false,
            time: DateTime.now().subtract(const Duration(days: 2))),
      ],
    ),
  ].obs;

  // ── Computed ───────────────────────────────────────────────────────────────
  int get totalUnread => conversations.fold(0, (sum, c) => sum + c.unreadCount);

  /// Avatar initials / color for outgoing bubbles in [ChatWindow] (seller = business).
  String get outgoingMessageBubbleInitials => 'AS';
  String get outgoingMessageBubbleHex => '#0E7C66';

  /// Composer hint in [ChatWindow].
  String get messageComposerHint => 'Type a message...';

  ConversationModel? get selectedConversation => conversations
      .firstWhereOrNull((c) => c.id == selectedConversationId.value);

  List<ConversationModel> get filteredConversations {
    List<ConversationModel> list = List.from(conversations);

    switch (activeTab.value) {
      case ConversationTab.unread:
        list = list.where((c) => c.unreadCount > 0).toList();
        break;
      case ConversationTab.orders:
        list = list.where((c) => c.recentOrders.isNotEmpty).toList();
        break;
      case ConversationTab.all:
        break;
    }

    if (convSearch.value.isNotEmpty) {
      final q = convSearch.value.toLowerCase();
      list = list
          .where((c) =>
              c.buyerName.toLowerCase().contains(q) ||
              c.lastMessage.toLowerCase().contains(q))
          .toList();
    }

    return list;
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  void clearSelection() => selectedConversationId.value = '';

  void selectConversation(String id) {
    selectedConversationId.value = id;
    final idx = conversations.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    final old = conversations[idx];
    conversations[idx] = ConversationModel(
      id: old.id,
      buyerName: old.buyerName,
      buyerEmail: old.buyerEmail,
      buyerLocation: old.buyerLocation,
      avatarHex: old.avatarHex,
      lastMessage: old.lastMessage,
      lastMessageTime: old.lastMessageTime,
      unreadCount: 0,
      isOnline: old.isOnline,
      isVip: old.isVip,
      totalOrders: old.totalOrders,
      totalSpent: old.totalSpent,
      memberSince: old.memberSince,
      messages: old.messages,
      recentOrders: old.recentOrders,
    );
  }

  void openConversationForCustomer(String customerId) {
    final exists = conversations.any((c) => c.id == customerId);
    if (exists) {
      activeTab.value = ConversationTab.all;
      convSearch.value = '';
      convSearchController.clear();
      selectConversation(customerId);
    }
  }

  void setTab(ConversationTab tab) => activeTab.value = tab;
  void onConvSearch(String val) => convSearch.value = val;
  void onTopSearch(String val) => topSearch.value = val;

  void startCall(String peerName) {
    callPeerName.value = peerName;
    callActive.value = true;
    callMinimized.value = false;
    Get.dialog(
      CallPhoneDialog(
        peerName: peerName,
        onMinimize: _minimizeCall,
        onEndCall: endCall,
      ),
      barrierDismissible: false,
    );
  }

  void _minimizeCall() {
    callMinimized.value = true;
    if (Get.isDialogOpen ?? false) Get.back();
  }

  void expandCall() {
    if (!callActive.value) return;
    callMinimized.value = false;
    Get.dialog(
      CallPhoneDialog(
        peerName: callPeerName.value,
        onMinimize: _minimizeCall,
        onEndCall: endCall,
      ),
      barrierDismissible: false,
    );
  }

  void endCall() {
    callActive.value = false;
    callMinimized.value = false;
    if (Get.isDialogOpen ?? false) Get.back();
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

  Future<void> sendMessage() async {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;
    if (isSending.value) return;
    isSending.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final idx =
        conversations.indexWhere((c) => c.id == selectedConversationId.value);
    if (idx == -1) {
      isSending.value = false;
      return;
    }
    final old = conversations[idx];
    final newMsg = MessageModel(
        id: 'm${old.messages.length + 1}',
        text: text,
        isMine: true,
        time: DateTime.now());
    final updated = List<MessageModel>.from(old.messages)..add(newMsg);
    conversations[idx] = ConversationModel(
      id: old.id,
      buyerName: old.buyerName,
      buyerEmail: old.buyerEmail,
      buyerLocation: old.buyerLocation,
      avatarHex: old.avatarHex,
      lastMessage: text,
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      isOnline: old.isOnline,
      isVip: old.isVip,
      totalOrders: old.totalOrders,
      totalSpent: old.totalSpent,
      memberSince: old.memberSince,
      messages: updated,
      recentOrders: old.recentOrders,
    );
    messageInputController.clear();
    isSending.value = false;
  }

  String formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  String formatMessageTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m ${time.hour < 12 ? "AM" : "PM"}';
  }

  @override
  void onClose() {
    topSearchController.dispose();
    convSearchController.dispose();
    messageInputController.dispose();
    super.onClose();
  }
}
