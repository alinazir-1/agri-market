import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../Data/Models/review_model.dart';

class ReviewsCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<ReviewFilter> selectedFilter = ReviewFilter.all.obs;
  final Rx<ReviewSort> selectedSort = ReviewSort.latest.obs;

  // reply dialog controller
  final TextEditingController replyController = TextEditingController();

  // ── Reviews Data ──────────────────────────────────────────────────────────

  final RxList<ReviewModel> reviews = <ReviewModel>[
    ReviewModel(
      id: 'R1',
      buyerId: 'C2',
      buyerName: 'Sara Malik',
      buyerLocation: 'Lahore, PK',
      avatarColor: const Color(0xFF7C3AED),
      productId: 'P1',
      productName: 'Sella Basmati Rice',
      productCategory: 'Grains & Cereals',
      productType: 'Marketplace',
      productEmoji: '🌾',
      rating: 5,
      reviewText:
          'Excellent quality rice! Very well packaged and delivered on time. The grain size and aroma are exactly as described. Will definitely order again.',
      reviewDate: DateTime(2026, 3, 15),
      isVerified: true,
      isFlagged: false,
    ),
    ReviewModel(
      id: 'R2',
      buyerId: 'C3',
      buyerName: 'Ali Hassan',
      buyerLocation: 'Dubai, UAE',
      avatarColor: const Color(0xFF0891B2),
      productId: 'P3',
      productName: 'Fresh Mangoes',
      productCategory: 'Fresh Produce',
      productType: 'Adv. Booking',
      productEmoji: '🥭',
      rating: 4,
      reviewText:
          'Good mangoes but delivery was slightly delayed. Quality is great though, very sweet and fresh.',
      reviewDate: DateTime(2026, 3, 12),
      isVerified: true,
      isFlagged: false,
      sellerReply:
          'Thank you Ali! We apologize for the delay. We have improved our logistics and look forward to your next order.',
    ),
    ReviewModel(
      id: 'R3',
      buyerId: 'C4',
      buyerName: 'Fatima Zahra',
      buyerLocation: 'Islamabad, PK',
      avatarColor: const Color(0xFFDC2626),
      productId: 'P2',
      productName: 'Desiree Potato',
      productCategory: 'Grains & Cereals',
      productType: 'Marketplace',
      productEmoji: '🥔',
      rating: 2,
      reviewText:
          'Not satisfied. The potatoes had some damage and the quantity was less than ordered.',
      reviewDate: DateTime(2026, 1, 10),
      isVerified: true,
      isFlagged: true,
    ),
    ReviewModel(
      id: 'R4',
      buyerId: 'C1',
      buyerName: 'Ahmed Khan',
      buyerLocation: 'Karachi, PK',
      avatarColor: const Color(0xFF0E7C66),
      productId: 'P1',
      productName: 'Sella Basmati Rice',
      productCategory: 'Grains & Cereals',
      productType: 'Marketplace',
      productEmoji: '🌾',
      rating: 5,
      reviewText:
          'Perfect quality and great packaging. I have been buying from this seller for 6 months and never disappointed.',
      reviewDate: DateTime(2026, 2, 28),
      isVerified: true,
      isFlagged: false,
    ),
    ReviewModel(
      id: 'R5',
      buyerId: 'C5',
      buyerName: 'Usman Tariq',
      buyerLocation: 'Multan, PK',
      avatarColor: const Color(0xFFD97706),
      productId: 'P5',
      productName: 'Premium Soybean',
      productCategory: 'Oil Seeds',
      productType: 'Live Auction',
      productEmoji: '🌱',
      rating: 4,
      reviewText:
          'Good quality but packaging could be better. Overall satisfied with the product.',
      reviewDate: DateTime(2026, 3, 8),
      isVerified: true,
      isFlagged: false,
    ),
    ReviewModel(
      id: 'R6',
      buyerId: 'C6',
      buyerName: 'Zara Ahmed',
      buyerLocation: 'Faisalabad, PK',
      avatarColor: const Color(0xFF059669),
      productId: 'P3',
      productName: 'Fresh Mangoes',
      productCategory: 'Fresh Produce',
      productType: 'Marketplace',
      productEmoji: '🥭',
      rating: 5,
      reviewText:
          'Very fresh produce, happy with the order! The mangoes were perfectly ripe.',
      reviewDate: DateTime(2026, 2, 20),
      isVerified: true,
      isFlagged: false,
    ),
  ].obs;

  // ── Top Rated Products ────────────────────────────────────────────────────

  final List<TopRatedProduct> topRatedProducts = const [
    TopRatedProduct(
        productId: 'P1',
        productName: 'Sella Basmati Rice',
        emoji: '🌾',
        reviewCount: 128,
        avgRating: 4.9),
    TopRatedProduct(
        productId: 'P3',
        productName: 'Fresh Mangoes',
        emoji: '🥭',
        reviewCount: 64,
        avgRating: 4.7),
    TopRatedProduct(
        productId: 'P5',
        productName: 'Premium Soybean',
        emoji: '🌱',
        reviewCount: 47,
        avgRating: 4.5),
  ];

  // ── Computed Stats ────────────────────────────────────────────────────────

  int get totalReviews => reviews.length;
  int get repliedCount => reviews.where((r) => r.hasReply).length;
  int get pendingCount => reviews.where((r) => r.isPending).length;
  int get flaggedCount => reviews.where((r) => r.isFlagged).length;

  double get avgRating {
    if (reviews.isEmpty) return 0;
    return reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;
  }

  int countByRating(int star) => reviews.where((r) => r.rating == star).length;

  double ratingBarWidth(int star) {
    if (reviews.isEmpty) return 0;
    return countByRating(star) / reviews.length;
  }

  int get positivePercent {
    if (reviews.isEmpty) return 0;
    final positive = reviews.where((r) => r.rating >= 4).length;
    return ((positive / reviews.length) * 100).round();
  }

  List<ReviewModel> get pendingReviews =>
      reviews.where((r) => r.isPending).take(3).toList();

  // ── Filtered List ─────────────────────────────────────────────────────────

  List<ReviewModel> get filteredReviews {
    List<ReviewModel> list = List.from(reviews);

    switch (selectedFilter.value) {
      case ReviewFilter.fiveStar:
        list = list.where((r) => r.rating == 5).toList();
        break;
      case ReviewFilter.fourStar:
        list = list.where((r) => r.rating == 4).toList();
        break;
      case ReviewFilter.threeStar:
        list = list.where((r) => r.rating == 3).toList();
        break;
      case ReviewFilter.lowRating:
        list = list.where((r) => r.rating <= 2).toList();
        break;
      case ReviewFilter.pendingReply:
        list = list.where((r) => r.isPending).toList();
        break;
      case ReviewFilter.flagged:
        list = list.where((r) => r.isFlagged).toList();
        break;
      case ReviewFilter.all:
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((r) =>
              r.buyerName.toLowerCase().contains(q) ||
              r.productName.toLowerCase().contains(q) ||
              r.reviewText.toLowerCase().contains(q))
          .toList();
    }

    switch (selectedSort.value) {
      case ReviewSort.latest:
        list.sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
        break;
      case ReviewSort.oldest:
        list.sort((a, b) => a.reviewDate.compareTo(b.reviewDate));
        break;
      case ReviewSort.highestRating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSort.lowestRating:
        list.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }

    return list;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void setFilter(ReviewFilter f) => selectedFilter.value = f;
  void setSort(ReviewSort s) => selectedSort.value = s;
  void onSearch(String val) => searchQuery.value = val;

  void submitReply(String reviewId) {
    final text = replyController.text.trim();
    if (text.isEmpty) return;
    final idx = reviews.indexWhere((r) => r.id == reviewId);
    if (idx == -1) return;
    reviews[idx] = reviews[idx].copyWith(sellerReply: text);
    replyController.clear();
  }

  void toggleFlag(String reviewId) {
    final idx = reviews.indexWhere((r) => r.id == reviewId);
    if (idx == -1) return;
    reviews[idx] = reviews[idx].copyWith(isFlagged: !reviews[idx].isFlagged);
  }

  String formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  void onClose() {
    searchController.dispose();
    replyController.dispose();
    super.onClose();
  }
}
