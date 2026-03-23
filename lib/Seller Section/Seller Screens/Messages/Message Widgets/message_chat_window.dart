import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/message_model.dart';
import '../message_con.dart';
import 'message_bubble.dart';
import 'message_data_divider.dart';

class ChatWindow extends StatelessWidget {
  final MessagesCon messageController;
  const ChatWindow({required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conv = messageController.selectedConversation;
      if (conv == null) {
        return const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.chat_bubble_outline_rounded,
                size: CSize.icon36XLarge, color: CColors.textSecondary),
            SizedBox(height: CSize.space12),
            Text('Select a conversation',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
          ]),
        );
      }
      return Container(
        color: const Color(0xFFF8FAFC),
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
    return Container(
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space16,
        vertical: CSize.space10,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: Stack(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: conv.avatarColor, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(conv.initials,
                    style: const TextStyle(
                        fontSize: CSize.font13Small,
                        fontWeight: FontWeight.w800,
                        color: CColors.textWhite)),
              ),
              if (conv.isOnline)
                Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: CColors.backGroundWhite, width: 1.5)),
                    )),
            ]),
          ),
          const SizedBox(width: CSize.space10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(conv.buyerName,
                style: const TextStyle(
                    fontSize: CSize.font13Small,
                    fontWeight: FontWeight.w800,
                    color: CColors.textPrimary)),
            Text(
              conv.isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: conv.isOnline
                      ? const Color(0xFF22C55E)
                      : CColors.textSecondary),
            ),
          ]),
          const Spacer(),
          // Call button
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: CColors.backGroundWhite,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(color: const Color(0xFFE2E8F0))),
            child: const Icon(Icons.call_outlined,
                size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
          ),
          const SizedBox(width: CSize.space8),
          // More button
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: CColors.backGroundWhite,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(color: const Color(0xFFE2E8F0))),
            child: const Icon(Icons.more_horiz_rounded,
                size: CSize.icon16Small, color: CColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _chatMessages(ConversationModel conv) {
    return ListView.separated(
      padding: const EdgeInsets.all(CSize.space16),
      itemCount: conv.messages.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: CSize.space10),
      itemBuilder: (context, index) {
        if (index == 0) return const MessageDateDivider(label: 'Today');
        final msg = conv.messages[index - 1];
        return MessageBubble(
          message: msg,
          senderInitials: msg.isMine ? 'AS' : conv.initials,
          senderColor:
              msg.isMine ? CColors.backGroundEmeraldGreen : conv.avatarColor,
          timeText: messageController.formatMessageTime(msg.time),
        );
      },
    );
  }

  Widget _chatInput() {
    return Container(
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.all(CSize.space10),
      child: Row(
        children: [
          // Attach
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: CColors.backGroundLightGrey,
                borderRadius: BorderRadius.circular(CSize.radius20Large)),
            child: const Icon(Icons.attach_file_rounded,
                size: CSize.icon16Small, color: CColors.textSecondary),
          ),
          const SizedBox(width: CSize.space8),
          // Input
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: CColors.backGroundLightGrey,
                borderRadius: BorderRadius.circular(CSize.radius24XLarge),
              ),
              padding: const EdgeInsets.symmetric(horizontal: CSize.space14),
              child: TextField(
                controller: messageController.messageInputController,
                onSubmitted: (_) => messageController.sendMessage(),
                style:
                    const TextStyle(fontSize: 11, color: CColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle:
                      TextStyle(fontSize: 11, color: CColors.textSecondary),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: CSize.space10),
                ),
              ),
            ),
          ),
          const SizedBox(width: CSize.space8),
          // Send
          GestureDetector(
            onTap: messageController.sendMessage,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: CColors.backGroundEmeraldGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded,
                  size: CSize.icon16Small, color: CColors.iconWhite),
            ),
          ),
        ],
      ),
    );
  }
}
