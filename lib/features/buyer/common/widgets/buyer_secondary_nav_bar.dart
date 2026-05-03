import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_bin.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_scr.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Secondary links row below [BuyerTopBar]. Does not modify the top bar.
/// "All categories" hover menu is rendered via [Overlay] in [HomeCon] (full width).
class BuyerSecondaryNavBar extends StatelessWidget {
  const BuyerSecondaryNavBar({
    super.key,
    this.navBarKey,
  });

  final Key? navBarKey;

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HomeCon>();
    return AppContainer(
      key: navBarKey,
      backgroundColor: AppColors.backGroundWhite,
      border: const Border(
        bottom: BorderSide(color: AppColors.borderLight),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.space32,
                  vertical: AppSize.space12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LeftNavGroup(),
                    _RightNavGroup(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LeftNavGroup extends StatelessWidget {
  const _LeftNavGroup();

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HomeCon>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => con.onAllCategoriesMenuEnter(),
          onExit: (_) => con.onAllCategoriesMenuExit(),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_rounded,
                size: AppSize.icon20,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: AppSize.space8),
              AppText(
                text: 'All categories',
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RightNavGroup extends StatelessWidget {
  const _RightNavGroup();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavLink(
          text: 'Verified seller',
          onTap: () => Get.to<void>(
            () => const VerifiedSellerScr(),
            binding: VerifiedSellerBinding(),
          ),
        ),
        const SizedBox(width: AppSize.space20),
        const _NavLink(text: 'App & extension'),
        const SizedBox(width: AppSize.space20),
        const _NavLink(text: 'Start selling'),
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppText(
          text: text,
          fontSize: AppSize.font14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
