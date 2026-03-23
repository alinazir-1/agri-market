import 'package:agri_market/Seller%20Section/Seller%20Screens/Side%20Bar/side_bar_con.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import 'Side Bar Widgets/side_bar_widget.dart';

class SellerSideBarScr extends StatelessWidget {
  SellerSideBarScr({super.key});

  final SellerSideBarCon c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.backGroundWhite,
      body: SafeArea(
        child: Row(
          children: [
            SideBar(c: c),
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: c.selectedIndex.value,
                  children: c.screens,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
