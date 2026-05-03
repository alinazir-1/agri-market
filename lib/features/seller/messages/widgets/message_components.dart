// lib/features/seller/messages/widgets/message_widgets.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/message_model.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/features/seller/messages/message_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';

// ─── HEX HELPER ───────────────────────────────────────────────────────────────
Color _hex(String hex) {
  final c = hex.replaceAll('#', '');
  return Color(int.parse('FF$c', radix: 16));
}

// ─── MESSAGE TOP BAR ──────────────────────────────────────────────────────────
class MessageTopBar extends StatelessWidget {
  final MessagesCon messageController;
  const MessageTopBar({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) => ScreenTopBar(
        title: 'Messages',
        subtitle: 'Communicate with your buyers',
        searchController: messageController.topSearchController,
        onSearch: messageController.onTopSearch,
        searchHint: 'Search conversations...',
      );
}

// ─── ORDER CARD (inside bubble) ───────────────────────────────────────────────
class OrderCard extends StatelessWidget {
  final OrderCardData data;
  const OrderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(top: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space8),
      backgroundColor: AppColors.badgeSuccessBg,
      borderRadius: BorderRadius.circular(AppSize.radius8),
      border: Border.all(color: AppColors.emerald100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
              text: 'Order ${data.orderId}',
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w700,
              color: AppColors.textEmeraldGreen),
          const SizedBox(height: AppSize.space4),
          _orderRow('Product', data.productName),
          _orderRow('Qty', data.quantity),
          _orderRow('Total', data.total),
        ],
      ),
    );
  }

  Widget _orderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSize.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
              text: label,
              fontSize: AppSize.font8,
              color: AppColors.textSecondary),
          AppText(
              text: value,
              fontSize: AppSize.font8,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

// ─── MESSAGE BUBBLE ───────────────────────────────────────────────────────────
class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String senderInitials;
  final String senderHex;
  final String timeText;

  const MessageBubble({
    super.key,
    required this.message,
    required this.senderInitials,
    required this.senderHex,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: message.isMine ? TextDirection.rtl : TextDirection.ltr,
          children: [
            AppContainer(
              width: 26,
              height: 26,
              backgroundColor: _hex(senderHex),
              shape: BoxShape.circle,
              alignment: Alignment.center,
              child: AppText(
                  text: senderInitials,
                  fontSize: AppSize.font8,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite),
            ),
            const SizedBox(width: AppSize.space8),
            Flexible(
              child: Column(
                crossAxisAlignment: message.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  AppContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.space12, vertical: AppSize.space8),
                    backgroundColor: message.isMine
                        ? AppColors.emeraldGreen
                        : AppColors.backGroundWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: message.isMine
                          ? const Radius.circular(16)
                          : const Radius.circular(AppSize.radius4),
                      bottomRight: message.isMine
                          ? const Radius.circular(AppSize.radius4)
                          : const Radius.circular(16),
                    ),
                    border: message.isMine
                        ? null
                        : Border.all(color: AppColors.borderLight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: message.text,
                            fontSize: AppSize.font12,
                            height: 1.5,
                            color: message.isMine
                                ? AppColors.textWhite
                                : AppColors.textPrimary),
                        if (message.type == MessageType.orderCard &&
                            message.orderCard != null)
                          OrderCard(data: message.orderCard!),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSize.space2),
                  AppText(
                      text: message.isMine ? '$timeText ✓✓' : timeText,
                      fontSize: AppSize.font8,
                      color: AppColors.textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── DATE DIVIDER ─────────────────────────────────────────────────────────────
class MessageDateDivider extends StatelessWidget {
  final String label;
  const MessageDateDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: AppColors.borderLight, thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.space8),
          child: AppText(
              text: label,
              fontSize: AppSize.font8,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600),
        ),
        const Expanded(
            child: Divider(color: AppColors.borderLight, thickness: 0.5)),
      ],
    );
  }
}

// ─── CONV TAB CHIP ────────────────────────────────────────────────────────────
class ConvTabChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ConvTabChip(
      {super.key,
      required this.label,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space12, vertical: AppSize.space4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.emeraldGreen : AppColors.backGroundWhite,
          borderRadius: BorderRadius.circular(AppSize.radius20),
          border: Border.all(
              color: isActive
                  ? AppColors.borderEmeraldGreen
                  : AppColors.borderLight),
        ),
        child: AppText(
            text: label,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.textWhite : AppColors.textSecondary),
      ),
    );
  }
}

// ─── BUYER INFO ROW ───────────────────────────────────────────────────────────
class BuyerInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const BuyerInfoRow(
      {super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(vertical: AppSize.space4),
      border: const Border(
          bottom: BorderSide(color: AppColors.backgroundSurface, width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
              text: label,
              fontSize: AppSize.font10,
              color: AppColors.textSecondary),
          AppText(
              text: value,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary),
        ],
      ),
    );
  }
}

// ─── BUYER ORDER CARD ─────────────────────────────────────────────────────────
class BuyerOrderCard extends StatelessWidget {
  final RecentOrderInfo order;
  const BuyerOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space8),
      backgroundColor: AppColors.backgroundSurface,
      borderRadius: BorderRadius.circular(AppSize.radius8),
      border: Border.all(color: AppColors.borderLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: AppText(
                      text: order.productName,
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
              AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space4, vertical: AppSize.space2),
                backgroundColor: order.isDelivered
                    ? AppColors.badgeInfoBg
                    : AppColors.badgeSuccessBg,
                borderRadius: BorderRadius.circular(AppSize.radius20),
                child: AppText(
                    text: order.status,
                    fontSize: AppSize.font8,
                    fontWeight: FontWeight.w700,
                    color: order.isDelivered
                        ? AppColors.badgeInfoText
                        : AppColors.badgeSuccessText),
              ),
            ],
          ),
          const SizedBox(height: AppSize.space2),
          AppText(
              text: '${order.date} · ${order.amount}',
              fontSize: AppSize.font8,
              color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

// ─── CONVERSATION ITEM ────────────────────────────────────────────────────────
class ConversationItem extends StatelessWidget {
  final ConversationModel conversation;
  final bool isSelected;
  final String timeText;
  final VoidCallback onTap;

  /// When the list sits on the **right** of the chat, draw the selection stripe
  /// on the **left** so it faces the chat pane.
  final bool selectionStripeOnLeft;

  const ConversationItem({
    super.key,
    required this.conversation,
    required this.isSelected,
    required this.timeText,
    required this.onTap,
    this.selectionStripeOnLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space16, vertical: AppSize.space8),
        backgroundColor:
            isSelected ? AppColors.badgeSuccessBg : AppColors.backGroundWhite,
        border: Border(
          bottom:
              const BorderSide(color: AppColors.backgroundSurface, width: 0.5),
          left: selectionStripeOnLeft && isSelected
              ? const BorderSide(
                  color: AppColors.borderEmeraldGreen, width: 3)
              : BorderSide.none,
          right: !selectionStripeOnLeft && isSelected
              ? const BorderSide(
                  color: AppColors.borderEmeraldGreen, width: 3)
              : BorderSide.none,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                  AppContainer(
                    width: 38,
                    height: 38,
                    backgroundColor: _hex(conversation.avatarHex),
                    shape: BoxShape.circle,
                    alignment: Alignment.center,
                    child: AppText(
                        text: conversation.initials,
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textWhite),
                  ),
                  if (conversation.isOnline)
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: AppContainer(
                        width: 9,
                        height: 9,
                        backgroundColor: AppColors.emeraldGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.backGroundWhite, width: 1.5),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSize.space8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: AppText(
                              text: conversation.buyerName,
                              fontSize: AppSize.font12,
                              fontWeight: conversation.unreadCount > 0
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: AppColors.textPrimary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)),
                      AppText(
                          text: timeText,
                          fontSize: AppSize.font8,
                          color: AppColors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: AppSize.space2),
                  AppText(
                      text: conversation.lastMessage,
                      fontSize: AppSize.font10,
                      color: conversation.unreadCount > 0
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (conversation.unreadCount > 0) ...[
              const SizedBox(width: AppSize.space8),
              AppContainer(
                width: 18,
                height: 18,
                backgroundColor: AppColors.emeraldGreen,
                shape: BoxShape.circle,
                alignment: Alignment.center,
                child: AppText(
                    text: '${conversation.unreadCount}',
                    fontSize: AppSize.font8,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textWhite),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── CONVERSATION LIST ────────────────────────────────────────────────────────
class ConversationList extends StatelessWidget {
  final MessagesCon messageController;

  /// When the list is the **trailing** child in a [Row] (chat on the left), use a
  /// left border so the divider sits against the chat pane.
  final bool listPlacedAtRowEnd;

  /// When false, hides the "Conversations" / unread header row (e.g. buyer dock
  /// supplies its own "Messaging" chrome).
  final bool showSectionHeader;

  const ConversationList({
    super.key,
    required this.messageController,
    this.listPlacedAtRowEnd = false,
    this.showSectionHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: 300,
      backgroundColor: AppColors.backGroundWhite,
      border: listPlacedAtRowEnd
          ? const Border(left: BorderSide(color: AppColors.borderLight))
          : const Border(right: BorderSide(color: AppColors.borderLight)),
      child: Column(
        children: [
          if (showSectionHeader)
            Obx(() => AppContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space16, vertical: AppSize.space12),
                  border: const Border(
                      bottom: BorderSide(color: AppColors.backgroundDivider)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                          text: 'Conversations',
                          fontSize: AppSize.font12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary),
                      if (messageController.totalUnread > 0)
                        AppContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.space8,
                              vertical: AppSize.space2),
                          backgroundColor: AppColors.emeraldGreen,
                          borderRadius: BorderRadius.circular(AppSize.radius20),
                          child: AppText(
                              text: '${messageController.totalUnread} unread',
                              fontSize: AppSize.font8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textWhite),
                        ),
                    ],
                  ),
                )),
          Padding(
            padding: const EdgeInsets.all(AppSize.space8),
            child: SizedBox(
              height: 32,
              child: TextField(
                controller: messageController.convSearchController,
                onChanged: messageController.onConvSearch,
                style: const TextStyle(
                    fontSize: AppSize.font10, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                      fontSize: AppSize.font10, color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search,
                      size: AppSize.font12, color: AppColors.iconEmeraldGreen),
                  filled: true,
                  fillColor: AppColors.backGroundLightGrey,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: AppSize.space4),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.radius20),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.radius20),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.radius20),
                      borderSide: const BorderSide(
                          color: AppColors.borderEmeraldGreen,
                          width: AppSize.borderWidth1)),
                ),
              ),
            ),
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSize.space16, 0, AppSize.space16, AppSize.space8),
                child: Row(children: [
                  ConvTabChip(
                      label: 'All',
                      isActive: messageController.activeTab.value ==
                          ConversationTab.all,
                      onTap: () =>
                          messageController.setTab(ConversationTab.all)),
                  const SizedBox(width: AppSize.space4),
                  ConvTabChip(
                      label: 'Unread',
                      isActive: messageController.activeTab.value ==
                          ConversationTab.unread,
                      onTap: () =>
                          messageController.setTab(ConversationTab.unread)),
                  const SizedBox(width: AppSize.space4),
                  ConvTabChip(
                      label: 'Orders',
                      isActive: messageController.activeTab.value ==
                          ConversationTab.orders,
                      onTap: () =>
                          messageController.setTab(ConversationTab.orders)),
                ]),
              )),
          Expanded(
            child: Obx(() {
              if (messageController.isLoading.value) {
                return const AppSkeletonListColumn();
              }
              final list = messageController.filteredConversations;
              if (list.isEmpty) {
                return const AppEmptyListState(
                  message: 'No conversations',
                  icon: Icons.chat_bubble_outline_rounded,
                );
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final conv = list[index];
                  return ConversationItem(
                    conversation: conv,
                    isSelected:
                        messageController.selectedConversationId.value ==
                            conv.id,
                    timeText:
                        messageController.formatTime(conv.lastMessageTime),
                    onTap: () => messageController.selectConversation(conv.id),
                    selectionStripeOnLeft: listPlacedAtRowEnd,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── CHAT WINDOW ──────────────────────────────────────────────────────────────
class ChatWindow extends StatelessWidget {
  final MessagesCon messageController;
  const ChatWindow({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conv = messageController.selectedConversation;
      if (conv == null) {
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.chat_bubble_outline_rounded,
                size: AppSize.icon40, color: AppColors.textSecondary),
            const SizedBox(height: AppSize.space12),
            const AppText(
                text: 'Select a conversation',
                fontSize: AppSize.font12,
                color: AppColors.textSecondary),
          ]),
        );
      }
      return AppContainer(
        backgroundColor: AppColors.backgroundSurface,
        child: Column(
          children: [
            _chatHeader(conv),
            Expanded(child: _chatMessages(conv)),
            _chatInput(),
          ],
        ),
      );
    });
  }

  Widget _chatHeader(ConversationModel conv) {
    return AppContainer(
      backgroundColor: AppColors.backGroundWhite,
      border: const Border(bottom: BorderSide(color: AppColors.borderLight)),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space16, vertical: AppSize.space8),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: Stack(children: [
              AppContainer(
                width: 36,
                height: 36,
                backgroundColor: _hex(conv.avatarHex),
                shape: BoxShape.circle,
                alignment: Alignment.center,
                child: AppText(
                    text: conv.initials,
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textWhite),
              ),
              if (conv.isOnline)
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: AppContainer(
                      width: 9,
                      height: 9,
                      backgroundColor: AppColors.emeraldGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.backGroundWhite, width: 1.5)),
                ),
            ]),
          ),
          const SizedBox(width: AppSize.space8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppText(
                text: conv.buyerName,
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary),
            AppText(
                text: conv.isOnline ? 'Online' : 'Offline',
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w600,
                color: conv.isOnline
                    ? AppColors.emeraldGreen
                    : AppColors.textSecondary),
          ]),
          const Spacer(),
          GestureDetector(
            onTap: () => messageController.startCall(conv.buyerName),
            child: AppContainer(
              width: 30,
              height: 30,
              backgroundColor: AppColors.backGroundWhite,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              border: Border.all(color: AppColors.borderLight),
              child: const Icon(Icons.call_outlined,
                  size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
            ),
          ),
          const SizedBox(width: AppSize.space8),
          AppContainer(
            width: 30,
            height: 30,
            backgroundColor: AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius8),
            border: Border.all(color: AppColors.borderLight),
            child: const Icon(Icons.more_horiz_rounded,
                size: AppSize.icon16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _chatMessages(ConversationModel conv) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSize.space16),
      itemCount: conv.messages.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppSize.space8),
      itemBuilder: (context, index) {
        if (index == 0) return const MessageDateDivider(label: 'Today');
        final msg = conv.messages[index - 1];
        return MessageBubble(
          message: msg,
          senderInitials: msg.isMine
              ? messageController.outgoingMessageBubbleInitials
              : conv.initials,
          senderHex: msg.isMine
              ? messageController.outgoingMessageBubbleHex
              : conv.avatarHex,
          timeText: messageController.formatMessageTime(msg.time),
        );
      },
    );
  }

  Widget _chatInput() {
    return AppContainer(
      backgroundColor: AppColors.backGroundWhite,
      border: const Border(top: BorderSide(color: AppColors.borderLight)),
      padding: const EdgeInsets.all(AppSize.space8),
      child: Row(
        children: [
          AppContainer(
            width: 32,
            height: 32,
            backgroundColor: AppColors.backGroundLightGrey,
            borderRadius: BorderRadius.circular(AppSize.radius20),
            child: const Icon(Icons.attach_file_rounded,
                size: AppSize.icon16, color: AppColors.textSecondary),
          ),
          const SizedBox(width: AppSize.space8),
          Expanded(
            child: AppContainer(
              height: 40,
              backgroundColor: AppColors.backGroundLightGrey,
              borderRadius: BorderRadius.circular(AppSize.radius20),
              padding: const EdgeInsets.symmetric(horizontal: AppSize.space16),
              child: TextField(
                controller: messageController.messageInputController,
                onSubmitted: (_) => messageController.sendMessage(),
                style: const TextStyle(
                    fontSize: AppSize.font12, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: messageController.messageComposerHint,
                  hintStyle: const TextStyle(
                      fontSize: AppSize.font12, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: AppSize.space8),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSize.space8),
          GestureDetector(
            onTap: () => messageController.sendMessage(),
            child: Obx(() => AppContainer(
                  width: 36,
                  height: 36,
                  backgroundColor: AppColors.emeraldGreen,
                  shape: BoxShape.circle,
                  alignment: Alignment.center,
                  child: messageController.isSending.value
                      ? const AppInlineProgress()
                      : const Icon(Icons.send_rounded,
                          size: AppSize.icon16,
                          color: AppColors.iconWhite),
                )),
          ),
        ],
      ),
    );
  }
}

// ─── BUYER INFO PANEL ─────────────────────────────────────────────────────────
class BuyerInfoPanel extends StatelessWidget {
  final MessagesCon messageController;
  const BuyerInfoPanel({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conv = messageController.selectedConversation;
      if (conv == null) return const SizedBox(width: 260);
      return AppContainer(
        width: 260,
        backgroundColor: AppColors.backGroundWhite,
        border: const Border(left: BorderSide(color: AppColors.borderLight)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSize.space16),
          child: Column(
            children: [
              _buyerHeader(conv),
              const SizedBox(height: AppSize.space16),
              _buyerStats(conv),
              const SizedBox(height: AppSize.space16),
              _recentOrders(conv),
            ],
          ),
        ),
      );
    });
  }

  Widget _buyerHeader(ConversationModel conv) {
    return Column(
      children: [
        AppContainer(
          width: 52,
          height: 52,
          backgroundColor: _hex(conv.avatarHex),
          shape: BoxShape.circle,
          alignment: Alignment.center,
          child: AppText(
              text: conv.initials,
              fontSize: AppSize.font18,
              fontWeight: FontWeight.w800,
              color: AppColors.textWhite),
        ),
        const SizedBox(height: AppSize.space8),
        AppText(
            text: conv.buyerName,
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary),
        const SizedBox(height: AppSize.space2),
        AppText(
            text: conv.buyerEmail,
            fontSize: AppSize.font10,
            color: AppColors.textSecondary),
        if (conv.isVip) ...[
          const SizedBox(height: AppSize.space8),
          AppContainer(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: AppSize.space4),
            backgroundColor: AppColors.badgeWarningBg,
            borderRadius: BorderRadius.circular(AppSize.radius20),
            child: const AppText(
                text: 'VIP Customer',
                fontSize: AppSize.font8,
                fontWeight: FontWeight.w700,
                color: AppColors.badgeWarningText),
          ),
        ],
        const SizedBox(height: AppSize.space12),
        const Divider(
            height: 1, thickness: 0.5, color: AppColors.backgroundDivider),
      ],
    );
  }

  Widget _buyerStats(ConversationModel conv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
            text: 'BUYER INFO',
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5),
        const SizedBox(height: AppSize.space8),
        BuyerInfoRow(label: 'Location', value: conv.buyerLocation),
        BuyerInfoRow(
            label: 'Total Orders', value: '${conv.totalOrders} orders'),
        BuyerInfoRow(
            label: 'Total Spent',
            value: '\$${conv.totalSpent.toStringAsFixed(0)}',
            valueColor: AppColors.textEmeraldGreen),
        BuyerInfoRow(label: 'Member Since', value: conv.memberSince),
      ],
    );
  }

  Widget _recentOrders(ConversationModel conv) {
    if (conv.recentOrders.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
            text: 'RECENT ORDERS',
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5),
        const SizedBox(height: AppSize.space8),
        ...conv.recentOrders.map((order) => BuyerOrderCard(order: order)),
      ],
    );
  }
}
