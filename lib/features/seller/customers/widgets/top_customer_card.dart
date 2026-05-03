import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/customer_model.dart';
import 'package:agri_market/features/seller/customers/widgets/customer_avatar.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class TopCustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const TopCustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius12),
      border: Border.all(color: AppColors.borderLight),
      child: Row(
        children: [
          CustomerAvatar(
              initials: customer.initials,
              avatarHex: customer.avatarHex,
              size: 32),
          const SizedBox(width: AppSize.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: customer.name,
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText(
                  text: '${customer.totalOrders} orders · ${customer.location}',
                  fontSize: AppSize.font10,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          AppText(
            text: '\$${(customer.totalSpent / 1000).toStringAsFixed(1)}k',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w700,
            color: AppColors.textEmeraldGreen,
          ),
        ],
      ),
    );
  }
}
