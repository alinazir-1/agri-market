import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/features/seller/customers/customers_con.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';

class SummaryCards extends StatelessWidget {
  final CustomersCon ctrlCustomers;
  const SummaryCards({super.key, required this.ctrlCustomers});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SellerMetricStatRow(
        items: [
          SellerMetricStatItem(
            label: 'TOTAL CUSTOMERS',
            value: '${ctrlCustomers.totalCustomers}',
            badge: 'All buyers',
            icon: Icons.people_alt_outlined,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.badgeSuccessText,
          ),
          SellerMetricStatItem(
            label: 'ACTIVE BUYERS',
            value: '${ctrlCustomers.activeCount}',
            badge: 'Engaged',
            icon: Icons.trending_up_rounded,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.iconEmeraldGreen,
          ),
          SellerMetricStatItem(
            label: 'VIP CUSTOMERS',
            value: '${ctrlCustomers.vipCount}',
            badge: 'High value',
            icon: Icons.star_outline_rounded,
            iconBg: AppColors.badgeWarningBg,
            iconColor: AppColors.badgeWarningText,
            valueColor: AppColors.badgeWarningText,
          ),
          SellerMetricStatItem(
            label: 'TOTAL REVENUE',
            value:
                '\$${(ctrlCustomers.totalRevenue / 1000).toStringAsFixed(0)}k',
            badge: 'Lifetime',
            icon: Icons.attach_money_rounded,
            iconBg: AppColors.badgeInfoBg,
            iconColor: AppColors.badgeInfoText,
            valueColor: AppColors.badgeInfoText,
          ),
        ],
      ),
    );
  }
}
