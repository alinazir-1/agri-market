// lib/features/seller/messages/message_scr.dart

import 'package:agri_market/features/seller/messages/widgets/call_phone_dialog.dart';
import 'package:agri_market/features/seller/messages/widgets/message_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/features/seller/messages/message_con.dart';

import '../../../core/constants/sizes.dart';

class MessagesScr extends StatelessWidget {
  MessagesScr({super.key});

  MessagesCon get messageController => Get.find<MessagesCon>();

  @override
  Widget build(BuildContext context) {
    final c = messageController;
    return Scaffold(
      backgroundColor: context.appBg,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              MessageTopBar(messageController: c),
              Expanded(
                child: Row(
                  children: [
                    ConversationList(messageController: c),
                    Expanded(child: ChatWindow(messageController: c)),
                    BuyerInfoPanel(messageController: c),
                  ],
                ),
              ),
            ],
          ),
          Obx(() {
            if (!c.callActive.value || !c.callMinimized.value) {
              return const SizedBox.shrink();
            }
            return Positioned(
              left: AppSize.space16,
              right: AppSize.space16,
              bottom: AppSize.space16,
              child: CallMinimizedBar(
                name: c.callPeerName.value,
                onExpand: c.expandCall,
                onEnd: c.endCall,
              ),
            );
          }),
        ],
      ),
    );
  }
}
