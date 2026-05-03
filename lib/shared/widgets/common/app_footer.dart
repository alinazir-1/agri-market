import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const List<String> _quickLinks = [
    'Home',
    'MarketPlace',
    'Advance Booking',
    'Live Auctions',
    'Become a Seller',
    'About Us',
  ];

  static const List<String> _supportLinks = [
    'Help Center',
    'Privacy Policy',
    'Terms of Service',
    'Cookie Policy',
  ];

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: AppColors.backGroundWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space32,
          vertical: AppSize.space24,
        ),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final bool compact = constraints.maxWidth < 980;
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _BrandBlock(),
                      SizedBox(height: AppSize.space20),
                      _LinksBlock(title: 'Quick Links', items: _quickLinks),
                      SizedBox(height: AppSize.space16),
                      _LinksBlock(title: 'Support', items: _supportLinks),
                    ],
                  );
                }
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _BrandBlock()),
                    SizedBox(width: AppSize.space24),
                    Expanded(child: _LinksBlock(title: 'Quick Links', items: _quickLinks)),
                    SizedBox(width: AppSize.space24),
                    Expanded(child: _LinksBlock(title: 'Support', items: _supportLinks)),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSize.space20),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.borderLight,
            ),
            const SizedBox(height: AppSize.space12),
            const Row(
              children: [
                Expanded(
                  child: AppText(
                    text: '© 2026 AgriKrop. All rights reserved.',
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.eco_rounded,
              size: AppSize.icon20,
              color: AppColors.iconEmeraldGreen,
            ),
            SizedBox(width: AppSize.space8),
            AppText(
              text: 'AgriKrop',
              fontSize: AppSize.font20,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: AppSize.space8),
        AppText(
          text:
              'Pakistan\'s trusted B2B agricultural marketplace connecting verified buyers and suppliers.',
          fontSize: AppSize.font14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _LinksBlock extends StatelessWidget {
  const _LinksBlock({
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          fontSize: AppSize.font16,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSize.space8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSize.space8),
            child: AppText(
              text: item,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
