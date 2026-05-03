// lib/features/buyer/common/widgets/buyer_home_messages_con.dart
//
// Buyer home messaging — same controller surface as [MessagesCon] so we can
// reuse seller chat UI ([ChatWindow], [ConversationList]) with buyer POV data.

import 'package:get/get.dart';

import 'package:agri_market/data/models/message_model.dart';
import 'package:agri_market/features/seller/messages/message_con.dart';

class BuyerHomeMessagesCon extends MessagesCon {
  @override
  String get outgoingMessageBubbleInitials => 'ME';

  @override
  String get messageComposerHint => 'Write a message...';

  /// Buyer dock: panel #2 (full chat) visible to the left of the inbox list.
  final RxBool buyerDockChatPanelOpen = false.obs;

  /// Open dock showing **inbox only** (LinkedIn-style panel #1).
  void prepareBuyerDockInboxOnly() {
    clearSelection();
    buyerDockChatPanelOpen.value = false;
  }

  /// Open dock with chat panel visible (e.g. after picking a thread from preview).
  void prepareBuyerDockWithChatPanel() {
    buyerDockChatPanelOpen.value = true;
  }

  @override
  void selectConversation(String id) {
    super.selectConversation(id);
    buyerDockChatPanelOpen.value = true;
  }

  BuyerHomeMessagesCon() {
    conversations.clear();
    conversations.addAll(_buyerConversations);
    if (conversations.isNotEmpty) {
      selectedConversationId.value = conversations.first.id;
    }
  }

  static List<ConversationModel> get _buyerConversations => [
        ConversationModel(
          id: 'BC1',
          buyerName: 'Al-Rehman Traders',
          buyerEmail: 'sales@alrehman.pk',
          buyerLocation: 'Sahiwal, Punjab',
          avatarHex: '#0E7C66',
          lastMessage: 'Bulk wheat quote updated for 100 bags.',
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 12)),
          unreadCount: 2,
          isOnline: true,
          isVip: false,
          totalOrders: 14,
          totalSpent: 186000,
          memberSince: 'Jan 2026',
          recentOrders: const [
            RecentOrderInfo(
              productName: 'Premium Wheat',
              status: 'Delivered',
              date: 'Mar 2, 2026',
              amount: 'PKR 325,000',
              isDelivered: true,
            ),
          ],
          messages: [
            MessageModel(
              id: 'm1',
              text:
                  'Assalamualaikum — we can dispatch 100 bags by Tuesday. Please confirm delivery address.',
              isMine: false,
              time: DateTime.now().subtract(const Duration(minutes: 25)),
            ),
            MessageModel(
              id: 'm2',
              text: 'Please share the final per-bag rate including freight to Lahore.',
              isMine: true,
              time: DateTime.now().subtract(const Duration(minutes: 18)),
            ),
            MessageModel(
              id: 'm3',
              text: 'Bulk wheat quote updated for 100 bags.',
              isMine: false,
              time: DateTime.now().subtract(const Duration(minutes: 12)),
            ),
          ],
        ),
        ConversationModel(
          id: 'BC2',
          buyerName: 'Madinah Agro Supply',
          buyerEmail: 'procurement@madinahagro.pk',
          buyerLocation: 'Multan, Punjab',
          avatarHex: '#7C3AED',
          lastMessage: 'Yellow maize MOQ slots are filling fast.',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
          unreadCount: 1,
          isOnline: true,
          isVip: true,
          totalOrders: 9,
          totalSpent: 94200,
          memberSince: 'Feb 2026',
          recentOrders: const [],
          messages: [
            MessageModel(
              id: 'm1',
              text: 'Yellow maize MOQ slots are filling fast.',
              isMine: false,
              time: DateTime.now().subtract(const Duration(hours: 1)),
            ),
            MessageModel(
              id: 'm2',
              text: 'Hold 30 bags for us until tomorrow — we will confirm by 5 PM.',
              isMine: true,
              time: DateTime.now().subtract(const Duration(minutes: 50)),
            ),
          ],
        ),
        ConversationModel(
          id: 'BC3',
          buyerName: 'Sindh Pulse Hub',
          buyerEmail: 'orders@sindhpulse.pk',
          buyerLocation: 'Larkana, Sindh',
          avatarHex: '#0891B2',
          lastMessage: 'Chickpea sample approved — ready to book.',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
          unreadCount: 0,
          isOnline: false,
          isVip: false,
          totalOrders: 6,
          totalSpent: 41200,
          memberSince: 'Dec 2025',
          recentOrders: const [],
          messages: [
            MessageModel(
              id: 'm1',
              text: 'Chickpea sample approved — ready to book.',
              isMine: false,
              time: DateTime.now().subtract(const Duration(hours: 5)),
            ),
          ],
        ),
        ConversationModel(
          id: 'BC4',
          buyerName: 'Pak Harvest Co.',
          buyerEmail: 'buyers@pakharvest.pk',
          buyerLocation: 'Gujranwala, Punjab',
          avatarHex: '#D97706',
          lastMessage: 'Can you extend the advance booking window?',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
          unreadCount: 3,
          isOnline: false,
          isVip: false,
          totalOrders: 22,
          totalSpent: 210000,
          memberSince: 'Nov 2025',
          recentOrders: const [],
          messages: [
            MessageModel(
              id: 'm1',
              text: 'Can you extend the advance booking window?',
              isMine: false,
              time: DateTime.now().subtract(const Duration(days: 1)),
            ),
            MessageModel(
              id: 'm2',
              text: 'We need 2 more days to finalize internal approval.',
              isMine: true,
              time: DateTime.now().subtract(const Duration(hours: 20)),
            ),
          ],
        ),
      ];
}
