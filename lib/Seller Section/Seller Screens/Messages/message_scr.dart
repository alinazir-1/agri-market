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
        child: Column(
          children: [
            MessageTopBar(messageController: messageController),
            Expanded(
              child: Row(
                children: [
                  ConversationList(messageController: messageController),
                  Expanded(
                      child: ChatWindow(messageController: messageController)),
                  BuyerInfoPanel(messageController: messageController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
