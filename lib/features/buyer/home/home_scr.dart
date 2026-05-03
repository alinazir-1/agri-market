// home_scr.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/features/buyer/common/widgets/buyer_message_fab.dart';
import 'package:agri_market/features/buyer/home/home_bin.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/features/buyer/home/widgets/home_widgets.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_top_bar.dart';

class HomeScr extends StatelessWidget {
  const HomeScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4EF),
      floatingActionButton: const BuyerMessageFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const BuyerTopBar(),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification n) {
                if (n.metrics.axis != Axis.vertical) return false;
                HomeBinding.ensureHomeCon();
                Get.find<HomeCon>().syncCompactTopBarSearchVisibility(context);
                return false;
              },
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    HomeTickerBar(),
                    HomeHeroSourcingBanner(),
                    HomeGlobalSourcingCtaBand(),
                    HomeCampaignBannerBand(),
                    HomeFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
