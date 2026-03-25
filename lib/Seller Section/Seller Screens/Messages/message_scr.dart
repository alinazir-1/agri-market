import 'package:agri_market/Seller%20Section/Seller%20Screens/Messages/Message%20Widgets/message_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import 'Message Widgets/buyer_info_panel.dart';
import 'Message Widgets/conversation_list.dart';
import 'Message Widgets/message_chat_window.dart';
import 'message_con.dart';

class MessagesScr extends StatelessWidget {
  final MessagesCon messageController = Get.find();

  MessagesScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isMobile = width < 600;
            final isTablet = width >= 600 && width < 900;

            return Column(
              children: [
                MessageTopBar(messageController: messageController),
                Expanded(
                  child: Obx(() {
                    final hasConv =
                        messageController.selectedConversation != null;

                    // ── Mobile layout ──────────────────────────────────────
                    if (isMobile) {
                      if (hasConv) {
                        // Show chat window with a back button to return to list
                        return Column(
                          children: [
                            _MobileBackBar(
                              onBack: messageController.clearSelection,
                              title: messageController
                                      .selectedConversation?.buyerName ??
                                  '',
                            ),
                            Expanded(
                              child: ChatWindow(
                                  messageController: messageController),
                            ),
                          ],
                        );
                      }
                      // Show conversation list (300px, fits on mobile)
                      return ConversationList(
                          messageController: messageController);
                    }

                    // ── Tablet layout (no buyer info panel) ────────────────
                    if (isTablet) {
                      return Row(
                        children: [
                          ConversationList(
                              messageController: messageController),
                          Expanded(
                            child: ChatWindow(
                                messageController: messageController),
                          ),
                        ],
                      );
                    }

                    // ── Desktop layout (all 3 panels) ─────────────────────
                    return Row(
                      children: [
                        ConversationList(
                            messageController: messageController),
                        Expanded(
                            child:
                                ChatWindow(messageController: messageController)),
                        BuyerInfoPanel(
                            messageController: messageController),
                      ],
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Back bar shown on mobile when a conversation is open.
class _MobileBackBar extends StatelessWidget {
  final VoidCallback onBack;
  final String title;

  const _MobileBackBar({required this.onBack, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.backGroundWhite,
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space12,
        vertical: CSize.space10,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: CSize.icon20Medium,
              color: CColors.iconEmeraldGreen,
            ),
          ),
          const SizedBox(width: CSize.space12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: CSize.font13Small,
                fontWeight: FontWeight.w700,
                color: CColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
