// lib/features/buyer/common/widgets/buyer_top_bar_message_overlay_con.dart
//
// Web hover preview for buyer home message icon (unread-only), mirroring seller
// [TopBarCon] overlay behaviour.

import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/message_model.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_home_messages_con.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_messaging_bottom_sheet.dart';
import 'package:agri_market/features/seller/messages/widgets/top_bar_message_dropdown.dart';

class BuyerTopBarMessageOverlayCon extends GetxController {
  OverlayEntry? msgOverlay;
  Timer? hideTimer;
  final RxBool isDropdownHovered = false.obs;

  BuyerHomeMessagesCon get _msgs => Get.find<BuyerHomeMessagesCon>();

  List<ConversationModel> _unreadPreview() {
    final list = _msgs.conversations
        .where((c) => c.unreadCount > 0)
        .toList()
      ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return list.take(3).toList();
  }

  void onMsgHoverEnter(
    BuildContext context,
    GlobalKey triggerKey,
  ) {
    if (!kIsWeb) return;
    hideTimer?.cancel();
    final recent = _unreadPreview();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (triggerKey.currentContext == null) return;
      _showMessageDropdown(
        context,
        recent,
        triggerKey,
      );
    });
  }

  void onMsgHoverExit() {
    if (!kIsWeb) return;
    hideTimer = Timer(const Duration(milliseconds: 250), () {
      if (!isDropdownHovered.value) removeDropdowns();
    });
  }

  void onDropdownHoverEnter() {
    isDropdownHovered.value = true;
    hideTimer?.cancel();
  }

  void onDropdownHoverExit() {
    isDropdownHovered.value = false;
    hideTimer = Timer(const Duration(milliseconds: 120), () {
      removeDropdowns();
    });
  }

  void removeDropdowns() {
    msgOverlay?.remove();
    msgOverlay = null;
  }

  void _showMessageDropdown(
    BuildContext context,
    List<ConversationModel> conversations,
    GlobalKey triggerKey,
  ) {
    removeDropdowns();
    final ctx = triggerKey.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final iconSize = box.size;
    final screenWidth = MediaQuery.sizeOf(context).width;

    msgOverlay = OverlayEntry(
      builder: (_) => Positioned(
        top: offset.dy + iconSize.height + AppSize.space8,
        right: screenWidth - offset.dx - iconSize.width,
        child: Material(
          color: AppColors.backGroundTransparent,
          child: MouseRegion(
            onEnter: (_) => onDropdownHoverEnter(),
            onExit: (_) => onDropdownHoverExit(),
            child: TopBarMessageDropdown(
              conversations: conversations,
              onViewAll: () {
                removeDropdowns();
                BuyerMessagingBottomSheet.open(context);
              },
              onConversationTap: (c) {
                removeDropdowns();
                _msgs.selectConversation(c.id);
                BuyerMessagingBottomSheet.open(
                  context,
                  openWithChatPanel: true,
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(msgOverlay!);
  }

  void openMessagingSheet(BuildContext context) {
    removeDropdowns();
    BuyerMessagingBottomSheet.open(context);
  }

  @override
  void onClose() {
    hideTimer?.cancel();
    removeDropdowns();
    super.onClose();
  }
}
