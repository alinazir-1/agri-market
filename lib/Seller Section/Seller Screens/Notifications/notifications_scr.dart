import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Data/Models/notification_model.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'notifications_con.dart';

class NotificationsScr extends StatelessWidget {
  final NotificationsCon c = Get.find();

  NotificationsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTopBar(
              title: 'Notifications',
              subtitle: 'Stay updated on orders, payments and messages',
              searchController: c.searchController,
              onSearch: c.onSearch,
              searchHint: 'Search notifications...',
            ),
            _StatsRow(c: c),
            _FilterBar(c: c),
            Expanded(child: _NotificationList(c: c)),
          ],
        ),
      ),
    );
  }
}

// ── Stats Row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final NotificationsCon c;
  const _StatsRow({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: context.cardBg2,
            border: Border(bottom: BorderSide(color: context.borderClr)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20,
            vertical: CSize.space14,
          ),
          child: Row(
            children: [
              _StatCard(
                label: 'Total',
                value: '${c.totalCount}',
                icon: Icons.notifications_none_rounded,
                iconBg: const Color(0xFFF3F4F6),
                iconColor: const Color(0xFF6B7280),
              ),
              const SizedBox(width: CSize.space12),
              _StatCard(
                label: 'Unread',
                value: '${c.unreadCount}',
                icon: Icons.mark_email_unread_outlined,
                iconBg: const Color(0xFFFEE2E2),
                iconColor: CColors.textError,
                valueColor: CColors.textError,
              ),
              const SizedBox(width: CSize.space12),
              _StatCard(
                label: 'Today',
                value: '${c.todayCount}',
                icon: Icons.today_outlined,
                iconBg: CColors.backgroundEmerald100,
                iconColor: CColors.iconEmeraldGreen,
              ),
              const Spacer(),
              if (c.unreadCount > 0)
                GestureDetector(
                  onTap: c.markAllRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space14,
                      vertical: CSize.space8,
                    ),
                    decoration: BoxDecoration(
                      color: context.cardBg,
                      borderRadius:
                          BorderRadius.circular(CSize.radius10Medium),
                      border: Border.all(color: context.borderClr),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.done_all_rounded,
                            size: CSize.icon16Small,
                            color: CColors.iconEmeraldGreen),
                        SizedBox(width: CSize.space5),
                        Text(
                          'Mark all as read',
                          style: TextStyle(
                            fontSize: CSize.font10XSmall,
                            fontWeight: FontWeight.w600,
                            color: CColors.textEmeraldGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color? valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space14,
        vertical: CSize.space10,
      ),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(color: context.borderClr),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: CSize.space10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: CSize.font16Medium,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? context.txtPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: context.txtSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Filter Bar ─────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final NotificationsCon c;
  const _FilterBar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: context.cardBg,
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20,
            vertical: CSize.space10,
          ),
          child: Row(
            children: [
              _chip('All', NotificationFilter.all),
              const SizedBox(width: CSize.space8),
              _chip('Unread', NotificationFilter.unread),
              const SizedBox(width: CSize.space8),
              _chip('Orders & Shipping', NotificationFilter.orders),
              const SizedBox(width: CSize.space8),
              _chip('Payments', NotificationFilter.payments),
              const SizedBox(width: CSize.space8),
              _chip('System', NotificationFilter.system),
            ],
          ),
        ));
  }

  Widget _chip(String label, NotificationFilter filter) {
    final isActive = c.activeFilter.value == filter;
    return GestureDetector(
      onTap: () => c.setFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: CSize.space12,
          vertical: CSize.space5,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? CColors.backGroundEmeraldGreen
              : context.cardBg,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(
            color: isActive
                ? CColors.borderEmeraldGreen
                : context.borderClr,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: CSize.font10XSmall,
            fontWeight: FontWeight.w600,
            color: isActive ? CColors.textWhite : CColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Notification List ──────────────────────────────────────────────────────

class _NotificationList extends StatelessWidget {
  final NotificationsCon c;
  const _NotificationList({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = c.filteredNotifications;
      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.notifications_off_outlined,
                  size: CSize.icon36XLarge, color: CColors.textSecondary),
              SizedBox(height: CSize.space12),
              Text(
                'No notifications',
                style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w600,
                  color: CColors.textSecondary,
                ),
              ),
              SizedBox(height: CSize.space4),
              Text(
                'You\'re all caught up!',
                style: TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: CSize.space20,
          vertical: CSize.space16,
        ),
        itemCount: list.length,
        separatorBuilder: (_, __) =>
            Divider(color: context.dividerClr, height: 1),
        itemBuilder: (_, i) => _NotifCard(
          notification: list[i],
          onTap: () => c.markAsRead(list[i].id),
        ),
      );
    });
  }
}

class _NotifCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotifCard({required this.notification, required this.onTap});

  @override
  State<_NotifCard> createState() => _NotifCardState();
}

class _NotifCardState extends State<_NotifCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.notification;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12,
            vertical: CSize.space14,
          ),
          decoration: BoxDecoration(
            color: _hovered
                ? context.hoverBg
                : n.isRead
                    ? Colors.transparent
                    : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: n.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(n.icon, size: 18, color: n.iconColor),
              ),
              const SizedBox(width: CSize.space12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: n.iconBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            n.typeLabel,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: n.iconColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: CSize.space8),
                        Expanded(
                          child: Text(
                            n.title,
                            style: TextStyle(
                              fontSize: CSize.font13Small,
                              fontWeight: n.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: context.txtPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CSize.space4),
                    Text(
                      n.body,
                      style: TextStyle(
                        fontSize: CSize.font10XSmall,
                        color: n.isRead
                            ? context.txtSecondary
                            : context.txtPrimary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: CSize.space12),

              // Time + unread dot
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Get.find<NotificationsCon>().formatTime(n.time),
                    style: TextStyle(
                      fontSize: 9,
                      color: context.txtSecondary,
                    ),
                  ),
                  if (!n.isRead) ...[
                    const SizedBox(height: CSize.space5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: CColors.notificationDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
