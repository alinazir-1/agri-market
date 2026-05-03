import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/getx/lazy_controller.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/message_model.dart';
import 'package:agri_market/data/models/notification_model.dart';
import 'package:agri_market/features/seller/messages/message_con.dart';
import 'package:agri_market/features/seller/messages/widgets/top_bar_message_dropdown.dart';
import 'package:agri_market/features/seller/notifications/notifications_con.dart';
import 'package:agri_market/features/seller/notifications/widgets/top_bar_notification_dropdown.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_con.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import '../common/app_container.dart';
import '../common/app_text.dart';
import '../common/app_text_field.dart';

/// UI state for top bar hover overlays (no [StatefulWidget]).
class TopBarCon extends GetxController {
  final notifKey = GlobalKey();
  final msgKey = GlobalKey();
  OverlayEntry? notifOverlay;
  OverlayEntry? msgOverlay;
  Timer? hideTimer;
  final RxBool isDropdownHovered = false.obs;

  NotificationsCon? get notifCon {
    try {
      return Get.find<NotificationsCon>();
    } catch (_) {
      return null;
    }
  }

  MessagesCon? get msgCon {
    try {
      return Get.find<MessagesCon>();
    } catch (_) {
      return null;
    }
  }

  void onNotifHoverEnter(BuildContext context) {
    if (!kIsWeb) return;
    hideTimer?.cancel();
    final list = notifCon?.notifications.toList() ?? [];
    if (list.isEmpty) return;
    list.sort((a, b) => b.time.compareTo(a.time));
    final recent = list.take(3).toList();
    // Defer overlay work past the pointer/mouse tracker phase (avoids
    // mouse_tracker.dart !_debugDuringDeviceUpdate on Flutter Web).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notifKey.currentContext == null) return;
      _showNotificationDropdown(context, recent);
    });
  }

  void onNotifHoverExit() {
    if (!kIsWeb) return;
    hideTimer = Timer(const Duration(milliseconds: 250), () {
      if (!isDropdownHovered.value) removeDropdowns();
    });
  }

  void onMsgHoverEnter(BuildContext context) {
    if (!kIsWeb) return;
    hideTimer?.cancel();
    final list = msgCon?.conversations.toList() ?? [];
    if (list.isEmpty) return;
    list.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    final recent = list.take(3).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (msgKey.currentContext == null) return;
      _showMessageDropdown(context, recent);
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

  void _showNotificationDropdown(
    BuildContext context,
    List<NotificationModel> notifications,
  ) {
    removeDropdowns();
    final ctx = notifKey.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final iconSize = box.size;
    final screenWidth = MediaQuery.sizeOf(context).width;

    notifOverlay = OverlayEntry(
      builder: (overlayCtx) => Positioned(
        top: offset.dy + iconSize.height + AppSize.space8,
        right: screenWidth - offset.dx - iconSize.width,
        child: Material(
          color: AppColors.backGroundTransparent,
          child: MouseRegion(
            onEnter: (_) => onDropdownHoverEnter(),
            onExit: (_) => onDropdownHoverExit(),
            child: TopBarNotificationDropdown(
              notifications: notifications,
              onViewAll: navigateToNotifications,
              con: notifCon,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(notifOverlay!);
  }

  void _showMessageDropdown(
    BuildContext context,
    List<ConversationModel> conversations,
  ) {
    removeDropdowns();
    final ctx = msgKey.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final iconSize = box.size;
    final screenWidth = MediaQuery.sizeOf(context).width;

    msgOverlay = OverlayEntry(
      builder: (overlayCtx) => Positioned(
        top: offset.dy + iconSize.height + AppSize.space8,
        right: screenWidth - offset.dx - iconSize.width,
        child: Material(
          color: AppColors.backGroundTransparent,
          child: MouseRegion(
            onEnter: (_) => onDropdownHoverEnter(),
            onExit: (_) => onDropdownHoverExit(),
            child: TopBarMessageDropdown(
              conversations: conversations,
              onViewAll: () => navigateToMessages(),
              onConversationTap: (c) =>
                  navigateToMessages(conversationId: c.id),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(msgOverlay!);
  }

  void removeDropdowns() {
    notifOverlay?.remove();
    notifOverlay = null;
    msgOverlay?.remove();
    msgOverlay = null;
  }

  void navigateToNotifications() {
    removeDropdowns();
    try {
      Get.find<SellerSideBarCon>().changeScreen(11);
    } catch (_) {}
  }

  void navigateToMessages({String? conversationId}) {
    removeDropdowns();
    if (conversationId != null) {
      msgCon?.selectConversation(conversationId);
    }
    try {
      Get.find<SellerSideBarCon>().changeScreen(7);
    } catch (_) {}
  }

  void navigateToBusinessProfile() {
    removeDropdowns();
    try {
      Get.find<SellerSideBarCon>().changeScreen(12);
    } catch (_) {}
  }

  void navigateToBuyerMode() {
    removeDropdowns();
    // Must not push a second [HomeScr] on top of the shell: [HomeCon]'s [GlobalKey]s (nav anchor,
    // hero search, category strip columns) would then mount twice → duplicate GlobalKey crash.
    Get.offAllNamed(AppRoutes.buyerDashboard);
  }

  @override
  void onClose() {
    hideTimer?.cancel();
    removeDropdowns();
    super.onClose();
  }
}

/// Universal top bar used across all Seller screens.
class ScreenTopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearch;
  final String searchHint;
  final double searchWidth;

  const ScreenTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.searchController,
    this.onSearch,
    this.searchHint = 'Search...',
    this.searchWidth = 280,
  });

  @override
  Widget build(BuildContext context) {
    final TopBarCon ctrlTopBar =
        lazyPutFind(() => TopBarCon(), tag: title);

    final width = MediaQuery.sizeOf(context).width;
    final effectiveSearchWidth = searchWidth.clamp(0.0, width * 0.28);

    Widget notifIcon = GestureDetector(
      onTap: ctrlTopBar.navigateToNotifications,
      child: Stack(
        key: ctrlTopBar.notifKey,
        clipBehavior: Clip.none,
        children: [
          AppContainer(
            width: 32,
            height: 32,
            backgroundColor: AppColors.backGroundWhite,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderLight),
            child: const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                size: AppSize.icon20,
                color: AppColors.iconEmeraldGreen,
              ),
            ),
          ),
          Obx(() {
            final n = Get.find<NotificationsCon>().notifications;
            final count = n.where((x) => !x.isRead).length;
            if (count == 0) return const SizedBox.shrink();
            return Positioned(
              top: 1,
              right: 1,
              child: AppContainer(
                width: AppSize.space8,
                height: AppSize.space8,
                backgroundColor: AppColors.notificationDot,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.backGroundWhite,
                  width: 1.5,
                ),
              ),
            );
          }),
        ],
      ),
    );
    if (kIsWeb) {
      notifIcon = MouseRegion(
        onEnter: (_) => ctrlTopBar.onNotifHoverEnter(context),
        onExit: (_) => ctrlTopBar.onNotifHoverExit(),
        cursor: SystemMouseCursors.click,
        child: notifIcon,
      );
    }

    Widget msgIcon = GestureDetector(
      onTap: () => ctrlTopBar.navigateToMessages(),
      child: Stack(
        key: ctrlTopBar.msgKey,
        clipBehavior: Clip.none,
        children: [
          AppContainer(
            width: 32,
            height: 32,
            backgroundColor: AppColors.backGroundWhite,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderLight),
            child: const Center(
              child: Icon(
                Icons.messenger_outline_rounded,
                size: AppSize.icon20,
                color: AppColors.iconEmeraldGreen,
              ),
            ),
          ),
          Obx(() {
            final conv = Get.find<MessagesCon>().conversations;
            final count =
                conv.fold<int>(0, (sum, c) => sum + c.unreadCount);
            if (count == 0) return const SizedBox.shrink();
            return Positioned(
              top: 1,
              right: 1,
              child: AppContainer(
                width: AppSize.space8,
                height: AppSize.space8,
                backgroundColor: AppColors.notificationDot,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.backGroundWhite,
                  width: 1.5,
                ),
              ),
            );
          }),
        ],
      ),
    );
    if (kIsWeb) {
      msgIcon = MouseRegion(
        onEnter: (_) => ctrlTopBar.onMsgHoverEnter(context),
        onExit: (_) => ctrlTopBar.onMsgHoverExit(),
        cursor: SystemMouseCursors.click,
        child: msgIcon,
      );
    }

    return AppContainer(
      backgroundColor: AppColors.backGroundWhite,
      border: const Border(bottom: BorderSide(color: AppColors.borderLight)),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space20,
        vertical: AppSize.space12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: title,
                  fontSize: AppSize.font24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space4),
                AppText(
                  text: subtitle,
                  fontSize: AppSize.font10,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (searchController != null) ...[
            const SizedBox(width: AppSize.space20),
            SizedBox(
              width: effectiveSearchWidth,
              height: 36, // Fixed height
              child: AppTextField(
                controller: searchController,
                onChanged: onSearch,
                hintText: searchHint,
                hintStyle: const TextStyle(
                  fontSize: AppSize.font10,
                  color: AppColors.textSecondary,
                  height:
                      1.2, // Hint text ki height line icon ke sath match karne ke liye
                ),
                prefixIcon: Icons.search,
                iconColor: AppColors.iconEmeraldGreen,
                iconSize: AppSize.icon16,
                filled: true,
                fillColor: AppColors.backGroundLightGrey,
                isDense: true,
                // Content Padding ko adjust kiya gaya hai taake text center mein rahe
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12,
                  vertical: 0, // Height fixed hai isliye vertical 0 rakhein
                ),
                customBorder: const OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppSize.radius8)),
                  borderSide: BorderSide(color: AppColors.borderLight),
                ),
                customFocusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  borderSide: const BorderSide(
                    color: AppColors.borderEmeraldGreen,
                    width: AppSize.borderWidth1,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(width: AppSize.space20),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: ctrlTopBar.navigateToBuyerMode,
              child: AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12,
                  vertical: AppSize.space8,
                ),
                borderRadius: BorderRadius.circular(AppSize.radius8),
                border: Border.all(color: AppColors.borderLight),
                backgroundColor: AppColors.backGroundWhite,
                child: const AppText(
                  text: 'Buyer Mode',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSize.space8),
          notifIcon,
          const SizedBox(width: AppSize.space8),
          msgIcon,
          const SizedBox(width: AppSize.space8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: ctrlTopBar.navigateToBusinessProfile,
              child: const Tooltip(
                message: 'Business Profile',
                child: AppContainer(
                  width: 32,
                  height: 32,
                  shape: BoxShape.circle,
                  backgroundColor: AppColors.emeraldGreen,
                  child: Center(
                    child: AppText(
                      text: 'AS',
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
