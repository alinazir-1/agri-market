import 'package:agri_market/Seller%20Section/Seller%20Screens/Customers/Customers%20Widgets/customer_activity_item.dart';
import 'package:agri_market/Seller%20Section/Seller%20Screens/Customers/Customers%20Widgets/top_customer_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../customers_con.dart';

class Sidebar extends StatelessWidget {
  final CustomersCon c;
  const Sidebar({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(CSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topCustomers(),
            const SizedBox(height: CSize.space20),
            _activityLog(),
          ],
        ),
      ),
    );
  }

  Widget _topCustomers() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.star_outline_rounded,
                  size: CSize.icon16Small, color: Color(0xFFCA8A04)),
              SizedBox(width: CSize.space5),
              Text('Top Customers',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: CColors.textPrimary)),
            ]),
            const SizedBox(height: CSize.space10),
            ...c.topCustomers
                .map((customer) => TopCustomerCard(customer: customer)),
          ],
        ));
  }

  Widget _activityLog() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.timeline_rounded,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
              SizedBox(width: CSize.space5),
              Text('Recent Activity',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: CColors.textPrimary)),
            ]),
            const SizedBox(height: CSize.space10),
            ...c.activityLog.map((entry) => CustomerActivityItem(entry: entry)),
          ],
        ));
  }
}
