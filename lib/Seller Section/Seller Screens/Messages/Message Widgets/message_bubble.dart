// ── 2. Message Bubble ────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/message_model.dart';
import 'order_card.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String senderInitials;
  final Color senderColor;
  final String timeText;

  const MessageBubble({
    super.key,
    required this.message,
    required this.senderInitials,
    required this.senderColor,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.45,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: message.isMine ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Avatar
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: senderColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                senderInitials,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: CColors.textWhite,
                ),
              ),
            ),
            const SizedBox(width: CSize.space8),
            // Bubble + time
            Flexible(
              child: Column(
                crossAxisAlignment: message.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space12,
                      vertical: CSize.space8,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMine
                          ? CColors.backGroundEmeraldGreen
                          : CColors.backGroundWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: message.isMine
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: message.isMine
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                      border: message.isMine
                          ? null
                          : Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            color: message.isMine
                                ? CColors.textWhite
                                : CColors.textPrimary,
                          ),
                        ),
                        // Order card inside bubble
                        if (message.type == MessageType.orderCard &&
                            message.orderCard != null)
                          OrderCard(data: message.orderCard!),
                      ],
                    ),
                  ),
                  const SizedBox(height: CSize.space2),
                  Text(
                    message.isMine ? '$timeText ✓✓' : timeText,
                    style: TextStyle(
                      fontSize: 8,
                      color: message.isMine
                          ? CColors.textSecondary
                          : CColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
