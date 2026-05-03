// buyer_message_fab.dart — floating message action (replaces top-bar icon + hover dropdown).
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_home_messages_con.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_top_bar_message_overlay_con.dart';
import 'package:agri_market/features/buyer/home/home_bin.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Circular FAB bottom-end; opens messaging sheet on tap (no hover preview).
class BuyerMessageFab extends StatelessWidget {
  const BuyerMessageFab({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBinding.ensureMessagingControllers();
    final overlay = Get.find<BuyerTopBarMessageOverlayCon>();
    final msgs = Get.find<BuyerHomeMessagesCon>();

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          FloatingActionButton(
            onPressed: () => overlay.openMessagingSheet(context),
            backgroundColor: AppColors.emeraldGreen,
            foregroundColor: AppColors.textWhite,
            elevation: 6,
            tooltip: 'Messages',
            child: const Icon(
              Icons.mark_chat_unread_outlined,
              size: AppSize.icon24,
            ),
          ),
          Positioned(
            right: -2,
            top: -2,
            child: Obx(() {
              final n = msgs.totalUnread;
              if (n <= 0) return const SizedBox.shrink();
              return AppContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                backgroundColor: AppColors.backGroundWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.emeraldGreen,
                  width: AppSize.borderWidth1,
                ),
                child: AppText(
                  text: n > 9 ? '9+' : '$n',
                  fontSize: AppSize.font8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.emeraldGreen,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
