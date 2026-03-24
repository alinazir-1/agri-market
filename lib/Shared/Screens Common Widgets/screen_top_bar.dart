import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/sizes.dart';
import '../../Seller Section/Seller Screens/Messages/message_con.dart';
import '../../Seller Section/Seller Screens/Notifications/notifications_con.dart';
import '../../Seller Section/Seller Screens/Side Bar/side_bar_con.dart';
import '../../Data/Models/notification_model.dart';

/// Universal top bar used across all Seller screens.
class ScreenTopBar extends StatefulWidget {
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
  State<ScreenTopBar> createState() => _ScreenTopBarState();
}

class _ScreenTopBarState extends State<ScreenTopBar> {
  final _notifKey = GlobalKey();
  OverlayEntry? _notifOverlay;
  Timer? _hideTimer;

  // ── Safe controller accessors ─────────────────────────────────────────────

  NotificationsCon? get _notifCon {
    try {
      return Get.find<NotificationsCon>();
    } catch (_) {
      return null;
    }
  }

  MessagesCon? get _msgCon {
    try {
      return Get.find<MessagesCon>();
    } catch (_) {
      return null;
    }
  }

  // ── Overlay management ────────────────────────────────────────────────────

  void _onNotifHoverEnter() {
    _hideTimer?.cancel();
    final unread = _notifCon?.notifications
            .where((n) => !n.isRead)
            .take(3)
            .toList() ??
        [];
    if (unread.isEmpty) return;
    _showDropdown(unread);
  }

  void _onNotifHoverExit() {
    _hideTimer = Timer(const Duration(milliseconds: 250), () {
      if (mounted) _removeDropdown();
    });
  }

  void _onDropdownHoverEnter() => _hideTimer?.cancel();

  void _onDropdownHoverExit() {
    _hideTimer = Timer(const Duration(milliseconds: 120), () {
      if (mounted) _removeDropdown();
    });
  }

  void _showDropdown(List<NotificationModel> unread) {
    _removeDropdown();
    final ctx = _notifKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final iconSize = box.size;
    final screenWidth = MediaQuery.of(context).size.width;

    _notifOverlay = OverlayEntry(
      builder: (_) => Positioned(
        top: offset.dy + iconSize.height + 8,
        right: screenWidth - offset.dx - iconSize.width,
        child: Material(
          color: Colors.transparent,
          child: MouseRegion(
            onEnter: (_) => _onDropdownHoverEnter(),
            onExit: (_) => _onDropdownHoverExit(),
            child: _NotifDropdown(
              notifications: unread,
              onViewAll: _navigateToNotifications,
              con: _notifCon,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_notifOverlay!);
  }

  void _removeDropdown() {
    _notifOverlay?.remove();
    _notifOverlay = null;
  }

  void _navigateToNotifications() {
    _removeDropdown();
    try {
      Get.find<SellerSideBarCon>().changeScreen(11);
    } catch (_) {}
  }

  void _navigateToMessages() {
    try {
      Get.find<SellerSideBarCon>().changeScreen(7);
    } catch (_) {}
  }

  void _navigateToBusinessProfile() {
    try {
      Get.find<SellerSideBarCon>().changeScreen(12);
    } catch (_) {}
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _removeDropdown();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space20,
        vertical: CSize.space12,
      ),
      child: Row(
        children: [
          // ── Title + Subtitle ─────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: CSize.font24Large,
                  fontWeight: FontWeight.w900,
                  color: CColors.textPrimary,
                ),
              ),
              const SizedBox(height: CSize.space2),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(width: CSize.space20),

          // ── Search Field ─────────────────────────────────────────────────
          SizedBox(
            width: widget.searchWidth,
            height: 36,
            child: TextField(
              controller: widget.searchController,
              onChanged: widget.onSearch,
              style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: const TextStyle(
                    fontSize: 11, color: CColors.textSecondary),
                prefixIcon: const Icon(Icons.search,
                    size: CSize.icon16Small,
                    color: CColors.iconEmeraldGreen),
                filled: true,
                fillColor: CColors.backGroundLightGrey,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: CSize.space10),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(
                      color: CColors.borderEmeraldGreen,
                      width: CSize.borderWidth1),
                ),
              ),
            ),
          ),

          const Spacer(),

          // ── Notification Button ──────────────────────────────────────────
          MouseRegion(
            onEnter: (_) => _onNotifHoverEnter(),
            onExit: (_) => _onNotifHoverExit(),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _navigateToNotifications,
              child: Stack(
                key: _notifKey,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: CColors.backGroundWhite,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      size: CSize.icon16Small,
                      color: CColors.iconEmeraldGreen,
                    ),
                  ),
                  // Red dot — only when unread notifications exist
                  Obx(() {
                    final count = _notifCon?.unreadCount ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: CColors.notificationDot,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: CColors.backGroundWhite, width: 1.5),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(width: CSize.space8),

          // ── Message Button ───────────────────────────────────────────────
          GestureDetector(
            onTap: _navigateToMessages,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Stack(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: CColors.backGroundWhite,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.messenger_outline_rounded,
                      size: CSize.icon16Small,
                      color: CColors.iconEmeraldGreen,
                    ),
                  ),
                  // Red dot — only when unread messages exist
                  Obx(() {
                    final count = _msgCon?.totalUnread ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: CColors.notificationDot,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: CColors.backGroundWhite, width: 1.5),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(width: CSize.space8),

          // ── User Avatar ──────────────────────────────────────────────────
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _navigateToBusinessProfile,
              child: Tooltip(
                message: 'Business Profile',
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: CColors.backGroundEmeraldGreen,
                  child: const Text(
                    'AS',
                    style: TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w800,
                      color: CColors.textWhite,
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

// ── Notification Dropdown Panel ────────────────────────────────────────────

class _NotifDropdown extends StatelessWidget {
  final List<NotificationModel> notifications;
  final VoidCallback onViewAll;
  final NotificationsCon? con;

  const _NotifDropdown({
    required this.notifications,
    required this.onViewAll,
    required this.con,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space14,
              vertical: CSize.space12,
            ),
            child: Row(
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: CSize.font13Small,
                    fontWeight: FontWeight.w700,
                    color: CColors.textPrimary,
                  ),
                ),
                const SizedBox(width: CSize.space8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CColors.notificationDot,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${notifications.length} new',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: CColors.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),

          // Notification items
          ...notifications.map((n) => _DropdownItem(n: n, con: con)),

          const Divider(color: Color(0xFFF1F5F9), height: 1),

          // View all link
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: CSize.space12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(CSize.radius10Medium),
                  bottomRight: Radius.circular(CSize.radius10Medium),
                ),
              ),
              child: const Center(
                child: Text(
                  'View all notifications →',
                  style: TextStyle(
                    fontSize: CSize.font10XSmall,
                    fontWeight: FontWeight.w600,
                    color: CColors.textEmeraldGreen,
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

class _DropdownItem extends StatefulWidget {
  final NotificationModel n;
  final NotificationsCon? con;

  const _DropdownItem({required this.n, required this.con});

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.n;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.con?.markAsRead(n.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: _hovered ? const Color(0xFFF8FAFC) : Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space14,
            vertical: CSize.space10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: n.iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(n.icon, size: 15, color: n.iconColor),
              ),
              const SizedBox(width: CSize.space10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: CColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      n.body,
                      style: const TextStyle(
                        fontSize: 10,
                        color: CColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: CSize.space8),
              Column(
                children: [
                  Text(
                    _formatTime(n.time),
                    style: const TextStyle(
                        fontSize: 9, color: CColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: CColors.notificationDot,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
