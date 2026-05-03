import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class HomeBulkMoqBand extends StatelessWidget {
  const HomeBulkMoqBand({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppContainer(
      backgroundColor: AppColors.backgroundPage,
      padding: EdgeInsets.fromLTRB(
        AppSize.space32,
        0,
        AppSize.space32,
        AppSize.space16,
      ),
      child: Row(
        children: [
          Expanded(
            child: _BulkMoqCard(
              title: 'Bulk Deals',
              subtitle: 'High-volume offers for wholesale buyers',
              valueLine: 'Up to 18% savings on 100+ bag orders',
              footLine: 'Best for mills, distributors, and exporters',
              icon: Icons.inventory_2_outlined,
              iconBg: AppColors.badgeSuccessBg,
            ),
          ),
          SizedBox(width: AppSize.space16),
          Expanded(
            child: _BulkMoqCard(
              title: 'MOQ Deals',
              subtitle: 'Small-to-mid quantity sourcing with flexibility',
              valueLine: 'MOQ starts from 20 bags in selected categories',
              footLine: 'Ideal for retailers and growing procurement teams',
              icon: Icons.tune_rounded,
              iconBg: AppColors.badgeInfoBg,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulkMoqCard extends StatelessWidget {
  const _BulkMoqCard({
    required this.title,
    required this.subtitle,
    required this.valueLine,
    required this.footLine,
    required this.icon,
    required this.iconBg,
  });

  final String title;
  final String subtitle;
  final String valueLine;
  final String footLine;
  final IconData icon;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space16),
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius12),
      border: Border.all(color: AppColors.borderLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppContainer(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                backgroundColor: iconBg,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: AppColors.iconEmeraldGreen,
                  size: AppSize.icon20,
                ),
              ),
              const SizedBox(width: AppSize.space12),
              Expanded(
                child: AppText(
                  text: title,
                  fontSize: AppSize.font18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.space12),
          AppText(
            text: subtitle,
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text: valueLine,
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w600,
            color: AppColors.textInfo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text: footLine,
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
