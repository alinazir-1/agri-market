import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class _RecentOrderLine {
  const _RecentOrderLine(this.title, this.qtyLabel, this.timeAgo, this.stars);
  final String title;
  final String qtyLabel;
  final String timeAgo;
  final int stars;
}

class BuyerProductDetailRecentOrdersCard extends StatelessWidget {
  const BuyerProductDetailRecentOrdersCard({super.key});

  static const List<_RecentOrderLine> _orders = [
    _RecentOrderLine('Maize Grain', '12 tons', '1 day ago', 5),
    _RecentOrderLine('Wheat Bran', '8 tons', '3 days ago', 4),
    _RecentOrderLine('Rice Polish', '20 tons', '1 week ago', 5),
  ];

  @override
  Widget build(BuildContext context) {
    final orders = _orders;
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.space16),
      borderRadius: BorderRadius.circular(AppSize.radius12),
      backgroundColor: AppColors.backGroundWhite,
      border: Border.all(color: AppColors.borderLight),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Recent Orders',
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space16),
          for (var i = 0; i < orders.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSize.space12),
            _RecentOrderRow(item: orders[i]),
          ],
          const SizedBox(height: AppSize.space12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: AppText(
                text: 'Show more',
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                color: AppColors.textInfo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrderRow extends StatelessWidget {
  const _RecentOrderRow({required this.item});

  final _RecentOrderLine item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: item.title,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSize.space4),
              AppText(
                text: '${item.qtyLabel} · ${item.timeAgo}',
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var s = 0; s < 5; s++)
              Icon(
                s < item.stars ? Icons.star_rounded : Icons.star_border_rounded,
                size: AppSize.icon16,
                color: AppColors.iconEmeraldGreen,
              ),
          ],
        ),
      ],
    );
  }
}
