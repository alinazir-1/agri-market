// ── 1. Conversation Item ──────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/message_model.dart';

class ConversationItem extends StatelessWidget {
  final ConversationModel conversation;
  final bool isSelected;
  final String timeText;
  final VoidCallback onTap;

  const ConversationItem({
    super.key,
    required this.conversation,
    required this.isSelected,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: CSize.space14,
          vertical: CSize.space10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? CColors.backgroundEmerald100
              : CColors.backGroundWhite,
          border: Border(
            bottom: const BorderSide(color: Color(0xFFF9FAFB), width: 0.5),
            right: isSelected
                ? const BorderSide(color: CColors.borderEmeraldGreen, width: 3)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            // Avatar with online dot
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: conversation.avatarColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      conversation.initials,
                      style: const TextStyle(
                        fontSize: CSize.font13Small,
                        fontWeight: FontWeight.w800,
                        color: CColors.textWhite,
                      ),
                    ),
                  ),
                  if (conversation.isOnline)
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: CColors.backGroundWhite, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: CSize.space10),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.buyerName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: CColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeText,
                        style: const TextStyle(
                            fontSize: 9, color: CColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: CSize.space2),
                  Text(
                    conversation.lastMessage,
                    style: TextStyle(
                      fontSize: 10,
                      color: conversation.unreadCount > 0
                          ? CColors.textPrimary
                          : CColors.textSecondary,
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Unread badge
            if (conversation.unreadCount > 0) ...[
              const SizedBox(width: CSize.space8),
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: CColors.backGroundEmeraldGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${conversation.unreadCount}',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: CColors.textWhite,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
