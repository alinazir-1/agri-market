import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_con.dart';
import 'package:agri_market/features/buyer/verified_seller/widgets/verified_seller_card.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_footer.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class VerifiedSellerScr extends StatelessWidget {
  const VerifiedSellerScr({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Get.find<VerifiedSellerCon>();
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      body: SafeArea(
        child: Column(
          children: [
            _VerifiedSellerHeader(),
            Expanded(
              child: Obx(() {
                if (con.isLoading.value) {
                  return const AppSkeletonListColumn(itemCount: 6);
                }
                if (con.sellers.isEmpty) {
                  return const AppEmptyListState(
                    message: 'No verified sellers available right now.',
                    icon: Icons.verified_outlined,
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width > 1400
                        ? 3
                        : width > AppSize.breakpointDesktop
                            ? 2
                            : 1;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSize.space20),
                      child: Column(
                        children: [
                          _TopInsightBand(count: con.sellers.length),
                          const SizedBox(height: AppSize.space16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: con.sellers.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: AppSize.space16,
                              mainAxisSpacing: AppSize.space16,
                              childAspectRatio: crossAxisCount == 1 ? 2.4 : 1.35,
                            ),
                            itemBuilder: (_, index) {
                              return VerifiedSellerCard(
                                seller: con.sellers[index],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.borderLight,
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _VerifiedSellerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      backgroundColor: AppColors.backGroundWhite,
      border: const Border(bottom: BorderSide(color: AppColors.borderLight)),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Get.back<void>(),
              child: AppContainer(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: AppSize.icon16,
                  color: AppColors.iconBlack,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSize.space12),
          const Expanded(
            child: AppText(
              text: 'Verified Sellers',
              fontSize: AppSize.font20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            borderRadius: BorderRadius.circular(AppSize.radiusCircular),
            backgroundColor: AppColors.badgeInfoBg,
            child: const AppText(
              text: 'B2B Trust Layer',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w600,
              color: AppColors.badgeInfoText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopInsightBand extends StatelessWidget {
  const _TopInsightBand({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(AppSize.radius16),
      gradient: const LinearGradient(
        colors: [
          AppColors.emeraldGreen,
          AppColors.textInfo,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'Trusted supplier network for bulk procurement',
            fontSize: AppSize.font20,
            fontWeight: FontWeight.w700,
            color: AppColors.textWhite,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
            text:
                '$count verified sellers passed profile, transaction, and quality checks.',
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w500,
            color: AppColors.textWhite,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
