import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/message_model.dart';
import '../message_con.dart';
import 'conv_tab_chip.dart';
import 'conversation_item.dart';

class ConversationList extends StatelessWidget {
  final MessagesCon messageController;
  const ConversationList({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          // Header
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space14,
                  vertical: CSize.space12,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Conversations',
                      style: TextStyle(
                          fontSize: CSize.font13Small,
                          fontWeight: FontWeight.w800,
                          color: CColors.textPrimary),
                    ),
                    if (messageController.totalUnread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CSize.space8, vertical: 2),
                        decoration: BoxDecoration(
                          color: CColors.backGroundEmeraldGreen,
                          borderRadius:
                              BorderRadius.circular(CSize.radius20Large),
                        ),
                        child: Text(
                          '${messageController.totalUnread} unread',
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: CColors.textWhite),
                        ),
                      ),
                  ],
                ),
              )),

          // Search
          Padding(
            padding: const EdgeInsets.all(CSize.space10),
            child: SizedBox(
              height: 32,
              child: TextField(
                controller: messageController.convSearchController,
                onChanged: messageController.onConvSearch,
                style:
                    const TextStyle(fontSize: 10, color: CColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                      fontSize: 10, color: CColors.textSecondary),
                  prefixIcon: const Icon(Icons.search,
                      size: CSize.font13Small, color: CColors.iconEmeraldGreen),
                  filled: true,
                  fillColor: CColors.backGroundLightGrey,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: CSize.space5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CSize.radius20Large),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CSize.radius20Large),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CSize.radius20Large),
                      borderSide: const BorderSide(
                          color: CColors.borderEmeraldGreen,
                          width: CSize.borderWidth1)),
                ),
              ),
            ),
          ),

          // Tabs
          Obx(() => Padding(
                padding: const EdgeInsets.fromLTRB(
                    CSize.space14, 0, CSize.space14, CSize.space8),
                child: Row(children: [
                  ConvTabChip(
                      label: 'All',
                      isActive: messageController.activeTab.value ==
                          ConversationTab.all,
                      onTap: () =>
                          messageController.setTab(ConversationTab.all)),
                  const SizedBox(width: CSize.space5),
                  ConvTabChip(
                      label: 'Unread',
                      isActive: messageController.activeTab.value ==
                          ConversationTab.unread,
                      onTap: () =>
                          messageController.setTab(ConversationTab.unread)),
                  const SizedBox(width: CSize.space5),
                  ConvTabChip(
                      label: 'Orders',
                      isActive: messageController.activeTab.value ==
                          ConversationTab.orders,
                      onTap: () =>
                          messageController.setTab(ConversationTab.orders)),
                ]),
              )),

          // List
          Expanded(
            child: Obx(() {
              final list = messageController.filteredConversations;
              if (list.isEmpty) {
                return const Center(
                  child: Text('No conversations',
                      style: TextStyle(
                          fontSize: CSize.font10XSmall,
                          color: CColors.textSecondary)),
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
