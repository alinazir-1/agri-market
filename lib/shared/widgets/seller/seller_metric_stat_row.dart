import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// One metric for [SellerMetricStatRow] (Orders-style stat cards).
class SellerMetricStatItem {
  final String label;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color? valueColor;

  const SellerMetricStatItem({
    required this.label,
    required this.value,
    required this.badge,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.valueColor,
  });
}

/// Single stat tile: icon + label + value + pill (matches Orders screen).
class SellerMetricStatCard extends StatelessWidget {
  final SellerMetricStatItem item;

  const SellerMetricStatCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius16),
      border: Border.all(
        color: context.borderClr,
        width: AppSize.borderWidth1,
      ),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.06),
          blurRadius: AppSize.space16,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            width: 40,
            height: 40,
            backgroundColor: item.iconBg,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            alignment: Alignment.center,
            child: Icon(
              item.icon,
              size: AppSize.icon20,
              color: item.iconColor,
            ),
          ),
          const SizedBox(width: AppSize.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: item.label,
                  fontSize: AppSize.font8,
                  fontWeight: FontWeight.w700,
                  color: context.txtSecondary,
                  letterSpacing: 0.6,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space4),
                AppText(
                  text: item.value,
                  fontSize: AppSize.font18,
                  fontWeight: FontWeight.w800,
                  color: item.valueColor ?? context.txtPrimary,
                  height: 1.15,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space8),
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space8,
                    vertical: AppSize.space4,
                  ),
                  backgroundColor: item.iconBg.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppSize.radiusCircular),
                  child: AppText(
                    text: item.badge,
                    fontSize: AppSize.font8,
                    fontWeight: FontWeight.w700,
                    color: item.iconColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Four or five metric cards in one row; stacks in rows below [AppSize.breakpointTablet].
/// Optional [trailing] (e.g. action button) sits at row end or below on narrow.
class SellerMetricStatRow extends StatelessWidget {
  final List<SellerMetricStatItem> items;
  final Widget? trailing;

  const SellerMetricStatRow({
    super.key,
    required this.items,
    this.trailing,
  }) : assert(
          items.length == 4 || items.length == 5,
          'SellerMetricStatRow expects 4 or 5 items',
        );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < AppSize.breakpointTablet;
        final cards =
            items.map((e) => SellerMetricStatCard(item: e)).toList();
        final n = cards.length;

        if (narrow) {
          return AppContainer(
            backgroundColor: context.inputFill,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space20,
              vertical: AppSize.space16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: AppSize.space12),
                    Expanded(child: cards[1]),
                  ],
                ),
                const SizedBox(height: AppSize.space12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[2]),
                    const SizedBox(width: AppSize.space12),
                    Expanded(child: cards[3]),
                  ],
                ),
                if (n == 5) ...[
                  const SizedBox(height: AppSize.space12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cards[4]),
                    ],
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(height: AppSize.space12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: trailing!,
                  ),
                ],
              ],
            ),
          );
        }

        return AppContainer(
          backgroundColor: context.inputFill,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space20,
            vertical: AppSize.space16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: AppSize.space12),
              Expanded(child: cards[1]),
              const SizedBox(width: AppSize.space12),
              Expanded(child: cards[2]),
              const SizedBox(width: AppSize.space12),
              Expanded(child: cards[3]),
              if (n == 5) ...[
                const SizedBox(width: AppSize.space12),
                Expanded(child: cards[4]),
              ],
              if (trailing != null) ...[
                const SizedBox(width: AppSize.space12),
                trailing!,
              ],
            ],
          ),
        );
      },
    );
  }
}
