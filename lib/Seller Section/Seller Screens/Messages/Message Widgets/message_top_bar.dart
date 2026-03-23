import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../message_con.dart';

class MessageTopBar extends StatelessWidget {
  final MessagesCon messageController;
  const MessageTopBar({super.key, required this.messageController});

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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: TextStyle(
                  fontSize: CSize.font24Large,
                  fontWeight: FontWeight.w900,
                  color: CColors.textPrimary,
                ),
              ),
              SizedBox(height: CSize.space2),
              Text(
                'Communicate with your buyers',
                style: TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: CSize.space20),
          SizedBox(
            width: 280,
            height: 36,
            child: TextField(
              controller: messageController.topSearchController,
              onChanged: messageController.onTopSearch,
              style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle:
                    const TextStyle(fontSize: 11, color: CColors.textSecondary),
                prefixIcon: const Icon(Icons.search,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                filled: true,
                fillColor: CColors.backGroundLightGrey,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: CSize.space10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(
                    color: CColors.borderEmeraldGreen,
                    width: CSize.borderWidth1,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Stack(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: CColors.backGroundWhite,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: CColors.notificationDot,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: CColors.backGroundWhite, width: 1.5),
                ),
              ),
            ),
          ]),
          const SizedBox(width: CSize.space8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: CColors.backGroundWhite,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(Icons.messenger_outline_rounded,
                size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
          ),
          const SizedBox(width: CSize.space8),
          const CircleAvatar(
            radius: 17,
            backgroundColor: CColors.backGroundEmeraldGreen,
            child: Text('AS',
                style: TextStyle(
                    fontSize: CSize.font10XSmall,
                    fontWeight: FontWeight.w800,
                    color: CColors.textWhite)),
          ),
        ],
      ),
    );
  }
}
