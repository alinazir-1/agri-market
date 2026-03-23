import 'package:agri_market/Seller%20Section/Seller%20Screens/Review%20and%20Rating/review&rating_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Data/Models/review_model.dart';
import 'Review and Rating Widgets/pending_reply_card.dart';
import 'Review and Rating Widgets/rating_bar_row.dart';
import 'Review and Rating Widgets/reply_dialog.dart';
import 'Review and Rating Widgets/review_card.dart';
import 'Review and Rating Widgets/review_filter_chip.dart';
import 'Review and Rating Widgets/review_stat_card.dart';
import 'Review and Rating Widgets/star_row.dart';
import 'Review and Rating Widgets/top_rated_product_card.dart';

class ReviewsScr extends StatelessWidget {
  final ReviewsCon reviewsController = Get.put(ReviewsCon());

  ReviewsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(reviewsController: reviewsController),
            _RatingOverview(reviewsController: reviewsController),
            _StatsStrip(reviewsController: reviewsController),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _ReviewListSection(
                          reviewsController: reviewsController)),
                  _Sidebar(reviewsController: reviewsController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///----Classes-----///

class _TopBar extends StatelessWidget {
  final ReviewsCon reviewsController;
  const _TopBar({required this.reviewsController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: CSize.space20, vertical: CSize.space12),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reviews & Ratings',
                  style: TextStyle(
                      fontSize: CSize.font24Large,
                      fontWeight: FontWeight.w900,
                      color: CColors.textPrimary)),
              SizedBox(height: CSize.space2),
              Text('Monitor buyer feedback on your products',
                  style: TextStyle(
                      fontSize: CSize.font10XSmall,
                      color: CColors.textSecondary)),
            ],
          ),
          const SizedBox(width: CSize.space20),
          SizedBox(
            width: 280,
            height: 36,
            child: TextField(
              controller: reviewsController.searchController,
              onChanged: reviewsController.onSearch,
              style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search reviews...',
                hintStyle:
                    const TextStyle(fontSize: 11, color: CColors.textSecondary),
                prefixIcon: const Icon(Icons.search,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                filled: true,
                fillColor: CColors.backGroundLightGrey,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: CSize.space10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                    borderSide: const BorderSide(
                        color: CColors.borderEmeraldGreen,
                        width: CSize.borderWidth1)),
              ),
            ),
          ),
          const Spacer(),
          Stack(children: [
            Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: CColors.backGroundWhite,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0))),
                child: const Icon(Icons.notifications_none_rounded,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen)),
            Positioned(
                top: 4,
                right: 4,
                child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                        color: CColors.notificationDot,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: CColors.backGroundWhite, width: 1.5)))),
          ]),
          const SizedBox(width: CSize.space8),
          Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: CColors.backGroundWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0))),
              child: const Icon(Icons.messenger_outline_rounded,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen)),
          const SizedBox(width: CSize.space8),
          const CircleAvatar(
              radius: 17,
              backgroundColor: CColors.backGroundEmeraldGreen,
              child: Text('AS',
                  style: TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w800,
                      color: CColors.textWhite))),
        ],
      ),
    );
  }
}

class _RatingOverview extends StatelessWidget {
  final ReviewsCon reviewsController;
  const _RatingOverview({required this.reviewsController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: CColors.backGroundWhite,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Big rating
                Container(
                  width: 240,
                  padding: const EdgeInsets.symmetric(vertical: CSize.space20),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Color(0xFFE2E8F0)),
                      bottom: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        reviewsController.avgRating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: CColors.textPrimary,
                            height: 1),
                      ),
                      const SizedBox(height: CSize.space5),
                      StarRow(
                          rating: reviewsController.avgRating.round(),
                          size: 20),
                      const SizedBox(height: CSize.space5),
                      Text(
                        'Based on ${reviewsController.totalReviews} reviews',
                        style: const TextStyle(
                            fontSize: 11, color: CColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Rating bars
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CSize.space20, vertical: CSize.space16),
                    decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(5, (i) {
                          final star = 5 - i;
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: CSize.space8),
                            child: RatingBarRow(
                              star: star,
                              fillFraction:
                                  reviewsController.ratingBarWidth(star),
                              count: reviewsController.countByRating(star),
                            ),
                          );
                        }),
                        const SizedBox(height: CSize.space5),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: CSize.space10,
                                vertical: CSize.space4),
                            decoration: BoxDecoration(
                                color: CColors.backgroundEmerald100,
                                borderRadius:
                                    BorderRadius.circular(CSize.radius20Large)),
                            child: Text(
                                '${reviewsController.positivePercent}% positive',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: CColors.textEmeraldGreen)),
                          ),
                          const SizedBox(width: CSize.space8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: CSize.space10,
                                vertical: CSize.space4),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius:
                                    BorderRadius.circular(CSize.radius20Large)),
                            child: const Text('+12 this month',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: CColors.textEmeraldGreen)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class _StatsStrip extends StatelessWidget {
  final ReviewsCon reviewsController;
  const _StatsStrip({required this.reviewsController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: const BoxDecoration(
            color: CColors.backGroundWhite,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(children: [
            Expanded(
                child: ReviewStatCard(
              label: 'Total Reviews',
              value: '${reviewsController.totalReviews}',
              icon: Icons.star_outline_rounded,
              iconBg: CColors.backgroundEmerald100,
              iconColor: CColors.iconEmeraldGreen,
            )),
            Container(width: 1, height: 40, color: const Color(0xFFF1F5F9)),
            Expanded(
                child: ReviewStatCard(
              label: 'Replied',
              value: '${reviewsController.repliedCount}',
              icon: Icons.reply_rounded,
              iconBg: CColors.backgroundEmerald100,
              iconColor: CColors.iconEmeraldGreen,
            )),
            Container(width: 1, height: 40, color: const Color(0xFFF1F5F9)),
            Expanded(
                child: ReviewStatCard(
              label: 'Pending Reply',
              value: '${reviewsController.pendingCount}',
              icon: Icons.pending_outlined,
              iconBg: const Color(0xFFFFF7ED),
              iconColor: CColors.backGroundOrange,
              valueColor: CColors.backGroundOrange,
            )),
            Container(width: 1, height: 40, color: const Color(0xFFF1F5F9)),
            Expanded(
                child: ReviewStatCard(
              label: 'Flagged',
              value: '${reviewsController.flaggedCount}',
              icon: Icons.flag_outlined,
              iconBg: const Color(0xFFFEE2E2),
              iconColor: CColors.iconError,
              valueColor: CColors.textError,
            )),
          ]),
        ));
  }
}

class _ReviewListSection extends StatelessWidget {
  final ReviewsCon reviewsController;
  const _ReviewListSection({required this.reviewsController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          _filterHeader(),
          Expanded(child: _reviewList()),
        ],
      ),
    );
  }

  Widget _filterHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          CSize.space20, CSize.space14, CSize.space20, CSize.space12),
      child: Row(
        children: [
          const Text('All Reviews',
              style: TextStyle(
                  fontSize: CSize.font13Small,
                  fontWeight: FontWeight.w800,
                  color: CColors.textPrimary)),
          const Spacer(),
          Obx(() => Wrap(
                spacing: CSize.space5,
                children: [
                  ReviewFilterChip(
                      label: 'All',
                      isActive: reviewsController.selectedFilter.value ==
                          ReviewFilter.all,
                      onTap: () =>
                          reviewsController.setFilter(ReviewFilter.all)),
                  ReviewFilterChip(
                      label: '5 ★',
                      isActive: reviewsController.selectedFilter.value ==
                          ReviewFilter.fiveStar,
                      onTap: () =>
                          reviewsController.setFilter(ReviewFilter.fiveStar)),
                  ReviewFilterChip(
                      label: '4 ★',
                      isActive: reviewsController.selectedFilter.value ==
                          ReviewFilter.fourStar,
                      onTap: () =>
                          reviewsController.setFilter(ReviewFilter.fourStar)),
                  ReviewFilterChip(
                      label: '3 ★',
                      isActive: reviewsController.selectedFilter.value ==
                          ReviewFilter.threeStar,
                      onTap: () =>
                          reviewsController.setFilter(ReviewFilter.threeStar)),
                  ReviewFilterChip(
                      label: '1-2 ★',
                      isActive: reviewsController.selectedFilter.value ==
                          ReviewFilter.lowRating,
                      onTap: () =>
                          reviewsController.setFilter(ReviewFilter.lowRating),
                      activeColor: const Color(0xFFFBBF24),
                      activeBorder: const Color(0xFFFBBF24),
                      inactiveBorder: const Color(0xFFFDE68A),
                      inactiveText: const Color(0xFF854D0E)),
                  ReviewFilterChip(
                      label: 'Pending Reply',
                      isActive: reviewsController.selectedFilter.value ==
                          ReviewFilter.pendingReply,
                      onTap: () => reviewsController
                          .setFilter(ReviewFilter.pendingReply),
                      activeColor: CColors.backGroundOrange,
                      activeBorder: CColors.backGroundOrange,
                      inactiveBorder: const Color(0xFFFED7AA),
                      inactiveText: CColors.textOrange),
                  ReviewFilterChip(
                      label: 'Flagged',
                      isActive: reviewsController.selectedFilter.value ==
                          ReviewFilter.flagged,
                      onTap: () =>
                          reviewsController.setFilter(ReviewFilter.flagged),
                      activeColor: CColors.borderError,
                      activeBorder: CColors.borderError,
                      inactiveBorder: const Color(0xFFFCA5A5),
                      inactiveText: CColors.textRichRed),
                ],
              )),
          const SizedBox(width: CSize.space12),
          // Sort
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space12, vertical: CSize.space5),
                decoration: BoxDecoration(
                    color: CColors.backGroundWhite,
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    border: Border.all(color: const Color(0xFFE2E8F0))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ReviewSort>(
                    value: reviewsController.selectedSort.value,
                    isDense: true,
                    style: const TextStyle(
                        fontSize: CSize.font10XSmall,
                        fontWeight: FontWeight.w600,
                        color: CColors.textPrimary),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        size: CSize.icon16Small,
                        color: CColors.iconEmeraldGreen),
                    items: const [
                      DropdownMenuItem(
                          value: ReviewSort.latest, child: Text('Latest')),
                      DropdownMenuItem(
                          value: ReviewSort.oldest, child: Text('Oldest')),
                      DropdownMenuItem(
                          value: ReviewSort.highestRating,
                          child: Text('Highest Rating')),
                      DropdownMenuItem(
                          value: ReviewSort.lowestRating,
                          child: Text('Lowest Rating')),
                    ],
                    onChanged: (val) =>
                        reviewsController.setSort(val ?? ReviewSort.latest),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _reviewList() {
    return Obx(() {
      final list = reviewsController.filteredReviews;
      if (list.isEmpty) {
        return const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.rate_review_outlined,
                size: CSize.icon36XLarge, color: CColors.textSecondary),
            SizedBox(height: CSize.space12),
            Text('No reviews found',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
          ]),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final review = list[index];
          return ReviewCard(
            review: review,
            dateText: reviewsController.formatDate(review.reviewDate),
            onReply: () => Get.dialog(ReviewReplyDialog(
              review: review,
              controller: reviewsController.replyController,
              onSubmit: () => reviewsController.submitReply(review.id),
            )),
            onToggleFlag: () => reviewsController.toggleFlag(review.id),
          );
        },
      );
    });
  }
}

class _Sidebar extends StatelessWidget {
  final ReviewsCon reviewsController;
  const _Sidebar({required this.reviewsController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(CSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topRated(),
            const SizedBox(height: CSize.space20),
            _pendingReplies(),
          ],
        ),
      ),
    );
  }

  Widget _topRated() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Icon(Icons.star_outline_rounded,
              size: CSize.icon16Small, color: Color(0xFFCA8A04)),
          SizedBox(width: CSize.space5),
          Text('Top Rated Products',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: CColors.textPrimary)),
        ]),
        const SizedBox(height: CSize.space10),
        ...reviewsController.topRatedProducts
            .map((p) => TopRatedProductCard(product: p)),
      ],
    );
  }

  Widget _pendingReplies() {
    return Obx(() {
      final pending = reviewsController.pendingReviews;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.pending_outlined,
                size: CSize.icon16Small, color: CColors.backGroundOrange),
            const SizedBox(width: CSize.space5),
            const Text('Pending Replies',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: CColors.textPrimary)),
            const SizedBox(width: CSize.space5),
            if (reviewsController.pendingCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space8, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(CSize.radius20Large)),
                child: Text('${reviewsController.pendingCount}',
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9A3412))),
              ),
          ]),
          const SizedBox(height: CSize.space10),
          if (pending.isEmpty)
            Container(
              padding: const EdgeInsets.all(CSize.space12),
              decoration: BoxDecoration(
                  color: CColors.backgroundEmerald100,
                  borderRadius: BorderRadius.circular(CSize.radius10Medium)),
              child: const Row(children: [
                Icon(Icons.check_circle_outline,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                SizedBox(width: CSize.space8),
                Text('All reviews replied!',
                    style: TextStyle(
                        fontSize: 10,
                        color: CColors.textEmeraldGreen,
                        fontWeight: FontWeight.w600)),
              ]),
            )
          else
            ...pending.map((review) => PendingReplyCard(
                  review: review,
                  onReply: () => Get.dialog(ReviewReplyDialog(
                    review: review,
                    controller: reviewsController.replyController,
                    onSubmit: () => reviewsController.submitReply(review.id),
                  )),
                )),
        ],
      );
    });
  }
}
