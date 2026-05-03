// lib/features/seller/sidebar/seller_side_bar_scr.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_con.dart';
import 'package:agri_market/features/seller/sidebar/widgets/side_bar_components.dart';

class SellerSideBarScr extends StatelessWidget {
  SellerSideBarScr({super.key});

  SellerSideBarCon get c => Get.find<SellerSideBarCon>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundWhite,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SideBar(c: c),
          Expanded(
            child: Obx(
              () => Stack(
                fit: StackFit.expand,
                children: List.generate(c.screens.length, (i) {
                  return Offstage(
                    offstage: i != c.selectedIndex.value,
                    child: c.visitedScreens[i]
                        ? c.screens[i]
                        : const SizedBox.shrink(),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
