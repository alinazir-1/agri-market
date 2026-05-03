import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/seller/customers/customers_con.dart';
import 'package:agri_market/features/seller/customers/widgets/customer_activity_item.dart';
import 'package:agri_market/features/seller/customers/widgets/top_customer_card.dart';
import '../../../../shared/widgets/common/app_text.dart';

class CustomerSidebar extends StatelessWidget {
  final CustomersCon ctrlCustomers;
  const CustomerSidebar({super.key, required this.ctrlCustomers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topCustomers(),
            const SizedBox(height: AppSize.space20),
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
                  size: AppSize.icon16, color: AppColors.textWarning),
              SizedBox(width: AppSize.space4),
              AppText(
                  text: 'Top Customers',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary),
            ]),
            const SizedBox(height: AppSize.space12),
            ...ctrlCustomers.topCustomers
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
                  size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
              SizedBox(width: AppSize.space4),
              AppText(
                  text: 'Recent Activity',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary),
            ]),
            const SizedBox(height: AppSize.space12),
            ...ctrlCustomers.activityLog
                .map((entry) => CustomerActivityItem(entry: entry)),
          ],
        ));
  }
}
