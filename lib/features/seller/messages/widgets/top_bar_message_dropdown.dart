import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/message_model.dart';
import 'package:agri_market/features/seller/messages/message_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Lightweight hover preview for the seller top bar (recent conversations).
class TopBarMessageDropdown extends StatelessWidget {
  final List<ConversationModel> conversations;
  final VoidCallback onViewAll;
  final void Function(ConversationModel c) onConversationTap;

  const TopBarMessageDropdown({
    super.key,
    required this.conversations,
    required this.onViewAll,
    required this.onConversationTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  text: 'Messages',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.backgroundDivider,
            height: AppSize.borderWidth1,
          ),
          ...conversations.map(
            (c) => TopBarMessageDropdownItem(
              conversation: c,
              onTap: () => onConversationTap(c),
            ),
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
                    text: 'View all messages →',
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

class TopBarMessageDropdownItem extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  TopBarMessageDropdownItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final RxBool _isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final avatarColor = MessagesCon.hexToColor(c.avatarHex);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: GestureDetector(
        onTap: onTap,
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
                  shape: BoxShape.circle,
                  backgroundColor: avatarColor,
                  child: Center(
                    child: AppText(
                      text: c.initials,
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: c.buyerName,
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        text: c.lastMessage,
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
                      text: _formatTime(c.lastMessageTime),
                      fontSize: AppSize.font8,
                      color: AppColors.textSecondary,
                    ),
                    if (c.unreadCount > 0) ...[
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
