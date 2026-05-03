import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/notification_model.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/features/seller/notifications/notifications_con.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';

class NotificationsScr extends StatelessWidget {
  NotificationsScr({super.key});

  NotificationsCon get ctrlNotifications => Get.find<NotificationsCon>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTopBar(
              title: 'Notifications',
              subtitle: 'Stay updated on orders, payments and messages',
              searchController: ctrlNotifications.searchController,
              onSearch: ctrlNotifications.onSearch,
              searchHint: 'Search notifications...',
            ),
            _StatsRow(ctrlNotifications: ctrlNotifications),
            _FilterBar(ctrlNotifications: ctrlNotifications),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _NotificationList(
                      ctrlNotifications: ctrlNotifications,
                    ),
                  ),
                  Obx(() {
                    final selected =
                        ctrlNotifications.selectedNotification.value;
                    if (selected == null) return const SizedBox.shrink();
                    return Row(
                      children: [
                        VerticalDivider(
                          width: AppSize.borderWidth1,
                          color: context.borderClr,
                        ),
                        _NotifDetailPanel(
                          ctrlNotifications: ctrlNotifications,
                          notification: selected,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

// ── Stats Row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final NotificationsCon ctrlNotifications;
  const _StatsRow({required this.ctrlNotifications});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final readCount =
          ctrlNotifications.totalCount - ctrlNotifications.unreadCount;
      return SellerMetricStatRow(
        items: [
          SellerMetricStatItem(
            label: 'TOTAL',
            value: '${ctrlNotifications.totalCount}',
            badge: 'In inbox',
            icon: Icons.notifications_none_rounded,
            iconBg: AppColors.backgroundPage,
            iconColor: AppColors.textSecondary,
          ),
          SellerMetricStatItem(
            label: 'UNREAD',
            value: '${ctrlNotifications.unreadCount}',
            badge: 'Needs attention',
            icon: Icons.mark_email_unread_outlined,
            iconBg: AppColors.badgeErrorBg,
            iconColor: AppColors.textError,
            valueColor: AppColors.textError,
          ),
          SellerMetricStatItem(
            label: 'TODAY',
            value: '${ctrlNotifications.todayCount}',
            badge: 'Last 24h',
            icon: Icons.today_outlined,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.badgeSuccessText,
          ),
          SellerMetricStatItem(
            label: 'READ',
            value: '$readCount',
            badge: 'Opened',
            icon: Icons.mark_email_read_outlined,
            iconBg: AppColors.badgeInfoBg,
            iconColor: AppColors.badgeInfoText,
          ),
        ],
      );
    });
  }
}

// ── Filter Bar ─────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final NotificationsCon ctrlNotifications;
  const _FilterBar({required this.ctrlNotifications});

  @override
  Widget build(BuildContext context) {
    /// 💀🔥 ---------------- Notification Tabs And Action ----------------
    return AppContainer(
      backgroundColor: context.cardBg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space20,
        vertical: AppSize.space8, // mapped 10 to 8
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => Wrap(
                spacing: AppSize.space8,
                runSpacing: AppSize.space8,
                children: [
                  _chip(context, 'All', NotificationFilter.all),
                  _chip(context, 'Unread', NotificationFilter.unread),
                  _chip(
                      context, 'Orders & Shipping', NotificationFilter.orders),
                  _chip(context, 'Payments', NotificationFilter.payments),
                  _chip(context, 'System', NotificationFilter.system),
                ],
              ),
            ),
          ),
          Obx(() {
            if (ctrlNotifications.unreadCount <= 0) {
              return const SizedBox.shrink();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: AppSize.space12),
                _MarkAllReadButton(onTap: ctrlNotifications.markAllRead),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, NotificationFilter filter) {
    final isActive = ctrlNotifications.activeFilter.value == filter;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => ctrlNotifications.setFilter(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space12,
            vertical: AppSize.space4, // mapped 5 to 4
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.emeraldGreen
                : context.cardBg, // mapped backGroundEmeraldGreen
            borderRadius: BorderRadius.circular(AppSize.radius20),
            border: Border.all(
              color:
                  isActive ? AppColors.borderEmeraldGreen : context.borderClr,
            ),
          ),
          child: AppText(
            text: label,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.textWhite : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// 💀🔥 ---------------- Mark All Read Hover Button ----------------
class _MarkAllReadButton extends StatelessWidget {
  final VoidCallback onTap;
  _MarkAllReadButton({required this.onTap});

  final RxBool _isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() => AppContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space12,
                vertical: AppSize.space8,
              ),
              backgroundColor: _isHovered.value
                  ? AppColors.badgeSuccessBg
                  : AppColors.backGroundWhite,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              border: Border.all(
                  color: _isHovered.value
                      ? AppColors.borderEmeraldGreen
                      : AppColors.borderLight),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.done_all_rounded,
                    size: AppSize.icon16,
                    color: AppColors.iconEmeraldGreen,
                  ),
                  SizedBox(width: AppSize.space4),
                  AppText(
                    text: 'Mark all as read',
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textEmeraldGreen,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

// ── Notification List ──────────────────────────────────────────────────────

class _NotificationList extends StatelessWidget {
  final NotificationsCon ctrlNotifications;
  const _NotificationList({required this.ctrlNotifications});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrlNotifications.isLoading.value) {
        return const AppSkeletonListColumn();
      }
      final list = ctrlNotifications.filteredNotifications;
      if (list.isEmpty) {
        return const AppEmptyListState(
          message: 'No notifications',
          icon: Icons.notifications_off_outlined,
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space20,
          vertical: AppSize.space16,
        ),
        itemCount: list.length,
        separatorBuilder: (_, __) =>
            Divider(color: context.dividerClr, height: AppSize.borderWidth1),
        itemBuilder: (_, i) => _NotifCard(
          notification: list[i],
          isSelected:
              ctrlNotifications.selectedNotification.value?.id == list[i].id,
          onTap: () => ctrlNotifications.selectNotification(list[i]),
        ),
      );
    });
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isSelected;
  final VoidCallback onTap;

  _NotifCard({
    required this.notification,
    required this.isSelected,
    required this.onTap,
  });

  final RxBool _isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final style =
        _getNotifStyle(n.type); // Helper mapped for missing icon/colors

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space12,
                vertical: AppSize.space12, // mapped 14 to 12
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.badgeSuccessBg.withValues(
                        alpha: 0.5) // mapped emeraldGreen alpha 0.12
                    : _isHovered.value
                        ? context.hoverBg
                        : n.isRead
                            ? AppColors.backGroundTransparent
                            : AppColors.badgeSuccessBg
                                .withValues(alpha: 0.3), // mapped 0xFFF0FDF4
                borderRadius:
                    BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
                border: isSelected
                    ? Border.all(color: AppColors.borderEmeraldGreen)
                    : Border.all(color: AppColors.backGroundTransparent),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  AppContainer(
                    width: AppSize.icon40,
                    height: AppSize.icon40,
                    backgroundColor: style.bg,
                    borderRadius: BorderRadius.circular(
                        AppSize.radius12), // mapped 10 to 12
                    child: Center(
                        child: Icon(style.icon,
                            size: AppSize.icon16,
                            color: style.color)), // mapped 18 to 16
                  ),
                  const SizedBox(width: AppSize.space12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Type badge
                            AppContainer(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.space8,
                                  vertical: 2), // mapped 6 to 8
                              backgroundColor: style.bg,
                              borderRadius:
                                  BorderRadius.circular(AppSize.radius4),
                              child: AppText(
                                text: n.typeLabel,
                                fontSize: AppSize.font8, // mapped 9 to 8
                                fontWeight: FontWeight.w700,
                                color: style.color,
                              ),
                            ),
                            const SizedBox(width: AppSize.space8),
                            Expanded(
                              child: AppText(
                                text: n.title,
                                fontSize: AppSize.font12, // mapped 13 to 12
                                fontWeight: n.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: context.txtPrimary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSize.space4),
                        AppText(
                          text: n.body,
                          fontSize: AppSize.font10,
                          color: n.isRead
                              ? context.txtSecondary
                              : context.txtPrimary,
                          height: 1.4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: AppSize.space12),

                  // Time + unread dot
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        text: Get.find<NotificationsCon>().formatTime(n.time),
                        fontSize: AppSize.font8, // mapped 9 to 8
                        color: context.txtSecondary,
                      ),
                      if (!n.isRead) ...[
                        const SizedBox(height: AppSize.space4), // mapped 5 to 4
                        AppContainer(
                          width: AppSize.space8,
                          height: AppSize.space8,
                          backgroundColor: AppColors.notificationDot,
                          shape: BoxShape.circle,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

// ── Notification Detail Panel ──────────────────────────────────────────────

class _NotifDetailPanel extends StatelessWidget {
  final NotificationsCon ctrlNotifications;
  final NotificationModel notification;

  const _NotifDetailPanel(
      {required this.ctrlNotifications, required this.notification});

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final style = _getNotifStyle(n.type);

    return AppContainer(
      width: 360.0, // Fixed width direct value
      backgroundColor: context.cardBg2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          AppContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space20,
              vertical: AppSize.space12, // mapped 14 to 12
            ),
            backgroundColor: context.cardBg,
            border: Border(bottom: BorderSide(color: context.borderClr)),
            child: Row(
              children: [
                AppText(
                  text: 'Notification Detail',
                  fontSize: AppSize.font12, // mapped 13 to 12
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: ctrlNotifications.clearSelection,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AppContainer(
                      padding:
                          const EdgeInsets.all(AppSize.space4), // mapped 6 to 4
                      backgroundColor: context.cardBg2,
                      borderRadius: BorderRadius.circular(
                          AppSize.radius8), // mapped 6 to 8
                      border: Border.all(color: context.borderClr),
                      child: Icon(Icons.close_rounded,
                          size: AppSize.icon12,
                          color: context.txtSecondary), // mapped 14 to 12
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSize.space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + type badge
                  Row(
                    children: [
                      AppContainer(
                        width: AppSize.icon48,
                        height: AppSize.icon48,
                        backgroundColor: style.bg,
                        borderRadius: BorderRadius.circular(AppSize.radius12),
                        child: Center(
                            child: Icon(style.icon,
                                size: AppSize.icon20,
                                color: style.color)), // mapped 22 to 20
                      ),
                      const SizedBox(width: AppSize.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.space8,
                                vertical: AppSize.space4), // mapped 3 to 4
                            backgroundColor: style.bg,
                            borderRadius: BorderRadius.circular(
                                AppSize.radius8), // mapped 6 to 8
                            child: AppText(
                              text: n.typeLabel,
                              fontSize: AppSize.font10,
                              fontWeight: FontWeight.w700,
                              color: style.color,
                            ),
                          ),
                          const SizedBox(height: AppSize.space4),
                          AppText(
                            text: ctrlNotifications.formatTime(n.time),
                            fontSize: AppSize.font10,
                            color: context.txtSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSize.space16),

                  // Title
                  AppText(
                    text: n.title,
                    fontSize: AppSize.font16,
                    fontWeight: FontWeight.w700,
                    color: context.txtPrimary,
                  ),

                  const SizedBox(height: AppSize.space12),

                  // Divider
                  Divider(
                      color: context.dividerClr, height: AppSize.borderWidth1),

                  const SizedBox(height: AppSize.space12),

                  // Body message
                  AppText(
                    text: n.body,
                    fontSize: AppSize.font12, // mapped 13 to 12
                    color: context.txtSecondary,
                    height: 1.6,
                  ),

                  const SizedBox(height: AppSize.space20),

                  // Status row
                  AppContainer(
                    padding: const EdgeInsets.all(
                        AppSize.space12), // mapped 14 to 12
                    backgroundColor: context.cardBg,
                    borderRadius: BorderRadius.circular(
                        AppSize.radius12), // mapped 10 to 12
                    border: Border.all(color: context.borderClr),
                    child: Row(
                      children: [
                        Icon(
                          n.isRead ? Icons.done_all_rounded : Icons.circle,
                          size: AppSize.icon12, // mapped 14 to 12
                          color: n.isRead
                              ? AppColors.iconEmeraldGreen
                              : AppColors.notificationDot,
                        ),
                        const SizedBox(width: AppSize.space8),
                        AppText(
                          text: n.isRead ? 'Read' : 'Unread',
                          fontSize: AppSize.font10,
                          fontWeight: FontWeight.w600,
                          color: n.isRead
                              ? AppColors.textEmeraldGreen
                              : AppColors.notificationDot,
                        ),
                        const Spacer(),
                        AppText(
                          text: _formatFullTime(n.time),
                          fontSize: AppSize.font10,
                          color: context.txtSecondary,
                        ),
                      ],
                    ),
                  ),

                  if (n.linkedId != null) ...[
                    const SizedBox(height: AppSize.space12),
                    AppContainer(
                      padding: const EdgeInsets.all(
                          AppSize.space12), // mapped 14 to 12
                      backgroundColor: AppColors
                          .badgeSuccessBg, // mapped backgroundEmerald100
                      borderRadius: BorderRadius.circular(
                          AppSize.radius12), // mapped 10 to 12
                      border: Border.all(color: AppColors.borderEmeraldGreen),
                      child: Row(
                        children: [
                          const Icon(Icons.link_rounded,
                              size: AppSize.icon12,
                              color: AppColors
                                  .iconEmeraldGreen), // mapped 14 to 12
                          const SizedBox(width: AppSize.space8),
                          AppText(
                            text: 'Linked: ${n.linkedId}',
                            fontSize: AppSize.font10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textEmeraldGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullTime(DateTime time) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '${time.day} ${months[time.month - 1]} ${time.year}, $h:$m';
  }
}

// ── Helper to resolve missing Model properties ──────────────────────────────

class _NotifStyle {
  final IconData icon;
  final Color bg;
  final Color color;
  const _NotifStyle(this.icon, this.bg, this.color);
}

_NotifStyle _getNotifStyle(NotificationType type) {
  switch (type) {
    case NotificationType.order:
      return const _NotifStyle(Icons.receipt_long_outlined,
          AppColors.badgeInfoBg, AppColors.textInfo);
    case NotificationType.payment:
      return const _NotifStyle(Icons.payments_outlined,
          AppColors.badgeSuccessBg, AppColors.textEmeraldGreen);
    case NotificationType.message:
      return const _NotifStyle(Icons.chat_bubble_outline_rounded,
          AppColors.badgePurpleBg, AppColors.textPurple);
    case NotificationType.shipping:
      return const _NotifStyle(Icons.local_shipping_outlined,
          AppColors.badgeWarningBg, AppColors.textWarning);
    case NotificationType.review:
      return const _NotifStyle(Icons.star_outline_rounded,
          AppColors.badgeWarningBg, AppColors.textWarning);
    case NotificationType.system:
      return const _NotifStyle(Icons.settings_outlined,
          AppColors.backgroundPage, AppColors.textSecondary);
  }
}
