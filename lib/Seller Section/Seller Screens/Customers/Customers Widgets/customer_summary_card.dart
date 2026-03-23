import 'package:agri_market/Seller%20Section/Seller%20Screens/Customers/Customers%20Widgets/customer_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../customers_con.dart';

class SummaryCards extends StatelessWidget {
  final CustomersCon c;
  const SummaryCards({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20,
            vertical: CSize.space14,
          ),
          child: Row(
            children: [
              Expanded(
                  child: CustomerStatCard(
                label: 'Total Customers',
                value: '${c.totalCustomers}',
                badge: '+12 this month',
                icon: Icons.people_alt_outlined,
                iconBg: CColors.backgroundEmerald100,
                iconColor: CColors.iconEmeraldGreen,
                badgeBg: CColors.backgroundEmerald100,
                badgeText: CColors.textEmeraldGreen,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: CustomerStatCard(
                label: 'Active Buyers',
                value: '${c.activeCount}',
                badge: 'Currently active',
                icon: Icons.trending_up_rounded,
                iconBg: CColors.backgroundEmerald100,
                iconColor: CColors.iconEmeraldGreen,
                badgeBg: CColors.backgroundEmerald100,
                badgeText: CColors.textEmeraldGreen,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: CustomerStatCard(
                label: 'VIP Customers',
                value: '${c.vipCount}',
                badge: 'High value',
                icon: Icons.star_outline_rounded,
                iconBg: const Color(0xFFFEF9C3),
                iconColor: const Color(0xFFCA8A04),
                badgeBg: const Color(0xFFFEF9C3),
                badgeText: const Color(0xFF854D0E),
                valueColor: const Color(0xFFCA8A04),
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: CustomerStatCard(
                label: 'Total Revenue',
                value: '\$${(c.totalRevenue / 1000).toStringAsFixed(0)}k',
                badge: 'Lifetime',
                icon: Icons.attach_money_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF3B82F6),
                badgeBg: const Color(0xFFEFF6FF),
                badgeText: const Color(0xFF1D4ED8),
                valueColor: const Color(0xFF1D4ED8),
              )),
            ],
          ),
        ));
  }
}
