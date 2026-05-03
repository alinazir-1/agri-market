import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/review_model.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';

import 'package:agri_market/features/seller/reviews/review_rating_con.dart';
import 'package:agri_market/features/seller/reviews/widgets/pending_reply_card.dart';
import 'package:agri_market/features/seller/reviews/widgets/reply_dialog.dart';
import 'package:agri_market/features/seller/reviews/widgets/review_card.dart';
import 'package:agri_market/features/seller/reviews/widgets/review_filter_chip.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/features/seller/reviews/widgets/top_rated_product_card.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';

import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';

class ReviewsScr extends StatelessWidget {
  final ReviewsCon ctrlReviews = Get.put(ReviewsCon(), permanent: true);

  ReviewsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            ScreenTopBar(
              title: 'Reviews & Ratings',
              subtitle: 'Monitor buyer feedback on your products',
              searchController: ctrlReviews.searchController,
              onSearch: ctrlReviews.onSearch,
              searchHint: 'Search reviews...',
            ),
            _StatsStrip(ctrlReviews: ctrlReviews),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _ReviewListSection(ctrlReviews: ctrlReviews)),
                  _Sidebar(ctrlReviews: ctrlReviews),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  final ReviewsCon ctrlReviews;
  const _StatsStrip({required this.ctrlReviews});

  @override
  Widget build(BuildContext context) {
    /// 💀🔥 ---------------- Reviews Stats Cards ----------------
    return Obx(() => SellerMetricStatRow(
          items: [
            SellerMetricStatItem(
              label: 'RATING',
              value: ctrlReviews.avgRating.toStringAsFixed(1),
              badge: 'Avg score',
              icon: Icons.star_outline_rounded,
              iconBg: AppColors.badgeWarningBg,
              iconColor: AppColors.badgeWarningText,
              valueColor: AppColors.badgeWarningText,
            ),
            SellerMetricStatItem(
              label: 'TOTAL REVIEWS',
              value: '${ctrlReviews.totalReviews}',
              badge: 'All time',
              icon: Icons.reviews_outlined,
              iconBg: AppColors.badgeSuccessBg,
              iconColor: AppColors.iconEmeraldGreen,
            ),
            SellerMetricStatItem(
              label: 'REPLIED',
              value: '${ctrlReviews.repliedCount}',
              badge: 'Completed',
              icon: Icons.reply_rounded,
              iconBg: AppColors.badgeInfoBg,
              iconColor: AppColors.badgeInfoText,
            ),
            SellerMetricStatItem(
              label: 'PENDING',
              value: '${ctrlReviews.pendingCount}',
              badge: 'Need response',
              icon: Icons.pending_outlined,
              iconBg: AppColors.badgeWarningBg,
              iconColor: AppColors.textWarning,
              valueColor: AppColors.textWarning,
            ),
            SellerMetricStatItem(
              label: 'FLAGGED',
              value: '${ctrlReviews.flaggedCount}',
              badge: 'Needs review',
              icon: Icons.flag_outlined,
              iconBg: AppColors.badgeErrorBg,
              iconColor: AppColors.iconError,
              valueColor: AppColors.textError,
            ),
          ],
        ));
  }
}

class _ReviewListSection extends StatelessWidget {
  final ReviewsCon ctrlReviews;
  const _ReviewListSection({required this.ctrlReviews});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      border: Border(right: BorderSide(color: context.borderClr)),
      child: Column(
        children: [
          _filterHeader(context),
          Expanded(child: _reviewList(context)),
        ],
      ),
    );
  }

  Widget _filterHeader(BuildContext context) {
    /// 💀🔥 ---------------- Reviews Filter Row ----------------
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSize.space20, AppSize.space12,
          AppSize.space20, AppSize.space12), // mapped 14 to 12
      child: Row(
        children: [
          Expanded(
            child: Obx(() => Wrap(
                  spacing: AppSize.space4,
                  runSpacing: AppSize.space4,
                  children: [
                    ReviewFilterChip(
                        label: 'All',
                        isActive:
                            ctrlReviews.selectedFilter.value == ReviewFilter.all,
                        onTap: () => ctrlReviews.setFilter(ReviewFilter.all)),
                    ReviewFilterChip(
                        label: '5 ★',
                        isActive: ctrlReviews.selectedFilter.value ==
                            ReviewFilter.fiveStar,
                        onTap: () =>
                            ctrlReviews.setFilter(ReviewFilter.fiveStar)),
                    ReviewFilterChip(
                        label: '3 ★',
                        isActive: ctrlReviews.selectedFilter.value ==
                            ReviewFilter.threeStar,
                        onTap: () =>
                            ctrlReviews.setFilter(ReviewFilter.threeStar)),
                    ReviewFilterChip(
                        label: 'Flagged',
                        isActive: ctrlReviews.selectedFilter.value ==
                            ReviewFilter.flagged,
                        onTap: () => ctrlReviews.setFilter(ReviewFilter.flagged),
                        activeColor: AppColors.borderError,
                        activeBorder: AppColors.borderError,
                        inactiveBorder: AppColors.badgeErrorBg,
                        inactiveText: AppColors.textRichRed),
                  ],
                )),
          ),
          const SizedBox(width: AppSize.space12),
          /// 💀🔥 ---------------- Reviews Sort Dropdown ----------------
          Obx(() => AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space12,
                    vertical: AppSize.space4), // mapped 5 to 4
                backgroundColor: context.cardBg,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                border: Border.all(color: context.borderClr),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ReviewSort>(
                    value: ctrlReviews.selectedSort.value,
                    isDense: true,
                    style: TextStyle(
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w600,
                        color: context.txtPrimary),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        size: AppSize.icon16,
                        color: AppColors.iconEmeraldGreen),
                    items: const [
                      DropdownMenuItem(
                          value: ReviewSort.latest,
                          child: AppText(text: 'Latest')),
                      DropdownMenuItem(
                          value: ReviewSort.oldest,
                          child: AppText(text: 'Oldest')),
                      DropdownMenuItem(
                          value: ReviewSort.highestRating,
                          child: AppText(text: 'Highest Rating')),
                      DropdownMenuItem(
                          value: ReviewSort.lowestRating,
                          child: AppText(text: 'Lowest Rating')),
                    ],
                    onChanged: (val) =>
                        ctrlReviews.setSort(val ?? ReviewSort.latest),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _reviewList(BuildContext context) {
    return Obx(() {
      if (ctrlReviews.isLoading.value) {
        return const AppSkeletonListColumn();
      }
      final list = ctrlReviews.filteredReviews;
      if (list.isEmpty) {
        return const AppEmptyListState(
          message: 'No reviews found',
          icon: Icons.rate_review_outlined,
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final review = list[index];
          return ReviewCard(
            review: review,
            dateText: ctrlReviews.formatDate(review.reviewDate),
            onReply: () {
              ctrlReviews.replyController.clear();
              Get.dialog(ReviewReplyDialog(
                review: review,
                controller: ctrlReviews.replyController,
                reviewsCon: ctrlReviews,
              ));
            },
            onToggleFlag: () => ctrlReviews.toggleFlag(review.id),
          );
        },
      );
    });
  }
}

class _Sidebar extends StatelessWidget {
  final ReviewsCon ctrlReviews;
  const _Sidebar({required this.ctrlReviews});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.0, // Fixed layout size
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topRated(context),
            const SizedBox(height: AppSize.space20),
            _pendingReplies(context),
          ],
        ),
      ),
    );
  }

  Widget _topRated(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.star_outline_rounded,
              size: AppSize.icon16,
              color: AppColors.textWarning), // mapped 0xFFCA8A04
          const SizedBox(width: AppSize.space4), // mapped 5 to 4
          AppText(
              text: 'Top Rated Products',
              fontSize: AppSize.font10, // mapped 11 to 10
              fontWeight: FontWeight.w800,
              color: context.txtPrimary),
        ]),
        const SizedBox(height: AppSize.space12), // mapped 10 to 12
        ...ctrlReviews.topRatedProducts
            .map((p) => TopRatedProductCard(product: p)),
      ],
    );
  }

  Widget _pendingReplies(BuildContext context) {
    return Obx(() {
      final pending = ctrlReviews.pendingReviews;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.pending_outlined,
                size: AppSize.icon16,
                color: AppColors.textWarning), // mapped backGroundOrange
            const SizedBox(width: AppSize.space4), // mapped 5 to 4
            AppText(
                text: 'Pending Replies',
                fontSize: AppSize.font10, // mapped 11 to 10
                fontWeight: FontWeight.w800,
                color: context.txtPrimary),
            const SizedBox(width: AppSize.space4),
            if (ctrlReviews.pendingCount > 0)
              AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space8, vertical: 2),
                backgroundColor: AppColors.badgeWarningBg, // mapped 0xFFFFF7ED
                borderRadius: BorderRadius.circular(AppSize.radius20),
                child: AppText(
                    text: '${ctrlReviews.pendingCount}',
                    fontSize: AppSize.font8, // mapped 9 to 8
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWarning), // mapped 0xFF9A3412
              ),
          ]),
          const SizedBox(height: AppSize.space12), // mapped 10 to 12
          if (pending.isEmpty)
            AppContainer(
              padding: const EdgeInsets.all(AppSize.space12),
              backgroundColor:
                  AppColors.badgeSuccessBg, // mapped backgroundEmerald100
              borderRadius:
                  BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
              child: const Row(children: [
                Icon(Icons.check_circle_outline,
                    size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
                SizedBox(width: AppSize.space8),
                AppText(
                    text: 'All reviews replied!',
                    fontSize: AppSize.font10,
                    color: AppColors.textEmeraldGreen,
                    fontWeight: FontWeight.w600),
              ]),
            )
          else
            ...pending.map((review) => PendingReplyCard(
                  review: review,
                  onReply: () {
                    ctrlReviews.replyController.clear();
                    Get.dialog(ReviewReplyDialog(
                      review: review,
                      controller: ctrlReviews.replyController,
                      reviewsCon: ctrlReviews,
                    ));
                  },
                )),
        ],
      );
    });
  }
}
