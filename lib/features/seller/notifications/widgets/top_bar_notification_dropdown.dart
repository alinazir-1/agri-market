import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/notification_model.dart';
import 'package:agri_market/features/seller/notifications/notifications_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Lightweight hover preview for the seller top bar (recent notifications).
class TopBarNotificationDropdown extends StatelessWidget {
  final List<NotificationModel> notifications;
  final VoidCallback onViewAll;
  final NotificationsCon? con;

  const TopBarNotificationDropdown({
    super.key,
    required this.notifications,
    required this.onViewAll,
    required this.con,
  });

  @override
  Widget build(BuildContext context) {
    final unreadTotal = con?.unreadCount ?? 0;
    final panelW = min(320.0, MediaQuery.sizeOf(context).width * 0.92);

    return AppContainer(
      width: panelW,
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius12),
      border: Border.all(color: AppColors.borderLight),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.10),
          blurRadius: AppSize.space24,
          offset: const Offset(0, 8),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12,
              vertical: AppSize.space12,
            ),
            child: Row(
              children: [
                const AppText(
                  text: 'Notifications',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSize.space8),
                if (unreadTotal > 0)
                  AppContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space8,
                      vertical: 2,
                    ),
                    backgroundColor: AppColors.notificationDot,
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    child: AppText(
                      text: '$unreadTotal unread',
                      fontSize: AppSize.font8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.backgroundDivider,
            height: AppSize.borderWidth1,
          ),
          ...notifications.map(
            (n) => TopBarNotificationDropdownItem(n: n, con: con),
          ),
          const Divider(
            color: AppColors.backgroundDivider,
            height: AppSize.borderWidth1,
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onViewAll,
              child: AppContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSize.space12),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSize.radius12),
                  bottomRight: Radius.circular(AppSize.radius12),
                ),
                child: const Center(
                  child: AppText(
                    text: 'View all notifications →',
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textEmeraldGreen,
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

class TopBarNotificationDropdownItem extends StatelessWidget {
  final NotificationModel n;
  final NotificationsCon? con;

  TopBarNotificationDropdownItem({
    super.key,
    required this.n,
    required this.con,
  });

  final RxBool _isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    final style = _getNotifStyle(n.type);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: GestureDetector(
        onTap: () => con?.selectNotification(n),
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: _isHovered.value
                ? AppColors.backgroundHover
                : AppColors.backGroundTransparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12,
              vertical: AppSize.space12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppContainer(
                  width: AppSize.icon32,
                  height: AppSize.icon32,
                  backgroundColor: style.bg,
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  child: Center(
                    child: Icon(
                      style.icon,
                      size: AppSize.icon16,
                      color: style.color,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: n.title,
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        text: n.body,
                        fontSize: AppSize.font10,
                        color: AppColors.textSecondary,
                        height: 1.3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSize.space8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      text: _formatTime(n.time),
                      fontSize: AppSize.font8,
                      color: AppColors.textSecondary,
                    ),
                    if (!n.isRead) ...[
                      const SizedBox(height: AppSize.space4),
                      AppContainer(
                        width: 6.0,
                        height: 6.0,
                        backgroundColor: AppColors.notificationDot,
                        shape: BoxShape.circle,
                      ),
                    ],
                  ],
                ),
              ],
            ),
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

class _NotifStyle {
  final IconData icon;
  final Color bg;
  final Color color;
  const _NotifStyle(this.icon, this.bg, this.color);
}

_NotifStyle _getNotifStyle(NotificationType type) {
  switch (type) {
    case NotificationType.order:
      return const _NotifStyle(
        Icons.receipt_long_outlined,
        AppColors.badgeInfoBg,
        AppColors.textInfo,
      );
    case NotificationType.payment:
      return const _NotifStyle(
        Icons.payments_outlined,
        AppColors.badgeSuccessBg,
        AppColors.textEmeraldGreen,
      );
    case NotificationType.message:
      return const _NotifStyle(
        Icons.chat_bubble_outline_rounded,
        AppColors.badgePurpleBg,
        AppColors.textPurple,
      );
    case NotificationType.shipping:
      return const _NotifStyle(
        Icons.local_shipping_outlined,
        AppColors.badgeWarningBg,
        AppColors.textWarning,
      );
    case NotificationType.review:
      return const _NotifStyle(
        Icons.star_outline_rounded,
        AppColors.badgeWarningBg,
        AppColors.textWarning,
      );
    case NotificationType.system:
      return const _NotifStyle(
        Icons.settings_outlined,
        AppColors.backgroundPage,
        AppColors.textSecondary,
      );
  }
}
